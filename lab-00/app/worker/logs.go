package main

import (
	log "github.com/sirupsen/logrus"
	"os"
)

func setupLogger() {
	log.SetFormatter(&log.JSONFormatter{})
	log.SetOutput(os.Stdout)
	log.SetLevel(log.InfoLevel)
}
