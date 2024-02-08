# Terraform stack for Open Telemetry Blueprints

## Description
Baseline stack with network infrastructure.

## Prerequisites
* [Terraform 0.13+](https://developer.hashicorp.com/terraform/downloads) Tool that manages IaC (infrastructure-as-code) in diverse public cloud providers and tools.
* [terraform-docs](https://github.com/terraform-docs/terraform-docs/releases/) Generate documentation for Terraform stacks.
* [tflint](https://github.com/terraform-linters/tflint) Linter for Terraform stacks. Linting rules for diverse public providers.
* [pre-commit](https://pre-commit.com/) A framework for managing and maintaining multi-language pre-commit hooks.

## Installation
Configure your Terraform *TFVARS* file accordingly. Check the included [sample](./terraform.tfvars.sample)

```
terraform init
terraform plan -out baseline.plan
terraform apply baseline.plan
```

## Removal
Configure your Terraform *TFVARS* file accordingly. Check the included [sample](./terraform.tfvars.sample)

```
terraform apply -destroy -auto-approve
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 4.0 |
| <a name="requirement_google-beta"></a> [google-beta](#requirement\_google-beta) | ~> 4.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | ~> 3.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 4.84.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_subnets"></a> [subnets](#module\_subnets) | terraform-google-modules/network/google//modules/subnets-beta | ~> 7.3 |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-google-modules/network/google//modules/vpc | ~> 7.3 |

## Resources

| Name | Type |
|------|------|
| [google_compute_firewall.lb_health_check](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | GCP project ID | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | GCP compute region ID | `string` | n/a | yes |
| <a name="input_stack_name"></a> [stack\_name](#input\_stack\_name) | Name of the stack | `string` | n/a | yes |
| <a name="input_vpc_auto_create_subnetworks"></a> [vpc\_auto\_create\_subnetworks](#input\_vpc\_auto\_create\_subnetworks) | When set to true, the network is created in 'auto subnet mode' and it will create a subnet for each region automatically across the 10.128.0.0/9 address range. <br>When set to false, the network is created in 'custom subnet mode' so the user can explicitly connect subnetwork resources. | `bool` | `false` | no |
| <a name="input_vpc_delete_default_igw_routes"></a> [vpc\_delete\_default\_igw\_routes](#input\_vpc\_delete\_default\_igw\_routes) | If set, ensure that all routes within the network specified whose names begin with 'default-route' and with a next hop of 'default-internet-gateway' are deleted. | `bool` | `false` | no |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | VPC name | `string` | `"test-vpc"` | no |
| <a name="input_vpc_routing_mode"></a> [vpc\_routing\_mode](#input\_vpc\_routing\_mode) | VPC routing mode | `string` | `"GLOBAL"` | no |
| <a name="input_vpc_subnets"></a> [vpc\_subnets](#input\_vpc\_subnets) | The list of subnets being created. | `list(map(string))` | n/a | yes |
| <a name="input_vpc_subnets_secondary_ranges"></a> [vpc\_subnets\_secondary\_ranges](#input\_vpc\_subnets\_secondary\_ranges) | Secondary ranges that will be used in some of the subnets. | `map(list(object({ range_name = string, ip_cidr_range = string })))` | `{}` | no |
| <a name="input_zone"></a> [zone](#input\_zone) | GCP compute zone ID | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_vpc_network_id"></a> [vpc\_network\_id](#output\_vpc\_network\_id) | VPC network ID |
| <a name="output_vpc_network_name"></a> [vpc\_network\_name](#output\_vpc\_network\_name) | VPC network name |
| <a name="output_vpc_network_self_link"></a> [vpc\_network\_self\_link](#output\_vpc\_network\_self\_link) | VPC network self link |
| <a name="output_vpc_subnets"></a> [vpc\_subnets](#output\_vpc\_subnets) | VPC subnets |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->