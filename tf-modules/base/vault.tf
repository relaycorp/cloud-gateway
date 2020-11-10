resource "google_service_account" "vault" {
  account_id = "${local.env_full_name}-vault"
  project    = var.gcp_project_id
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

data "google_iam_policy" "vault_auto_unseal" {
  binding {
    role    = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
    members = ["serviceAccount:${google_service_account.vault.email}"]
  }

  binding {
    role    = "roles/cloudkms.cryptoKeys.get"
    members = ["serviceAccount:${google_service_account.vault.email}"]
  }
}

resource "google_kms_crypto_key_iam_policy" "crypto_key" {
  crypto_key_id = google_kms_crypto_key.vault_auto_unseal.id
  policy_data   = data.google_iam_policy.vault_auto_unseal.policy_data
}
