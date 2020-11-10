resource "google_service_account" "vault" {
  project    = var.gcp_project_id
  account_id = "${local.env_full_name}-vault"
}

resource "google_service_account_key" "vault" {
  service_account_id = google_service_account.vault.name
}

resource "kubernetes_secret" "vault_cd" {
  metadata {
    name = "vault-cd"
  }

  data = {
    "service_account_key.json" = google_service_account_key.vault.private_key
  }
}

resource "kubernetes_config_map" "vault_cd" {
  metadata {
    name = "vault-cd"
  }

  data = {
    "partial-vault.hcl" = <<EOF
      seal "gcpckms" {
        project     = "${var.gcp_project_id}"
        region      = "global"
        key_ring    = "${google_kms_key_ring.main.name}"
        crypto_key  = "${google_kms_crypto_key.vault_auto_unseal.name}"
      }

      storage "gcs" {
        bucket     = "${google_storage_bucket.vault.name}"
        ha_enabled = "true"
      }
EOF
  }
}

// Auto-unseal

resource "google_kms_crypto_key" "vault_auto_unseal" {
  name            = "vault-auto-unseal"
  key_ring        = google_kms_key_ring.main.self_link
  rotation_period = "100000s"

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_project_iam_custom_role" "vault_auto_unseal" {
  project = var.gcp_project_id

  role_id     = "${replace(local.env_full_name, "-", "_")}.vault_auto_unseal"
  title       = "Vault auto-unseal"
  permissions = ["cloudkms.cryptoKeys.get"]

  // TODO: Add conditions to restrict it to one keyring
}

resource "google_project_iam_binding" "vault_auto_unseal" {
  role = google_project_iam_custom_role.vault_auto_unseal.id

  members = [
    "serviceAccount:${google_service_account.vault.email}"
  ]
}

data "google_iam_policy" "vault_auto_unseal" {
  binding {
    role    = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
    members = ["serviceAccount:${google_service_account.vault.email}"]
  }
}

resource "google_kms_crypto_key_iam_policy" "crypto_key" {
  crypto_key_id = google_kms_crypto_key.vault_auto_unseal.id
  policy_data   = data.google_iam_policy.vault_auto_unseal.policy_data
}

// GCS storage backend

resource "google_storage_bucket" "vault" {
  name          = "relaycorp-${local.env_full_name}-vault"
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

resource "google_storage_bucket_iam_member" "vault_storage" {
  bucket = google_storage_bucket.vault.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.vault.email}"
}
