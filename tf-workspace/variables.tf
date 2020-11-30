variable "gcp_project_id" {
  default = "relaycorp-cloud-gateway"
}
variable "gcp_service_account_id" {}

variable "mongodb_atlas_project_id" {}
variable "env_mongodb_atlas_public_key" {}
variable "env_mongodb_atlas_private_key" {}

variable "sre_iam_uri" {
  description = "GCP IAM URI for an SRE or the SRE group (e.g., 'group:sre-team@acme.com')"
}
