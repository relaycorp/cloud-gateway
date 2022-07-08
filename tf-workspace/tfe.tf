locals {
  tfe_organization = "Relaycorp"
}

resource "tfe_variable_set" "environments" {
  name          = "Public Gateway Environments"
  description   = "Variables shared by all public gateway environments"
  organization  = local.tfe_organization
  workspace_ids = local.env_workspace_ids
}

resource "tfe_variable" "mongodb_atlas_org_id" {
  variable_set_id = tfe_variable_set.environments.id

  key       = "mongodb_atlas_org_id"
  value     = var.mongodb_atlas_org_id
  category  = "terraform"
  sensitive = false
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
