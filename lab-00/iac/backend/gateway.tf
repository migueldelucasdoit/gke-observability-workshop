resource "google_compute_global_address" "gateway_external_address" {
  project      = var.project_id
  name         = "gateway-external-address"
  address_type = "EXTERNAL"
  ip_version   = "IPV4"
}