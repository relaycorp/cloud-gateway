output "sre_monitoring_notification_channel" {
  value     = var.sre_monitoring_notification_channel
  sensitive = false
}

output "sre_email_addresses" {
  value     = var.sre_email_addresses
  sensitive = false
}

output "gcp_parent_folder" {
  value     = var.gcp_parent_folder
  sensitive = false
}

output "gcp_billing_account" {
  value     = var.gcp_billing_account
  sensitive = false
}
