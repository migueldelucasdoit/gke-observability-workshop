#############################################################################
# Output                                                                    #
#############################################################################

output "gateway_external_address" {
  value = google_compute_global_address.gateway_external_address.address
}