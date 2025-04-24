################################################################################
# Open Telemetry operator
################################################################################
# Helm Chart values file
# https://github.com/open-telemetry/opentelemetry-helm-charts/blob/main/charts/opentelemetry-operator/values.yaml 
resource "helm_release" "otel_operator" {
  namespace  = var.otel_operator_namespace
  version    = var.otel_operator_version
  repository = "https://open-telemetry.github.io/opentelemetry-helm-charts"
  chart      = "opentelemetry-operator"
  name       = var.otel_operator_name

  create_namespace = true

  set {
    name  = "admissionWebhooks.certManager.enabled"
    value = true
  }

  dynamic "set" {
    for_each = var.otel_operator_settings == null ? {} : var.otel_operator_settings

    content {
      name  = set.key
      value = set.value
    }
  }

  depends_on = [helm_release.cert_manager]
}