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
On this lab, will deploy the required base infrastructure composed of:
- A VPC with necessary network configurations
- A subnet with secondary ranges for GKE pods and services
- A GKE cluster with 2 node pools
- An Artifact Registry repository
- A Pub-Sub topic with its associated subscription
- CertManager and OpenTelemetry operator using HELM charts

## Deployment

Once you've launched your Cloud Shell, clone this repository using the following command: `git clone https://github.com/migueldelucasdoit/gke-observability-workshop.git` (TODO: move the repository under the DoiT organization)

First of all, you need to initialize the terraform environment using the following command (please ensure that you're on the `01-infrastructure` folder): `terraform init`

Then, edit the `terraform.tfvars.sample` to specify your `project_id`.

Apply the stack using the following command: `terraform apply --var-file terraform.tfvars.sample`. *(If you're prompted with a dialog box, click on "Authorize".)* Enter `yes`.

## Cluster Application Check / Playground
Once the stack is deployed, retrieve the GKE cluster credentials using this command: `gcloud container clusters get-credentials gke-otel-blueprints --region europe-west6`

Ensure that you can access the Kubernetes API Server: `kubectl version`. You should see something like:
```shell
Client Version: v1.29.0
Kustomize Version: v5.0.4-0.20230601165947-6ce0bf390ce3
Server Version: v1.29.0-gke.1381000
```

### Provision Kubernetes system objects

Go to the `02-provision` folder to create necessary Kubernetes resources:
- Patch files with your `PROJECT_ID` using the following command: `sed -i s/PROJECT_ID/XXX/ *.yaml` *(replace `XXX` by your project ID)*
- `kubectl apply -f 01-base.yaml`: creates the application namespace and required RBAC permissions 
- `kubectl apply -f 02-workloadidentity.yaml`: creates required IAM objects for Workload Identity
- `kubectl apply -f 03-collectorconfig.yaml`: creates the OpenTelemetry Collector object required for OpenTelemetry to operate
- `kubectl apply -f 04-instrumentation.yaml`: creates the Instrumentation object to use OpenTelemetry Auto-instrumentation with golang

### Build & Deploy the application

The application is located in the `app` folder. It consists of the following:
- an `api` that listen of incoming messages on the `/telemetry` HTTP endpoint, then publish those messages in a Pub/Sub topic
- a `worker` that pulls messages from the Pub/Sub topic, prints them and ack those messages

We use `skaffold` to easily manage these applications. The first step is to build those two applications.

Go to the `app` folder and path files with your `PROJECT_ID` using the following command:
*(replace `XXX` by your project ID)*
```shell
find . -type f -exec sed -i s/PROJECT_ID_VALUE/XXX/ {} +
```

To build and deploy the applications, go to the `app` folder, then use the following command (replace `XXX` with your GCP project ID): 
```shell
skaffold run --default-repo europe-west6-docker.pkg.dev/XXX/blueprints-repository
```

## Links

- https://cloud.google.com/sdk/gcloud/reference/container/clusters/create
- https://kubernetes.io/docs/reference/kubectl/cheatsheet/
- https://phoenixnap.com/kb/kubectl-commands-cheat-sheet
- https://cloud.google.com/kubernetes-engine/docs/how-to/workload-identity
