locals {
  tfe_organization = "Relaycorp"
}

resource "tfe_variable_set" "environments" {
  name          = "Public Gateway Environments"
  description   = "Variables shared by all public gateway environments"
  organization  = local.tfe_organization
  workspace_ids = local.env_workspace_ids
}

resource "tfe_variable" "env_mongodb_atlas_public_key" {
  variable_set_id = tfe_variable_set.environments.id

  category  = "env"
  key       = "MONGODB_ATLAS_PUBLIC_KEY"
  value     = var.env_mongodb_atlas_public_key
  sensitive = false
}

resource "tfe_variable" "env_mongodb_atlas_private_key" {
  variable_set_id = tfe_variable_set.environments.id

  category  = "env"
  key       = "MONGODB_ATLAS_PRIVATE_KEY"
  value     = var.env_mongodb_atlas_private_key
  sensitive = true
}

resource "tfe_variable" "sre_email" {
  variable_set_id = tfe_variable_set.environments.id

  category  = "terraform"
  key       = "sre_iam_uri"
  value     = var.sre_iam_uri
  sensitive = false
}

resource "tfe_variable" "alert_email_addresses" {
  variable_set_id = tfe_variable_set.environments.id

  category  = "terraform"
  key       = "alert_email_addresses"
  value     = jsonencode(var.sre_email_addresses)
  hcl       = true
  sensitive = false
}

resource "tfe_variable" "gcp_shared_infra_project_id" {
  variable_set_id = tfe_variable_set.environments.id

  category  = "terraform"
  key       = "shared_infra_gcp_project_id"
  value     = data.google_project.main.project_id
  sensitive = false
}
