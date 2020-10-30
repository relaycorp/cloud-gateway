# Example deployment of the Relaynet-Internet gateway on Google Cloud Platform

This directory contains a Terraform module to deploy the Relaynet-Internet Gateway and its backing services to a production-ready environment on GCP.

Note that the primary objective here is to provide a working environment for this service, which can be used as a starting point for a real-world deployment where you may want to re-use any pre-existing instances of any backing services. Consequently, the gateway itself is configured with values that are safe in production, but you should check the corresponding documentation for the backing services to learn how to configure them in production.

Apart from the Kubernetes and GCP resources created by the chart, this Terraform module will create the following cloud resources:

- A GCP project.
- A GKE cluster.
- A corresponding GCP node pool.
- A GCP HTTP load balancer (managed by a Kubernetes ingress).
- A MongoDB Atlas project and cluster on GCP.

## Pre-requisites

1. Install the following dependencies: Git, Terraform, Helm 3, `kubectl` and the `gcloud` CLI.
1. Set your GCP credentials in a location supported by the GCP provider in Terraform, if you haven't already done so; for example:
  ```
   gcloud auth application-default login
  ```
1. Create the GCP project where you want to host the resources created by this module, unless you want to reuse an existing project.
1. Go to your project's [API library](https://console.cloud.google.com/apis/library/container.googleapis.com) and make sure the following APIs are enabled: Kubernetes.
1. Check out this directory if you haven't done so:
   ```
   git clone https://github.com/relaycorp/relaynet-internet-gateway-chart.git
   cd relaynet-internet-gateway-chart/example
   ```
1. Configure MongoDB Atlas:
   1. [Generate API keys](https://docs.atlas.mongodb.com/tutorial/manage-programmatic-access/index.html) (Organization Project Creator, Organization Member).
   1. Define them as environment variables:
      ```shell script
      export MONGODB_ATLAS_PUBLIC_KEY=<PUBLIC-KEY>
      export MONGODB_ATLAS_PRIVATE_KEY=<PRIVATE-KEY>
      ```

## Install

We'll create the GCP resources first, so we can then create the Kubernetes resources in the newly-created cluster.

To create the GCP resources, run:

```
terraform init
terraform apply
```

The commands above require about 10 minutes to complete. Once the GCP resources are available, it's time to create the Kubernetes resources. First, download the credentials for the newly-created cluster; e.g.:

```
gcloud container clusters get-credentials gateway-example \
    --zone europe-west2-a \
    --project public-gw
```

1. Install Vault in development mode (not recommended in production) and enable the KV secret store:
   ```
   # Add HashiCorp's repo if you haven't done so yet
   helm repo add hashicorp https://helm.releases.hashicorp.com
   
   helm install vault-test hashicorp/vault \
       --set "server.dev.enabled=true" \
       --set "server.image.extraEnvironmentVars.VAULT_DEV_ROOT_TOKEN_ID=letmein"
   
   # Check when the pod vault-test-0 is ready:
   kubectl get pod vault-test-0
   # Configure Vault when the pod is ready:
   kubectl exec -it vault-test-0 -- vault secrets enable -path=gw-keys kv-v2
   ```
1. [Install Minio](https://github.com/minio/charts):
   ```
   helm repo add minio https://helm.min.io
   
   helm install minio-test minio/minio \
       --set accessKey=test-key,secretKey=test-secret \
       --set persistence.size=100Mi \
       --set buckets[0].name=public-gateway,buckets[0].policy=none \
       --set resources.requests.memory=500Mi
   ```
1. [Install NATS Streaming](https://github.com/nats-io/nats-streaming-operator).
1. Install the gateway chart:
   1. Get an initial Helm values file from the Terraform module by running:
      ```
      terraform output helm_values > values.yml
      ```
   1. Update `values.yml`:
      - Add the username and password to the `mongo.uri`.
      - Set `pohttpHost` to the domain to be used by PoHTTP.
   1. Create the GCP CRDs:
      ```
      terraform output gcp_crds | kubectl apply -f -
      ```
   1. Update your DNS to make the domains in the certificate point to the GCP global IP associated with the managed certificate. Run the following to get the IP address:
      ```
      terraform output gcp_global_ip
      ```
   1. Install the chart:
      ```
      helm install --values values.yml gw-test \
          https://github.com/relaycorp/relaynet-internet-gateway-chart/archive/master.tar.gz
      ```
   1. Follow the post-install notes.

Subsequent changes to `values.yml` can be applied with:

```
helm upgrade --values values.yml gw-test \
          https://github.com/relaycorp/relaynet-internet-gateway-chart/archive/master.tar.gz
```
