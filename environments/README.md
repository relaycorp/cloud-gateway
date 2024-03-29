# Gateway environments

We currently manage one environment: [Belgium](./belgium).

## Provision a new environment

1. Add the Terraform Cloud workspace for the new environment in the main workspace and push the changes to the `main` branch. See [`tf-workspace/environments.tf`](https://github.com/relaycorp/cloud-gateway/blob/main/tf-workspace/environments.tf).
1. Create a new Terraform workspace in this directory and push it to `main`. This workspace MUST initialise the [`gateway` module](./_modules/gateway). You could start by copying an existing workspace.
1. [Go to GCB](https://console.cloud.google.com/cloud-build/triggers) and run the trigger for the new environment. You will have to connect the GitHub repository first.

   The first build might fail if [the MongoDB Atlas VPC peering connection isn't ready](https://feedback.mongodb.com/forums/924145-atlas/suggestions/44625444-mongodbatlas-cluster-should-wait-until-cluster-is) (the connection string won't be available). If this happens:
   1. Go to MongoDB Atlas and wait until the peering connection is available.
   1. Go to [Terraform Cloud](https://app.terraform.io/app/Relaycorp/workspaces?search=gateway-) and trigger another run.
   1. Run the GCB trigger again.
1. Configure CI by registering the new environment in [`cloud-oss`](https://github.com/relaycorp/cloud-oss/blob/main/cloud.tf).
1. Configure Error Reporting notifications by [going to the console](https://console.cloud.google.com/errors) and clicking "Configure Notifications". Unfortunately, [we're unable to automate this](https://github.com/hashicorp/terraform-provider-google/issues/12068).
1. Add to [dependabot.yml](../.github/dependabot.yml).
1. Add to [CI](../.github/workflows/ci.yml).

## Deprovision an environment

[Deprovisioning isn't currently as automated as it can be](https://github.com/relaycorp/cloud-gateway/issues/56), so the following manual steps are needed:

1. Deactivate CI by removing the environment from [`cloud-oss`](https://github.com/relaycorp/cloud-oss/blob/main/cloud.tf).
1. Alter Terraform resources to allow destruction by setting the `prevent_destruction` in the module to `false`.
1. Go to [Terraform Cloud](https://app.terraform.io/app/Relaycorp/workspaces?search=gateway-) and destroy the workspace from the settings.
1. Delete the Terraform Cloud workspace from the main workspace, by removing the respective module from [`tf-workspace/environments.tf`](https://github.com/relaycorp/cloud-gateway/blob/main/tf-workspace/environments.tf) in the `main` branch.
1. Delete the module from [the current directory](./).
