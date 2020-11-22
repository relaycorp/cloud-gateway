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
