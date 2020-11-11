resource "codefresh_project" "gateway" {
  name = "cloud-gateway"

  variables = {
    GCP_PROJECT_ID   = var.gcp_project_id,
    KEYBASE_USERNAME = "gnarea",
  }
}
