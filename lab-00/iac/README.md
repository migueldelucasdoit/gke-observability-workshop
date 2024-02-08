# Terraform stack for Open Telemetry Blueprints


## Prerequisites
* [Terraform 0.13+](https://developer.hashicorp.com/terraform/downloads) Tool that manages IaC (infrastructure-as-code) in diverse public cloud providers and tools.
* [terraform-docs](https://github.com/terraform-docs/terraform-docs/releases/) Generate documentation for Terraform stacks.
* [tflint](https://github.com/terraform-linters/tflint) Linter for Terraform stacks. Linting rules for diverse public providers.
* [pre-commit](https://pre-commit.com/) A framework for managing and maintaining multi-language pre-commit hooks.
* [Helm 3.0+](https://helm.sh/docs/) Helm is the package manager for Kubernetes.
* [Google Cloud CLI](https://cloud.google.com/sdk/docs/install) Google Cloud Command Line Interface.
* [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/) The Kubernetes command-line tool, kubectl, allows you to run commands against Kubernetes clusters.

## Install

This PoC is composed of three layers.
You must apply them in this order and destroy them in reverse order.

1. [Baseline stack](./baseline/README.md) with application infrastructure. VPC and subnets.
2. [Backend layer](./backend/README.md) with application infrastructure. GKE cluster, NAT router, Artifact Registry repository, Pub/Sub resources and base Helm Charts.
3. [Provisioning layer](./provision/README.md) with Kubernetes resources.

