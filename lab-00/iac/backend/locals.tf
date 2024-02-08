#############################################################################
# Locals                                                                    #
#############################################################################

locals {
  vpc_network_id                 = data.google_compute_network.vpc.id
  vpc_network_name               = var.vpc_name
  gke_cluster_zones              = var.gke_cluster_regional ? data.google_compute_zones.available.names : [var.zone]
  gke_cluster_region             = var.gke_cluster_regional ? var.region : null
  gke_master_authorized_networks = var.gke_cluster_enable_private_endpoint ? [{ display_name = "allow-iap", cidr_block = var.iap_proxy_subnet_cidr_range }] : var.gke_cluster_master_authorized_networks
}

locals {
  keda_operator_gcp_derived_name    = "serviceAccount:${var.project_id}.svc.id.goog[${var.keda_operator_namespace}/${var.keda_operator_name}]"
  config_connector_gcp_derived_name = "serviceAccount:${var.project_id}.svc.id.goog[cnrm-system/cnrm-controller-manager]"
  gke_cluster_all_nodes_tags        = lookup(var.gke_cluster_node_pools_tags, "all", ["${var.gke_cluster_name}-node"])
  gke_cluster_registry_project_ids  = var.gke_cluster_enable_registry_access ? [var.project_id] : []
}

locals {
  common_labels = {
    "managed-by" = "terraform"
    "stack-name" = var.stack_name
  }
}