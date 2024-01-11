module "env_frankfurt" {
  source = "../tf-modules/environment_workspace"

  name = "frankfurt"

  gcp_parent_folder   = var.gcp_parent_folder
  gcp_billing_account = var.gcp_billing_account

  depends_on = [google_project_service.iam]
}

locals {
  env_workspace_ids = [
    module.env_frankfurt.tfe_workspace_id,
  ]
}
