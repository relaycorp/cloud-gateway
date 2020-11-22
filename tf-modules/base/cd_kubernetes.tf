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
  }

  tags = [var.environment_name]

  provider = google-beta
}
