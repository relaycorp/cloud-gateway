// See https://docs.relaycorp.tech/awala-keystore-cloud-js/gcp

locals {
  kms_protection_level = var.type == "production" ? "HSM" : "SOFTWARE"
}

// KMS

resource "random_id" "kms_key_ring_suffix" {
  byte_length = 3
}

resource "google_kms_key_ring" "keystores" {
  project = var.gcp_project_id

  # Key rings can be deleted from the Terraform state but not GCP, so let's add a suffix in case
  # we need to recreate it.
  name = "gateway-keystores-${random_id.kms_key_ring_suffix.hex}"

  location = var.gcp_region
}

resource "google_kms_crypto_key" "awala_identity_keys" {
  name     = "awala-identity-keys"
  key_ring = google_kms_key_ring.keystores.self_link
  purpose  = "ASYMMETRIC_SIGN"

  skip_initial_version_creation = true

  version_template {
    algorithm        = "RSA_SIGN_PSS_2048_SHA256"
    protection_level = local.kms_protection_level
  }

  lifecycle {
    prevent_destroy = false
  }
}

resource "google_kms_crypto_key" "awala_session_keys" {
  name            = "awala-session-keys"
  key_ring        = google_kms_key_ring.keystores.self_link
  rotation_period = "2592000s" // 30 days
  purpose         = "ENCRYPT_DECRYPT"

  version_template {
    algorithm        = "GOOGLE_SYMMETRIC_ENCRYPTION"
    protection_level = local.kms_protection_level
  }

  lifecycle {
    prevent_destroy = false
  }
}

// IAM
// https://docs.relaycorp.tech/awala-keystore-cloud-js/gcp#iam-permissions

resource "google_project_iam_custom_role" "keystore_kms_admin" {
  project = var.gcp_project_id

  role_id = "gateway.keystore_kms_manager"
  title   = "Permissions to manage KMS resources related to the Awala keystore"
  permissions = [
    "cloudkms.cryptoKeys.get",
    "cloudkms.cryptoKeyVersions.create",
  ]
}

resource "google_project_iam_binding" "keystore_kms_admin" {
  role = google_project_iam_custom_role.keystore_kms_admin.id

  members = ["serviceAccount:${google_service_account.gateway.email}"]

  condition {
    title      = "Limit app access to KMS key ring"
    expression = "resource.name.startsWith(\"${google_kms_key_ring.keystores.id}\")"
  }
}

resource "google_project_iam_member" "keystore_kms_user" {
  role   = "roles/cloudkms.cryptoOperator"
  member = "serviceAccount:${google_service_account.gateway.email}"

  condition {
    title      = "Limit app access to KMS key ring"
    expression = "resource.name.startsWith(\"${google_kms_key_ring.keystores.id}\")"
  }
}
