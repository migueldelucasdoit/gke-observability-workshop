# GKE Observability Blueprints App

Demo Application for demonstrating for illustrating monitoring, logging and tracing with GKE. It does have the following components:

* [REST API](./api). Presents an external REST-based API for telemetry. Validates the input and publish a message on a Pub/Sub topic.
* [Worker processor](./worker) pulls messages from the Pub/Sub topic as they're available. It scales based on the number of acknowledged messages.

![Demo App](../assets/demo-app.png)

## Prerequisites

* [Google Cloud SDK](https://cloud.google.com/sdk/docs/install) Google Cloud Command Line Interface.
* [Golang 1.20+](https://go.dev/doc/install) Go language.
* [Skaffold](https://skaffold.dev/) Skaffold is a command line tool that facilitates continuous development for container based & Kubernetes applications. It's included as an optional component in Google Cloud SDK and you can install it.

```
$ gcloud components install skaffold
```


## Deploy application.
To build and push your application to the Artifact Registry repository and deploy it to your GKE cluster. Make sure that you have valid [GCP credentials](https://cloud.google.com/sdk/docs/authorizing).

* Obtain credentials for GKE cluster.
```
gcloud container clusters get-credentials gke-otel-blueprints --region europe-west6
```

* Point the *SKAFFOLD_DEFAULT_REPO* environment variable to the external registry.
```
$ export SKAFFOLD_DEFAULT_REPO=europe-west6-docker.pkg.dev/PROJECT_ID_VALUE/blueprints-repository
```

* Set the *SKAFFOLD_PROFILE* environment variable to use the `sandbox` profile. 
```
$ export SKAFFOLD_PROFILE=sandbox
```

* If you just want to build and push the containers to the external registry use.
```
$ skaffold build
```

* If you want to build and push the containers to the external registry and also deploy the application to GKE use.
```
$ kubectl create ns blueprints
$ skaffold run
```

* If you want to delete the application from GKE use.
```
$ skaffold delete
```