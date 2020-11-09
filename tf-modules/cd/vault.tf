resource "codefresh_pipeline" "test" {
  lifecycle {
    ignore_changes = [
      revision,

      // See: https://github.com/codefresh-io/terraform-provider-codefresh/issues/21
      project_id
    ]
  }

  name = "${var.cf_project_name}/vault-${var.environment_name}"

  tags = [
    "gateway",
    "env-${var.environment_name}",
    "service-vault"
  ]

  spec {
    concurrency = 1
    priority    = 5

    trigger {
      context     = "git"
      description = "Trigger for commits"
      disabled    = false
      events = [
        "push.heads"
      ]
      modified_files_glob = "**/vault.yml"
      name                = "commits"
      provider            = "github"
      repo                = "relaycorp/cloud-gateway"
      branch_regex        = "/^main/"
      type                = "git"
    }

    variables = {
      KUBERNETES_CONTEXT = var.cf_kubernetes_context
    }

    spec_template {
      repo     = "relaycorp/cloud-gateway"
      path     = "./cf-pipelines/vault.yml"
      revision = "main"
      context  = "github"
    }
  }
}
