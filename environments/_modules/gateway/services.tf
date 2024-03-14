locals {
  services = [
    "run.googleapis.com",
    "compute.googleapis.com",
    "cloudkms.googleapis.com",
    "pubsub.googleapis.com",
    "secretmanager.googleapis.com",
    "iam.googleapis.com",
    "cloudscheduler.googleapis.com",
    "servicenetworking.googleapis.com",
    "redis.googleapis.com",
    "monitoring.googleapis.com",
    "billingbudgets.googleapis.com",
  ]
}

resource "google_project_service" "services" {
  for_each = toset(local.services)

  project                    = var.gcp_project_id
  service                    = each.value
  disable_dependent_services = true
}

resource "time_sleep" "wait_for_services" {
  depends_on      = [google_project_service.services]
  create_duration = "30s"
}
