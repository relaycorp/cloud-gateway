resource "codefresh_pipeline" "vault" {
  lifecycle {
    ignore_changes = [
      revision,

      // See: https://github.com/codefresh-io/terraform-provider-codefresh/issues/21
      project_id
    ]
  }

  name = "${var.cf_project_name}/${var.environment_name}: vault"

  tags = [
    "gateway",
    "env-${var.environment_name}",
    "service-vault"
  ]

  spec {
    concurrency = 1
    priority    = 5

    trigger {
      context     = "github"
      description = "Trigger for commits"
      disabled    = false
      events = [
        "push.heads"
      ]
      modified_files_glob = "**/vault.yml"
      name                = "commits"
      provider            = "github"
      repo                = "relaycorp/cloud-gateway"
      branch_regex        = "/^main$/"
      type                = "git"
    }

    variables = {
      KUBERNETES_CONTEXT = var.cf_kubernetes_context
      VAULT_KV_PREFIX    = local.vault_kv_prefix
    }

    spec_template {
      repo     = "relaycorp/cloud-gateway"
      path     = "./cf-pipelines/vault.yml"
      revision = "main"
      context  = "github"
    }
  }
}

resource "codefresh_pipeline" "vault_deprovision" {
  lifecycle {
    ignore_changes = [
      revision,

      // See: https://github.com/codefresh-io/terraform-provider-codefresh/issues/21
      project_id
    ]
  }

  name = "${var.cf_project_name}/${var.environment_name}: vault-deprovision"

  tags = [
    "gateway",
    "env-${var.environment_name}",
    "service-vault"
  ]

  spec {
    concurrency = 1
    priority    = 5

    variables = {
      KUBERNETES_CONTEXT = var.cf_kubernetes_context
    }

    spec_template {
      repo     = "relaycorp/cloud-gateway"
      path     = "./cf-pipelines/vault-deprovision.yml"
      revision = "main"
      context  = "github"
    }
  }
}
