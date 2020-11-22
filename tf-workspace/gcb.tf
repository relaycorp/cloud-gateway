locals {
  gcb_service_account_email = "${data.google_project.main.number}@cloudbuild.gserviceaccount.com"

  gcb_community_builders_repo     = "https://github.com/GoogleCloudPlatform/cloud-builders-community.git"
  gcb_community_builders_revision = "82588e81d18a0f2bd6fd1177257875d0601a542e"
}

resource "google_project_iam_member" "gcb_gke_developer" {
  role   = "roles/container.developer"
  member = "serviceAccount:${local.gcb_service_account_email}"
}

resource "google_cloudbuild_trigger" "gcb_builder_helmfile" {
  name = "gcb-builder-helmfile"

  # This is just a hack to be able to trigger the build manually
  github {
    owner = "relaycorp"
    name  = "cloud-gateway"
    push {
      branch = "^main$"
    }
  }
  ignored_files = ["**"]

  build {
    step {
      name = "gcr.io/cloud-builders/git"
      id   = "clone"
      args = ["clone", local.gcb_community_builders_repo]
    }

    step {
      name = "gcr.io/cloud-builders/git"
      id   = "checkout"
      args = ["reset", "--hard", "$${_GIT_REVISION}"]

      wait_for = ["clone"]
    }

    step {
      name       = "gcr.io/google.com/cloudsdktool/cloud-sdk"
      wait_for   = ["checkout"]
      entrypoint = "bash"
      args = [
        "-o",
        "nounset",
        "-o",
        "errexit",
        "-o",
        "pipefail",
        "-c",
        "cd cloud-builders-community/helmfile && gcloud builds submit .",
      ]
    }

    logs_bucket = "gs://${google_storage_bucket.gcb_builder_logs.name}/helmfile"
  }

  substitutions = {
    _GIT_REVISION = local.gcb_community_builders_revision
  }

  provider = google-beta
}

resource "google_storage_bucket" "gcb_builder_logs" {
  name          = "relaycorp-gcb-builder-logs"
  storage_class = "REGIONAL"
  location      = "europe-west2"

  uniform_bucket_level_access = true

  versioning {
    enabled = false
  }

  labels = {
    stage : "deployment"
  }
}

resource "google_storage_bucket_iam_member" "gcb_builder_logs" {
  bucket = google_storage_bucket.gcb_builder_logs.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${local.gcb_service_account_email}"
}
