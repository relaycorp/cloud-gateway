module "gw_test" {
  source = "../tf-modules/base"

  environment_name = "test"

  pohttp_host = "pohttp-test.relaycorp.tech"
  poweb_host  = "poweb-test.relaycorp.tech"
  cogrpc_host = "cogrpc-test.relaycorp.tech"

  gcp_project_id = var.gcp_project_id
  gcp_region     = "europe-west2"

  mongodb_atlas_project_id = var.mongodb_atlas_project_id

  cf_kubernetes_context = "gateway-test"
  cf_project_name       = codefresh_project.gateway.name
}

module "gw_test_gke_access" {
  source = "../tf-modules/gke-admin-access"

  gke_cluster_endpoint       = module.gw_test.gke_cluster_endpoint
  gke_cluster_ca_certificate = module.gw_test.gke_cluster_ca_certificate
}
