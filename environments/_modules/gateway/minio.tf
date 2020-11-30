resource "random_password" "minio_secret_key" {
  length  = 32
  special = false
}

module "minio_secret_key" {
  source = "../cd_secret"

  secret_id                      = "${local.env_full_name}-minio-secret-key"
  secret_value                   = random_password.minio_secret_key.result
  accessor_service_account_email = local.gcb_service_account_email
  gcp_labels                     = local.gcp_resource_labels
}
