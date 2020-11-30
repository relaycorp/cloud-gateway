variable "name" {
  description = "Environment name"
}

variable "gcp_service_account_id" {}
variable "sre_iam_uri" {}

variable "mongodb_atlas_project_id" {}
variable "env_mongodb_atlas_public_key" {}
variable "env_mongodb_atlas_private_key" {}

variable "tfe_organization" {
  default = "Relaycorp"
}
