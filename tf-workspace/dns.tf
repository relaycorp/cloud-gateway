resource "google_dns_managed_zone" "relaycorp_services" {
  project     = var.gcp_project_id
  name        = "relaycorp-services"
  dns_name    = "relaycorp.services."
  description = "Relaycorp Cloud"

  dnssec_config {
    state = "on"
  }

  depends_on = [google_project_service.dns]
}
