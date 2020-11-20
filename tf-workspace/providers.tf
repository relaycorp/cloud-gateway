provider "google" {
  project = var.gcp_project_id
  region  = "europe-west2"
  zone    = "europe-west2-a"
}

provider "google-beta" {
  project = var.gcp_project_id
  region  = "europe-west2"
  zone    = "europe-west2-a"
}

provider "mongodbatlas" {
}

provider "codefresh" {
}
