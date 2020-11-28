resource "google_dns_managed_zone" "relaycorp_cloud" {
  name        = "relaycorp-cloud"
  dns_name    = "relaycorp.cloud."
  description = "Relaycorp Cloud"
}
