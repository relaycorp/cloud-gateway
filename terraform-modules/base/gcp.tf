provider "google" {
  project = var.gcp_project_id
  region  = "europe-west2"
  zone    = "europe-west2-a"

  version = "~> 3.27"
}

provider "google-beta" {
  project = var.gcp_project_id
  region  = "europe-west2"
  zone    = "europe-west2-a"

  version = "~> 3.27"
}
