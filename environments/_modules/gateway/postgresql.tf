# PostgreSQL instance used by NATS Streaming (aka Stan)

resource "google_compute_global_address" "postgresql" {
  provider = google-beta
  project  = var.gcp_project_id

  name         = "${local.env_full_name}-postgresql"
  purpose      = "VPC_PEERING"
  address_type = "INTERNAL"
  network      = google_compute_network.main.id

  # Set the address explicitly to avoid non-deterministic behaviour.
  address       = "10.101.0.0"
  prefix_length = 16 # TODO: Reduce to 24
}

resource "google_service_networking_connection" "postgresql" {
  provider = google-beta

  network                 = google_compute_network.main.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.postgresql.name]
}

resource "random_id" "postgresql_instance_suffix" {
  byte_length = 3
}

resource "google_sql_database_instance" "postgresql" {
  name             = "${local.env_full_name}-${random_id.postgresql_instance_suffix.hex}"
  database_version = "POSTGRES_12"
  region           = var.gcp_region

  settings {
    tier              = "db-f1-micro"
    availability_type = "REGIONAL"
    backup_configuration {
      enabled    = true
      start_time = "07:30" # Should be shortly before maintenance
    }
    maintenance_window {
      # Optimise for London, in case anything goes awry.
      day  = 1 # Monday
      hour = 8 # Should be shortly after daily backup
    }
    ip_configuration {
      ipv4_enabled    = false
      private_network = google_compute_network.main.self_link
      require_ssl     = false # Don't require client-side certificates
    }

    user_labels = local.gcp_resource_labels
  }

  depends_on = [google_service_networking_connection.postgresql]

  provider = google-beta
}
