resource "google_project_service" "cloudresourcemanager" {
  project                    = var.gcp_project_id
  service                    = "cloudresourcemanager.googleapis.com"
  disable_dependent_services = true
}

resource "google_project_service" "logging" {
  project                    = var.gcp_project_id
  service                    = "logging.googleapis.com"
  disable_dependent_services = true

  depends_on = [google_project_service.cloudresourcemanager]
}

resource "google_project_service" "compute" {
  project                    = var.gcp_project_id
  service                    = "compute.googleapis.com"
  disable_dependent_services = true

  depends_on = [google_project_service.cloudresourcemanager]
}
