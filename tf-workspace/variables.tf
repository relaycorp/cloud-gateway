variable "gcp_project_id" {
  default = "relaycorp-cloud-gateway"
}
variable "gcp_service_account_id" {}

variable "mongodb_atlas_project_id" {}

variable "sre_iam_uri" {
  description = "GCP IAM URI for an SRE or the SRE group (e.g., 'group:sre-team@acme.com')"
}
