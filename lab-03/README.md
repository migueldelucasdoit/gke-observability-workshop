# GKE Observability Workshop LAB-03

## GKE Metrics

[![Context](https://img.shields.io/badge/GKE%20Fundamentals-1-blue.svg)](#)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

## Introduction
Each application (`api` and `worker`) contains a `metrics` package defining and populating Prometheus metrics. Those metrics are exposed on a specific internal port in order to be scraped.
Since Managed Prometheus is enabled on the GKE cluster, defining `PodMonitoring` objects is the only required step for these metrics to be scraped by GMP.

## Deployment
Both applications come with K8S manifests. Those manifests include a `PodMonitoring` object. This object specify the pod port to use to scrap metrics as well as the scraping interval:
```
  endpoints:
    - port: system
      interval: 5s
```

## Playground Check
Metrics can then be queried on the **Metrics explorer** page using the PromQL language.
Go to the **Metrics explorer** page, click on "MQL", then select PromQL.
At this stage, you can retrieve all metrics exported by applications. For example, you can type `api_received_requests`.

There is also a Service Dashboard that is using those metrics.

## Links

- https://cloud.google.com/stackdriver/docs/managed-prometheus/setup-managed
- https://prometheus.io/docs/prometheus/latest/querying/basics/
- https://prometheus.io/docs/prometheus/latest/querying/functions/
