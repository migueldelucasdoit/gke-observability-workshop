# Terraform stack for Open Telemetry Blueprints

## Description
Provisioning stack with Open Telemetry resources.

## Prerequisites
* [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/) The Kubernetes command-line tool, kubectl, allows you to run commands against Kubernetes clusters.
* [Google Cloud SDK](https://cloud.google.com/sdk/docs/install) Google Cloud Command Line Interface.

## Connection to GKE control plane
* Obtain credentials for GKE cluster.
```
gcloud container clusters get-credentials gke-otel-blueprints --region europe-west6
```

* Set [USE_GKE_GCLOUD_AUTH_PLUGIN](https://cloud.google.com/blog/products/containers-kubernetes/kubectl-auth-changes-in-gke) environment variable.
```
export USE_GKE_GCLOUD_AUTH_PLUGIN=True
```

* Use kubectl as usual.

## Create Open Telemetry resources
* Create the `blueprints` namespace and K8s service account
```
kubectl apply -f 01-base.yaml
```

* Configure the GCP IAM resources using Config Connector.
```
kubectl apply -f 02-workloadidentity.yaml
```

* Create the Open Telemetry [Connector](https://opentelemetry.io/docs/collector/).
```
kubectl apply -f 03-collectorconfig.yaml
```

* Create the Open Telemetry [Instrumentation](https://opentelemetry.io/docs/instrumentation/).
```
kubectl apply -f 04-instrumentation.yaml
```

## Delete Open Telemetry resources

* Delete the Open Telemetry [Instrumentation](https://opentelemetry.io/docs/instrumentation/).
```
kubectl delete -f 04-instrumentation.yaml
```

* Delete the Open Telemetry [Connector](https://opentelemetry.io/docs/collector/).
```
kubectl delete -f 03-collectorconfig.yaml
```

* Delete the GCP IAM resources using Config Connector.
```
kubectl delete -f 02-workloadidentity.yaml
```




