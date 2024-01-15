data "google_dns_managed_zone" "main" {
  project = var.gcp_shared_infra_project_id

  name = var.gcp_dns_managed_zone
}

resource "google_dns_record_set" "poweb" {
  project = var.gcp_shared_infra_project_id

  name         = "${var.instance_name}-poweb.${data.google_dns_managed_zone.main.dns_name}"
  managed_zone = data.google_dns_managed_zone.main.name
  type         = "A"
  ttl          = 300

  rrdatas = [module.gateway.load_balancer_ip_address]
}

resource "google_dns_record_set" "pohttp" {
  project = var.gcp_shared_infra_project_id

  name         = "${var.instance_name}-pohttp.${data.google_dns_managed_zone.main.dns_name}"
  managed_zone = data.google_dns_managed_zone.main.name
  type         = "A"
  ttl          = 300

  rrdatas = [module.gateway.load_balancer_ip_address]
}

resource "google_dns_record_set" "cogrpc" {
  project = var.gcp_shared_infra_project_id

  name         = "${var.instance_name}-cogrpc.${data.google_dns_managed_zone.main.dns_name}"
  managed_zone = data.google_dns_managed_zone.main.name
  type         = "A"
  ttl          = 300

  rrdatas = [module.gateway.load_balancer_ip_address]
}

resource "google_dns_record_set" "awala_gsc_srv" {
  project = var.gcp_shared_infra_project_id

  name         = "_awala-gsc._tcp.${var.instance_name}.${data.google_dns_managed_zone.main.dns_name}"
  managed_zone = data.google_dns_managed_zone.main.name
  type         = "SRV"
  ttl          = 300
  rrdatas      = ["0 1 443 ${google_dns_record_set.poweb.name}"]
}

resource "google_dns_record_set" "awala_pdc_srv" {
  project = var.gcp_shared_infra_project_id

  name         = "_awala-pdc._tcp.${var.instance_name}.${data.google_dns_managed_zone.main.dns_name}"
  managed_zone = data.google_dns_managed_zone.main.name
  type         = "SRV"
  ttl          = 300
  rrdatas      = ["0 1 443 ${google_dns_record_set.pohttp.name}"]
}

resource "google_dns_record_set" "awala_crc_srv" {
  project = var.gcp_shared_infra_project_id

  name         = "_awala-crc._tcp.${var.instance_name}.${data.google_dns_managed_zone.main.dns_name}"
  managed_zone = data.google_dns_managed_zone.main.name
  type         = "SRV"
  ttl          = 300
  rrdatas      = ["0 1 443 ${google_dns_record_set.cogrpc.name}"]
}
