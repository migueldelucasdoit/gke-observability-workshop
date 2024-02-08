package main

import (
	"os"
	"sync/atomic"
)

func getEnv(key, fallback string) string {
	if value, ok := os.LookupEnv(key); ok {
		return value
	}
	return fallback
}

// Syncronized queue type to store messages
type Queue[T comparable] struct {
	// Items to be added to channel
	items chan T
	// counter used to incremented and decremented atomically.
	counter uint64
}

func NewQueue[T comparable]() *Queue[T] {
	return &Queue[T]{
		items:   make(chan T, 1),
		counter: 0,
	}
}

func (q *Queue[T]) Enqueue(item T) {
	// counter variable atomically incremented
	atomic.AddUint64(&q.counter, 1)
	// put item to channel
	q.items <- item
}

func (q *Queue[T]) Dequeue() T {
	// read item from channel
	item := <-q.items
	// counter variable decremented atomically.
	atomic.AddUint64(&q.counter, ^uint64(0))
	return item
}

func (q *Queue[T]) IsEmpty() bool {
	return q.counter == 0
}
