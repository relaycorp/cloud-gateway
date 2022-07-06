terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 3.27"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 3.27"
    }
    mongodbatlas = {
      source  = "mongodb/mongodbatlas"
      version = "~> 0.6"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0.0"
    }
    tfe = {
      source  = "hashicorp/tfe"
      version = "~> 0.24.0"
    }
  }
  required_version = ">= 1.1.0"
}
