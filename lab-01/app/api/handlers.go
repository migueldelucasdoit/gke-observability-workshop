package main

import (
	"context"
	"encoding/json"
	"github.com/doitintl/cre-terraform-stacks/pocs/keda-blueprints/app/api/metrics"
	"net/http"
	"sync/atomic"

	"github.com/gin-gonic/gin"
)

// healthz is a liveness probe.
func healthz(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{
		"status": "ok",
	})
}

// readyz is a readiness probe
func readyz(isReady *atomic.Value) gin.HandlerFunc {
	fn := func(c *gin.Context) {
		if isReady == nil || !isReady.Load().(bool) {
			c.JSON(http.StatusServiceUnavailable, gin.H{
				"ready": "ko",
			})
			return
		}
		c.JSON(http.StatusOK, gin.H{
			"ready": "ok",
		})
	}

	return gin.HandlerFunc(fn)
}

// Handler for storing telemetry data in the message buffer
func storeTelemetryData(c *gin.Context) {
	var data TelemetryData
	// Validate the fields
	if err := c.ShouldBindJSON(&data); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	if payloadBytes, err := json.Marshal(data); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
	} else {
		// Submit the message to the worker pool
		WorkerPool.Submit(
			publishMessage(
				context.Background(),
				Topic,
				&MessagePayload{PayloadBytes: payloadBytes}))
		metrics.IncPublished()
		metrics.AddPublishedSize(float64(len(payloadBytes)))
		c.JSON(http.StatusCreated, data)
	}

}
