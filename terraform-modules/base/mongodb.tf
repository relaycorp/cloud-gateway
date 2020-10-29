provider "mongodbatlas" {
  version = "~> 0.6"
}

resource "mongodbatlas_project" "main" {
  name   = var.environment_name
  org_id = var.mongodb_atlas_org_id
}

resource "mongodbatlas_network_peering" "main" {
  project_id       = mongodbatlas_project.main.id
  atlas_cidr_block = "192.168.0.0/16"

  container_id   = mongodbatlas_cluster.main.container_id
  provider_name  = "GCP"
  gcp_project_id = var.gcp_project_id
  network_name   = data.google_compute_network.main.name
}

resource "mongodbatlas_project_ip_whitelist" "main" {
  project_id = mongodbatlas_project.main.id
  cidr_block = "192.168.0.0/16"
  comment    = "Peering from network ${data.google_compute_network.main.name}"
}

resource "mongodbatlas_cluster" "main" {
  project_id = mongodbatlas_project.main.id
  name       = "main"
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
  username           = "gw"
  password           = var.mongodb_user_password
  project_id         = mongodbatlas_project.main.id
  auth_database_name = "admin"

  roles {
    role_name     = "readWrite"
    database_name = var.mongodb_db_name
  }
}
