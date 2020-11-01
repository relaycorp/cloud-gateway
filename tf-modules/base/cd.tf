# Retrieve an access token as the Terraform runner
data "google_client_config" "provider" {}

locals {
  cd_user_name = "continuous-deployment"
}

provider "kubernetes" {
  load_config_file = false

  host  = "https://${google_container_cluster.primary.endpoint}"
  token = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(
    google_container_cluster.primary.master_auth[0].cluster_ca_certificate,
  )
}

resource "kubernetes_cluster_role" "cd" {
  metadata {
    name = local.cd_user_name
  }

  rule {
    api_groups = ["*"]
    resources  = ["*"]
    verbs      = ["get", "list", "watch", "create", "update", "patch", "delete"]
  }
}

resource "kubernetes_service_account" "cd" {
  metadata {
    name      = local.cd_user_name
    namespace = "kube-system"
  }
}

resource "kubernetes_cluster_role_binding" "cd" {
  metadata {
    name = local.cd_user_name
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = local.cd_user_name
  }
  subject {
    kind      = "ServiceAccount"
    name      = local.cd_user_name
    namespace = "kube-system"
  }
}
