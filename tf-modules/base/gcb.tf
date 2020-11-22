locals {
  gcb_service_account_email = "${data.google_project.main.number}@cloudbuild.gserviceaccount.com"
}

resource "google_cloudbuild_trigger" "main" {
  name        = "${var.environment_name}-k8s-deployment"
  description = "Deploy and configure Kubernetes resources in environment ${var.environment_name}"

  github {
    owner = var.github_repo.organisation
    name  = var.github_repo.name
    push {
      branch = "^main$"
    }
  }

  included_files = [
    "charts/helmfile.yml",
    "charts/defaults/**",
    "charts/environments/${var.environment_name}/**",
  ]

  build {
    step {
      name = "gcr.io/cloud-builders/git"
      args = ["log", "HEAD^.."]
    }

    logs_bucket = "gs://${google_storage_bucket.gcb_build_logs.name}/main"
  }

  substitutions = {
    _STAN_DB_HOST = google_sql_database_instance.postgresql.private_ip_address
    _STAN_DB_NAME = google_sql_database.postgresql_stan.name
    _STAN_DB_USER = google_sql_user.postgresql_stan.name
  }

  tags = [var.environment_name]

  provider = google-beta
}

resource "google_storage_bucket" "gcb_build_logs" {
  name          = "relaycorp-${local.env_full_name}-gcb-logs"
  storage_class = "REGIONAL"
  location      = upper(var.gcp_region)

  uniform_bucket_level_access = true

  versioning {
    enabled = false
  }

  labels = local.gcp_resource_labels
}

resource "google_storage_bucket_iam_member" "gcb_build_logs" {
  bucket = google_storage_bucket.gcb_build_logs.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${local.gcb_service_account_email}"
}
