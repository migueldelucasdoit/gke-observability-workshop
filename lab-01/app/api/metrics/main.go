package metrics

import (
	"github.com/prometheus/client_golang/prometheus"
	"github.com/prometheus/client_golang/prometheus/promauto"
	"strconv"
)

var (
	receivedRequests = promauto.NewCounterVec(
		prometheus.CounterOpts{
			Name: "api_received_requests",
			Help: "Total number of received requests",
		},
		[]string{"code", "method", "path"},
	)
	publishedMessages = promauto.NewCounter(prometheus.CounterOpts{
		Name: "api_published_messages",
		Help: "The total number of published messages",
	})
	publishedMessagesSize = promauto.NewCounter(prometheus.CounterOpts{
		Name: "api_published_messages_size",
		Help: "The total payload size of published messages",
	})
)

func IncReceived(code int, method string, path string) {
	receivedRequests.WithLabelValues(strconv.Itoa(code), method, path).Inc()
}

func IncPublished() {
	publishedMessages.Inc()
}

func AddPublishedSize(size float64) {
	publishedMessagesSize.Add(size)
}
