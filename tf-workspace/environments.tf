module "env_frankfurt" {
  source = "../tf-modules/environment_workspace"

  name = "frankfurt"

  gcp_parent_folder   = var.gcp_parent_folder
  gcp_billing_account = var.gcp_billing_account

  mongodb_atlas_org_id          = var.mongodb_atlas_org_id
  env_mongodb_atlas_public_key  = var.env_mongodb_atlas_public_key
  env_mongodb_atlas_private_key = var.env_mongodb_atlas_private_key
  shared_infra_gcp_project_id   = data.google_project.main.project_id

  depends_on = [google_project_service.iam]
}

module "env_frankfurt2" {
  source = "../tf-modules/environment_workspace"

  name = "frankfurt2"

  gcp_parent_folder   = var.gcp_parent_folder
  gcp_billing_account = var.gcp_billing_account

  mongodb_atlas_org_id          = var.mongodb_atlas_org_id
  env_mongodb_atlas_public_key  = var.env_mongodb_atlas_public_key
  env_mongodb_atlas_private_key = var.env_mongodb_atlas_private_key
  shared_infra_gcp_project_id   = data.google_project.main.project_id

  depends_on = [google_project_service.iam]
}

locals {
  env_workspace_ids = [
    module.env_frankfurt.tfe_workspace_id,
    module.env_frankfurt2.tfe_workspace_id,
  ]
}
