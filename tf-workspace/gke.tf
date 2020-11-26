resource "google_project_iam_binding" "gke_developers" {
  role    = "roles/container.developer"
  members = [var.sre_iam_uri, "serviceAccount:${local.gcb_service_account_email}"]
}

resource "google_project_iam_binding" "gke_admins" {
  # TODO: Use developer role instead. See: https://github.com/relaycorp/cloud-gateway/issues/7
  role    = "roles/container.clusterAdmin"
  members = ["serviceAccount:${local.gcb_service_account_email}"]
}
