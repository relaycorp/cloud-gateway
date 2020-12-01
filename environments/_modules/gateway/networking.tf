resource "google_compute_network" "main" {
  name = local.env_full_name
}

resource "google_compute_global_address" "managed_tls_cert" {
  name = local.env_full_name
}

resource "google_compute_firewall" "neg_backend_workaround" {
  // Workaround for https://github.com/kubernetes/ingress-gce/issues/18#issuecomment-658765449
  name    = "${local.env_full_name}-neg-backend-workaround"
  network = google_compute_network.main.name

  allow {
    protocol = "tcp"
    ports    = ["8082"]
  }

  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
}
