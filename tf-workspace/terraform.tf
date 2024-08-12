terraform {
  backend "remote" {
    organization = "Relaycorp"

    workspaces {
      name = "cloud-gateway"
    }
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.12"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 5.12"
    }
    tfe = {
      source  = "hashicorp/tfe"
      version = "~> 0.58.0"
    }
    mongodbatlas = {
      source  = "mongodb/mongodbatlas"
      version = "~> 1.10.2"
    }
  }
  required_version = ">= 1.1.2"
}
