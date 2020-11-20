resource "google_container_cluster" "primary" {
  name = local.env_full_name

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1

  // Need Kubernetes 1.17.6-gke.7 or newer to get fix for
  // https://github.com/kubernetes/ingress-gce/issues/42
  min_master_version = "1.17.12"
  release_channel {
    channel = "REGULAR"
  }

  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = false
    }
  }

  # Make cluster VPC-native (alias IP) so we can connect to GCP services
  ip_allocation_policy {}

  provider = google-beta
}

resource "google_container_node_pool" "primary" {
  name       = local.env_full_name
  location   = google_container_cluster.primary.location
  cluster    = google_container_cluster.primary.name
  node_count = 5

  version = google_container_cluster.primary.master_version

  node_config {
    machine_type = "n1-standard-1"

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}
