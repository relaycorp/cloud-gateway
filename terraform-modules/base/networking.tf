data "google_compute_network" "main" {
  name = "default"
}

resource "google_compute_global_address" "managed_tls_cert" {
  name = "gateway-${var.environment_name}-managed-cert"
}

resource "google_compute_network_peering" "mongodb_atlas" {
  name         = "mongodb-atlas-peering"
  network      = data.google_compute_network.main.self_link
  peer_network = "https://www.googleapis.com/compute/v1/projects/${mongodbatlas_network_peering.main.atlas_gcp_project_id}/global/networks/${mongodbatlas_network_peering.main.atlas_vpc_name}"
}

resource "google_compute_firewall" "neg_backend_workaround" {
  // Workaround for https://github.com/kubernetes/ingress-gce/issues/18#issuecomment-658765449
  name    = "neg-backend-workaround"
  network = data.google_compute_network.main.name

  allow {
    protocol = "tcp"
    ports    = ["8082"]
  }

  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
}
