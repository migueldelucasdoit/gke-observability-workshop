# GKE Observability Workshop

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![GKE/K8s Version](https://img.shields.io/badge/k8s%20version-1.26.5-blue.svg)](#)
[![GCloud SDK Version](https://img.shields.io/badge/gcloud%20version-440.0.0-blue.svg)](#)

## Introduction

In this workshop, we will look at the landscape of GKE Observability with special focus on logging, monitoring and distributed tracing. We will also see best practices on monitoring.

## Available Labs

| Lab/Folder                                                                           | Description                                                             |
| ------------------------------------------------------------------------------------ | ----------------------------------------------------------------------- |
| [lab-00](./lab-00/README.md)                                 | Create and provision environment        |
| [lab-01](./lab-01/README.md)                             | Kubernetes probes            |
| [lab-02](./lab-02/README.md)                                       | GKE Logging  |
| [lab-03](./lab-03/README.md)                         | GKE Metrics           |
| [lab-04](./lab-04/README.md)                         | GKE Distributed Tracing |
| [lab-05](./lab-05/README.md)               |   GKE Monitoring and alerting             |

## Core Requirements

For the use of the local development environment for all GKE/K8s relevant CLI/API calls a certain tool set is required and Linux or macOS as operating system is recommended. If it is not possible to install our stack due to limitations in terms of feasibility/availability in the preparation, you can alternatively use the browser-internal cloud shell of your GCP console.

- `gcloud sdk` [installation](https://cloud.google.com/sdk/docs/install) tutorial
- `kubectl` [installation](https://cloud.google.com/kubernetes-engine/docs/how-to/cluster-access-for-kubectl#install_kubectl) tutorial
- `gke-gcloud-auth-plugin` [installation](https://cloud.google.com/kubernetes-engine/docs/how-to/cluster-access-for-kubectl#install_plugin)
- Skaffold [installation](https://cloud.google.com/sdk/docs/install) tutorial
- Helm 3.0+ [installation](https://helm.sh/docs/) Helm is the package manager for Kubernetes.
- Skaffold [installation](https://skaffold.dev/) Skaffold is a command line tool that facilitates continuous development for container based & Kubernetes applications. It's included as an optional component in Google Cloud SDK and you can install it.

```
$ gcloud components install skaffold
```

## Workshop presentation slides.
GKE Observability Workshop [presentation](https://docs.google.com/presentation/d/1ssd_Z8ykpXzf_50pVToBueMJ_JDzJi9H1bmKgDuGPfk/edit?usp=sharing) that can be used as a guide for exercises.

## Workshop Cluster Preparation 

The preparation of the GKE cluster is one of the first steps of our workshop and is the basis for all our further activity using the local development environment of all participants. We will pave the way to our first K8s application deployment step by step in the following section, learning some of the basics of using the gcloud SDK CLI and kubectl.

## GCloud SDK Preparation

```bash
gcloud components update
gcloud init
```

## Optional Terminal Preparation

```bash
alias k='kubectl'
```

## Tracking sheet
Google Docs [spreadsheet](https://docs.google.com/spreadsheets/d/1vnqlCl3JjEGbN0rdnhJkoZOzXEuupckJ7UghqQYeFKc/edit?usp=sharing) to track the completion of tasks.

## Prerequisites
* [Terraform 0.13+](https://developer.hashicorp.com/terraform/downloads) Tool that manages IaC 
* [Google Cloud SDK](https://cloud.google.com/sdk/docs/install) Google Cloud Command Line Interface.
* [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/) The Kubernetes command-line tool, kubectl, allows you to run commands against Kubernetes clusters.
* [Helm 3.0+](https://helm.sh/docs/) Helm is the package manager for Kubernetes.
* [Skaffold](https://skaffold.dev/) Skaffold is a command line tool that facilitates continuous development for container based & Kubernetes applications. It's included as an optional component in Google Cloud SDK and you can install it.

All these tools are available in Google Cloud CloudShell which is accesible from the Google Cloud console.

## Links

- pydevop's [gcloud cheat sheet](https://gist.github.com/pydevops/cffbd3c694d599c6ca18342d3625af97) markdown paper

## License

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

See [LICENSE](LICENSE.md) for full details.

    Licensed to the Apache Software Foundation (ASF) under one
    or more contributor license agreements.  See the NOTICE file
    distributed with this work for additional information
    regarding copyright ownership.  The ASF licenses this file
    to you under the Apache License, Version 2.0 (the
    "License"); you may not use this file except in compliance
    with the License.  You may obtain a copy of the License at

      https://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing,
    software distributed under the License is distributed on an
    "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
    KIND, either express or implied.  See the License for the
    specific language governing permissions and limitations
    under the License.

## Copyright

Copyright © 2024 DoiT International

