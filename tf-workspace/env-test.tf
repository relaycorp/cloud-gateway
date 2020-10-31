module "gw_test" {
  source = "../tf-modules/base"

  environment_name = "test"

  pohttp_host = "pohttp-test.relaycorp.tech"
  poweb_host  = "poweb-test.relaycorp.tech"
  cogrpc_host = "cogrpc-test.relaycorp.tech"

  gcp_project_id           = var.gcp_project_id
  mongodb_atlas_project_id = var.mongodb_atlas_project_id

  depends_on = [google_project_service.compute, google_project_service.logging]
}
