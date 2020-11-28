resource "mongodbatlas_project_ip_whitelist" "gcp_vpc" {
  project_id = var.mongodb_atlas_project_id
  cidr_block = "10.128.0.0/9" # https://cloud.google.com/vpc/docs/vpc#ip-ranges
  comment    = "Allow connections from GCP VPCs"
}
