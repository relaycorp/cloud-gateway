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

// TODO: Remove
resource "google_dns_managed_zone_iam_member" "member" {
  project      = var.gcp_project_id
  managed_zone = "relaycorp-cloud"
  role         = "roles/dns.admin"
  member       = var.sre_iam_uri
}
