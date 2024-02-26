# GKE Observability Workshop LAB-00

[![Context](https://img.shields.io/badge/GKE%20Observability%20Workshop-00-blue.svg)](#)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

## Prerequisites

* [Terraform 0.13+](https://developer.hashicorp.com/terraform/downloads) Tool that manages IaC 
* [Google Cloud SDK](https://cloud.google.com/sdk/docs/install) Google Cloud Command Line Interface.
* [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/) The Kubernetes command-line tool, kubectl, allows you to run commands against Kubernetes clusters.
* [Helm 3.0+](https://helm.sh/docs/) Helm is the package manager for Kubernetes.
* [Skaffold](https://skaffold.dev/) Skaffold is a command line tool that facilitates continuous development for container based & Kubernetes applications. It's included as an optional component in Google Cloud SDK and you can install it.

All these tools are available in Google Cloud Cloud Shell which can be [launched](https://cloud.google.com/shell/docs/launching-cloud-shell) from the Google Cloud console.

## Introduction
On this lab, we will deploy the required base infrastructure composed of:
- A VPC with necessary network configurations
- A subnet with secondary ranges for GKE pods and services
- A GKE cluster with 2 node pools
- An Artifact Registry repository
- A Pub-Sub topic with its associated subscription
- CertManager and OpenTelemetry operator using Helm charts

## Preparation

* Assignment of the lab users and playgrounds. Make sure you get access to the GCP project that you will use during the workshop.
* Login to the [Google Cloud console](https://console.cloud.google.com) with the required credentials.
* [Activate Cloud Shell](https://cloud.google.com/shell/docs/launching-cloud-shell) from the Google Cloud console.
* Once you've launched your [Cloud Shell Terminal](https://cloud.google.com/shell/docs/use-cloud-shell-terminal), check that all the required components are installed and up-to-date.
```
gcloud version
helm version
kubectl version --short --client-only
skaffold version
terraform version
```

* Clone this repository using the following command: 
```
git clone https://github.com/migueldelucasdoit/gke-observability-workshop.git 
```

## Create the required infrastructure

* Position yourself in the lab folder.
```
cd ~/gke-observability-workshop/lab-00/iac
```

* Initialize the Terraform environment using the following command: 
```
terraform init
```

* Then, edit the [terraform.tfvars.sample](./iac/terraform.tfvars.sample) using [Cloud Editor](https://cloud.google.com/shell/docs/launching-cloud-shell-editor) and set the `project_id` to match the GCP project ID you're using. You can check it from Cloud Shell using the following command:
```
gcloud config get-value project
```

* Apply the stack using the following command. *(If you're prompted with a dialog box, click on "Authorize".)* Enter `yes`.
```
terraform apply --var-file terraform.tfvars.sample
```

## Cluster Application Check / Playground

* Once the stack is deployed, retrieve the GKE cluster credentials using this command: 
```
gcloud container clusters get-credentials gke-otel-blueprints --region europe-west6`
```

Ensure that you can access the Kubernetes API Server. You should see something like:
```shell
$ kubectl version
Client Version: v1.29.0
Kustomize Version: v5.0.4-0.20230601165947-6ce0bf390ce3
Server Version: v1.29.0-gke.1381000
```

* The GKE cluster has been created with two node pools and it has enabled several features that will be needed in the next labs.
    - Check that [Config Connector](https://cloud.google.com/config-connector/docs/troubleshooting#check-if-running) is running.
    - Check that [Google Managed Service for Prometheus](https://cloud.google.com/stackdriver/docs/managed-prometheus/troubleshooting#no-errors) is running.


## Links

- https://cloud.google.com/sdk/gcloud/reference/container/clusters/create
- https://kubernetes.io/docs/reference/kubectl/cheatsheet/
- https://phoenixnap.com/kb/kubectl-commands-cheat-sheet
- https://cloud.google.com/kubernetes-engine/docs/how-to/workload-identity
