module "gw_test" {
  source = "../environments/_modules/gateway"

  name = "test"

  gcp_project_id = var.gcp_project_id
  gcp_region     = "europe-west2"

  mongodb_atlas_project_id = var.mongodb_atlas_project_id
  mongodb_atlas_region     = "EUROPE_WEST_2"

  sre_iam_uri = var.sre_iam_uri
}
