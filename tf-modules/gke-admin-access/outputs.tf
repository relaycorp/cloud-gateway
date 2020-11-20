output "cd_service_account_secret" {
  value     = data.kubernetes_secret.cd_service_access.data.token
  sensitive = true
}
