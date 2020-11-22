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
      id         = "stan-db-password-retrieval"
      name       = "gcr.io/google.com/cloudsdktool/cloud-sdk"
      entrypoint = "bash"
      args = [
        "-c",
        "gcloud secrets versions access '${module.stan_db_password.secret_version}' --secret=${module.stan_db_password.secret_id} > /tmp/stan-db-secret"
      ]
    }

    step {
      wait_for = ["stan-db-password-retrieval"]
      name     = "gcr.io/$PROJECT_ID/helmfile"
      args     = ["--file", "charts/helmfile.yml", "sync"]
      env = [
        "CLOUDSDK_COMPUTE_REGION=${var.gcp_region}",
        "CLOUDSDK_CONTAINER_CLUSTER=${google_container_cluster.main.name}",

        "STAN_DB_HOST=${google_sql_database_instance.postgresql.private_ip_address}",
        "STAN_DB_NAME=${google_sql_database.postgresql_stan.name}",
        "STAN_DB_USER=${google_sql_user.postgresql_stan.name}",
      ]
    }

    logs_bucket = "gs://${google_storage_bucket.gcb_build_logs.name}/main"
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
