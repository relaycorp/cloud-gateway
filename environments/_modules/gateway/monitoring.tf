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

data "google_monitoring_notification_channel" "sre" {
  display_name = data.terraform_remote_state.root.outputs.sre_monitoring_notification_channel
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

resource "google_monitoring_alert_policy" "poweb_lb_uptime" {
  display_name = "${local.env_full_name}-poweb-uptime"
  combiner     = "OR"
  conditions {
    display_name = "Uptime health check"
    condition_threshold {
      filter          = "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" resource.type=\"uptime_url\" metric.label.\"check_id\"=\"${basename(google_monitoring_uptime_check_config.poweb.id)}\""
      duration        = "60s"
      comparison      = "COMPARISON_GT"
      threshold_value = 1.0
      trigger {
        count = 1
      }
      aggregations {
        alignment_period     = "300s"
        cross_series_reducer = "REDUCE_COUNT_FALSE"
        group_by_fields      = ["resource.*"]
        per_series_aligner   = "ALIGN_NEXT_OLDER"
      }
    }
  }

  notification_channels = [data.google_monitoring_notification_channel.sre.name]

  user_labels = local.gcp_resource_labels
}

resource "google_monitoring_uptime_check_config" "cogrpc" {
  display_name = "${local.env_full_name}-cogrpc"
  timeout      = "5s"
  period       = "300s"

  tcp_check {
    port = 443
  }

  monitored_resource {
    type = "uptime_url"
    labels = {
      project_id = var.gcp_project_id
      host       = trimsuffix(google_dns_record_set.cogrpc.name, ".")
    }
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
