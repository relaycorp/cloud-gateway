resource "google_compute_managed_ssl_certificate" "main" {
  name = local.env_full_name

  managed {
    domains = [
      google_dns_record_set.poweb.name,
      google_dns_record_set.pohttp.name,
      google_dns_record_set.cogrpc.name,
    ]
  }

  provider = google-beta
}
