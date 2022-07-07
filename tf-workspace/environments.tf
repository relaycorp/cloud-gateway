module "env_frankfurt" {
  source = "../tf-modules/environment_workspace"

  name = "frankfurt"

  gcp_service_account_id = var.gcp_service_account_id
  gcp_parent_folder      = var.gcp_parent_folder
  gcp_billing_account    = var.gcp_billing_account
  sre_iam_uri            = var.sre_iam_uri

  mongodb_atlas_org_id      = var.mongodb_atlas_org_id
  mongodb_atlas_public_key  = var.env_mongodb_atlas_public_key
  mongodb_atlas_private_key = var.env_mongodb_atlas_private_key
}

locals {
  env_workspace_ids = [
    module.env_frankfurt.tfe_workspace_id,
  ]
}
