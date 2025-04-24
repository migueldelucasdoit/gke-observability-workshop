package main

import (
	"context"
	log "github.com/sirupsen/logrus"

	"cloud.google.com/go/pubsub"
	"google.golang.org/api/iterator"
)

// Returns a function that publish a message on the specified topic
func publishMessage(ctx context.Context, topic *pubsub.Topic, payload *MessagePayload) func() {
	return func() {
		result := topic.Publish(ctx, &pubsub.Message{Data: payload.PayloadBytes})
		id, err := result.Get(ctx)
		if err != nil {
			// Error handling code can be added here.
			log.Info("Pub/Sub: Topic.Publish: ", err)
		} else {
			log.Info("Pub/Sub: Topic.Publish: MessageID ", id)
		}

	}
}

func subscriptionExists(ctx context.Context, subscriptionId string) bool {
	it := Client.Subscriptions(ctx)
	for {
		s, err := it.Next()
		if err == iterator.Done {
			break
		}
		if err != nil {
			return false
		}
		if subscriptionId == s.ID() {
			return true
		}
	}
	return false
}
