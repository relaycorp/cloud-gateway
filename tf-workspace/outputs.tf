// Output Kubernetes connection arguments so that we can configure CodeFresh by hand. See:
// https://github.com/codefresh-io/terraform-provider-codefresh/issues/20
output "gw_test_cd_connection" {
  value = <<EOF
cluster_endpoint: ${module.gw_test.gke_cluster_endpoint}
cluster_ca_certificate: ${module.gw_test.gke_cluster_ca_certificate}
satoken: ${module.gw_test.cd_service_account_secret}
EOF
}
