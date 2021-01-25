resource "random_id" "gateway_key_id" {
  byte_length = 12
}

resource "google_service_account" "gateway" {
  project = var.gcp_project_id

  account_id   = "${local.env_full_name}-app"
  display_name = "GCP SA bound to K8S SA ${local.gateway.k8s.serviceAccount}"
}

resource "google_service_account_iam_member" "gateway_workload_identity" {
  service_account_id = google_service_account.gateway.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${local.workload_identity_pool}[${local.gateway.k8s.namespace}/${local.gateway.k8s.serviceAccount}]"

  depends_on = [google_container_cluster.main]
}
