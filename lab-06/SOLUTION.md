# Solution GKE Observability Workshop LAB-06

## Filter GKE Logs

[![Context](https://img.shields.io/badge/GKE%20Observability%20Workshop-06-blue.svg)](#)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

## Steps

* Set the [*CLOUDSDK_CORE_PROJECT*](https://cloud.google.com/compute/docs/gcloud-compute#default_project) environment variable to your GCP project ID.
```
export CLOUDSDK_CORE_PROJECT=$(gcloud config get-value project)
```

* Set the [default compute region](https://cloud.google.com/compute/docs/gcloud-compute#set-default-region-zone-environment-variables) environment variable to `europe-west6`.
```
export CLOUDSDK_COMPUTE_REGION=europe-west6
```

* Set the [default compute zone](https://cloud.google.com/compute/docs/gcloud-compute#set-default-region-zone-environment-variables) environment variable to `europe-west6-a`.
```
export CLOUDSDK_COMPUTE_ZONE=europe-west6a
```

* Position yourself in the lab folder.
```
cd ~/gke-observability-workshop/lab-06
```

* Update the logging sink to route application logs and add the exclusion.

```shell
gcloud logging sinks update blueprints-app-logs-sink --add-exclusion="name=opentelemetry-auto-instrumentation,filter=resource.labels.cluster_name=\"gke-otel-blueprints\" AND resource.type=\"k8s_container\" AND resource.labels.container_name=\"opentelemetry-auto-instrumentation\""
```

* Update the logging sink that avoid logs duplication and add the exclusion. This sink avoid application logs duplication in the `_Default` bucket.

```shell
gcloud logging sinks update blueprints-exclude-app-logs-sink --add-exclusion="name=opentelemetry-auto-instrumentation,filter=resource.labels.container_name=\"opentelemetry-auto-instrumentation\""
```