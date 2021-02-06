resource "google_project_iam_binding" "error_reporting_sre_access" {
  role    = "roles/errorreporting.user"
  members = [var.sre_iam_uri]
}

resource "google_monitoring_group" "main" {
  display_name = local.env_full_name

  filter = "resource.metadata.region=\"${var.gcp_region}\""
}

module "poweb_lb_uptime" {
  source = "../host_uptime_monitor"

  name                 = "${local.env_full_name}-poweb"
  host_name            = google_dns_record_set.poweb.name
  notification_channel = data.terraform_remote_state.root.outputs.sre_monitoring_notification_channel
  gcp_project_id       = var.gcp_project_id
}

module "pohttp_lb_uptime" {
  source = "../host_uptime_monitor"

  name                 = "${local.env_full_name}-pohttp"
  host_name            = google_dns_record_set.pohttp.name
  notification_channel = data.terraform_remote_state.root.outputs.sre_monitoring_notification_channel
  gcp_project_id       = var.gcp_project_id
}

module "cogrpc_lb_uptime" {
  source = "../host_uptime_monitor"

  name                 = "${local.env_full_name}-cogrpc"
  probe_type           = "tcp"
  host_name            = google_dns_record_set.cogrpc.name
  notification_channel = data.terraform_remote_state.root.outputs.sre_monitoring_notification_channel
  gcp_project_id       = var.gcp_project_id
}
