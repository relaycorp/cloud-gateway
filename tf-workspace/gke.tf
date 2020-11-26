resource "google_project_iam_binding" "gke_developers" {
  # TODO: Use developer role instead. See: https://github.com/relaycorp/cloud-gateway/issues/7
  role    = "roles/container.clusterAdmin"
  members = [var.sre_iam_uri, "serviceAccount:${local.gcb_service_account_email}"]
}
