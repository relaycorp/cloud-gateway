resource "mongodbatlas_network_container" "main" {
  project_id       = var.mongodb_atlas_project_id
  atlas_cidr_block = "192.168.0.0/16"
  provider_name    = "GCP"
}

resource "mongodbatlas_project_ip_whitelist" "gcp_vpc" {
  project_id = var.mongodb_atlas_project_id
  cidr_block = "10.0.0.0/8"
  comment    = "Allow connections from GCP VPCs"
}
