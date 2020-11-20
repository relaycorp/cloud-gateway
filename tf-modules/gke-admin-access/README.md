# Module to grant admin access to a GKE cluster

This is a workaround for CloudFresh' inability to manage a GKE cluster using a service account.

This has to be implemented outside the base module because the Kubernetes provider has to be configured dynamically, which would make it impossible to delete instances of the base module. By keeping the dynamic provider configuration in a separate module, we can at least delete the instance of this provider first and then delete the instance of the base module.
