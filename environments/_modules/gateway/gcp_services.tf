resource "google_project_service" "serviceusage" {
  project                    = data.google_project.main.id
  service                    = "serviceusage.googleapis.com"
  disable_dependent_services = true
}

resource "google_project_service" "cloudresourcemanager" {
  project                    = data.google_project.main.id
  service                    = "cloudresourcemanager.googleapis.com"
  disable_dependent_services = true
}

resource "google_project_service" "logging" {
  project                    = data.google_project.main.id
  service                    = "logging.googleapis.com"
  disable_dependent_services = true
}

resource "google_project_service" "compute" {
  project                    = data.google_project.main.id
  service                    = "compute.googleapis.com"
  disable_dependent_services = true
}

resource "google_project_service" "container" {
  project                    = data.google_project.main.id
  service                    = "container.googleapis.com"
  disable_dependent_services = true
}

resource "google_project_service" "cloudkms" {
  project                    = data.google_project.main.id
  service                    = "cloudkms.googleapis.com"
  disable_dependent_services = true
}

resource "google_project_service" "servicenetworking" {
  project                    = data.google_project.main.id
  service                    = "servicenetworking.googleapis.com"
  disable_dependent_services = true
}

resource "google_project_service" "sqladmin" {
  project                    = data.google_project.main.id
  service                    = "sqladmin.googleapis.com"
  disable_dependent_services = true
}

resource "google_project_service" "secretmanager" {
  project                    = data.google_project.main.id
  service                    = "secretmanager.googleapis.com"
  disable_dependent_services = true
}

resource "google_project_service" "cloudbuild" {
  project                    = data.google_project.main.id
  service                    = "cloudbuild.googleapis.com"
  disable_dependent_services = true
}

resource "google_project_service" "dns" {
  project                    = data.google_project.main.id
  service                    = "dns.googleapis.com"
  disable_dependent_services = true
}
