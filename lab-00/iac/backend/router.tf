#############################################################################
# Routers                                                                   #
# - Only created when a GKE cluster with private nodes is requested         #               
#############################################################################
resource "google_compute_router" "vpc_router" {
  count   = var.gke_cluster_enable_private_nodes ? 1 : 0
  name    = "${local.vpc_network_name}-router"
  region  = var.region
  network = local.vpc_network_id
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resource/compute_router_nat
resource "google_compute_router_nat" "vpc_router_nat" {
  count                              = var.gke_cluster_enable_private_nodes ? 1 : 0
  name                               = "${local.vpc_network_name}-router-nat"
  router                             = google_compute_router.vpc_router[count.index].name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = false
    filter = "ERRORS_ONLY"
  }
}
