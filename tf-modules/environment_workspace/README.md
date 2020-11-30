# Terraform Cloud workspace for a single Public Gateway environment

We're creating separate workspaces for each environment in order to:

1. Be able to manipulate the Terraform state when things go 2020.
1. Speed up operations such as planning.
