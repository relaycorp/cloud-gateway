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
    codefresh = {
      source  = "codefresh.io/app/codefresh"
      version = "~> 0.0.5"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0.0"
    }
  }
  required_version = ">= 0.13"
}
