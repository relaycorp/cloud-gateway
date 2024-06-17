module "gateway" {
  source  = "relaycorp/awala-gateway/google"
  version = "1.6.29"

  project_id = var.gcp_project_id
  region     = var.gcp_region

  docker_image_tag = var.docker_image_tag

  sre_iam_uri = var.sre_iam_uri

  instance_name    = var.instance_name
  internet_address = "${var.instance_name}.${data.google_dns_managed_zone.main.dns_name}"

  // See https://github.com/relaycorp/cloud-gateway/issues/64
  parcel_retention_days = 2

  pohttp_server_domain = google_dns_record_set.pohttp.name

  poweb_server_domain = google_dns_record_set.poweb.name

  cogrpc_server_domain             = google_dns_record_set.cogrpc.name
  cogrpc_server_min_instance_count = 0 # https://github.com/relaycorp/cloud-gateway/issues/96
  cogrpc_server_max_instance_count = 1

  mongodb_db       = local.gateway_db_name
  mongodb_password = random_password.mongodb_gateway_user_password.result
  mongodb_uri      = local.mongodb_uri
  mongodb_user     = mongodbatlas_database_user.gateway.username

  kms_protection_level = "HSM"

  depends_on = [time_sleep.wait_for_services]
}
