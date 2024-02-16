# GKE Observability Workshop LAB-02

## GKE Logging

[![Context](https://img.shields.io/badge/GKE%20Fundamentals-1-blue.svg)](#)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

## Introduction
The goal of this lab is to create a logging bucket with analytics enabled.
This logging bucket will be associated with a log sink to route application logs to this bucket. It will use some labels for filtering relevant application logs while excluding telemetry logs.
We will also create another log sink to avoid application logs duplication by filtering out application logs from the `_Default` logging bucket.

## Deployment
First, you need to create a logging bucket named `blueprints-app-logs` with analytics enabled and a retention of 10 days.

Then, you need to create a logging sink named `blueprints-app-logs-sink` that route applications logs to the previously created logging bucket.
You can filter those logs based on the cluster name, the resource type and labels associated to the application pods. Don't forget to exclude logs coming from the OpenTelemetry Instrumentation pods.

Finally, create another logging sink named `blueprints-exclude-app-logs-sink` that excludes applications logs from the `_Default` logging bucket.
You can filter those logs based on the labels associated to the application pods, as well as the OpenTelemetry instrumentation pods.

## Playground Check
On the **Log Storage** page, the `blueprints-app-logs` bucket appears with analytics enabled.

On the **Log Router** page, you can see 2 filters:
- `blueprints-app-logs-sink`: Used to route applications' logs to the `blueprints-app-logs` bucket
- `blueprints-exclude-app-logs-sink`: Used to avoid application logs duplication in the `_Default` bucket

On the **Logs Explorer**, using the "Refine scope" button and choosing the `blueprints-app-logs` bucket allows to display only application logs (emitted by the `api` and `worker`).

On the **Log Analytics** page, you can query application's logs.

Here is a query example:
*(replace `XXX` with your project ID)*
```sql
SELECT
    timestamp, severity, json_payload, JSON_VALUE(json_payload.status), resource
FROM
    `XXX.global.blueprints-app-logs._AllLogs`
WHERE
    JSON_VALUE(resource.labels.container_name) = "api" AND JSON_VALUE(json_payload.status) IS NOT NULL
    LIMIT 10000
```

## Links

- https://cloud.google.com/logging/docs/buckets
- https://cloud.google.com/logging/docs/export/configure_export_v2
- https://cloud.google.com/logging/docs/export/using_exported_logs
- https://cloud.google.com/logging/docs/log-analytics
- https://cloud.google.com/logging/docs/analyze/query-and-view