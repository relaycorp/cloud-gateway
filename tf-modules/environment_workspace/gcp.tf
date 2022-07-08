resource "random_id" "gcp_project_id_suffix" {
  byte_length = 2
}

resource "google_project" "main" {
  name            = var.name
  project_id      = "gw-${var.name}-${random_id.gcp_project_id_suffix.hex}" // <= 30 chars long
  folder_id       = var.gcp_parent_folder
  billing_account = var.gcp_billing_account
}

resource "google_project_service" "cloudbilling" {
  project                    = google_project.main.project_id
  service                    = "cloudbilling.googleapis.com"
  disable_dependent_services = true
}

resource "google_service_account" "tfe" {
  account_id = "tf-cloud"
  project    = google_project.main.project_id

  depends_on = [google_project_service.cloudbilling]
}

resource "google_project_iam_binding" "tfe_owner" {
  project = google_project.main.project_id
  role    = "roles/owner"
  members = ["serviceAccount:${google_service_account.tfe.email}"]
}

// TODO: Remove
resource "google_project_iam_binding" "old_gcp_project" {
  project = "relaycorp-cloud-gateway"
  role    = "roles/owner"
  members = ["serviceAccount:${google_service_account.tfe.email}"]
}

resource "google_service_account_key" "tfe" {
  service_account_id = google_service_account.tfe.name
}

resource "google_service_account_key" "main" {
  service_account_id = google_service_account.tfe.name
}
