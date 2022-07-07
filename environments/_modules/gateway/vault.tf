// TODO: Delete after the `force_destroy=true` has been applied
resource "google_storage_bucket" "vault" {
  name          = "relaycorp-${local.env_full_name}-vault"
  storage_class = "REGIONAL"
  location      = upper(var.gcp_region)

  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }

  force_destroy = true

  labels = local.gcp_resource_labels
}
