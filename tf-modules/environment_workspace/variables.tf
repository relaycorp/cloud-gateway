variable "name" {
  description = "Environment name"
}

variable "shared_infra_gcp_project_id" {}
variable "gcp_parent_folder" {}
variable "gcp_billing_account" {}

variable "mongodb_atlas_org_id" {
  default = null // Take from variable set
}
variable "env_mongodb_atlas_public_key" {
  default = null // Take from variable set
}
variable "env_mongodb_atlas_private_key" {
  default = null // Take from variable set
}

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
