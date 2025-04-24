################################################################################
# Cert Manager Helm chart
################################################################################

resource "helm_release" "cert_manager" {
  namespace  = var.cert_manager_namespace
  version    = var.cert_manager_version
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  name       = var.cert_manager_name

  create_namespace = true

  set {
    name  = "installCRDs"
    value = true
  }

  dynamic "set" {
    for_each = var.cert_manager_settings == null ? {} : var.cert_manager_settings

    content {
      name  = set.key
      value = set.value
    }
  }

}
