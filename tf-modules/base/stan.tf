resource "google_sql_database" "postgresql_stan" {
  name     = "stan"
  instance = google_sql_database_instance.postgresql.name
}

resource "google_sql_user" "postgresql_stan_runtime" {
  name     = "stan"
  instance = google_sql_database_instance.postgresql.name
  password = random_password.postgresql_stan_runtime.result
}
// TODO: Use service accounts instead (https://github.com/relaycorp/cloud-gateway/issues/6)
resource "random_password" "postgresql_stan_runtime" {
  length = 32
}

resource "google_sql_user" "postgresql_stan_initdb" {
  name     = "stan-initdb"
  instance = google_sql_database_instance.postgresql.name
  password = random_password.postgresql_stan_initdb.result
}
// TODO: Use service accounts instead (https://github.com/relaycorp/cloud-gateway/issues/6)
resource "random_password" "postgresql_stan_initdb" {
  length = 32
}

resource "kubernetes_secret" "stan_cd" {
  metadata {
    name = "stan-cd"
  }

  data = {
    postgresql_runtime_user_password = google_sql_user.postgresql_stan_runtime.password
    postgresql_initdb_user_password  = google_sql_user.postgresql_stan_initdb.password
  }
}
