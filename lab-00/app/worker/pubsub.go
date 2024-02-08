package main

import (
	"context"

	"google.golang.org/api/iterator"
)

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
