package metrics

import (
	"github.com/prometheus/client_golang/prometheus"
	"github.com/prometheus/client_golang/prometheus/promauto"
)

var (
	receivedMessages = promauto.NewCounterVec(prometheus.CounterOpts{
		Name: "worker_received_messages",
		Help: "The total number of received messages with status.",
	}, []string{"status"})
	receivedMessagesSize = promauto.NewCounter(prometheus.CounterOpts{
		Name: "worker_received_messages_size",
		Help: "The total payload size of received messages",
	})
)

func IncReceived() {
	receivedMessages.WithLabelValues("ok").Inc()
}

func AddReceivedSize(size float64) {
	receivedMessagesSize.Add(size)
}

func IncReceivedMessagesErrors() {
	receivedMessages.WithLabelValues("error").Inc()
}
