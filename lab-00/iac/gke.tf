#############################################################################
# GKE                                                                       #
#############################################################################

module "gke" {
  source  = "terraform-google-modules/kubernetes-engine/google//modules/beta-private-cluster"
  version = "~> 28.0"

  project_id         = var.project_id
  name               = var.gke_cluster_name
  regional           = var.gke_cluster_regional
  region             = local.gke_cluster_region
  zones              = local.gke_cluster_zones
  description        = "GKE ${var.gke_cluster_regional ? "regional" : "zonal"} cluster ${var.gke_cluster_name} for stack ${var.stack_name}."
  network            = local.vpc_network_name
  subnetwork         = "subnet-gke-${var.region}"
  ip_range_pods      = "subnet-gke-${var.region}-pods"
  ip_range_services  = "subnet-gke-${var.region}-services"
  kubernetes_version = var.gke_cluster_version
  release_channel    = var.gke_cluster_release_channel


  enable_private_endpoint              = var.gke_cluster_enable_private_endpoint
  enable_private_nodes                 = var.gke_cluster_enable_private_nodes
  enable_intranode_visibility          = var.gke_cluster_enable_intranode_visibility
  master_ipv4_cidr_block               = var.gke_cluster_master_ipv4_cidr_block
  master_authorized_networks           = local.gke_master_authorized_networks
  enable_identity_service              = var.gke_enable_identity_service
  default_max_pods_per_node            = var.gke_cluster_default_max_pods_per_node
  network_policy                       = var.gke_cluster_enable_network_policy
  grant_registry_access                = var.gke_cluster_enable_registry_access
  registry_project_ids                 = local.gke_cluster_registry_project_ids
  gateway_api_channel                  = var.gke_cluster_enable_gateway_api ? "CHANNEL_STANDARD" : "CHANNEL_DISABLED"
  monitoring_enable_managed_prometheus = var.gke_enable_managed_prometheus


  # deploy_using_private_endpoint = true


  horizontal_pod_autoscaling      = var.gke_cluster_enable_horizontal_pod_autoscaling
  enable_vertical_pod_autoscaling = var.gke_cluster_enable_vertical_pod_autoscaling
  config_connector                = var.gke_cluster_enable_config_connector
  http_load_balancing             = true
  gce_pd_csi_driver               = true

  create_service_account = var.gke_cluster_enable_creating_service_account
  service_account        = var.gke_cluster_enable_creating_service_account ? "" : google_service_account.cluster_service_account[0].email


  filestore_csi_driver    = false
  istio                   = false
  cloudrun                = false
  dns_cache               = false
  gke_backup_agent_config = false

  node_pools               = var.gke_cluster_node_pools
  remove_default_node_pool = var.gke_cluster_remove_default_node_pool

  node_pools_oauth_scopes = {
    all = [
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }

  node_pools_metadata = {
    all = {}
  }

  node_pools_labels          = var.gke_cluster_node_pools_labels
  node_pools_resource_labels = var.gke_cluster_node_pools_resource_labels
  node_pools_taints          = var.gke_cluster_node_pools_taints
  node_pools_tags            = var.gke_cluster_node_pools_tags

}