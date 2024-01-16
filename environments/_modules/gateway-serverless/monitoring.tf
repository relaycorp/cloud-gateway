resource "google_project_iam_binding" "monitoring_viewer_sre" {
  project = var.gcp_project_id
  role    = "roles/monitoring.viewer"
  members = [var.sre_iam_uri]
}

resource "google_project_iam_binding" "dashboard_viewer_sre" {
  project = var.gcp_project_id
  role    = "roles/monitoring.dashboardViewer"
  members = [var.sre_iam_uri]
}

resource "google_monitoring_group" "main" {
  display_name = "gateway"

  filter = "resource.metadata.tag.environment=\"${var.instance_name}\""

  depends_on = [google_project_service.services]
}

resource "google_monitoring_notification_channel" "sres_email" {
  for_each = toset(var.alert_email_addresses)

  display_name = "Notify SREs (managed by Terraform workspace ${terraform.workspace})"
  type         = "email"

  labels = {
    email_address = each.value
  }

  depends_on = [google_project_service.services]
}

module "poweb_lb_uptime" {
  source = "../host_uptime_monitor"

  name                  = "gateway-${var.instance_name}-poweb"
  host_name             = google_dns_record_set.poweb.name
  notification_channels = [for c in google_monitoring_notification_channel.sres_email : c.name]
  gcp_project_id        = var.gcp_project_id
}

module "pohttp_lb_uptime" {
  source = "../host_uptime_monitor"

  name                  = "gateway-${var.instance_name}-pohttp"
  host_name             = google_dns_record_set.pohttp.name
  notification_channels = [for c in google_monitoring_notification_channel.sres_email : c.name]
  gcp_project_id        = var.gcp_project_id
}

module "cogrpc_lb_uptime" {
  source = "../host_uptime_monitor"

  name                  = "gateway-${var.instance_name}-cogrpc"
  probe_type            = "tcp"
  host_name             = google_dns_record_set.cogrpc.name
  notification_channels = [for c in google_monitoring_notification_channel.sres_email : c.name]
  gcp_project_id        = var.gcp_project_id
}
