data "google_dns_managed_zone" "main" {
  name    = var.dns_managed_zone
  project = var.shared_infra_gcp_project_id
}

resource "google_dns_record_set" "status_page" {
  name         = "${var.name}.${data.google_dns_managed_zone.main.dns_name}"
  managed_zone = data.google_dns_managed_zone.main.name
  type         = "CNAME"
  ttl          = 300

  rrdatas = ["stats.uptimerobot.com."]
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

resource "google_dns_record_set" "awala_gsc_srv" {
  name         = "_awala-gsc._tcp.${var.name}.${data.google_dns_managed_zone.main.dns_name}"
  managed_zone = data.google_dns_managed_zone.main.name
  type         = "SRV"
  ttl          = 300
  rrdatas      = ["0 1 443 ${google_dns_record_set.poweb.name}"]
}

resource "google_dns_record_set" "awala_pdc_srv" {
  name         = "_awala-pdc._tcp.${var.name}.${data.google_dns_managed_zone.main.dns_name}"
  managed_zone = data.google_dns_managed_zone.main.name
  type         = "SRV"
  ttl          = 300
  rrdatas      = ["0 1 443 ${google_dns_record_set.pohttp.name}"]
}

resource "google_dns_record_set" "awala_crc_srv" {
  name         = "_awala-crc._tcp.${var.name}.${data.google_dns_managed_zone.main.dns_name}"
  managed_zone = data.google_dns_managed_zone.main.name
  type         = "SRV"
  ttl          = 300
  rrdatas      = ["0 1 443 ${google_dns_record_set.cogrpc.name}"]
}

// TODO: Remove *days* after releasing the following to production
// https://github.com/relaycorp/relaynet-gateway-android/pull/314
resource "google_dns_record_set" "gsc_srv" {
  name         = "_rgsc._tcp.${var.name}.${data.google_dns_managed_zone.main.dns_name}"
  managed_zone = data.google_dns_managed_zone.main.name
  type         = "SRV"
  ttl          = 300
  rrdatas      = ["0 1 443 ${google_dns_record_set.poweb.name}"]
}

// TODO: Remove *days* after releasing the following to production
// https://github.com/relaycorp/relaynet-courier-android/pull/312
resource "google_dns_record_set" "crc_srv" {
  name         = "_rcrc._tcp.${var.name}.${data.google_dns_managed_zone.main.dns_name}"
  managed_zone = data.google_dns_managed_zone.main.name
  type         = "SRV"
  ttl          = 300
  rrdatas      = ["0 1 443 ${google_dns_record_set.cogrpc.name}"]
}
