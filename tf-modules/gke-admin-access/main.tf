locals {
  cd_sa_name      = "continuous-deployment"
  cd_sa_namespace = "kube-system"
}

resource "kubernetes_cluster_role" "cd" {
  metadata {
    name = local.cd_sa_name
  }

  rule {
    api_groups = ["*"]
    resources  = ["*"]
    verbs      = ["get", "list", "watch", "create", "update", "patch", "delete"]
  }
}

resource "kubernetes_service_account" "cd" {
  metadata {
    name      = local.cd_sa_name
    namespace = local.cd_sa_namespace
  }
}

resource "kubernetes_cluster_role_binding" "cd" {
  metadata {
    name = local.cd_sa_name
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = local.cd_sa_name
  }
  subject {
    kind      = "ServiceAccount"
    name      = local.cd_sa_name
    namespace = local.cd_sa_namespace
  }
}

data "kubernetes_secret" "cd_service_access" {
  metadata {
    name      = kubernetes_service_account.cd.default_secret_name
    namespace = local.cd_sa_namespace
  }
}
