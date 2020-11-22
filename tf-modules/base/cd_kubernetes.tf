locals {
  gcb_service_account_email = "${data.google_project.main.number}@cloudbuild.gserviceaccount.com"
}

resource "google_project_iam_binding" "gcb_gke_developer" {
  role    = "roles/container.developer"
  members = ["serviceAccount:${local.gcb_service_account_email}"]
}

resource "google_cloudbuild_trigger" "main" {
  github {
    owner = var.github_repo.organisation
    name  = var.github_repo.name
    push {
      branch = "^main$"
    }
  }

  included_files = ["k8s-deployment/helmfile.yml", "charts/**"]

  filename = "../../k8s-deployment/cloudbuild.yml"

  tags = [var.environment_name]

  provider = google-beta
}
