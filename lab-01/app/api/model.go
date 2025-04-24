package main

import (
	"time"
)

// Model for TelemetryData
type TelemetryData struct {
	Timestamp   time.Time `json:"timestamp" binding:"required"`
	DeviceId    string    `json:"device_id" binding:"required,max=100"`
	MemoryUsage float32   `json:"memory_usage" binding:"required,gte=0,lte=1"`
	CpuUsage    float32   `json:"cpu_usage" binding:"required,gte=0,lte=1"`
}

// Model for message payload
type MessagePayload struct {
	PayloadBytes []byte
}

type PublishResponse struct {
	ResultBytes []byte
	Err         error
}
