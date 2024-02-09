#############################################################################
# Stack dependencies                                                        #
#############################################################################

data "google_compute_zones" "available" {
  project = var.project_id
  region  = var.region
  status  = "UP"
}

data "google_client_config" "default" {}

