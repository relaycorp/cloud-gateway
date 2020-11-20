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
  length = 32
}

resource "kubernetes_secret" "stan_cd" {
  metadata {
    name = "stan-cd"
  }

  data = {
    postgresql_user_password = google_sql_user.postgresql_stan.password
  }
}
