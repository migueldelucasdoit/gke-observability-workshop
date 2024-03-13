#############################################################################
# Terraform variables                                                       #
#############################################################################
#############################################################################
# Google Cloud variables                                                    #
#############################################################################
variable "project_id" {
  type        = string
  description = "GCP project ID"
}

variable "region" {
  type        = string
  description = "GCP compute region ID"
}

variable "zone" {
  type        = string
  description = "GCP compute zone ID"
}

#############################################################################
# Stack name                                                                #
#############################################################################
variable "stack_name" {
  type        = string
  description = "Name of the stack"
}

#############################################################################
# Network                                                                   #
#############################################################################
variable "vpc_routing_mode" {
  type        = string
  description = "VPC routing mode"
  default     = "GLOBAL"

  validation {
    condition     = contains(["GLOBAL", "REGIONAL"], var.vpc_routing_mode)
    error_message = "Invalid input, options: \"GLOBAL\", \"REGIONAL\"."
  }
}

variable "vpc_name" {
  type        = string
  description = "VPC name"
  default     = "test-vpc"

  validation {
    condition     = can(regex("[a-z]([-a-z0-9]*[a-z0-9])?", var.vpc_name))
    error_message = "Invalid input, name must be 1-63 characters long and match the regular expression [a-z]([-a-z0-9]*[a-z0-9])?."
  }
}

variable "vpc_auto_create_subnetworks" {
  type        = bool
  description = <<-EOT
  When set to true, the network is created in 'auto subnet mode' and it will create a subnet for each region automatically across the 10.128.0.0/9 address range.
  When set to false, the network is created in 'custom subnet mode' so the user can explicitly connect subnetwork resources.
  EOT
  default     = false
}

variable "vpc_delete_default_igw_routes" {
  type        = bool
  description = "If set, ensure that all routes within the network specified whose names begin with 'default-route' and with a next hop of 'default-internet-gateway' are deleted."
  default     = false
}

variable "vpc_subnets" {
  type        = list(map(string))
  description = "The list of subnets being created."
}

variable "vpc_subnets_secondary_ranges" {
  type        = map(list(object({ range_name = string, ip_cidr_range = string })))
  description = "Secondary ranges that will be used in some of the subnets."
  default     = {}
}

#############################################################################
# IAP proxy                                                                 #
#############################################################################
variable "iap_proxy_subnet_cidr_range" {
  type        = string
  description = "The range of internal addresses that are owned by IAP proxysubnetwork."
  default     = null
}

#############################################################################
# GKE cluster                                                               #
#############################################################################
variable "gke_cluster_name" {
  type        = string
  description = "GKE cluster name."
  default     = "test-cluster"
}

variable "gke_cluster_regional" {
  type        = bool
  description = "Flag to enable a GKE regional cluster."
  default     = false
}

variable "gke_cluster_version" {
  type        = string
  description = "The Kubernetes version of the masters. If set to 'latest' it will pull latest available version in the selected region."
  default     = "latest"
}

variable "gke_cluster_enable_private_endpoint" {
  type        = bool
  description = "Whether the master's internal IP address is used as the cluster endpoint."
  default     = false
}

variable "gke_cluster_enable_private_nodes" {
  type        = bool
  description = "Whether nodes have internal IP addresses only."
  default     = false
}

variable "gke_cluster_enable_intranode_visibility" {
  type        = bool
  description = "Whether Intra-node visibility is enabled for this cluster. This makes same node pod to pod traffic visible for VPC network."
  default     = false
}

variable "gke_cluster_enable_horizontal_pod_autoscaling" {
  type        = bool
  description = "Enable horizontal pod autoscaling addon."
  default     = true
}

variable "gke_cluster_enable_vertical_pod_autoscaling" {
  type        = bool
  description = "Vertical Pod Autoscaling automatically adjusts the resources of pods controlled by it."
  default     = false
}

variable "gke_enable_identity_service" {
  type        = bool
  description = "Enable the Identity Service component, which allows customers to use external identity providers with the K8S API."
  default     = false
}

variable "gke_cluster_enable_creating_service_account" {
  type        = bool
  description = "Defines if service account specified to run nodes should be created."
  default     = true
}

variable "gke_cluster_remove_default_node_pool" {
  type        = bool
  description = "Remove default node pool while setting up the cluster."
  default     = false
}

variable "gke_cluster_master_ipv4_cidr_block" {
  type        = string
  description = "The IP range in CIDR notation to use for the hosted master network."
  validation {
    condition     = can(cidrhost(var.gke_cluster_master_ipv4_cidr_block, 0))
    error_message = "Must be valid IPv4 CIDR."
  }
}

variable "gke_cluster_master_authorized_networks" {
  type        = list(object({ cidr_block = string, display_name = string }))
  description = "List of master authorized networks. If none are provided, disallow external access (except the cluster node IPs, which GKE automatically whitelists)."
  default     = []
}

variable "gke_cluster_node_pools" {
  type        = list(map(any))
  description = "List of maps containing node pools."
}

variable "gke_cluster_node_pools_tags" {
  type        = map(list(string))
  description = "Map of lists containing node network tags by node-pool name."
  default = {
    "all" : [],
    "default-node-pool" : []
  }
}

variable "gke_cluster_node_pools_taints" {
  type        = map(list(object({ key = string, value = string, effect = string })))
  description = "Map of lists containing node taints by node-pool name."
  default = {
    "all" : [],
    "default-node-pool" : []
  }
}

variable "gke_cluster_node_pools_labels" {
  type        = map(map(string))
  description = "Map of maps containing node labels by node-pool name."
  default = {
    "all" : {},
    "default-node-pool" : {}
  }
}

variable "gke_cluster_node_pools_resource_labels" {
  type        = map(map(string))
  description = "Map of maps containing resource labels by node-pool name."
  default = {
    "all" : {},
    "default-node-pool" : {}
  }
}

variable "gke_cluster_release_channel" {
  type        = string
  description = "The release channel of this cluster. Accepted values are UNSPECIFIED, RAPID, REGULAR and STABLE. Defaults to UNSPECIFIED."
  default     = "UNSPECIFIED"
}

variable "gke_cluster_default_max_pods_per_node" {
  type        = number
  description = "The maximum number of pods to schedule per node."
  default     = 110
}

variable "gke_cluster_enable_network_policy" {
  type        = bool
  description = "Enable network policy addon."
  default     = false
}

variable "gke_cluster_enable_config_connector" {
  type        = bool
  description = "Whether ConfigConnector is enabled for this cluster."
  default     = false
}

variable "gke_cluster_enable_registry_access" {
  type        = bool
  description = "Grants created cluster-specific service account `storage.objectViewer` and `artifactregistry.reader` roles."
  default     = false
}

variable "gke_cluster_enable_gateway_api" {
  type        = bool
  description = "Enable Gateway API."
  default     = false
}

variable "gke_enable_managed_prometheus" {
  type        = bool
  description = "Configuration for Managed Service for Prometheus. Whether or not the managed collection is enabled."
  default     = false
}


#############################################################################
# Cert Manager                                                              #
#############################################################################

variable "cert_manager_version" {
  description = "Cert Manager Helm chart version."
  type        = string
  nullable    = false
  default     = "v1.13.2"

  validation {
    condition     = var.cert_manager_version != ""
    error_message = "An empty string is not a valid value."
  }
}

variable "cert_manager_name" {
  description = "Cert Manager Helm chart name."
  type        = string
  nullable    = false
  default     = "cert-manager"

  validation {
    condition     = var.cert_manager_name != ""
    error_message = "An empty string is not a valid value."
  }
}

variable "cert_manager_namespace" {
  description = "Cert Manager Helm chart namespace."
  type        = string
  nullable    = false
  default     = "cert-manager"

  validation {
    condition     = var.cert_manager_namespace != ""
    error_message = "An empty string is not a valid value."
  }

}

variable "cert_manager_settings" {
  description = "Cert Manager Helm chart settings"
  type        = map(string)
  default     = {}
}

#############################################################################
# Open Telemetry operator                                                              #
#############################################################################

variable "otel_operator_version" {
  description = "Open Telemetry operator version."
  type        = string
  nullable    = false
  default     = "0.43.0"

  validation {
    condition     = var.otel_operator_version != ""
    error_message = "An empty string is not a valid value."
  }
}

variable "otel_operator_name" {
  description = "Open Telemetry operator name."
  type        = string
  nullable    = false
  default     = "opentelemetry-operator"

  validation {
    condition     = var.otel_operator_name != ""
    error_message = "An empty string is not a valid value."
  }
}

variable "otel_operator_namespace" {
  description = "Open Telemetry operator namespace."
  type        = string
  nullable    = false
  default     = "opentelemetry-operator-system"

  validation {
    condition     = var.otel_operator_namespace != ""
    error_message = "An empty string is not a valid value."
  }

}

variable "otel_operator_settings" {
  description = "Open Telemetry operator settings"
  type        = map(string)
  default     = {}
}

#############################################################################
# Config Connector                                                          #
#############################################################################

variable "config_connector_iam_roles" {
  description = "Config Connector IAM roles added to the operator service account"
  type        = set(string)
  default = [
    "roles/editor"
  ]
}

#############################################################################
# External email user to be added as user of the GKE cluster SA             #
#############################################################################

variable "user_email" {
  description = "External email user to be added as user of the GKE cluster SA."
  type        = string
  default     = ""
}
