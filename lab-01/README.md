# GKE Observability Workshop LAB-01

## Deploy blueprints application

[![Context](https://img.shields.io/badge/GKE%20Observability%20Workshop-01-blue.svg)](#)
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
You need to deploy the [*GKE Observability Blueprints application*](./app/) that we will use during our workshop. This demo Application has been built for demonstrating for illustrating monitoring, logging and tracing with GKE. It does have the following components:

* [REST API](./app/api). Presents an external REST-based API for telemetry. Validates the input and publish a message on a Pub/Sub topic.
* [Worker processor](./app/worker) pulls messages from the Pub/Sub topic as they're available. It scales based on the number of acknowledged messages.

![Demo App](../assets/demo-app.png)

## Preparation

* Assignment of the lab users and playgrounds. Make sure you get access to the GCP project that you will use during the workshop.
* Login to the [Google Cloud console](https://console.cloud.google.com) with the required credentials.
* [Activate Cloud Shell](https://cloud.google.com/shell/docs/launching-cloud-shell) from the Google Cloud console.
* Install [Grafana K6](https://k6.io/docs/get-started/installation/#debian-ubuntu). You will need it later to check that the application has been deployed correctly. *Ignore the warnings that you will receive from Cloud Shell.*
```
sudo gpg -k
sudo gpg --no-default-keyring --keyring /usr/share/keyrings/k6-archive-keyring.gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C5AD17C747E3415A3642D57D77C6C491D6AC1D69
echo "deb [signed-by=/usr/share/keyrings/k6-archive-keyring.gpg] https://dl.k6.io/deb stable main" | sudo tee /etc/apt/sources.list.d/k6.list
sudo apt-get update
sudo apt-get install k6
```
* Once you've launched your [Cloud Shell Terminal](https://cloud.google.com/shell/docs/use-cloud-shell-terminal), check that all the required components are installed and up-to-date.
```
gcloud version
helm version
kubectl version --client=true --output=yaml
skaffold version
terraform version
k6 version
```

## Deploy the application

* Set the [*CLOUDSDK_CORE_PROJECT*](https://cloud.google.com/compute/docs/gcloud-compute#default_project) environment variable to your GCP project ID.
```
export CLOUDSDK_CORE_PROJECT=$(gcloud config get-value project)
```

* Set the [default compute region](https://cloud.google.com/compute/docs/gcloud-compute#set-default-region-zone-environment-variables) environment variable to `europe-west6`.
```
export CLOUDSDK_COMPUTE_REGION=europe-west6
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

* Replace `PROJECT_ID_VALUE` in the application deployment specs using the following command.
```
find . -type f -exec sed -i s/PROJECT_ID_VALUE/$CLOUDSDK_CORE_PROJECT/ {} +
```

* Point the [*SKAFFOLD_DEFAULT_REPO*](https://skaffold.dev/docs/environment/image-registries/#:~:text=default%2Drepo%20%3Cmyrepo%3E-,SKAFFOLD_DEFAULT_REPO,-environment%20variable) environment variable to the Artifact Registry repository.
```
export SKAFFOLD_DEFAULT_REPO=$CLOUDSDK_COMPUTE_REGION-docker.pkg.dev/$CLOUDSDK_CORE_PROJECT/$REPO_NAME
```

* If you just want to [build and push](https://skaffold.dev/docs/builders/builder-types/docker/) the containers to the Artifact Registry repository use.
```
skaffold build -f skaffold-01.yaml
```

* If you want to build and push the containers to the Artifact Registry repository and also [deploy the application](https://skaffold.dev/docs/deployers/kubectl/) to the GKE cluster use.
```
kubectl create ns blueprints
skaffold run -f skaffold-01.yaml
```

## Cluster Application Check / Playground

* Once the application is deployed, check that the application is running.
```shell
$ kubectl get pods -n blueprints
NAME                                 READY   STATUS    RESTARTS   AGE
blueprints-api-5df98f7c4d-w2frz      1/1     Running   0          103s
blueprints-worker-5b44df6bff-qww8c   1/1     Running   0          97s
```

* After some time check that the Gateway has been deployed and annotate the IP address of the external Load Balancer. It might take some time to provision the external Load Balancer.
```
export GATEWAY_IP=$(kubectl get gateway blueprints-api -n blueprints -o jsonpath='{.status.addresses[].value}')
```

* Change the `gatewayIP` address of the [K6 test script](./app/loadtest/test.js) to the IP address of the external Load Balancer that has been created.
```
find . -type f -exec sed -i s/GATEWAY_IP_VALUE/$GATEWAY_IP/ {} +
```
* Run the [K6 test script](./app/loadtest/test.js) and [check that there are no errors](https://k6.io/docs/get-started/results-output/).
```
k6 run loadtest/test.js
```

## Links
- [Skaffold documentation](https://skaffold.dev/docs)
- [Artifact Registry documentation](https://cloud.google.com/artifact-registry/docs/docker/store-docker-container-images)
- [Deploying Gateways in GKE](https://cloud.google.com/kubernetes-engine/docs/how-to/deploying-gateways)
- [Running K6](https://k6.io/docs/get-started/running-k6/)
