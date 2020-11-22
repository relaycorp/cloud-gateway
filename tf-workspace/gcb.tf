locals {
  gcb_service_account_email   = "${data.google_project.main.number}@cloudbuild.gserviceaccount.com"
  gcb_community_builders_repo = "https://github.com/GoogleCloudPlatform/cloud-builders-community.git"
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
      args = ["clone", local.gcb_community_builders_repo]
    }

    step {
      name       = "gcr.io/google.com/cloudsdktool/cloud-sdk"
      entrypoint = "gcloud"
      args       = ["builds", "submit", "cloud-builders-community/helmfile"]
    }

    logs_bucket = "gs://${google_storage_bucket.gcb_builder_logs.name}/helmfile"
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
