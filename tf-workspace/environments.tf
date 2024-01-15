module "env_frankfurt" {
  source = "../tf-modules/environment_workspace"

  name = "frankfurt"

  gcp_parent_folder   = var.gcp_parent_folder
  gcp_billing_account = var.gcp_billing_account

  shared_infra_gcp_project_id = data.google_project.main.project_id
}

module "env_belgium" {
  source = "../tf-modules/environment_workspace"

  name = "belgium"

  gcp_parent_folder   = var.gcp_parent_folder
  gcp_billing_account = var.gcp_billing_account

  shared_infra_gcp_project_id = data.google_project.main.project_id
}

locals {
  env_workspace_ids = [
    module.env_frankfurt.tfe_workspace_id,
    module.env_belgium.tfe_workspace_id,
  ]
}
