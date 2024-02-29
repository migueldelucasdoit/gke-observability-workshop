# GKE Observability Workshop LAB-03

## GKE Logging

[![Context](https://img.shields.io/badge/GKE%20Observability%20Workshop-03-blue.svg)](#)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

## Prerequisites

* [Terraform 0.13+](https://developer.hashicorp.com/terraform/downloads) Tool that manages IaC 
* [Google Cloud SDK](https://cloud.google.com/sdk/docs/install) Google Cloud Command Line Interface.
* [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/) The Kubernetes command-line tool, kubectl, allows you to run commands against Kubernetes clusters.
* [Helm 3.0+](https://helm.sh/docs/) Helm is the package manager for Kubernetes.
* [Skaffold](https://skaffold.dev/) Skaffold is a command line tool that facilitates continuous development for container based & Kubernetes applications. It's included as an optional component in Google Cloud SDK and you can install it.

All these tools are available in Google Cloud Cloud Shell which can be [launched](https://cloud.google.com/shell/docs/launching-cloud-shell) from the Google Cloud console.


## Introduction
The goal of this lab is to create a logging bucket with analytics enabled.
This logging bucket will be associated with a log sink to route application logs to this bucket. It will use some labels for filtering relevant application logs while excluding telemetry logs.
We will also create another log sink to avoid application logs duplication by filtering out application logs from the `_Default` logging bucket.

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

* First, you need to create a logging bucket named `blueprints-app-logs` with analytics enabled and a retention of 10 days.
* Then, you need to create a logging sink named `blueprints-app-logs-sink` that route applications logs to the previously created logging bucket.
* You can filter those logs based on the cluster name, the resource type and labels associated to the application pods. Don't forget to exclude logs coming from the OpenTelemetry Instrumentation pods.
* Finally, create another logging sink named `blueprints-exclude-app-logs-sink` that excludes applications logs from the `_Default` logging bucket.
You can filter those logs based on the labels associated to the application pods, as well as the OpenTelemetry instrumentation pods.

## Playground Check
* On the **Log Storage** page, the `blueprints-app-logs` bucket appears with analytics enabled.
* On the **Log Router** page, you can see 2 filters:
    - `blueprints-app-logs-sink`: Used to route applications' logs to the `blueprints-app-logs` bucket
    - `blueprints-exclude-app-logs-sink`: Used to avoid application logs duplication in the `_Default` bucket
* On the **Logs Explorer**, using the "Refine scope" button and choosing the `blueprints-app-logs` bucket allows to display only application logs (emitted by the `api` and `worker`).
* On the **Log Analytics** page, you can query application's logs.

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



## Deploy the application

* Set the [*CLOUDSDK_CORE_PROJECT*](https://cloud.google.com/compute/docs/gcloud-compute#default_project) environment variable to your GCP project ID.
```
export CLOUDSDK_CORE_PROJECT=PROJECT_ID
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

* Position yourself in the lab folder.
```
cd ~/gke-observability-workshop/lab-01/app
```

* Point the [*SKAFFOLD_DEFAULT_REPO*](https://skaffold.dev/docs/environment/image-registries/#:~:text=default%2Drepo%20%3Cmyrepo%3E-,SKAFFOLD_DEFAULT_REPO,-environment%20variable) environment variable to the Artifact Registry repository.
```
$ export SKAFFOLD_DEFAULT_REPO=$CLOUDSDK_COMPUTE_REGION-docker.pkg.dev/$CLOUDSDK_CORE_PROJECT/$REPO_NAME
```

* If you just want to [build and push](https://skaffold.dev/docs/builders/builder-types/docker/) the containers to the Artifact Registry repository use.
```
skaffold build
```

* If you want to build and push the containers to the Artifact Registry repository and also [deploy the application](https://skaffold.dev/docs/deployers/kubectl/) to the GKE cluster use.
```
kubectl create ns blueprints
skaffold run
```

## Cluster Application Check / Playground

* Once the application is deployed, check that the application is running.
```
kubectl get pods -n blueprints
```

* After some time the applCheck that the Gateway has been deployed and 

## Links
- [Skaffold documentation](https://skaffold.dev/docs)
- [Artifact Registry documentation](https://cloud.google.com/artifact-registry/docs/docker/store-docker-container-images)
