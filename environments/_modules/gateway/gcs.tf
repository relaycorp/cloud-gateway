resource "random_id" "gateway_messages_bucket_suffix" {
  byte_length = 3
}

resource "google_storage_bucket" "gateway_messages" {
  name          = "${local.env_full_name}-messages-${random_id.gateway_messages_bucket_suffix.hex}"
  storage_class = "REGIONAL"
  location      = upper(var.gcp_region)

  uniform_bucket_level_access = true

  versioning {
    // Whislt the app may never use an older version of the message, we may find it useful to get
    // those versions during troubleshooting.
    enabled = true
  }

  lifecycle_rule {
    condition {
      age = 2 // https://github.com/relaycorp/cloud-gateway/issues/64
    }
    action {
      type = "Delete"
    }
  }

  labels = local.gcp_resource_labels
}

resource "google_storage_bucket_iam_member" "gateway_gcs_bucket" {
  bucket = google_storage_bucket.gateway_messages.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.gateway.email}"
}
