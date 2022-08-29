data "terraform_remote_state" "root" {
  backend = "remote"

  config = {
    organization = var.root_workspace.organization
    workspaces = {
      name = var.root_workspace.name
    }
  }
}

locals {
  gateway = {
    k8s = {
      namespace      = "default"
      serviceAccount = "public-gateway"
    }
    internet_address = "${var.name}.${trimsuffix(data.google_dns_managed_zone.main.dns_name, ".")}"
  }

  workload_identity_pool = "${data.google_project.main.project_id}.svc.id.goog"

  gcp_resource_labels = {
    environment = var.name
  }
}
