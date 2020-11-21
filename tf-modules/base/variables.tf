variable "environment_name" {}

variable "pohttp_host" {}
variable "poweb_host" {}
variable "cogrpc_host" {}

variable "mongodb_atlas_project_id" {}

variable gcp_project_id {}
variable gcp_region {}

variable "codefresh" {
  type = object({
    service_account_email = string
  })
}
variable "cf_project_name" {}
variable "cf_kubernetes_context" {}
