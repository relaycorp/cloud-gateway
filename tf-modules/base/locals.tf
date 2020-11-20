locals {
  env_full_name = "gateway-${var.environment_name}"

  vault_kv_prefix = "gw-keys"
}
