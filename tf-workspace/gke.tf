resource "google_project_iam_binding" "gke_developers" {
  role    = "roles/container.developer"
  members = [var.sre_iam_uri, "serviceAccount:${local.gcb_service_account_email}"]
}

resource "google_project_iam_binding" "gce_admin" {
  role    = "roles/compute.instanceAdmin"
  members = [var.sre_iam_uri]
}

resource "google_project_iam_binding" "gke_admins" {
  # TODO: Delete. See: https://github.com/relaycorp/cloud-gateway/issues/7
  role    = "roles/container.admin"
  members = ["serviceAccount:${local.gcb_service_account_email}"]
}
