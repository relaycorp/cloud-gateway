module "gw_test" {
  source = "../tf-modules/base"

  environment_name = "test"

  pohttp_host = "pohttp-test.relaycorp.tech"
  poweb_host  = "poweb-test.relaycorp.tech"
  cogrpc_host = "cogrpc-test.relaycorp.tech"

  gcp_project_id           = var.gcp_project_id
  mongodb_atlas_project_id = var.mongodb_atlas_project_id
}

module "gw_test_cd" {
  source = "../tf-modules/cd"

  environment_name = module.gw_test.environment_name
  cf_project_name  = codefresh_project.gateway.name
}
