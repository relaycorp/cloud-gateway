resource "mongodbatlas_project_ip_whitelist" "gcp_vpc" {
  project_id = var.mongodb_atlas_project_id
  cidr_block = "10.0.0.0/8"
  comment    = "Allow connections from GCP VPCs"
}
