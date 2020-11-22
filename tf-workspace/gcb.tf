locals {
  gcb_service_account_email = "${data.google_project.main.number}@cloudbuild.gserviceaccount.com"
}

resource "google_project_iam_binding" "gcb_gke_developer" {
  role    = "roles/container.developer"
  members = ["serviceAccount:${local.gcb_service_account_email}"]
}
