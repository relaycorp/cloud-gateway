# Gateway environments

We currently manage one environment: [Frankfurt](./frankfurt).

## Provision a new environment

1. Add the Terraform Cloud workspace for the new environment in the main workspace. See [`tf-workspace/environments.tf`](https://github.com/relaycorp/cloud-gateway/blob/main/tf-workspace/environments.tf).
1. Once the change above is pushed to `main`, go to Terraform Cloud and apply it.
1. Go to the Terraform Cloud workspace and connect the GitHub repository. (Unfortunately, Terraform Cloud doesn't do this automatically)
1. Create a new Terraform workspace in this directory and push it to `main`. This workspace MUST initialise the [`gateway` module](./_modules/gateway). You could start by copying an existing workspace.
1. Apply the change in Terraform Cloud.
1. [Go to GCB](https://console.cloud.google.com/cloud-build/triggers?project=relaycorp-cloud-gateway) and run the trigger for the new environment.

## Deprovision an environment

[Deprovisioning isn't currently as automated as it can be](https://github.com/relaycorp/cloud-gateway/issues/56), so the following manual steps are needed:

1. Uninstall the gateway and its CRDs via Helm:
   ```
   helm uninstall gateway
   helm uninstall gateway-crds
   ```
   
   This ensures that cloud resources created by Kubernetes (e.g., the load balancer) are removed.

   This step is not automated to avoid breaking an environment by simply clicking a button on GCB.
1. Delete the Terraform workspace directory for the environment and push it to `main`.
1. Apply the change in Terraform Cloud.
1. Delete the Terraform Cloud workspace from the main workspace. See [`tf-workspace/environments.tf`](https://github.com/relaycorp/cloud-gateway/blob/main/tf-workspace/environments.tf).
1. Once the change above is pushed to `main`, go to Terraform Cloud and apply it.
