module "env_frankfurt" {
  source = "../tf-modules/environment_workspace"

  name = "frankfurt"

  gcp_service_account_id = var.gcp_service_account_id
  sre_iam_uri            = var.sre_iam_uri

  mongodb_atlas_org_id      = var.mongodb_atlas_org_id
  mongodb_atlas_public_key  = var.env_mongodb_atlas_public_key
  mongodb_atlas_private_key = var.env_mongodb_atlas_private_key
}

module "env_frankfurt_test" {
  source = "../tf-modules/environment_workspace"

  name = "frankfurt-test"

  github_branch = "gcp-kms-test"

  gcp_service_account_id = var.gcp_service_account_id
  sre_iam_uri            = var.sre_iam_uri

  mongodb_atlas_org_id      = var.mongodb_atlas_org_id
  mongodb_atlas_public_key  = var.env_mongodb_atlas_public_key
  mongodb_atlas_private_key = var.env_mongodb_atlas_private_key
}

locals {
  env_workspace_ids = [
    module.env_frankfurt.tfe_workspace_id,
    module.env_frankfurt_test.tfe_workspace_id,
  ]
}
