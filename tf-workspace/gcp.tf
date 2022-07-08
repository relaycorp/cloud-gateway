resource "google_project_iam_member" "project_viewer" {
  project = var.gcp_project_id
  role    = "roles/viewer"
  member  = var.sre_iam_uri
}
