# GKE Observability Workshop LAB-07

## GKE Monitoring and Alerting

[![Context](https://img.shields.io/badge/GKE%20Observability%20Workshop-07-blue.svg)](#)
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
* The goal of this lab is creating a Cloud Monitoring [custom dashboard]() that reflects the performance metrics of both [API component](../lab-01/app/api/k8s/deployment.yaml) and [Worker component](../lab-01/app/worker/k8s/deployment.yaml).
* After you have created the dashboard we would like to create 

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
k6 version
```

## Deployment


* Create the Cloud Monitoring custom dashboard with the following information.
    * *Ingress bytes count* per GKE Pod for the `blueprints` namespace. You can check [Google Cloud Monitoring networking metrics](https://cloud.google.com/monitoring/api/metrics_gcp#gcp-networking) to find a valid metric to represent.
    * *Number of published messages by pod* for the [API component](../lab-01/app/api/metrics/main.go).
    * *Total size of published messages by pod* for the [API component](../lab-01/app/api/metrics/main.go).
    * *Number of received requests by pod* breakdown by `path` and `code` for the [API component](../lab-01/app/api/metrics/main.go).
    * *Number of received messages by pod* for the [WORKER component](../lab-01/app/worker/metrics/main.go).
    * *Number of errors while receiving messages by pod* for the [WORKER component](../lab-01/app/worker/metrics/main.go).
    * *Total size of received messages by pod* for the [WORKER component](../lab-01/app/worker/metrics/main.go).

## Playground Check
TODO

## Links

- [Create and manage custom dashboards](https://cloud.google.com/monitoring/charts/dashboards).
- [Select metrics for charts on dashboards](https://cloud.google.com/monitoring/charts/selecting-aggregating-metrics).
- [Google Cloud Monitoring networking metrics](https://cloud.google.com/monitoring/api/metrics_gcp#gcp-networking).
- [Google Cloud Monitoring GKE system metrics](https://cloud.google.com/monitoring/api/metrics_kubernetes).


