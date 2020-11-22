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

// Continuous Deployment

resource "codefresh_pipeline" "nats" {
  lifecycle {
    ignore_changes = [
      revision,

      // See: https://github.com/codefresh-io/terraform-provider-codefresh/issues/21
      project_id
    ]
  }

  name = "${var.cf_project_name}/${var.environment_name}: NATS"

  tags = [
    "gateway",
    "env-${var.environment_name}",
    "service-nats"
  ]

  spec {
    concurrency = 1
    priority    = 5

    trigger {
      context     = "github"
      description = "Trigger for commits"
      disabled    = false
      events = [
        "push.heads"
      ]
      modified_files_glob = "**/nats.yml"
      name                = "commits"
      provider            = "github"
      repo                = "relaycorp/cloud-gateway"
      branch_regex        = "/^main$/"
      type                = "git"
    }

    variables = {
      KUBERNETES_CONTEXT = var.cf_kubernetes_context
    }

    spec_template {
      repo     = "relaycorp/cloud-gateway"
      path     = "./cf-pipelines/nats.yml"
      revision = "main"
      context  = "github"
    }
  }
}

resource "codefresh_pipeline" "stan" {
  lifecycle {
    ignore_changes = [
      revision,

      // See: https://github.com/codefresh-io/terraform-provider-codefresh/issues/21
      project_id
    ]
  }

  name = "${var.cf_project_name}/${var.environment_name}: NAST Streaming"

  tags = [
    "gateway",
    "env-${var.environment_name}",
    "service-stan"
  ]

  spec {
    concurrency = 1
    priority    = 5

    trigger {
      context     = "github"
      description = "Trigger for commits"
      disabled    = false
      events = [
        "push.heads"
      ]
      modified_files_glob = "**/stan.yml"
      name                = "commits"
      provider            = "github"
      repo                = "relaycorp/cloud-gateway"
      branch_regex        = "/^main$/"
      type                = "git"
    }

    variables = {
      KUBERNETES_CONTEXT = var.cf_kubernetes_context

      DB_HOST = google_sql_database_instance.postgresql.private_ip_address
      DB_NAME = google_sql_database.postgresql_stan.name
      DB_USER = google_sql_user.postgresql_stan.name

      DB_PASSWORD_SECRET_ID      = module.cf_stan_db_password.secret_id
      DB_PASSWORD_SECRET_VERSION = module.cf_stan_db_password.secret_version
    }

    spec_template {
      repo     = "relaycorp/cloud-gateway"
      path     = "./cf-pipelines/stan.yml"
      revision = "main"
      context  = "github"
    }
  }
}

module "stan_db_password" {
  source = "../cd_secret"

  secret_id                      = "${local.env_full_name}-stan-db-password"
  secret_value                   = google_sql_user.postgresql_stan.password
  accessor_service_account_email = local.gcb_service_account_email
  gcp_labels                     = local.gcp_resource_labels
}

module "cf_stan_db_password" {
  source = "../cd_secret"

  secret_id                      = "cf-${local.env_full_name}-stan-db-password"
  secret_value                   = google_sql_user.postgresql_stan.password
  accessor_service_account_email = var.codefresh.service_account_email
  gcp_labels                     = local.gcp_resource_labels
}
