# GKE Observability Workshop LAB-02

## GKE Logging

[![Context](https://img.shields.io/badge/GKE%20Fundamentals-1-blue.svg)](#)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

## Introduction
The stack creates a logging bucket with analytics enabled associated.
This logging bucket is associated with a log sink to route application logs to this bucket. It uses some labels for filtering relevant application logs while excluding telemetry logs.
There is also another log sink to avoid application logs duplication by filtering out application logs from the `_Default` logging bucket.

## Deployment
There's nothing special to deploy here. Everything has been created by the Terraform stack. You can have a look at the `logs.tf` file to check how things have been configured.

## Playground Check
On the **Log Storage** page, the `backend-otel-blueprints-app-logs` bucket appears with analytics enabled.

On the **Log Router** page, you can see 2 filters:
- `backend-otel-blueprints-app-logs-sink`: Used to route applications' logs to the `backend-otel-blueprints-app-logs` bucket
- `backend-otel-blueprints-exclude-app-logs-sink`: Used to avoid application logs duplication in the `_Default` bucket

On the **Logs Explorer**, using the "Refine scope" button and choosing the `backend-otel-blueprints-app-logs` bucket allows to display only application logs (emitted by the `api` and `worker`).

On the **Log Analytics** page, you can query application's logs.

## Links

- https://cloud.google.com/logging/docs/buckets
- https://cloud.google.com/logging/docs/export/configure_export_v2
- https://cloud.google.com/logging/docs/export/using_exported_logs
- https://cloud.google.com/logging/docs/log-analytics
- https://cloud.google.com/logging/docs/analyze/query-and-view