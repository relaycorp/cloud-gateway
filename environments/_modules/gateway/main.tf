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
  env_full_name = "gateway-${var.name}"

  gateway = {
    k8s = {
      namespace      = "default"
      serviceAccount = "public-gateway"
    }
    public_address = "${var.name}.${trimsuffix(data.google_dns_managed_zone.main.dns_name, ".")}"
  }

  workload_identity_pool = "${data.google_project.main.project_id}.svc.id.goog"

  gcp_resource_labels = {
    environment = var.name
  }
}
