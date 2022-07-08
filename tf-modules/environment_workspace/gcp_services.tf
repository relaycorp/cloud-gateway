resource "google_project_service" "serviceusage" {
  project                    = google_project.main.id
  service                    = "serviceusage.googleapis.com"
  disable_dependent_services = true
}

resource "google_project_service" "cloudbilling" {
  project                    = google_project.main.id
  service                    = "cloudbilling.googleapis.com"
  disable_dependent_services = true
}

resource "google_project_service" "cloudresourcemanager" {
  project                    = google_project.main.id
  service                    = "cloudresourcemanager.googleapis.com"
  disable_dependent_services = true
}

resource "google_project_service" "logging" {
  project                    = google_project.main.id
  service                    = "logging.googleapis.com"
  disable_dependent_services = true
}

resource "google_project_service" "compute" {
  project                    = google_project.main.id
  service                    = "compute.googleapis.com"
  disable_dependent_services = true
}

resource "google_project_service" "container" {
  project                    = google_project.main.id
  service                    = "container.googleapis.com"
  disable_dependent_services = true
}

resource "google_project_service" "cloudkms" {
  project                    = google_project.main.id
  service                    = "cloudkms.googleapis.com"
  disable_dependent_services = true
}

resource "google_project_service" "servicenetworking" {
  project                    = google_project.main.id
  service                    = "servicenetworking.googleapis.com"
  disable_dependent_services = true
}

resource "google_project_service" "sqladmin" {
  project                    = google_project.main.id
  service                    = "sqladmin.googleapis.com"
  disable_dependent_services = true
}

resource "google_project_service" "secretmanager" {
  project                    = google_project.main.id
  service                    = "secretmanager.googleapis.com"
  disable_dependent_services = true
}

resource "google_project_service" "cloudbuild" {
  project                    = google_project.main.id
  service                    = "cloudbuild.googleapis.com"
  disable_dependent_services = true
}

resource "google_project_service" "dns" {
  project                    = google_project.main.id
  service                    = "dns.googleapis.com"
  disable_dependent_services = true
}
