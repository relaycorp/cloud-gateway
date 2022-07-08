data "google_project" "main" {
}

resource "google_project_iam_member" "project_viewer" {
  project = var.gcp_project_id
  role    = "roles/viewer"
  member  = var.sre_iam_uri
}

resource "google_project_service" "dns" {
  project                    = var.gcp_project_id
  service                    = "dns.googleapis.com"
  disable_dependent_services = true
}

resource "google_project_service" "iam" {
  project                    = var.gcp_project_id
  service                    = "iam.googleapis.com"
  disable_dependent_services = true
}
