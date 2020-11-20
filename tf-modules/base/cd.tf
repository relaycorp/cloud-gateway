# Retrieve an access token as the Terraform runner
data "google_client_config" "provider" {}

// TODO: REMOVE
provider "kubernetes" {
  load_config_file = false

  host  = "https://${google_container_cluster.primary.endpoint}"
  token = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(
    google_container_cluster.primary.master_auth[0].cluster_ca_certificate,
  )
}
