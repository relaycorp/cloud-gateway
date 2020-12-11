# Gateway environments

We currently manage one environment: [Frankfurt](./frankfurt).

## Provision a new environment

1. Create a new Terraform workspace in this directory. This workspace MUST initialise the [`gateway` module](./_modules/gateway). You could start by copying an existing workspace.
1. Apply the change in Terraform Cloud.
1. [Go to GCB](https://console.cloud.google.com/cloud-build/triggers?project=relaycorp-cloud-gateway) and run a build for the trigger a build for the new environment.

## Deprovision an environment

1. Uninstall the gateway and its CRDs via Helm:
   ```
   helm uninstall gateway
   helm uninstall gateway-crds
   ```
   
   This ensures that cloud resources created by Kubernetes (e.g., the load balancer) are removed.

   This step is not automated to avoid breaking an environment by simply clicking a button on GCB.
1. Delete the Terraform workspace for the environment.
1. Apply the change in Terraform Cloud.


