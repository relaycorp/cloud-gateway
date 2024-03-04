// TODO: Remove once the security audit is over

variable "temporary_auditor_iam_uris" {
  type = list(string)
}

resource "google_project_iam_member" "auditors_iam" {
  for_each = toset(var.temporary_auditor_iam_uris)

  project = var.gcp_project_id
  role    = "roles/iam.roleViewer"
  member  = each.value
}

resource "google_project_iam_member" "auditors_kms" {
  for_each = toset(var.temporary_auditor_iam_uris)

  project = var.gcp_project_id
  role    = "roles/cloudkms.viewer"
  member  = each.value
}

resource "google_project_iam_member" "auditors_run" {
  for_each = toset(var.temporary_auditor_iam_uris)

  project = var.gcp_project_id
  role    = "roles/run.viewer"
  member  = each.value
}

resource "google_project_iam_member" "auditors_scheduler" {
  for_each = toset(var.temporary_auditor_iam_uris)

  project = var.gcp_project_id
  role    = "roles/cloudscheduler.viewer"
  member  = each.value
}

resource "google_project_iam_member" "auditors_redis" {
  for_each = toset(var.temporary_auditor_iam_uris)

  project = var.gcp_project_id
  role    = "roles/redis.viewer"
  member  = each.value
}

resource "google_project_iam_member" "auditors_pubsub" {
  for_each = toset(var.temporary_auditor_iam_uris)

  project = var.gcp_project_id
  role    = "roles/pubsub.viewer"
  member  = each.value
}

resource "google_project_iam_member" "auditors_network" {
  for_each = toset(var.temporary_auditor_iam_uris)

  project = var.gcp_project_id
  role    = "roles/compute.networkViewer"
  member  = each.value
}

resource "google_project_iam_member" "auditors_secret_manager" {
  for_each = toset(var.temporary_auditor_iam_uris)

  project = var.gcp_project_id
  role    = "roles/secretmanager.viewer"
  member  = each.value
}

resource "google_project_iam_custom_role" "auditor_additional_perms" {
  project = var.gcp_project_id
  role_id = "tmp_auditor"
  title   = "Security auditor"
  permissions = [
    "iam.serviceAccounts.list",
  ]
}

resource "google_project_iam_member" "auditor_additional_perms" {
  // repeat for each auditor_uris
  for_each = toset(var.temporary_auditor_iam_uris)

  project = var.gcp_project_id
  role    = google_project_iam_custom_role.auditor_additional_perms.name
  member  = each.value
}
