resource "google_compute_network" "main" {
  name = "gateway"
}

resource "google_compute_global_address" "managed_tls_cert" {
  name = "gateway"

  labels = local.gcp_resource_labels

  provider = google-beta
}

resource "google_compute_firewall" "neg_backend_workaround" {
  // Workaround for https://github.com/kubernetes/ingress-gce/issues/18#issuecomment-658765449
  name    = "gateway-neg-backend-workaround"
  network = google_compute_network.main.name

  allow {
    protocol = "tcp"
    ports    = ["8082"]
  }

  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
}
