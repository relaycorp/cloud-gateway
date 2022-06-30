data "google_project" "main" {
}

resource "google_project_iam_member" "project_viewer" {
  role   = "roles/viewer"
  member = var.sre_iam_uri
}

resource "google_project_service" "logging" {
  project                    = var.gcp_project_id
  service                    = "logging.googleapis.com"
  disable_dependent_services = true
}

resource "google_project_service" "compute" {
  project                    = var.gcp_project_id
  service                    = "compute.googleapis.com"
  disable_dependent_services = true
}

resource "google_project_service" "container" {
  project                    = var.gcp_project_id
  service                    = "container.googleapis.com"
  disable_dependent_services = true
}

resource "google_project_service" "cloudkms" {
  project                    = var.gcp_project_id
  service                    = "cloudkms.googleapis.com"
  disable_dependent_services = true
}

resource "google_project_service" "servicenetworking" {
  project                    = var.gcp_project_id
  service                    = "servicenetworking.googleapis.com"
  disable_dependent_services = true
}

resource "google_project_service" "sqladmin" {
  project                    = var.gcp_project_id
  service                    = "sqladmin.googleapis.com"
  disable_dependent_services = true
}

resource "google_project_service" "secretmanager" {
  project                    = var.gcp_project_id
  service                    = "secretmanager.googleapis.com"
  disable_dependent_services = true
}

resource "google_project_service" "cloudbuild" {
  project                    = var.gcp_project_id
  service                    = "cloudbuild.googleapis.com"
  disable_dependent_services = true
}

resource "google_project_service" "dns" {
  project                    = var.gcp_project_id
  service                    = "dns.googleapis.com"
  disable_dependent_services = true
}

resource "google_project_service" "appengine" {
  project                    = var.gcp_project_id
  service                    = "appengine.googleapis.com"
  disable_dependent_services = true
}

resource "google_project_service" "datastore" {
  project                    = var.gcp_project_id
  service                    = "datastore.googleapis.com"
  disable_dependent_services = true
}
