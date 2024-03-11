#############################################################################
# Pub/Sub                                                                   #
#############################################################################

resource "google_pubsub_topic" "blueprints_topic" {
  name = "blueprints-topic"

  labels = local.common_labels

  message_storage_policy {
    allowed_persistence_regions = [
      var.region,
    ]
  }
}

resource "google_pubsub_subscription" "blueprints_subscription" {
  name  = "blueprints-subscription"
  topic = google_pubsub_topic.blueprints_topic.name

  labels = local.common_labels

  message_retention_duration = "3600s" # 1 hour
  retain_acked_messages      = true

  ack_deadline_seconds = 20

  expiration_policy {
    ttl = "" # Never expires
  }
  retry_policy {
    minimum_backoff = "10s"
  }

  enable_message_ordering = false
}