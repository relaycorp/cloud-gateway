locals {
  mongodb_db_name = "main"
}

# Create one Atlas project per environment due to a limitation in GCP/Atlas peering connections
# which would prevent us from creating a second connection to the same Atlas project (all the
# clusters in the same Atlas project share the same GCP VPC, so trying to connect a second
# GCP VPC will fail because routes will clash).
resource "mongodbatlas_project" "main" {
  name   = "gateway-${var.name}"
  org_id = var.mongodb_atlas_org_id
}

resource "mongodbatlas_network_peering" "main" {
  project_id = mongodbatlas_project.main.id

  container_id     = mongodbatlas_cluster.main.container_id
  atlas_cidr_block = "192.168.0.0/16"

  provider_name  = "GCP"
  gcp_project_id = var.gcp_project_id
  network_name   = google_compute_network.main.name
}

resource "google_compute_network_peering" "mongodb_atlas" {
  name         = "gateway-mongodb-atlas"
  network      = google_compute_network.main.self_link
  peer_network = "https://www.googleapis.com/compute/v1/projects/${mongodbatlas_network_peering.main.atlas_gcp_project_id}/global/networks/${mongodbatlas_network_peering.main.atlas_vpc_name}"
}

resource "mongodbatlas_project_ip_whitelist" "gcp_vpc" {
  project_id = mongodbatlas_project.main.id
  cidr_block = "10.0.0.0/8"
  comment    = "Allow connections from GCP VPCs"
}

resource "mongodbatlas_cluster" "main" {
  project_id = mongodbatlas_project.main.id

  name       = "gateway"
  num_shards = 1

  replication_factor           = 3
  provider_backup_enabled      = true
  auto_scaling_disk_gb_enabled = true
  mongo_db_major_version       = "4.2"

  provider_name               = "GCP"
  disk_size_gb                = 10
  provider_instance_size_name = "M10"
  provider_region_name        = var.mongodb_atlas_region
}

resource "mongodbatlas_database_user" "main" {
  project_id = mongodbatlas_project.main.id

  username           = "gateway"
  password           = random_password.mongodb_user_password.result
  auth_database_name = "admin"

  roles {
    role_name     = "readWrite"
    database_name = local.mongodb_db_name
  }
}

resource "random_password" "mongodb_user_password" {
  length = 32
}

module "mongodb_password" {
  source = "../cd_secret"

  secret_id                      = "gateway-mongodb-connection-uri"
  secret_value                   = random_password.mongodb_user_password.result
  accessor_service_account_email = local.gcb_service_account_email
  gcp_labels                     = local.gcp_resource_labels
}
