#############################################################################
# Artifact registry repository                                              #
#############################################################################

resource "google_artifact_registry_repository" "blueprints_repo" {
  count = var.gke_cluster_enable_registry_access ? 1 : 0

  provider      = google-beta
  location      = var.region
  repository_id = "blueprints-repository"
  description   = "Blueprints container artifacts repository"
  format        = "DOCKER"

  labels = local.common_labels

  cleanup_policy_dry_run = false
  cleanup_policies {
    id     = "delete-untagged"
    action = "DELETE"
    condition {
      tag_state  = "UNTAGGED"
      older_than = "1296000s" # 15 days
    }
  }
  cleanup_policies {
    id     = "keep-minimum-versions"
    action = "KEEP"
    most_recent_versions {
      package_name_prefixes = ["blueprints"]
      keep_count            = 5
    }
  }

}