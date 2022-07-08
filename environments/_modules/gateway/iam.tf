locals {
  iam_role_prefix = replace(local.env_full_name, "-", "_")
}
