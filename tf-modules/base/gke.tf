resource "google_container_cluster" "main" {
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

  network = google_compute_network.main.self_link

  location = var.gcp_region

  provider = google-beta
}

resource "google_container_node_pool" "main" {
  name       = local.env_full_name
  location   = google_container_cluster.main.location
  cluster    = google_container_cluster.main.name
  node_count = 2

  version = google_container_cluster.main.master_version

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

resource "google_project_iam_custom_role" "gke_limited_admin" {
  project = var.gcp_project_id

  role_id = "${replace(local.env_full_name, "-", "_")}.gke_limited_admin"
  title   = "Limited permissions to manage the GKE cluster"
  permissions = [
    "container.mutatingWebhookConfigurations.create",
    "container.mutatingWebhookConfigurations.get",
    "container.mutatingWebhookConfigurations.list",
    "container.mutatingWebhookConfigurations.update",
    "container.mutatingWebhookConfigurations.delete",
    "container.clusterRoles.create",
    "container.clusterRoles.delete",
    "container.clusterRoleBindings.delete",
    "container.roleBindings.delete",
    "container.roles.delete",
  ]
}

resource "google_project_iam_binding" "gke_limited_admin" {
  role = google_project_iam_custom_role.gke_limited_admin.id

  members = [
    var.sre_iam_uri, # TODO: REMOVE
    "serviceAccount:${local.gcb_service_account_email}"
  ]

  # TODO: Limit to a single GKE cluster
}
