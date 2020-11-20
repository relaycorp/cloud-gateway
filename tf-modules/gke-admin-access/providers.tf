# Retrieve an access token as the Terraform runner
data "google_client_config" "provider" {}

provider "kubernetes" {
  load_config_file = false

  host  = "https://${var.gke_cluster_endpoint}"
  token = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(var.gke_cluster_ca_certificate)
}
