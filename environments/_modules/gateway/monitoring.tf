resource "google_project_iam_binding" "stackdriver_dashboard_editor" {
  // Grant ourselves permission to create workspaces because Terraform doesn't support it:
  // https://github.com/hashicorp/terraform-provider-google/issues/2605
  role    = "roles/monitoring.admin"
  members = [var.sre_iam_uri]
}

resource "google_project_iam_binding" "error_reporting_sre_access" {
  role    = "roles/errorreporting.user"
  members = [var.sre_iam_uri]
}

resource "google_monitoring_group" "main" {
  display_name = local.env_full_name

  filter = "resource.metadata.region=\"${var.gcp_region}\""
}

resource "google_monitoring_uptime_check_config" "poweb" {
  display_name = "${local.env_full_name}-poweb"
  timeout      = "5s"
  period       = "300s"

  http_check {
    port         = "443"
    use_ssl      = true
    validate_ssl = true
  }

  monitored_resource {
    type = "uptime_url"
    labels = {
      project_id = var.gcp_project_id
      host       = trimsuffix(google_dns_record_set.poweb.name, ".")
    }
  }
}

resource "google_monitoring_uptime_check_config" "cogrpc" {
  display_name = "${local.env_full_name}-cogrpc"
  timeout      = "5s"
  period       = "300s"

  tcp_check {
    port = 888
  }

  resource_group {
    resource_type = "INSTANCE"
    group_id      = google_monitoring_group.main.name
  }
}

resource "google_monitoring_uptime_check_config" "pohttp" {
  display_name = "${local.env_full_name}-pohttp"
  timeout      = "5s"
  period       = "300s"

  http_check {
    port         = "443"
    use_ssl      = true
    validate_ssl = true
  }

  monitored_resource {
    type = "uptime_url"
    labels = {
      project_id = var.gcp_project_id
      host       = trimsuffix(google_dns_record_set.pohttp.name, ".")
    }
  }
}
