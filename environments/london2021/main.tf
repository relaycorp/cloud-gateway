terraform {
  backend "remote" {
    organization = "Relaycorp"

    workspaces {
      name = "gateway-london2021"
    }
  }
}

module "gateway" {
  source = "../_modules/gateway"

  name = "london2021"
  type = "testing"

  gcp_project_id = var.gcp_project_id
  gcp_region     = "europe-west2"

  mongodb_atlas_org_id = var.mongodb_atlas_org_id
  mongodb_atlas_region = "EUROPE_WEST_2"

  sre_iam_uri = var.sre_iam_uri

  gke_instance_type = "e2-standard-4"

  gke_min_version = "1.19.15"
}
