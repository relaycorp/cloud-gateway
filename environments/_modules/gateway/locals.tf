locals {
  env_full_name = "gateway-${var.name}"

  gateway = {
    public_address = "${var.name}.${trimsuffix(data.google_dns_managed_zone.main.dns_name, ".")}"
  }

  gcp_resource_labels = {
    environment = var.name
  }
}
