data "google_dns_managed_zone" "main" {
  project = var.shared_infra_gcp_project_id

  name = var.dns_managed_zone
}

resource "google_dns_record_set" "status_page" {
  project = var.shared_infra_gcp_project_id

  name         = "${var.name}.${data.google_dns_managed_zone.main.dns_name}"
  managed_zone = data.google_dns_managed_zone.main.name
  type         = "CNAME"
  ttl          = 300

  rrdatas = ["stats.uptimerobot.com."]
}

resource "google_dns_record_set" "poweb" {
  project = var.shared_infra_gcp_project_id

  name         = "poweb-${var.name}.${data.google_dns_managed_zone.main.dns_name}"
  managed_zone = data.google_dns_managed_zone.main.name
  type         = "A"
  ttl          = 300

  rrdatas = [google_compute_global_address.managed_tls_cert.address]
}

resource "google_dns_record_set" "pohttp" {
  project = var.shared_infra_gcp_project_id

  name         = "pohttp-${var.name}.${data.google_dns_managed_zone.main.dns_name}"
  managed_zone = data.google_dns_managed_zone.main.name
  type         = "A"
  ttl          = 300

  rrdatas = [google_compute_global_address.managed_tls_cert.address]
}

resource "google_dns_record_set" "cogrpc" {
  project = var.shared_infra_gcp_project_id

  name         = "cogrpc-${var.name}.${data.google_dns_managed_zone.main.dns_name}"
  managed_zone = data.google_dns_managed_zone.main.name
  type         = "A"
  ttl          = 300

  rrdatas = [google_compute_global_address.managed_tls_cert.address]
}

resource "google_dns_record_set" "awala_gsc_srv" {
  project = var.shared_infra_gcp_project_id

  name         = "_awala-gsc._tcp.${var.name}.${data.google_dns_managed_zone.main.dns_name}"
  managed_zone = data.google_dns_managed_zone.main.name
  type         = "SRV"
  ttl          = 300
  rrdatas      = ["0 1 443 ${google_dns_record_set.poweb.name}"]
}

resource "google_dns_record_set" "awala_pdc_srv" {
  project = var.shared_infra_gcp_project_id

  name         = "_awala-pdc._tcp.${var.name}.${data.google_dns_managed_zone.main.dns_name}"
  managed_zone = data.google_dns_managed_zone.main.name
  type         = "SRV"
  ttl          = 300
  rrdatas      = ["0 1 443 ${google_dns_record_set.pohttp.name}"]
}

resource "google_dns_record_set" "awala_crc_srv" {
  project = var.shared_infra_gcp_project_id

  name         = "_awala-crc._tcp.${var.name}.${data.google_dns_managed_zone.main.dns_name}"
  managed_zone = data.google_dns_managed_zone.main.name
  type         = "SRV"
  ttl          = 300
  rrdatas      = ["0 1 443 ${google_dns_record_set.cogrpc.name}"]
}
