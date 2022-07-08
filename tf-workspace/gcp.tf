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

resource "google_project_service" "serviceusage" {
  project                    = var.gcp_project_id
  service                    = "serviceusage.googleapis.com"
  disable_dependent_services = true
}

resource "google_project_service" "cloudresourcemanager" {
  project                    = var.gcp_project_id
  service                    = "cloudresourcemanager.googleapis.com"
  disable_dependent_services = true
}
