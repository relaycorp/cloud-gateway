data "google_project" "main" {
}

resource "google_project_service" "dns" {
  project                    = var.gcp_project_id
  service                    = "dns.googleapis.com"
  disable_dependent_services = true
}

resource "google_folder_iam_member" "project_viewer" {
  folder = var.gcp_parent_folder
  role   = "roles/viewer"
  member = var.sre_iam_uri
}
