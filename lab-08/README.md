# GKE Observability Workshop LAB-08

## Destroy the provisioned environment

[![Context](https://img.shields.io/badge/GKE%20Observability%20Workshop-08-blue.svg)](#)
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
* Destroy all the resources provisioned in the environment, so you don't incur in additional costs.

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

* Obtain the name of the [Artifact Registry container image repository](https://cloud.google.com/sdk/gcloud/reference/artifacts/repositories/list) that has been provisioned in the environment. This repository will be used to store the container images of the application.

```
export REPO_NAME=$(gcloud artifacts repositories list --location=$CLOUDSDK_COMPUTE_REGION --format="value(name)")
```

* Set up [Artifact Registry authentication for Docker](https://cloud.google.com/artifact-registry/docs/docker/authentication#gcloud-helper)
```
gcloud auth configure-docker $CLOUDSDK_COMPUTE_REGION-docker.pkg.dev
```

* Obtain credentials for GKE cluster.
```
gcloud container clusters get-credentials gke-otel-blueprints --region $CLOUDSDK_COMPUTE_REGION
```

* Point the [*SKAFFOLD_DEFAULT_REPO*](https://skaffold.dev/docs/environment/image-registries/#:~:text=default%2Drepo%20%3Cmyrepo%3E-,SKAFFOLD_DEFAULT_REPO,-environment%20variable) environment variable to the Artifact Registry repository.
```
export SKAFFOLD_DEFAULT_REPO=$CLOUDSDK_COMPUTE_REGION-docker.pkg.dev/$CLOUDSDK_CORE_PROJECT/$REPO_NAME
```

## Destroy OpenTelemetry resources

* Position yourself in the `lab-05` folder.
```
cd ~/gke-observability-workshop/lab-05
```

* Delete the [OpenTelemetry Instrumentation](https://opentelemetry.io/docs/instrumentation/) resource.
```
kubectl delete -f otelcollector/04-instrumentation.yaml
```

* Delete the [OpenTelemetry Collector](https://opentelemetry.io/docs/collector/).
```
kubectl delete -f otelcollector/03-collectorconfig.yaml
```

* Delete the GCP IAM resources using Config Connector.
```
kubectl delete -f otelcollector/02-workloadidentity.yaml
```

* Delete the K8s service account with permissions.
```
kubectl delete -f otelcollector/01-rbac.yaml
```

## Destroy the application

* Position yourself in the `lab-01` folder.
```
cd ~/gke-observability-workshop/lab-01/app
```

* Delete the application and provided resources using `skaffold`.
```
skaffold delete -f skaffold-01.yaml
```

## Destroy the Cloud Logging resources

* Delete the logging sink to route application logs.

```shell
gcloud logging sinks delete blueprints-app-logs-sink --quiet
```

* Delete the logging sink that avoid logs duplication. 

```shell
gcloud logging sinks delete blueprints-exclude-app-logs-sink --quiet
```

* Delete the logging bucket

```shell
gcloud logging buckets delete blueprints-app-logs --location=global --quiet
```

## Destroy the infrastructure

* Position yourself in the `lab-00` folder.
```
cd ~/gke-observability-workshop/lab-00/iac
```

* Initialize the Terraform environment using the following command: 
```
terraform init
```

* Destroy the GKE cluster in the Terraform stack using the following command. *(If you're prompted with a dialog box, click on "Authorize".)* Enter `yes`. The stack takes about *20 minutes* to be fully destroyed.
```
terraform apply -destroy --var-file terraform.tfvars.sample --target module.gke
```

* Destroy the remaining Terraform resources using the following command. *(If you're prompted with a dialog box, click on "Authorize".)* Enter `yes`.
```
terraform apply -destroy --var-file terraform.tfvars.sample
```

## Playground Check

* Check that the GKE cluster has been deleted.
```
gcloud container clusters list --region $CLOUDSDK_COMPUTE_REGION
```

## Links

- [Basic Terraform commands](https://cloud.google.com/docs/terraform/basic-commands)
- [Terraform stack documentation](../lab-00/iac/README.md)
- [kubectl cheat sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)
- [Skaffold documentation](https://skaffold.dev/docs)
- [Google Cloud SDK cheat sheet](https://gist.github.com/pydevops/cffbd3c694d599c6ca18342d3625af97)
