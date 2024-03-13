#############################################################################
# GKE Cluster Node Service Account                                          #
#############################################################################

data "google_client_openid_userinfo" "me" {
}


locals {
  service_account_default_name = "tf-gke-${substr(var.gke_cluster_name, 0, min(15, length(var.gke_cluster_name)))}-${random_string.cluster_service_account_suffix.result}"
}

resource "random_string" "cluster_service_account_suffix" {
  upper   = false
  lower   = true
  special = false
  length  = 4
}

resource "google_service_account" "cluster_service_account" {
  count        = var.gke_cluster_enable_creating_service_account ? 0 : 1
  project      = var.project_id
  account_id   = local.service_account_default_name
  display_name = "Terraform-managed service account for cluster ${var.gke_cluster_name}"
}

resource "google_project_iam_member" "cluster_service_account-nodeService_account" {
  count   = var.gke_cluster_enable_creating_service_account ? 0 : 1
  project = google_service_account.cluster_service_account[0].project
  role    = "roles/container.defaultNodeServiceAccount"
  member  = google_service_account.cluster_service_account[0].member
}

resource "google_project_iam_member" "cluster_service_account-gcr" {
  for_each = toset(var.gke_cluster_enable_creating_service_account ? [] : local.gke_cluster_registry_project_ids)
  project  = each.key
  role     = "roles/storage.objectViewer"
  member   = "serviceAccount:${google_service_account.cluster_service_account[0].email}"
}

resource "google_project_iam_member" "cluster_service_account-artifact-registry" {
  for_each = toset(var.gke_cluster_enable_creating_service_account ? [] : local.gke_cluster_registry_project_ids)
  project  = each.key
  role     = "roles/artifactregistry.reader"
  member   = "serviceAccount:${google_service_account.cluster_service_account[0].email}"
}


resource "google_service_account_iam_member" "cluster_service_account" {
  count              = var.gke_cluster_enable_creating_service_account ? 0 : 1
  service_account_id = google_service_account.cluster_service_account[0].name
  role               = "roles/iam.serviceAccountUser"
  member             = "user:${data.google_client_openid_userinfo.me.email}"
}