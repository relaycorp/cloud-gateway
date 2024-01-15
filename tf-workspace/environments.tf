module "env_frankfurt" {
  source = "../tf-modules/environment_workspace"

  name = "frankfurt"

  gcp_parent_folder   = var.gcp_parent_folder
  gcp_billing_account = var.gcp_billing_account

  shared_infra_gcp_project_id = data.google_project.main.project_id
}

module "env_belgium" {
  source = "../tf-modules/serverless_environment_workspace"

  name = "belgium"

  tfe_terraform_version = "1.6.6"

  gcp_parent_folder    = var.gcp_parent_folder
  gcp_billing_account  = var.gcp_billing_account
  mongodb_atlas_org_id = var.mongodb_atlas_org_id

  shared_infra_gcp_project_id = data.google_project.main.project_id
}

locals {
  env_workspace_ids = [
    module.env_frankfurt.tfe_workspace_id,
    module.env_belgium.tfe_workspace_id,
  ]
}
