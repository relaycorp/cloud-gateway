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
      version = "~> 4.27"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 4.27"
    }
    tfe = {
      source  = "hashicorp/tfe"
      version = "~> 0.32.1"
    }
    mongodbatlas = {
      source  = "mongodb/mongodbatlas"
      version = "~> 1.10.2"
    }
  }
  required_version = ">= 1.1.2"
}
