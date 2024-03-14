#############################################################################
# GKE Config Connector                                                      #
#############################################################################
#############################################################################
# Config Connector operator Workload identity                               #
#############################################################################
resource "google_service_account" "config_connector_sa" {
  count        = var.gke_cluster_enable_config_connector ? 1 : 0
  account_id   = "config-connector-sa"
  display_name = "Config Connector service account"
}

resource "google_project_iam_member" "config_connector_sa" {
  for_each = var.gke_cluster_enable_config_connector ? var.config_connector_iam_roles : []
  project  = var.project_id
  role     = each.value
  member   = google_service_account.config_connector_sa[0].member
}

# Workload Identity pool is created automatically after the first GKE cluster is created with 
# this enalbed. We need make sure the IAM perm is applied after the gke cluster.
resource "google_service_account_iam_member" "config_connector_sa" {
  count              = var.gke_cluster_enable_config_connector ? 1 : 0
  service_account_id = google_service_account.config_connector_sa[0].name
  role               = "roles/iam.workloadIdentityUser"
  member             = local.config_connector_gcp_derived_name
  depends_on = [
    module.gke
  ]
}

#############################################################################
# Config Connector cluster configuration                                    #
#############################################################################

resource "kubectl_manifest" "config_connector_cluster_config" {
  count = var.gke_cluster_enable_config_connector ? 1 : 0

  yaml_body = <<YAML
apiVersion: core.cnrm.cloud.google.com/v1beta1
kind: ConfigConnector
metadata:
  name: configconnector.core.cnrm.cloud.google.com
spec:
  mode: cluster
  googleServiceAccount: ${google_service_account.config_connector_sa[0].email}
  YAML

  depends_on = [
    module.gke.endpoint,
  ]
}
