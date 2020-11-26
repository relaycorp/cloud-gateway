locals {
  mongodb_db_name = "main"
}

resource "mongodbatlas_network_peering" "main" {
  project_id = var.mongodb_atlas_project_id

  atlas_cidr_block = "192.168.0.0/16"

  container_id   = mongodbatlas_cluster.main.container_id
  provider_name  = "GCP"
  gcp_project_id = var.gcp_project_id
  network_name   = google_compute_network.main.name
}

resource "mongodbatlas_project_ip_whitelist" "main" {
  project_id = var.mongodb_atlas_project_id
  cidr_block = "192.168.0.0/16"
  comment    = "Peering from network ${google_compute_network.main.name}"
}

resource "mongodbatlas_cluster" "main" {
  project_id = var.mongodb_atlas_project_id

  name       = local.env_full_name
  num_shards = 1

  replication_factor           = 3
  provider_backup_enabled      = true
  auto_scaling_disk_gb_enabled = true
  mongo_db_major_version       = "4.2"

  provider_name               = "GCP"
  disk_size_gb                = 10
  provider_instance_size_name = "M10"
  provider_region_name        = "EUROPE_WEST_2"
}

resource "mongodbatlas_database_user" "main" {
  project_id = var.mongodb_atlas_project_id

  username           = local.env_full_name
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

  secret_id                      = "${local.env_full_name}-mongodb-connection-uri"
  secret_value                   = random_password.mongodb_user_password.result
  accessor_service_account_email = local.gcb_service_account_email
  gcp_labels                     = local.gcp_resource_labels
}
