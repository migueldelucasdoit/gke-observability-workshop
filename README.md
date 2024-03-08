# GKE Observability Workshop

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![GKE/K8s Version](https://img.shields.io/badge/k8s%20version-1.29.0-blue.svg)](#)
[![GCloud SDK Version](https://img.shields.io/badge/gcloud%20version-462.0.1-blue.svg)](#)

## Introduction

In this workshop, we will look at the landscape of GKE Observability with special focus on logging, monitoring and distributed tracing. We will also see best practices on monitoring.

## Available Labs

| Lab/Folder                                                                           | Description                                                             |
| ------------------------------------------------------------------------------------ | ----------------------------------------------------------------------- |
| [lab-00](./lab-00/README.md) | Create and provision environment |
| [lab-01](./lab-01/README.md) | Deploy the blueprints application |
| [lab-02](./lab-02/README.md) | Kubernetes probes |
| [lab-03](./lab-03/README.md) | GKE Logging |
| [lab-04](./lab-04/README.md) | GKE Metrics |
| [lab-05](./lab-05/README.md) | GKE Distributed Tracing |
| [lab-06](./lab-06/README.md) | Filter GKE Logs |
| [lab-07](./lab-07/README.md) | GKE Monitoring and Alerting |
| [lab-08](./lab-08/README.md) | Destroy the provisioned environment |

## Workshop presentation slides.
GKE Observability Workshop [presentation](https://docs.google.com/presentation/d/1ssd_Z8ykpXzf_50pVToBueMJ_JDzJi9H1bmKgDuGPfk/edit?usp=sharing) that can be used as a guide for exercises.

## Tracking sheet
Google Docs [spreadsheet](https://docs.google.com/spreadsheets/d/1vnqlCl3JjEGbN0rdnhJkoZOzXEuupckJ7UghqQYeFKc/edit?usp=sharing) to track the completion of tasks.

## Prerequisites
* [Terraform 0.13+](https://developer.hashicorp.com/terraform/downloads) Tool that manages IaC 
* [Google Cloud SDK](https://cloud.google.com/sdk/docs/install) Google Cloud Command Line Interface.
* [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/) The Kubernetes command-line tool, kubectl, allows you to run commands against Kubernetes clusters.
* [Helm 3.0+](https://helm.sh/docs/) Helm is the package manager for Kubernetes.
* [Skaffold](https://skaffold.dev/) Skaffold is a command line tool that facilitates continuous development for container based & Kubernetes applications. It's included as an optional component in Google Cloud SDK and you can install it.

All these tools are available in Google Cloud Cloud Shell which can be [launched](https://cloud.google.com/shell/docs/launching-cloud-shell) from the Google Cloud console.

## Links

- pydevop's [gcloud cheat sheet](https://gist.github.com/pydevops/cffbd3c694d599c6ca18342d3625af97) markdown paper

## License

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

See [LICENSE](./LICENSE) for full details.

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

