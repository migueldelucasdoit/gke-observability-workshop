#############################################################################
# Stack dependencies                                                        #
#############################################################################

data "google_compute_zones" "available" {
  region = var.region
  status = "UP"
}

data "google_client_config" "default" {}

data "google_compute_network" "vpc" {
  name = var.vpc_name
}
