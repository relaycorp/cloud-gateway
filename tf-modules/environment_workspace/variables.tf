variable "name" {
  description = "Environment name"
}

variable "gcp_service_account_id" {}
variable "sre_iam_uri" {}

variable "mongodb_atlas_org_id" {}
variable "mongodb_atlas_public_key" {}
variable "mongodb_atlas_private_key" {}

variable "tfe_organization" {
  default = "Relaycorp"
}
variable "tfe_root_workspace" {
  default = "cloud-gateway"
}
variable "tfe_oauth_client_id" {
  default = "oc-7jBF4Z5YhNc4QRSc"
}

variable "github_repo" {
  default = "relaycorp/cloud-gateway"
}
variable "github_branch" {
  default = "main"
}
