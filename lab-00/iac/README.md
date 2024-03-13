# Terraform stack for GKE Observability Workshop

## Description
Backend stack with application infrastructure.

## Connection to GKE control plane
* Obtain credentials for GKE cluster.
```
gcloud container clusters get-credentials gke-otel-blueprints --region europe-west6
```
* Use kubectl as usual.

## Configure Helm
* Add all the needed repositories for the Helm charts.
```
helm repo add kedacore https://kedacore.github.io/charts
helm repo add jetstack https://charts.jetstack.io
helm repo add open-telemetry https://open-telemetry.github.io/opentelemetry-helm-charts
helm repo update
```

## Prerequisites
* [Terraform 0.13+](https://developer.hashicorp.com/terraform/downloads) Tool that manages IaC (infrastructure-as-code) in diverse public cloud providers and tools.
* [terraform-docs](https://github.com/terraform-docs/terraform-docs/releases/) Generate documentation for Terraform stacks.
* [tflint](https://github.com/terraform-linters/tflint) Linter for Terraform stacks. Linting rules for diverse public providers.
* [pre-commit](https://pre-commit.com/) A framework for managing and maintaining multi-language pre-commit hooks.
* [Google Cloud CLI](https://cloud.google.com/sdk/docs/install) Google Cloud Command Line Interface.
* [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/) The Kubernetes command-line tool, kubectl, allows you to run commands against Kubernetes clusters.
* [Helm 3.9+](https://helm.sh/docs/) Helm is the package manager for Kubernetes.

## Installation
Configure your Terraform *TFVARS* file accordingly. Check the included [sample](../iac/terraform.tfvars.sample)

```
terraform init
terraform plan -out backend.plan
terraform apply backend.plan
```

## Removal
Configure your Terraform *TFVARS* file accordingly. Check the included [sample](../iac/terraform.tfvars.sample)

```
terraform apply -destroy -auto-approve
```

## Known issues
When deleting then recreating the stack, you can face the following error:
```
Error: Error deleting Logging Bucket Config "projects/PROJECT_ID/locations/europe-west6/buckets/backend-otel-blueprints-app-logs": googleapi: Error 400: Only buckets in state ACTIVE can be deleted
```
This is caused by the fact that once deleted, the bucket still exists and state is `DELETE_REQUESTED`.
To fix the issue, do the following:
- In the GCP console, restore the bucket
- Remove the resource from your state, then import it:
```shell
terraform state rm google_logging_project_bucket_config.app-logs-bucket
terraform import google_logging_project_bucket_config.app-logs-bucket projects/PROJECT_ID/locations/REGION_ID/buckets/backend-otel-blueprints-app-logs
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 4.0 |
| <a name="requirement_google-beta"></a> [google-beta](#requirement\_google-beta) | ~> 4.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.11 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | >= 1.7.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.23 |
| <a name="requirement_null"></a> [null](#requirement\_null) | ~> 3.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 4.84.0 |
| <a name="provider_google-beta"></a> [google-beta](#provider\_google-beta) | 4.84.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.11.0 |
| <a name="provider_kubectl"></a> [kubectl](#provider\_kubectl) | 1.14.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.5.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_gke"></a> [gke](#module\_gke) | terraform-google-modules/kubernetes-engine/google//modules/beta-private-cluster | ~> 28.0 |
| <a name="module_subnets"></a> [subnets](#module\_subnets) | terraform-google-modules/network/google//modules/subnets-beta | ~> 7.3 |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-google-modules/network/google//modules/vpc | ~> 7.3 |

## Resources

| Name | Type |
|------|------|
| [google-beta_google_artifact_registry_repository.blueprints_repo](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_artifact_registry_repository) | resource |
| [google_compute_firewall.iap_tcp_forwarding](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_firewall.lb_health_check](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_global_address.gateway_external_address](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_address) | resource |
| [google_compute_instance.iap_proxy](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance) | resource |
| [google_compute_router.vpc_router](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router) | resource |
| [google_compute_router_nat.vpc_router_nat](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router_nat) | resource |
| [google_compute_subnetwork.subnet_iap](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork) | resource |
| [google_project_iam_member.cluster_service_account-artifact-registry](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_iam_member.cluster_service_account-gcr](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_iam_member.cluster_service_account-nodeService_account](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_iam_member.config_connector_sa](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_pubsub_subscription.blueprints_subscription](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_subscription) | resource |
| [google_pubsub_topic.blueprints_topic](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_topic) | resource |
| [google_service_account.cluster_service_account](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_service_account.config_connector_sa](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_service_account_iam_member.cluster_service_account](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account_iam_member) | resource |
| [google_service_account_iam_member.config_connector_sa](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account_iam_member) | resource |
| [helm_release.cert_manager](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.otel_operator](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubectl_manifest.config_connector_cluster_config](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [random_string.cluster_service_account_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [google_client_config.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/client_config) | data source |
| [google_client_openid_userinfo.me](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/client_openid_userinfo) | data source |
| [google_compute_zones.available](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/compute_zones) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cert_manager_name"></a> [cert\_manager\_name](#input\_cert\_manager\_name) | Cert Manager Helm chart name. | `string` | `"cert-manager"` | no |
| <a name="input_cert_manager_namespace"></a> [cert\_manager\_namespace](#input\_cert\_manager\_namespace) | Cert Manager Helm chart namespace. | `string` | `"cert-manager"` | no |
| <a name="input_cert_manager_settings"></a> [cert\_manager\_settings](#input\_cert\_manager\_settings) | Cert Manager Helm chart settings | `map(string)` | `{}` | no |
| <a name="input_cert_manager_version"></a> [cert\_manager\_version](#input\_cert\_manager\_version) | Cert Manager Helm chart version. | `string` | `"v1.13.2"` | no |
| <a name="input_config_connector_iam_roles"></a> [config\_connector\_iam\_roles](#input\_config\_connector\_iam\_roles) | Config Connector IAM roles added to the operator service account | `set(string)` | <pre>[<br>  "roles/editor"<br>]</pre> | no |
| <a name="input_gke_cluster_default_max_pods_per_node"></a> [gke\_cluster\_default\_max\_pods\_per\_node](#input\_gke\_cluster\_default\_max\_pods\_per\_node) | The maximum number of pods to schedule per node. | `number` | `110` | no |
| <a name="input_gke_cluster_enable_config_connector"></a> [gke\_cluster\_enable\_config\_connector](#input\_gke\_cluster\_enable\_config\_connector) | Whether ConfigConnector is enabled for this cluster. | `bool` | `false` | no |
| <a name="input_gke_cluster_enable_creating_service_account"></a> [gke\_cluster\_enable\_creating\_service\_account](#input\_gke\_cluster\_enable\_creating\_service\_account) | Defines if service account specified to run nodes should be created. | `bool` | `true` | no |
| <a name="input_gke_cluster_enable_gateway_api"></a> [gke\_cluster\_enable\_gateway\_api](#input\_gke\_cluster\_enable\_gateway\_api) | Enable Gateway API. | `bool` | `false` | no |
| <a name="input_gke_cluster_enable_horizontal_pod_autoscaling"></a> [gke\_cluster\_enable\_horizontal\_pod\_autoscaling](#input\_gke\_cluster\_enable\_horizontal\_pod\_autoscaling) | Enable horizontal pod autoscaling addon. | `bool` | `true` | no |
| <a name="input_gke_cluster_enable_intranode_visibility"></a> [gke\_cluster\_enable\_intranode\_visibility](#input\_gke\_cluster\_enable\_intranode\_visibility) | Whether Intra-node visibility is enabled for this cluster. This makes same node pod to pod traffic visible for VPC network. | `bool` | `false` | no |
| <a name="input_gke_cluster_enable_network_policy"></a> [gke\_cluster\_enable\_network\_policy](#input\_gke\_cluster\_enable\_network\_policy) | Enable network policy addon. | `bool` | `false` | no |
| <a name="input_gke_cluster_enable_private_endpoint"></a> [gke\_cluster\_enable\_private\_endpoint](#input\_gke\_cluster\_enable\_private\_endpoint) | Whether the master's internal IP address is used as the cluster endpoint. | `bool` | `false` | no |
| <a name="input_gke_cluster_enable_private_nodes"></a> [gke\_cluster\_enable\_private\_nodes](#input\_gke\_cluster\_enable\_private\_nodes) | Whether nodes have internal IP addresses only. | `bool` | `false` | no |
| <a name="input_gke_cluster_enable_registry_access"></a> [gke\_cluster\_enable\_registry\_access](#input\_gke\_cluster\_enable\_registry\_access) | Grants created cluster-specific service account `storage.objectViewer` and `artifactregistry.reader` roles. | `bool` | `false` | no |
| <a name="input_gke_cluster_enable_vertical_pod_autoscaling"></a> [gke\_cluster\_enable\_vertical\_pod\_autoscaling](#input\_gke\_cluster\_enable\_vertical\_pod\_autoscaling) | Vertical Pod Autoscaling automatically adjusts the resources of pods controlled by it. | `bool` | `false` | no |
| <a name="input_gke_cluster_master_authorized_networks"></a> [gke\_cluster\_master\_authorized\_networks](#input\_gke\_cluster\_master\_authorized\_networks) | List of master authorized networks. If none are provided, disallow external access (except the cluster node IPs, which GKE automatically whitelists). | `list(object({ cidr_block = string, display_name = string }))` | `[]` | no |
| <a name="input_gke_cluster_master_ipv4_cidr_block"></a> [gke\_cluster\_master\_ipv4\_cidr\_block](#input\_gke\_cluster\_master\_ipv4\_cidr\_block) | The IP range in CIDR notation to use for the hosted master network. | `string` | n/a | yes |
| <a name="input_gke_cluster_name"></a> [gke\_cluster\_name](#input\_gke\_cluster\_name) | GKE cluster name. | `string` | `"test-cluster"` | no |
| <a name="input_gke_cluster_node_pools"></a> [gke\_cluster\_node\_pools](#input\_gke\_cluster\_node\_pools) | List of maps containing node pools. | `list(map(any))` | n/a | yes |
| <a name="input_gke_cluster_node_pools_labels"></a> [gke\_cluster\_node\_pools\_labels](#input\_gke\_cluster\_node\_pools\_labels) | Map of maps containing node labels by node-pool name. | `map(map(string))` | <pre>{<br>  "all": {},<br>  "default-node-pool": {}<br>}</pre> | no |
| <a name="input_gke_cluster_node_pools_resource_labels"></a> [gke\_cluster\_node\_pools\_resource\_labels](#input\_gke\_cluster\_node\_pools\_resource\_labels) | Map of maps containing resource labels by node-pool name. | `map(map(string))` | <pre>{<br>  "all": {},<br>  "default-node-pool": {}<br>}</pre> | no |
| <a name="input_gke_cluster_node_pools_tags"></a> [gke\_cluster\_node\_pools\_tags](#input\_gke\_cluster\_node\_pools\_tags) | Map of lists containing node network tags by node-pool name. | `map(list(string))` | <pre>{<br>  "all": [],<br>  "default-node-pool": []<br>}</pre> | no |
| <a name="input_gke_cluster_node_pools_taints"></a> [gke\_cluster\_node\_pools\_taints](#input\_gke\_cluster\_node\_pools\_taints) | Map of lists containing node taints by node-pool name. | `map(list(object({ key = string, value = string, effect = string })))` | <pre>{<br>  "all": [],<br>  "default-node-pool": []<br>}</pre> | no |
| <a name="input_gke_cluster_regional"></a> [gke\_cluster\_regional](#input\_gke\_cluster\_regional) | Flag to enable a GKE regional cluster. | `bool` | `false` | no |
| <a name="input_gke_cluster_release_channel"></a> [gke\_cluster\_release\_channel](#input\_gke\_cluster\_release\_channel) | The release channel of this cluster. Accepted values are UNSPECIFIED, RAPID, REGULAR and STABLE. Defaults to UNSPECIFIED. | `string` | `"UNSPECIFIED"` | no |
| <a name="input_gke_cluster_remove_default_node_pool"></a> [gke\_cluster\_remove\_default\_node\_pool](#input\_gke\_cluster\_remove\_default\_node\_pool) | Remove default node pool while setting up the cluster. | `bool` | `false` | no |
| <a name="input_gke_cluster_version"></a> [gke\_cluster\_version](#input\_gke\_cluster\_version) | The Kubernetes version of the masters. If set to 'latest' it will pull latest available version in the selected region. | `string` | `"latest"` | no |
| <a name="input_gke_enable_identity_service"></a> [gke\_enable\_identity\_service](#input\_gke\_enable\_identity\_service) | Enable the Identity Service component, which allows customers to use external identity providers with the K8S API. | `bool` | `false` | no |
| <a name="input_gke_enable_managed_prometheus"></a> [gke\_enable\_managed\_prometheus](#input\_gke\_enable\_managed\_prometheus) | Configuration for Managed Service for Prometheus. Whether or not the managed collection is enabled. | `bool` | `false` | no |
| <a name="input_iap_proxy_subnet_cidr_range"></a> [iap\_proxy\_subnet\_cidr\_range](#input\_iap\_proxy\_subnet\_cidr\_range) | The range of internal addresses that are owned by IAP proxysubnetwork. | `string` | `null` | no |
| <a name="input_otel_operator_name"></a> [otel\_operator\_name](#input\_otel\_operator\_name) | Open Telemetry operator name. | `string` | `"opentelemetry-operator"` | no |
| <a name="input_otel_operator_namespace"></a> [otel\_operator\_namespace](#input\_otel\_operator\_namespace) | Open Telemetry operator namespace. | `string` | `"opentelemetry-operator-system"` | no |
| <a name="input_otel_operator_settings"></a> [otel\_operator\_settings](#input\_otel\_operator\_settings) | Open Telemetry operator settings | `map(string)` | `{}` | no |
| <a name="input_otel_operator_version"></a> [otel\_operator\_version](#input\_otel\_operator\_version) | Open Telemetry operator version. | `string` | `"0.43.0"` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | GCP project ID | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | GCP compute region ID | `string` | n/a | yes |
| <a name="input_stack_name"></a> [stack\_name](#input\_stack\_name) | Name of the stack | `string` | n/a | yes |
| <a name="input_user_email"></a> [user\_email](#input\_user\_email) | External email user to be added as user of the GKE cluster SA. | `string` | `""` | no |
| <a name="input_vpc_auto_create_subnetworks"></a> [vpc\_auto\_create\_subnetworks](#input\_vpc\_auto\_create\_subnetworks) | When set to true, the network is created in 'auto subnet mode' and it will create a subnet for each region automatically across the 10.128.0.0/9 address range.<br>When set to false, the network is created in 'custom subnet mode' so the user can explicitly connect subnetwork resources. | `bool` | `false` | no |
| <a name="input_vpc_delete_default_igw_routes"></a> [vpc\_delete\_default\_igw\_routes](#input\_vpc\_delete\_default\_igw\_routes) | If set, ensure that all routes within the network specified whose names begin with 'default-route' and with a next hop of 'default-internet-gateway' are deleted. | `bool` | `false` | no |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | VPC name | `string` | `"test-vpc"` | no |
| <a name="input_vpc_routing_mode"></a> [vpc\_routing\_mode](#input\_vpc\_routing\_mode) | VPC routing mode | `string` | `"GLOBAL"` | no |
| <a name="input_vpc_subnets"></a> [vpc\_subnets](#input\_vpc\_subnets) | The list of subnets being created. | `list(map(string))` | n/a | yes |
| <a name="input_vpc_subnets_secondary_ranges"></a> [vpc\_subnets\_secondary\_ranges](#input\_vpc\_subnets\_secondary\_ranges) | Secondary ranges that will be used in some of the subnets. | `map(list(object({ range_name = string, ip_cidr_range = string })))` | `{}` | no |
| <a name="input_zone"></a> [zone](#input\_zone) | GCP compute zone ID | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_gateway_external_address"></a> [gateway\_external\_address](#output\_gateway\_external\_address) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->