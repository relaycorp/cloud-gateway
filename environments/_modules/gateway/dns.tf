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

resource "google_dns_record_set" "gsc_srv" {
  name         = "_rpdc._tcp.${var.name}.${data.google_dns_managed_zone.main.dns_name}"
  managed_zone = data.google_dns_managed_zone.main.name
  type         = "SRV"
  ttl          = 300
  rrdatas      = ["0 1 443 ${google_dns_record_set.poweb.name}"]
}

resource "google_dns_record_set" "pdc_srv" {
  name         = "_rgsc._tcp.${var.name}.${data.google_dns_managed_zone.main.dns_name}"
  managed_zone = data.google_dns_managed_zone.main.name
  type         = "SRV"
  ttl          = 300
  rrdatas      = ["0 1 443 ${google_dns_record_set.pohttp.name}"]
}

resource "google_dns_record_set" "crc_srv" {
  name         = "_rcrc._tcp.${var.name}.${data.google_dns_managed_zone.main.dns_name}"
  managed_zone = data.google_dns_managed_zone.main.name
  type         = "SRV"
  ttl          = 300
  rrdatas      = ["0 1 443 ${google_dns_record_set.cogrpc.name}"]
}
