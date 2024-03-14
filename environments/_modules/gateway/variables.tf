variable "instance_name" {}

variable "docker_image_tag" {}

variable "sre_iam_uri" {}
variable "alert_email_addresses" {
  type = list(string)
}

variable "gcp_billing_account_id" {}
variable "gcp_billing_monthly_budget_usd" {}

variable "gcp_shared_infra_project_id" {}
variable "gcp_project_id" {}
variable "gcp_region" {
  description = "Google region"
}
variable "gcp_dns_managed_zone" {
  default = "relaycorp-services"
}

variable "mongodbatlas_project_id" {}
variable "mongodbatlas_region" {}
