resource "google_sql_database" "postgresql_stan" {
  name     = "stan"
  instance = google_sql_database_instance.postgresql.name
}

resource "google_sql_user" "postgresql_stan" {
  name     = "stan"
  instance = google_sql_database_instance.postgresql.name
  password = random_password.postgresql_stan.result
}
// TODO: Use service accounts instead (https://github.com/relaycorp/cloud-gateway/issues/6)
resource "random_password" "postgresql_stan" {
  length  = 32
  special = false
}

module "stan_db_password" {
  source = "../cd_secret"

  secret_id                      = "gateway-stan-db-password"
  secret_value                   = google_sql_user.postgresql_stan.password
  accessor_service_account_email = local.gcb_service_account_email
  gcp_labels                     = local.gcp_resource_labels
}
