resource "google_project_iam_binding" "stackdriver_dashboard_editor" {
  // Grant ourselves permission to create workspaces because Terraform doesn't support it:
  // https://github.com/hashicorp/terraform-provider-google/issues/2605
  role = "roles/monitoring.admin"
  members = [var.sre_iam_uri]
}

resource "google_project_iam_binding" "error_reporting_sre_access" {
  role = "roles/errorreporting.user"
  members = [var.sre_iam_uri]
}
