resource "google_storage_bucket" "internal" {
  name          = "relaycorp-${local.env_full_name}-internal"
  storage_class = "REGIONAL"
  location      = upper(var.gcp_region)

  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }

  labels = {
    env_name = var.environment_name
  }
}
