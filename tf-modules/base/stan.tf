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
    }

    spec_template {
      repo     = "relaycorp/cloud-gateway"
      path     = "./cf-pipelines/stan.yml"
      revision = "main"
      context  = "github"
    }
  }
}

//resource "kubernetes_secret" "stan_cd" {
//  metadata {
//    name = "stan-cd"
//  }
//
//  data = {
//    postgresql_user_password = google_sql_user.postgresql_stan.password
//  }
//}
