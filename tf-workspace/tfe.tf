locals {
  tfe_organization = "Relaycorp"
}

resource "tfe_variable_set" "environments" {
  name          = "Public Gateway Environments"
  description   = "Variables shared by all public gateway environments"
  organization  = local.tfe_organization
  workspace_ids = local.env_workspace_ids
}

resource "tfe_variable" "gcp_billing_account" {
  key             = "gcp_billing_account"
  value           = var.gcp_billing_account
  category        = "terraform"
  variable_set_id = tfe_variable_set.environments.id
}
