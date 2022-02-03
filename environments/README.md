# Gateway environments

We currently manage one environment: [Frankfurt](./frankfurt).

## Provision a new environment

1. Add the Terraform Cloud workspace for the new environment in the main workspace. See [`tf-workspace/environments.tf`](https://github.com/relaycorp/cloud-gateway/blob/main/tf-workspace/environments.tf).
1. Once the change above is pushed to `main`, go to [Terraform Cloud](https://app.terraform.io/app/Relaycorp/workspaces/cloud-gateway) and apply it.
1. Create a new Terraform workspace in this directory and push it to `main`. This workspace MUST initialise the [`gateway` module](./_modules/gateway). You could start by copying an existing workspace.
1. [Go to GCB](https://console.cloud.google.com/cloud-build/triggers?project=relaycorp-cloud-gateway) and run the trigger for the new environment.

   The first build might fail if [the MongoDB Atlas VPC peering connection isn't ready](https://feedback.mongodb.com/forums/924145-atlas/suggestions/44625444-mongodbatlas-cluster-should-wait-until-cluster-is) (the connection string won't be available). If this happens:
   1. Go to MongoDB Atlas and wait until the peering connection is available.
   1. Go to [Terraform Cloud](https://app.terraform.io/app/Relaycorp/workspaces/cloud-gateway) and trigger another run.
   1. Run the GCB trigger again.
1. Configure CI by registering the new environment in [`cloud-oss`](https://github.com/relaycorp/cloud-oss/blob/main/cloud.tf).

## Deprovision an environment

[Deprovisioning isn't currently as automated as it can be](https://github.com/relaycorp/cloud-gateway/issues/56), so the following manual steps are needed:

1. Uninstall all the Helm charts manually; e.g.:
   ```
   helm uninstall gateway
   helm uninstall gateway-crds
   ```
   
   This ensures that cloud resources created by Kubernetes (e.g., the load balancer) are removed.

   This step is not automated to avoid breaking an environment by simply clicking a button on GCB.
1. Empty the GCS buckets in the environment. For example, by creating a lifecycle rule that deletes all objects after 0 days.
1. Alter Terraform resources to allow destruction by setting the `prevent_destruction` in the module to `false`.
1. Go to Terraform Cloud and destroy the workspace from the settings.
1. Delete the Terraform Cloud workspace from the main workspace. See [`tf-workspace/environments.tf`](https://github.com/relaycorp/cloud-gateway/blob/main/tf-workspace/environments.tf).
1. Once the change above is pushed to `main`, go to Terraform Cloud and apply it.
1. Deactivate CI by removing the environment from [`cloud-oss`](https://github.com/relaycorp/cloud-oss/blob/main/cloud.tf).
