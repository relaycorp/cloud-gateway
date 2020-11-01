resource "codefresh_pipeline" "test" {
  lifecycle {
    ignore_changes = [
      revision
    ]
  }

  name = "${var.cf_project_name}/vault"

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
      modified_files_glob = "charts/**/vault.yml"
      name                = "commits"
      provider            = "github"
      repo                = "relaycorp/cloud-gateway"
      branch_regex        = "^master$"
      type                = "git"
    }

    variables = {
      FOO = "var"
    }
  }
}
