module "gw_test" {
  source = "../tf-modules/base"

  environment_name = "test"

  pohttp_host = "pohttp-test.relaycorp.tech"
  poweb_host  = "poweb-test.relaycorp.tech"
  cogrpc_host = "cogrpc-test.relaycorp.tech"

  gcp_project_id = var.gcp_project_id
  gcp_region     = "europe-west2"

  mongodb_atlas_project_id = var.mongodb_atlas_project_id
  mongodb_atlas_region     = "EUROPE_WEST_2"

  sre_iam_uri = var.sre_iam_uri
}
