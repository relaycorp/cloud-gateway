locals {
  gcb_service_account_email = "${data.google_project.main.number}@cloudbuild.gserviceaccount.com"

  gcb_gcloud_image = "gcr.io/google.com/cloudsdktool/cloud-sdk:319.0.0-slim"

  gcb = {
    secret_retrieval_env = [
      "STAN_DB_PASSWORD_SECRET_VERSION=${module.stan_db_password.secret_version}",

      "GW_MONGODB_PASSWORD_SECRET_VERSION=${module.mongodb_password.secret_version}",
    ]

    helmfile_env = [
      "CLOUDSDK_CORE_PROJECT=${var.gcp_project_id}",
      "CLOUDSDK_COMPUTE_REGION=${var.gcp_region}",

      "ENVIRONMENT_NAME=${var.name}",

      "STAN_DB_HOST=${google_sql_database_instance.postgresql.private_ip_address}",
      "STAN_DB_NAME=${google_sql_database.postgresql_stan.name}",
      "STAN_DB_USER=${google_sql_user.postgresql_stan.name}",

      "GW_PUBLIC_ADDRESS=${local.gateway.public_address}",
      "GW_KEY_ID_B64=${random_id.gateway_key_id.b64_std}",
      "GW_MONGODB_CONNECTION_URI=${lookup(mongodbatlas_cluster.main.connection_strings[0], "private_srv")}",
      "GW_MONGODB_DB_NAME=${local.mongodb_db_name}",
      "GW_MONGODB_USER_NAME=${mongodbatlas_database_user.main.username}",
      "GW_MONGODB_PASSWORD_SECRET_VERSION=${module.mongodb_password.secret_version}",
      "GW_POWEB_DOMAIN=${trimsuffix(google_dns_record_set.poweb.name, ".")}",
      "GW_POHTTP_DOMAIN=${trimsuffix(google_dns_record_set.pohttp.name, ".")}",
      "GW_COGRPC_DOMAIN=${trimsuffix(google_dns_record_set.cogrpc.name, ".")}",
      "GW_GLOBAL_IP_NAME=${google_compute_global_address.managed_tls_cert.name}",
      "GW_MANAGED_CERT_NAME=${local.env_full_name}",
      "GW_GCP_SERVICE_ACCOUNT=${google_service_account.gateway.email}",
      "GW_MESSAGES_BUCKET=${google_storage_bucket.gateway_messages.name}",
      "GW_KS_KEYRING=${google_kms_key_ring.keystores.name}",
      "GW_KS_ID_KEY=${google_kms_crypto_key.awala_identity_keys.name}",
      "GW_KS_SESSION_ENC_KEY=${google_kms_crypto_key.awala_session_keys.name}",
    ]
  }
}

resource "google_project_iam_member" "gcb_editor" {
  // Grants SREs permission to start and cancel builds
  project = var.gcp_project_id
  role    = "roles/cloudbuild.builds.editor"
  member  = var.sre_iam_uri
}

resource "google_cloudbuild_trigger" "gke_deployment" {
  name        = "${local.env_full_name}-gke-deployment"
  description = "Deploy and configure Kubernetes resources in environment ${var.name}"

  github {
    owner = var.github_repo.organisation
    name  = var.github_repo.name
    push {
      branch = "^${var.github_repo.branch}$"
    }
  }

  included_files = ["charts/**"]
  ignored_files  = var.type == "production" ? ["charts/values-testing.yml"] : []

  build {
    step {
      id = "cluster-credentials-retrieval"

      name = local.gcb_gcloud_image
      args = [
        "gcloud",
        "container",
        "clusters",
        "get-credentials",
        google_container_cluster.main.name,
      ]
      env = [
        "CLOUDSDK_CORE_PROJECT=${var.gcp_project_id}",
        "CLOUDSDK_COMPUTE_REGION=${var.gcp_region}",
      ]
    }

    step {
      id       = "secrets-retrieval"
      wait_for = ["cluster-credentials-retrieval"]

      name       = local.gcb_gcloud_image
      entrypoint = "bash"
      args       = ["charts/scripts/retrieve-secrets.sh"]
      env        = local.gcb.secret_retrieval_env
    }

    step {
      id       = "helmfile-backing-services-apply"
      wait_for = ["secrets-retrieval"]

      name       = "gcr.io/$PROJECT_ID/helmfile"
      dir        = "charts"
      entrypoint = "scripts/helmfile.sh"
      args       = ["--selector", "tier=backingService", "--environment", var.type, "apply"]
      env        = local.gcb.helmfile_env
    }

    step {
      id       = "helmfile-apply"
      wait_for = ["helmfile-backing-services-apply"]

      name       = "gcr.io/$PROJECT_ID/helmfile"
      dir        = "charts"
      entrypoint = "scripts/helmfile.sh"
      args       = ["--selector", "tier!=backingService", "--environment", var.type, "apply"]
      env        = local.gcb.helmfile_env
    }

    logs_bucket = "gs://${google_storage_bucket.gcb_build_logs.name}/main"
  }

  tags = [var.name]

  provider = google-beta
}

resource "google_cloudbuild_trigger" "gke_deployment_preview" {
  // This trigger should ideally be run with a limited service account. See:
  // https://github.com/relaycorp/cloud-gateway/issues/16

  name        = "${local.env_full_name}-gke-deployment-preview"
  description = "Preview a potential deployment to ${var.name}"

  github {
    owner = var.github_repo.organisation
    name  = var.github_repo.name
    pull_request {
      branch = "^${var.github_repo.branch}$"

      # NEVER, EVER change this. It prevents PRs from external contributors from being triggered
      # automatically.
      comment_control = "COMMENTS_ENABLED_FOR_EXTERNAL_CONTRIBUTORS_ONLY"
    }
  }

  included_files = ["charts/**"]
  ignored_files  = var.type == "production" ? ["charts/values-testing.yml"] : []

  build {
    step {
      id = "cluster-credentials-retrieval"

      name = local.gcb_gcloud_image
      args = [
        "gcloud",
        "container",
        "clusters",
        "get-credentials",
        google_container_cluster.main.name,
      ]
      env = [
        "CLOUDSDK_CORE_PROJECT=${var.gcp_project_id}",
        "CLOUDSDK_COMPUTE_REGION=${var.gcp_region}",
      ]
    }

    step {
      id       = "secrets-retrieval"
      wait_for = ["cluster-credentials-retrieval"]

      name       = local.gcb_gcloud_image
      entrypoint = "bash"
      args       = ["charts/scripts/retrieve-secrets.sh"]
      env        = local.gcb.secret_retrieval_env
    }

    step {
      id       = "helmfile-diff"
      wait_for = ["secrets-retrieval"]

      name       = "gcr.io/$PROJECT_ID/helmfile"
      dir        = "charts"
      entrypoint = "scripts/helmfile.sh"
      args       = ["--environment", var.type, "diff"]
      env        = local.gcb.helmfile_env
    }

    logs_bucket = "gs://${google_storage_bucket.gcb_build_logs.name}/preview"
  }

  tags = [var.name]

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

  force_destroy = !var.prevent_destruction

  labels = local.gcp_resource_labels
}

resource "google_storage_bucket_iam_member" "gcb_build_logs" {
  bucket = google_storage_bucket.gcb_build_logs.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${local.gcb_service_account_email}"
}
