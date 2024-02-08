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

