resource "google_logging_project_bucket_config" "app-logs-bucket" {
  project          = var.project_id
  location         = var.region
  retention_days   = 10
  enable_analytics = true
  bucket_id        = "${var.stack_name}-app-logs"
  locked           = false
}

resource "google_logging_project_sink" "app-logs-sink" {
  name = "${var.stack_name}-app-logs-sink"

  destination = "logging.googleapis.com/${google_logging_project_bucket_config.app-logs-bucket.id}"

  # Log all WARN or higher severity messages relating to instances
  filter                 = "resource.labels.cluster_name = ${var.gke_cluster_name} AND resource.type=\"k8s_container\" AND labels.\"k8s-pod/logs\"=\"app-sink\" AND -resource.labels.container_name=\"opentelemetry-auto-instrumentation\""
  unique_writer_identity = true
}

resource "google_logging_project_sink" "exclude-app-logs-sink" {
  name = "${var.stack_name}-exclude-app-logs-sink"

  destination = "logging.googleapis.com/projects/${var.project_id}/locations/global/buckets/_Default"

  # Log all WARN or higher severity messages relating to instances
  filter                 = "-labels.\"k8s-pod/logs\"=\"app-sink\" AND -resource.labels.container_name=\"opentelemetry-auto-instrumentation\""
  unique_writer_identity = true
}