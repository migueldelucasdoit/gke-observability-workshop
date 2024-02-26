package main

import (
	"context"
	"fmt"
	"github.com/doitintl/cre-terraform-stacks/pocs/keda-blueprints/app/worker/metrics"
	log "github.com/sirupsen/logrus"
	"net/http"
	"os"
	"os/signal"
	"time"

	"cloud.google.com/go/pubsub"
)

var (
	ProjectId      string
	TopicId        string
	SubscriptionId string
	Client         *pubsub.Client
	Topic          *pubsub.Topic
	Subscription   *pubsub.Subscription
	SystemPort     string
)

func init() {
	ProjectId = getEnv("PROJECT_ID", "")
	TopicId = getEnv("TOPIC_ID", "")
	SubscriptionId = getEnv("SUBSCRIPTION_ID", "")
	SystemPort = getEnv("SYSTEM_PORT", "3000")
}

func main() {

	setupLogger()

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
			log.Fatal("Pub/Sub: Unable to create Topic: ", TopicId, err)
		}
		log.Infof("Pub/Sub: Created Topic: %s", TopicId)
	} else {
		log.Infof("Pub/Sub: Topic %s exists", TopicId)
	}
	// Check that the Pub/Sub suscription exists
	if subscriptionExists(ctx, SubscriptionId) {
		log.Infof("Pub/Sub: Subscription %s exists", SubscriptionId)
		Subscription = Client.Subscription(SubscriptionId)
	} else {
		Subscription, err = Client.CreateSubscription(ctx, SubscriptionId, pubsub.SubscriptionConfig{
			Topic:            Topic,
			AckDeadline:      20 * time.Second,
			ExpirationPolicy: time.Duration(0), // Never expires
		})
		log.Infof("Pub/Sub: Subscription %s created", SubscriptionId)
		if err != nil {
			log.Fatal("Pub/Sub: Unable to create Subscription: ", SubscriptionId, err)
		}
	}

	go func() {
		//	system connections
		http.Handle("/metrics", metrics.PrometheusHandler())
		http.ListenAndServe(fmt.Sprint(":", SystemPort), nil)
	}()

	ctx, cancel := context.WithCancel(context.Background())

	c := make(chan os.Signal, 1)
	signal.Notify(c, os.Interrupt)
	defer func() {
		signal.Stop(c)
		cancel()
	}()
	go func() {
		select {
		case <-c:
			cancel()
		case <-ctx.Done():
		}
	}()
	log.Info("Pub/Sub: Receive: message loop....")
	// Receive messages loop
	err = Subscription.Receive(ctx, func(_ context.Context, msg *pubsub.Message) {
		log.Infof("Pub/Sub: Receive: Got message: %q\n", string(msg.Data))
		msg.Ack()
		metrics.IncReceived()
		metrics.AddReceivedSize(float64(len(msg.Data)))
	})
	if err != nil {
		metrics.IncReceivedMessagesErrors()
		log.Fatal("Pub/Sub: Receive: Error receiving messages", err)
	}
	log.Info("Pub/Sub: Receive: Exiting application....")

}
