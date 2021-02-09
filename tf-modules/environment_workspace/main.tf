data "google_service_account" "main" {
  account_id = var.gcp_service_account_id
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

  terraform_version = "0.14.5"

  vcs_repo {
    identifier     = var.github_repo
    oauth_token_id = data.tfe_oauth_client.main.oauth_token_id
    branch         = var.github_branch
  }
}

resource "google_service_account_key" "main" {
  service_account_id = data.google_service_account.main.name
}

resource "tfe_variable" "gcp_credentials" {
  workspace_id = tfe_workspace.main.id

  category    = "env"
  sensitive   = true
  key         = "GOOGLE_CREDENTIALS"
  description = data.google_service_account.main.email

  // Remove new line characters as a workaround for
  // https://github.com/hashicorp/terraform/issues/22796
  value = jsonencode(
    jsondecode(base64decode(google_service_account_key.main.private_key))
  )
}

resource "tfe_variable" "mongodb_atlas_org_id" {
  workspace_id = tfe_workspace.main.id

  category = "terraform"
  key      = "mongodb_atlas_org_id"
  value    = var.mongodb_atlas_org_id
}
resource "tfe_variable" "mongodb_atlas_public_key" {
  workspace_id = tfe_workspace.main.id

  category = "env"
  key      = "MONGODB_ATLAS_PUBLIC_KEY"
  value    = var.mongodb_atlas_public_key
}
resource "tfe_variable" "mongodb_atlas_private_key" {
  workspace_id = tfe_workspace.main.id

  category  = "env"
  sensitive = true
  key       = "MONGODB_ATLAS_PRIVATE_KEY"
  value     = var.mongodb_atlas_private_key
}

resource "tfe_variable" "sre_email" {
  workspace_id = tfe_workspace.main.id

  category = "terraform"
  key      = "sre_iam_uri"
  value    = var.sre_iam_uri
}
