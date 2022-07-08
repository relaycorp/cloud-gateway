data "terraform_remote_state" "root" {
  backend = "remote"

  config = {
    organization = var.tfe_organization
    workspaces = {
      name = var.tfe_root_workspace
    }
  }
}

data "tfe_oauth_client" "main" {
  oauth_client_id = var.tfe_oauth_client_id
}

resource "tfe_workspace" "main" {
  name         = "gateway-${var.name}"
  organization = var.tfe_organization

  working_directory = "environments/${var.name}"
  trigger_prefixes  = ["environments/_modules"]

  auto_apply = true

  terraform_version = "1.2.4"

  vcs_repo {
    identifier     = var.github_repo
    oauth_token_id = data.tfe_oauth_client.main.oauth_token_id
    branch         = var.github_branch
  }
}

data "tfe_organization_membership" "sres" {
  for_each = toset(data.terraform_remote_state.root.outputs.sre_email_addresses)

  organization = var.tfe_organization
  email        = each.value
}

resource "tfe_notification_configuration" "sres" {
  name             = "Notify SREs to anything that needs their attention"
  enabled          = true
  destination_type = "email"
  email_user_ids   = [for sre in data.tfe_organization_membership.sres : sre.user_id]
  triggers         = ["run:needs_attention", "run:errored"]
  workspace_id     = tfe_workspace.main.id
}

resource "tfe_variable" "gcp_credentials" {
  workspace_id = tfe_workspace.main.id

  category    = "env"
  sensitive   = true
  key         = "GOOGLE_CREDENTIALS"
  description = google_service_account.tfe.email

  // Remove new line characters as a workaround for
  // https://github.com/hashicorp/terraform/issues/22796
  value = jsonencode(
    jsondecode(base64decode(google_service_account_key.main.private_key))
  )
}

resource "tfe_variable" "gcp_project_id" {
  workspace_id = tfe_workspace.main.id

  category = "terraform"
  key      = "gcp_project_id"
  value    = google_project.main.project_id
}

// TODO: Remove when https://support.hashicorp.com/hc/en-us/requests/78185 is fixed
resource "tfe_variable" "shared_infra_gcp_project_id" {
  workspace_id = tfe_workspace.main.id

  category = "terraform"
  key      = "shared_infra_gcp_project_id"
  value    = var.shared_infra_gcp_project_id
}

// TODO: Remove when https://support.hashicorp.com/hc/en-us/requests/78185 is fixed
resource "tfe_variable" "mongodb_atlas_org_id" {
  workspace_id = tfe_workspace.main.id

  category = "terraform"
  key      = "mongodb_atlas_org_id"
  value    = var.mongodb_atlas_org_id
}

// TODO: Remove when https://support.hashicorp.com/hc/en-us/requests/78185 is fixed
resource "tfe_variable" "env_mongodb_atlas_public_key" {
  workspace_id = tfe_workspace.main.id

  category  = "env"
  key       = "MONGODB_ATLAS_PUBLIC_KEY"
  value     = var.env_mongodb_atlas_public_key
  sensitive = false
}

// TODO: Remove when https://support.hashicorp.com/hc/en-us/requests/78185 is fixed
resource "tfe_variable" "env_mongodb_atlas_private_key" {
  workspace_id = tfe_workspace.main.id

  category  = "env"
  key       = "MONGODB_ATLAS_PRIVATE_KEY"
  value     = var.env_mongodb_atlas_private_key
  sensitive = true
}
