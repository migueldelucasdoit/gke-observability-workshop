# Solution GKE Observability Workshop LAB-03

## GKE Logging

[![Context](https://img.shields.io/badge/GKE%20Observability%20Workshop-03-blue.svg)](#)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

## Steps

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

* Position yourself in the lab folder.
```
cd ~/gke-observability-workshop/lab-01/app
```

* Copy the Skaffold configuration file [`skaffold-03.yaml`](./app/skaffold-02.yaml) to the [`lab-01/app`](../lab-01/app/) folder.
```
cp ../lab-03/app/skaffold-03.yaml ./
```

* Replace `PROJECT_ID_VALUE` in the application deployment specs using the following command.
```
find . -type f -exec sed -i s/PROJECT_ID_VALUE/$CLOUDSDK_CORE_PROJECT/ {} +
```

* Point the [*SKAFFOLD_DEFAULT_REPO*](https://skaffold.dev/docs/environment/image-registries/#:~:text=default%2Drepo%20%3Cmyrepo%3E-,SKAFFOLD_DEFAULT_REPO,-environment%20variable) environment variable to the Artifact Registry repository.
```
export SKAFFOLD_DEFAULT_REPO=$CLOUDSDK_COMPUTE_REGION-docker.pkg.dev/$CLOUDSDK_CORE_PROJECT/$REPO_NAME
```

* [Deploy the application](https://skaffold.dev/docs/deployers/kubectl/) to the GKE cluster.
```
skaffold run -f skaffold-03.yaml
```

* Create the logging bucket

```shell
gcloud logging buckets create blueprints-app-logs --location=global --enable-analytics --retention-days 10
```

* Create the logging sink to route application logs.

```shell
gcloud logging sinks create blueprints-app-logs-sink logging.googleapis.com/projects/$CLOUDSDK_CORE_PROJECT/locations/global/buckets/blueprints-app-logs --log-filter "resource.labels.cluster_name=\"gke-otel-blueprints\" AND resource.type=\"k8s_container\" AND labels.\"k8s-pod/logs\"=\"app-sink\""
```

* Create the logging sink that avoid logs duplication. This sink avoid application logs duplication in the `_Default` bucket.

```shell
gcloud logging sinks create blueprints-exclude-app-logs-sink logging.googleapis.com/projects/$CLOUDSDK_CORE_PROJECT/locations/global/buckets/_Default --exclusion=name=application-pods-logs,filter=labels.\"k8s-pod/logs\"=\"app-sink\""
```