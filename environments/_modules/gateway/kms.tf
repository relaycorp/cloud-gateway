resource "random_id" "kms_key_ring_suffix" {
  byte_length = 3
}

resource "google_kms_key_ring" "main" {
  project = "${var.gcp_project_id}-${random_id.kms_key_ring_suffix.hex}"

  name     = local.env_full_name
  location = var.gcp_region
}
