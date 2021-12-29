terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 3.53.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 3.53.0"
    }
    mongodbatlas = {
      source  = "mongodb/mongodbatlas"
      version = "~> 0.6"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0.0"
    }
  }
  required_version = ">= 0.13"
}
