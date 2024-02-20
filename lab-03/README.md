# GKE Observability Workshop LAB-03

## GKE Metrics

[![Context](https://img.shields.io/badge/GKE%20Fundamentals-1-blue.svg)](#)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

## Introduction
Each application (`api` and `worker`) contains a `metrics` package defining and populating Prometheus metrics. Those metrics are exposed on a specific internal port in order to be scraped.
Since Managed Prometheus is enabled on the GKE cluster, defining `PodMonitoring` objects is the only required step for these metrics to be scraped by GMP.

## Deployment
Create a `PodMonitoring` object for each service (`api` and `worker`) in order to specify how metrics should be scrapped.

*Hint: both the `api` and `worker` services expose metrics on the `/metrics` path (which is the default) on the port named `system`*

Have a look at the [api.yaml](solution/api.yaml) and [worker.yaml](solution/worker.yaml) files for the solution.

## Playground Check
Metrics can then be queried on the **Metrics explorer** page using the PromQL language.
Go to the **Metrics explorer** page, click on "MQL", then select PromQL.
At this stage, you can retrieve all metrics exported by applications. For example, you can type `api_received_requests`.

You can also create a dashboard that uses those metrics.
A sample dashboard can be found in the [dashboard.json](solution/dashboard.json) file.

## Links

- https://cloud.google.com/stackdriver/docs/managed-prometheus/setup-managed
- https://prometheus.io/docs/prometheus/latest/querying/basics/
- https://prometheus.io/docs/prometheus/latest/querying/functions/
- https://cloud.google.com/monitoring/charts/dashboards#edit-dashboard
