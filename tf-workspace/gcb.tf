resource "google_storage_bucket" "gcb_builder_logs" {
  name          = "relaycorp-gcb-builder-logs"
  storage_class = "REGIONAL"
  location      = "europe-west2"

  uniform_bucket_level_access = true

  force_destroy = true

  versioning {
    enabled = false
  }

  labels = {
    stage : "deployment"
  }
}
