resource "google_app_engine_application" "main" {
  // We don't actually use App Engine but this is the only way to enable Firebase Datastore
  project       = var.gcp_project_id
  location_id   = "europe-west3" // TODO: This should be environment-specific
  database_type = "CLOUD_DATASTORE_COMPATIBILITY"

  depends_on = [google_project_service.appengine]
}
