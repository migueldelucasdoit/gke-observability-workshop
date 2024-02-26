#############################################################################
# VPC and subnets                                                           #
#############################################################################
#############################################################################
# VPC                                                                       #
#############################################################################

module "vpc" {
  source     = "terraform-google-modules/network/google//modules/vpc"
  version    = "~> 7.3"
  project_id = var.project_id

  network_name                           = var.vpc_name
  description                            = "VPC ${var.vpc_name} for stack ${var.stack_name}. Managed by Terraform."
  auto_create_subnetworks                = var.vpc_auto_create_subnetworks
  routing_mode                           = var.vpc_routing_mode
  delete_default_internet_gateway_routes = var.vpc_delete_default_igw_routes
  shared_vpc_host                        = false
}

#############################################################################
# VPC subnets                                                               #
#############################################################################

module "subnets" {
  source  = "terraform-google-modules/network/google//modules/subnets-beta"
  version = "~> 7.3"

  project_id       = var.project_id
  network_name     = module.vpc.network_name
  subnets          = var.vpc_subnets
  secondary_ranges = var.vpc_subnets_secondary_ranges

  module_depends_on = [
    module.vpc,
  ]
}

#############################################################################
# Network Firewall rules                                                    #
#############################################################################

resource "google_compute_firewall" "lb_health_check" {
  name        = "allow-health-check"
  network     = module.vpc.network_name
  description = "VPC ${var.vpc_name}. Allow health checks from GCP LBs."
  direction   = "INGRESS"

  allow {
    protocol = "tcp"
  }
  # https://cloud.google.com/load-balancing/docs/health-check-concepts#ip-ranges
  source_ranges = [
    "35.191.0.0/16",  # Global external HTTP(S) load balancer 
    "130.211.0.0/22", # Global external HTTP(S) load balancer (classic)
  ]
}

