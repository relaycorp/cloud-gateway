data "google_dns_managed_zone" "main" {
  name = var.dns_managed_zone
}

resource "google_dns_record_set" "poweb" {
  name         = "poweb-${var.name}.${data.google_dns_managed_zone.main.dns_name}"
  managed_zone = data.google_dns_managed_zone.main.name
  type         = "A"
  ttl          = 300

  rrdatas = [google_compute_global_address.managed_tls_cert.address]
}

resource "google_dns_record_set" "pohttp" {
  name         = "pohttp-${var.name}.${data.google_dns_managed_zone.main.dns_name}"
  managed_zone = data.google_dns_managed_zone.main.name
  type         = "A"
  ttl          = 300

  rrdatas = [google_compute_global_address.managed_tls_cert.address]
}

resource "google_dns_record_set" "cogrpc" {
  name         = "cogrpc-${var.name}.${data.google_dns_managed_zone.main.dns_name}"
  managed_zone = data.google_dns_managed_zone.main.name
  type         = "A"
  ttl          = 300

  rrdatas = [google_compute_global_address.managed_tls_cert.address]
}
