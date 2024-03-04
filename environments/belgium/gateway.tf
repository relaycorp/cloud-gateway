module "gateway" {
  source = "../_modules/gateway"

  docker_image_tag = "5.1.2"

  instance_name = "belgium"

  gcp_project_id = var.gcp_project_id
  gcp_region     = "europe-west1"

  mongodbatlas_project_id = var.mongodbatlas_project_id
  mongodbatlas_region     = "WESTERN_EUROPE"

  alert_email_addresses = var.alert_email_addresses
  sre_iam_uri           = var.sre_iam_uri

  gcp_shared_infra_project_id = var.shared_infra_gcp_project_id
}
