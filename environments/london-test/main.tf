terraform {
  backend "remote" {
    organization = "Relaycorp"

    workspaces {
      name = "gateway-london-test"
    }
  }
}

module "gateway" {
  source = "../_modules/gateway"

  name = "london-test"

  gcp_project_id = var.gcp_project_id
  gcp_region     = "europe-west2"
  gke_instance_type = "n1-standard-1"

  gke_version = "1.17.13"

  mongodb_atlas_org_id = var.mongodb_atlas_org_id
  mongodb_atlas_region = "EUROPE_WEST_2"

  sre_iam_uri = var.sre_iam_uri
}
