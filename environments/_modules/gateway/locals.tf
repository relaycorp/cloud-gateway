locals {
  env_full_name = "gateway-${var.name}"

  gcp_resource_labels = {
    environment = var.name
  }
}
