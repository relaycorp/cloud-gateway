# Infrastructure for all Relaycorp-operated Relaynet-Internet Gateways

This repository contains the code and configuration for all the cloud and Kubernetes resources powering the [Relaynet-Internet Gateway](https://docs.relaycorp.tech/relaynet-internet-gateway/) instances operated by Relaycorp.

The cloud and Kubernetes infrastructure is managed separately by a Terraform module ([`tf-workspace`](./tf-workspace)) and Helmfile charts ([`charts`](./charts)), respectively.
