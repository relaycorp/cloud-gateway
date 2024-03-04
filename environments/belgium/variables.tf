variable "sre_iam_uri" {}
variable "alert_email_addresses" {
  type = list(string)
}

variable "gcp_project_id" {}
variable "shared_infra_gcp_project_id" {}

variable "mongodbatlas_project_id" {}

// TODO: Remove once the security audit is over
variable "temporary_auditor_iam_uris" {
  type = list(string)
}
