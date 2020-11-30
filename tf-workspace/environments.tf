module "env_frankfurt" {
  source = "../tf-modules/environment_workspace"

  name = "frankfurt"

  gcp_service_account_id = var.gcp_service_account_id
  sre_iam_uri            = var.sre_iam_uri

  mongodb_atlas_project_id      = var.mongodb_atlas_project_id
  env_mongodb_atlas_public_key  = var.env_mongodb_atlas_public_key
  env_mongodb_atlas_private_key = var.env_mongodb_atlas_private_key
}
