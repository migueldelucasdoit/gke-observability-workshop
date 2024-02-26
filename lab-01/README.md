# GKE Observability Workshop LAB-01

## Kubernetes probes

[![Context](https://img.shields.io/badge/GKE%20Observability%20Workshop-01-blue.svg)](#)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

## Introduction
You need to deploy the [GKE Observability Blueprints application](./app/README.md) that we will use during our workshop.
The `api` application is currently deployed without readiness and liveness probes. Since this application will receive traffic (HTTP requests), it's important to set up a liveness and a readiness probe.

## Add liveness and readiness probes

Edit the `blueprints-api` deployment in the `blueprints` namespace to add liveness and readiness probes. You can use the HTTP health checks `/healthz` and `/readyz` for liveness and readiness probes respectively.

*Tips: You can use the `kubectl -n blueprints edit deploy blueprints-api` command.*

After editing the deployment you should see a new pod starting and becoming ready after few seconds:
```log
blueprints-api-5dbb46dc7-l42rc    0/1     Init:0/1          0          3s
blueprints-api-5dbb46dc7-l42rc    0/1     PodInitializing   0          4s
blueprints-api-5dbb46dc7-l42rc    0/1     Running           0          5s
blueprints-api-5dbb46dc7-l42rc    0/1     Running           0          10s
blueprints-api-5dbb46dc7-l42rc    1/1     Running           0          12s
```

Have a look at the [deployment.yaml](solution/deployment.yaml) file for the solution.

## Links

- https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes
