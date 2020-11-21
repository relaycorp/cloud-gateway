resource "codefresh_project" "gateway" {
  name = "cloud-gateway"

  variables = {
    GCP_PROJECT_ID   = var.gcp_project_id,
    KEYBASE_USERNAME = "gnarea",
  }
}

resource "google_service_account" "codefresh" {
  project    = var.gcp_project_id
  account_id = "codefresh"
}

resource "google_service_account_key" "codefresh" {
  service_account_id = google_service_account.codefresh.name
}
