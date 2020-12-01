# Terraform Cloud workspace for a single Public Gateway environment

We're creating separate workspaces for each environment in order to:

1. Be able to manipulate the Terraform state when things go 2020.
1. Make it easier to review Terraform plans.
1. Speed up operations such as planning.

Unfortunately, when creating an instance of this module, you have to manually enable the VCS connection to GitHub from the Terraform Cloud web console.
