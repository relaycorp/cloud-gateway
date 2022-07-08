variable "name" {
  description = "Environment name"
}

variable "gcp_parent_folder" {}
variable "gcp_billing_account" {}

variable "mongodb_atlas_org_id" {}
variable "env_mongodb_atlas_public_key" {}
variable "env_mongodb_atlas_private_key" {}

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
