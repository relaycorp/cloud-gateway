terraform {
  backend "remote" {
    organization = "Relaycorp"

    workspaces {
      name = "gateway-frankfurt"
    }
  }
}

module "gateway" {
  source = "../_modules/gateway"

  name = "frankfurt"

  gcp_project_id = var.gcp_project_id
  gcp_region     = "europe-west3"

  mongodb_atlas_org_id = var.mongodb_atlas_org_id
  mongodb_atlas_region = "EUROPE_WEST_3"

  sre_iam_uri = var.sre_iam_uri
}
