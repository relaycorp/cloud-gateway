variable "environment_name" {}

variable "pohttp_host" {}
variable "poweb_host" {}
variable "cogrpc_host" {}
variable "dns_managed_zone" {
  default = "relaycorp-cloud"
}

variable gcp_project_id {}
variable gcp_region {}

variable "mongodb_atlas_project_id" {}
variable "mongodb_atlas_region" {}

variable "github_repo" {
  type = object({
    organisation = string
    name         = string
  })

  default = {
    organisation = "relaycorp"
    name         = "cloud-gateway"
  }
}

variable "sre_iam_uri" {}
