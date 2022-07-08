module "env_frankfurt" {
  source = "../tf-modules/environment_workspace"

  name = "frankfurt"

  gcp_parent_folder   = var.gcp_parent_folder
  gcp_billing_account = var.gcp_billing_account

  mongodb_atlas_org_id = var.mongodb_atlas_org_id
}

locals {
  env_workspace_ids = [
    module.env_frankfurt.tfe_workspace_id,
  ]
}
