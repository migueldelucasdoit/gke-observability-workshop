# GKE Observability Workshop LAB-04

## GKE Metrics

[![Context](https://img.shields.io/badge/GKE%20Observability%20Workshop-04-blue.svg)](#)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

## Prerequisites

* [Terraform 0.13+](https://developer.hashicorp.com/terraform/downloads) Tool that manages IaC 
* [Google Cloud SDK](https://cloud.google.com/sdk/docs/install) Google Cloud Command Line Interface.
* [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/) The Kubernetes command-line tool, kubectl, allows you to run commands against Kubernetes clusters.
* [Helm 3.0+](https://helm.sh/docs/) Helm is the package manager for Kubernetes.
* [Skaffold](https://skaffold.dev/) Skaffold is a command line tool that facilitates continuous development for container based & Kubernetes applications. It's included as an optional component in Google Cloud SDK and you can install it.
* [K6](https://k6.io/docs/). Grafana k6 is an open-source load testing tool that makes performance testing easy and productive for engineering teams. 

All these tools are available in Google Cloud Cloud Shell which can be [launched](https://cloud.google.com/shell/docs/launching-cloud-shell) from the Google Cloud console.


## Introduction
* Each application component ([*api*](../lab-01/app/api/) and [*worker*](../lab-01/app/worker/) contains a `metrics` package defining and populating Prometheus metrics. Those metrics are exposed on a specific internal port in order to be scraped.
* Since Managed Prometheus is enabled on the GKE cluster, defining `PodMonitoring` objects is the only required step for these metrics to be scraped by GMP.

## Preparation

* Assignment of the lab users and playgrounds. Make sure you get access to the GCP project that you will use during the workshop.
* Login to the [Google Cloud console](https://console.cloud.google.com) with the required credentials.
* [Activate Cloud Shell](https://cloud.google.com/shell/docs/launching-cloud-shell) from the Google Cloud console.
* Once you've launched your [Cloud Shell Terminal](https://cloud.google.com/shell/docs/use-cloud-shell-terminal), check that all the required components are installed and up-to-date.
```
gcloud version
helm version
kubectl version --client=true --output=yaml
skaffold version
terraform version
```

## Deployment
* Create a `PodMonitoring` object for each service (`api` and `worker`) in order to specify how metrics should be scrapped. You can use [Cloud Editor](https://cloud.google.com/shell/docs/launching-cloud-shell-editor) for that purpose.
*Hint: both the `api` and `worker` services export metrics on the `/metrics` endpoint on the port named `system`*

* Take a look to the `metrics` package in [*api*](../lab-01/app/api/metrics/) and [*worker*](../lab-01/app/worker/metrics/) components to check which metrics are exported.


## Playground Check
* Metrics can then be queried on the **Metrics explorer** page using the PromQL language.

* Go to the **Metrics explorer** page, click on "MQL", then select PromQL. At this stage, you can retrieve all metrics exported by applications. 

## Links

- [Get started with managed collection](https://cloud.google.com/stackdriver/docs/managed-prometheus/setup-managed).
- [Querying Prometheus](https://prometheus.io/docs/prometheus/latest/querying/basics/).
- [PromQL Functions](https://prometheus.io/docs/prometheus/latest/querying/functions/).
- [PromQL in Cloud Monitoring](https://cloud.google.com/monitoring/promql).
