locals {
  mongodb_uri     = "${mongodbatlas_serverless_instance.main.connection_strings_standard_srv}/?retryWrites=true&w=majority"
  gateway_db_name = "awala-gateway"
}

resource "mongodbatlas_serverless_instance" "main" {
  project_id = var.mongodbatlas_project_id
  name       = "gateway"

  provider_settings_backing_provider_name = "GCP"
  provider_settings_provider_name         = "SERVERLESS"
  provider_settings_region_name           = var.mongodbatlas_region
}

resource "mongodbatlas_project_ip_access_list" "main" {
  project_id = var.mongodbatlas_project_id
  comment    = "See https://github.com/relaycorp/cloud-gateway/issues/95"
  cidr_block = "0.0.0.0/0"
}

resource "mongodbatlas_database_user" "gateway" {
  project_id = var.mongodbatlas_project_id

  username           = "awala-gateway"
  password           = random_password.mongodb_gateway_user_password.result
  auth_database_name = "admin"

  roles {
    role_name     = "readWrite"
    database_name = local.gateway_db_name
  }
}

resource "random_password" "mongodb_gateway_user_password" {
  length = 32
}
