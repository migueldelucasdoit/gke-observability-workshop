# Solution

## Create the logging bucket

```shell
gcloud logging buckets create blueprints-app-logs --location=global --enable-analytics --retention-days 10
```

## Create the logging sink to route application logs

*(Replace `XXX` with your GCP Project ID)*
```shell
gcloud logging sinks create blueprints-app-logs-sink logging.googleapis.com/projects/XXX/locations/global/buckets/blueprints-app-logs --log-filter "resource.labels.cluster_name=\"gke-otel-blueprints\" AND resource.type=\"k8s_container\" AND labels.\"k8s-pod/logs\"=\"app-sink\" AND -resource.labels.container_name=\"opentelemetry-auto-instrumentation\""
```

*Please note that you can also use the `--exclusion` flag to filter out logs that you don't want, instead of using a negative filter.*

## Create the logging sink that avoid logs duplication

This sink avoid application logs duplication in the `_Default` bucket. It also filters out OpenTelemetry logs.

*(Replace `XXX` with your GCP Project ID)*
```shell
gcloud logging sinks create blueprints-exclude-app-logs-sink logging.googleapis.com/projects/XXX/locations/global/buckets/_Default --exclusion=name=application-pods-logs,filter=labels.\"k8s-pod/logs\"=\"app-sink\" --exclusion=name=opentelemetry-pods-logs,filter=resource.labels.container_name=\"opentelemetry-auto-instrumentation\"
```