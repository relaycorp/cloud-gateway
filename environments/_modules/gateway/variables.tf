variable "name" {}

variable "dns_managed_zone" {
  default = "relaycorp-cloud"
}

variable gcp_project_id {}
variable gcp_region {}

variable "gke_version" {
  default = "1.17.12"
}
variable "gke_instance_type" {
  default = "c2-standard-4"
}

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