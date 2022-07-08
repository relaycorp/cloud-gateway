resource "google_project_iam_binding" "monitoring_admin_sre" {
  // TODO: Remove
  role    = "roles/monitoring.admin"
  members = [var.sre_iam_uri]
}

resource "google_project_iam_binding" "monitoring_viewer_sre" {
  role    = "roles/monitoring.viewer"
  members = [var.sre_iam_uri]
}

resource "google_project_iam_binding" "dashboard_viewer_sre" {
  role    = "roles/monitoring.dashboardViewer"
  members = [var.sre_iam_uri]
}

resource "google_project_iam_binding" "error_reporting_sre_access" {
  role    = "roles/errorreporting.user"
  members = [var.sre_iam_uri]
}

resource "google_monitoring_group" "main" {
  display_name = "gateway"

  filter = "resource.metadata.tag.environment=\"${var.name}\""
}

resource "google_monitoring_notification_channel" "sre_email" {
  for_each = toset(data.terraform_remote_state.root.outputs.sre_email_addresses)

  type = "email"
  labels = {
    email_address = each.value
  }
}

module "poweb_lb_uptime" {
  source = "../host_uptime_monitor"

  name                  = "gateway-poweb"
  host_name             = google_dns_record_set.poweb.name
  notification_channels = [for c in google_monitoring_notification_channel.sre_email: c.name]
  gcp_project_id        = var.gcp_project_id
}

// TODO: Restore when the following has been fixed:
// https://console.cloud.google.com/support/cases/detail/26799183?project=relaycorp-cloud-gateway
//resource "google_monitoring_custom_service" "poweb_deployment" {
//  display_name = "${local.env_full_name}-poweb-deployment"
//
//  telemetry {
//    resource_name = "//container.googleapis.com/projects/${var.gcp_project_id}/locations/${var.gcp_region}/clusters/${google_container_cluster.main.name}/k8s/namespaces/default/apps/deployments/public-gateway-poweb"
//  }
//}
//
//resource "google_monitoring_slo" "poweb_service_uptime" {
//  service      = google_monitoring_custom_service.poweb_deployment.service_id
//  display_name = "${local.env_full_name}-poweb-deployment: 99% uptime (calendar month)"
//
//  goal            = 0.99
//  calendar_period = "MONTH"
//
//  windows_based_sli {
//    window_period = "300s"
//    metric_mean_in_range {
//      time_series = join(" AND ", [
//        "metric.type=\"kubernetes.io/container/uptime\"",
//        "resource.type=\"k8s_container\"",
//      ])
//
//      range {
//        min = 299
//        max = 300
//      }
//    }
//  }
//}

module "pohttp_lb_uptime" {
  source = "../host_uptime_monitor"

  name                  = "gateway-pohttp"
  host_name             = google_dns_record_set.pohttp.name
  notification_channels = [for c in google_monitoring_notification_channel.sre_email: c.name]
  gcp_project_id        = var.gcp_project_id
}

module "cogrpc_lb_uptime" {
  source = "../host_uptime_monitor"

  name                  = "gateway-cogrpc"
  probe_type            = "tcp"
  host_name             = google_dns_record_set.cogrpc.name
  notification_channels = [for c in google_monitoring_notification_channel.sre_email: c.name]
  gcp_project_id        = var.gcp_project_id
}
