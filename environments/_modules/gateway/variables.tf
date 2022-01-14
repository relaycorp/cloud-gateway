variable "name" {}

variable "root_workspace" {
  type = object({
    name         = string,
    organization = string,
  })
  default = {
    name         = "cloud-gateway",
    organization = "Relaycorp",
  }
}

variable "type" {
  default = "production"
  validation {
    condition     = contains(["production", "testing"], var.type)
    error_message = "Environment type must be either 'production' or 'testing'."
  }
}

variable "dns_managed_zone" {
  default = "relaycorp-cloud"
}

variable "gcp_project_id" {}
variable "gcp_region" {}

variable "gke_instance_type" {
  default = "c2-standard-4"
}

variable "kubernetes_min_version" {
  default = "1.19"
  validation {
    condition     = can(regex("^\\d+\\.\\d+$", var.kubernetes_min_version))
    error_message = "Minimum Kubernetes version, excluding patch version (e.g., '1.21')."
  }
}

variable "mongodb_atlas_org_id" {}
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
