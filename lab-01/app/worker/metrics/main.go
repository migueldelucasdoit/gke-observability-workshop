package metrics

import (
	"github.com/prometheus/client_golang/prometheus"
	"github.com/prometheus/client_golang/prometheus/promauto"
)

var (
	receivedMessages = promauto.NewCounter(prometheus.CounterOpts{
		Name: "worker_received_messages",
		Help: "The total number of received messages",
	})
	receivedMessagesSize = promauto.NewCounter(prometheus.CounterOpts{
		Name: "worker_received_messages_size",
		Help: "The total payload size of received messages",
	})
	receivedMessagesErrors = promauto.NewCounter(prometheus.CounterOpts{
		Name: "worker_received_messages_errors",
		Help: "The total number of errors while receiving messages",
	})
)

func IncReceived() {
	receivedMessages.Inc()
}

func AddReceivedSize(size float64) {
	receivedMessagesSize.Add(size)
}

func IncReceivedMessagesErrors() {
	receivedMessagesErrors.Inc()
}
