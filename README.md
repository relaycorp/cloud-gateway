# Infrastructure for all Relaycorp-operated Relaynet-Internet Gateways

This repository contains the code and configuration for all the cloud and Kubernetes resources powering the [Relaynet-Internet Gateway](https://docs.relaycorp.tech/relaynet-internet-gateway/) instances operated by Relaycorp.

The cloud and Kubernetes infrastructure is managed separately by a Terraform module ([`tf-workspace`](./tf-workspace)) and CloudFresh pipelines ([`cf-pipelines`](./cf-pipelines)), respectively.

# Manual tasks

Pretty much everything is automated, except for the following due to limitations in third-party software:

## Connect CodeFresh to the GKE cluster

[The Terraform provider for CodeFresh doesn't offer a resource for Kubernetes clusters](https://github.com/codefresh-io/terraform-provider-codefresh/issues/20), so we have to set up the authentication manually by copying the different connection arguments and pasting them in the CodeFresh web UI.

For example, to obtain the connection arguments for the test environment, run:

```
terraform output gw_test_cd_connection
```

## Authenticate CodeFresh with GCP

We have to manually copy a key for the service account used by CodeFresh, and paste it as a project-level secret by the name of `GCP_SA_PRIVATE_KEY`.

The key can be retrieved from the Terraform console, using the expression `google_service_account_key.codefresh.private_key`.

Unfortunately, this means we have to manually rotate the key periodically.
