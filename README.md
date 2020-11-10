# Infrastructure for all Relaycorp-operated Relaynet-Internet Gateways

This repository contains the code and configuration for all the cloud and Kubernetes resources powering the Relaynet-Internet Gateways operated by Relaycorp.

The cloud and Kubernetes infrastructure is managed separately by a Terraform module ([`tf-workspace`](./tf-workspace)) and CloudFresh pipelines ([`cf-pipelines`](./cf-pipelines)).

# Manual tasks

Pretty much everything is automated, except for the following due to limitations in third-party software:

## Connect CodeFresh to the GKE cluster

[The Terraform provider for CodeFresh doesn't offer a resource for Kubernetes clusters](https://github.com/codefresh-io/terraform-provider-codefresh/issues/20), so we have to set up the authentication manually by copying the different connection arguments and pasting them in the CodeFresh web UI.

For example, to obtain the connection arguments for the test environment, run:

```
terraform output gw_test_cd_connection
```
