package main

import (
	"context"
	"fmt"
	"github.com/doitintl/cre-terraform-stacks/pocs/keda-blueprints/app/api/metrics"
	log "github.com/sirupsen/logrus"
	"net/http"
	"os"
	"os/signal"
	"sync/atomic"
	"syscall"
	"time"

	"cloud.google.com/go/pubsub"
	"github.com/alitto/pond"
	"github.com/gin-gonic/gin"
)

var (
	ServingPort    string
	SystemPort     string
	ProjectId      string
	TopicId        string
	SubscriptionId string
	Client         *pubsub.Client
	Topic          *pubsub.Topic
	WorkerPool     *pond.WorkerPool
)

func init() {
	ServingPort = getEnv("PORT", "8080")
	SystemPort = getEnv("SYSTEM_PORT", "3000")
	ProjectId = getEnv("PROJECT_ID", "")
	TopicId = getEnv("TOPIC_ID", "")
	SubscriptionId = getEnv("SUBSCRIPTION_ID", "")
}

func main() {
	setupLogger()

	// Flag for readiness
	isReady := &atomic.Value{}
	isReady.Store(false)

	// Create Pub/Sub client
	ctx := context.Background()
	var err error
	Client, err = pubsub.NewClient(ctx, ProjectId)
	if err != nil {
		log.Fatal("Pub/Sub: NewClient: ", err)
	}
	defer Client.Close()

	// Check that the Pub/Sub topic exists
	Topic = Client.Topic(TopicId)
	if exists, err := Topic.Exists(ctx); !exists || err != nil {
		log.Info("Pub/Sub: Non-existent Topic: ", TopicId)
		// Create the topic otherwise
		Topic, err = Client.CreateTopic(ctx, TopicId)
		if err != nil {
			log.Info("Pub/Sub: Unable to create Topic: ", TopicId, err)
		}
		log.Info("Pub/Sub: Created Topic: ", TopicId)
		if subscriptionExists(ctx, SubscriptionId) {
			log.Infof("Pub/Sub: Subscription %s exists", SubscriptionId)
		} else {
			// Create the subscription to guarantee that messages are not lost
			_, err := Client.CreateSubscription(ctx, SubscriptionId, pubsub.SubscriptionConfig{
				Topic:            Topic,
				AckDeadline:      20 * time.Second,
				ExpirationPolicy: time.Duration(0), // Never expires
			})
			log.Infof("Pub/Sub: Subscription %s created", SubscriptionId)
			if err != nil {
				log.Fatal("Pub/Sub: Unable to create Subscription: ", SubscriptionId, err)
			}
		}

	}

	// Change variables for batching
	// https://cloud.google.com/pubsub/docs/publisher#configure_batch_messaging_in_a_client_library
	// TODO Allow to override this configuration with Environment Variables.
	Topic.PublishSettings.ByteThreshold = 5000
	Topic.PublishSettings.CountThreshold = 10
	Topic.PublishSettings.DelayThreshold = 100 * time.Millisecond
	defer Topic.Stop()

	// Create a worker pool
	// TODO Allow configuration of the pool bounds and timeout
	// https://github.com/alitto/pond#pool-configuration-options
	WorkerPool = pond.New(10, 100, pond.MinWorkers(5))
	defer WorkerPool.StopAndWait()

	// Create GIN router
	gin.SetMode(gin.ReleaseMode)
	router := gin.New()            // empty engine
	router.Use(LoggerMiddleware()) // adds our new middleware
	router.Use(gin.Recovery())     // adds the default recovery middleware
	router.GET("/healthz", healthz)
	router.GET("/readyz", readyz(isReady))
	router.POST("/telemetry", storeTelemetryData)

	srv := &http.Server{
		Addr:    fmt.Sprint(":", ServingPort),
		Handler: router,
	}

	go func() {
		// service connections
		log.Info("Server starting...")
		if err := srv.ListenAndServe(); err != nil && err != http.ErrServerClosed {
			log.Fatalf("listen: %s\n", err)
		}
	}()

	go func() {
		//	system connections
		http.Handle("/metrics", metrics.PrometheusHandler())
		http.ListenAndServe(fmt.Sprint(":", SystemPort), nil)
	}()

	isReady.Store(true)

	// Wait for interrupt signal to gracefully shutdown the server with
	// a timeout of 5 seconds.
	quit := make(chan os.Signal, 1)
	// kill (no param) default send syscanll.SIGTERM
	// kill -2 is syscall.SIGINT
	// kill -9 is syscall. SIGKILL but can"t be catch, so don't need add it
	signal.Notify(quit, syscall.SIGINT, syscall.SIGTERM)
	<-quit
	log.Info("Shutdown Server ...")

	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()
	if err := srv.Shutdown(ctx); err != nil {
		log.Fatal("Server Shutdown:", err)
	}
	// catching ctx.Done(). timeout of 5 seconds.
	<-ctx.Done()
	log.Info("timeout of 5 seconds.")
	log.Info("Server exiting")

}
