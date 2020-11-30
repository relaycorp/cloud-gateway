resource "google_kms_key_ring" "main" {
  project = var.gcp_project_id

  name     = local.env_full_name
  location = "global"
}
