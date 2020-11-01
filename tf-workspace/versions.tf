terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
    google-beta = {
      source = "hashicorp/google-beta"
    }
    mongodbatlas = {
      source = "mongodb/mongodbatlas"
    }
    codefresh = {
      version = "~> 0.0.5"
      source  = "codefresh.io/app/codefresh"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0.0"
    }
  }
  required_version = ">= 0.13"
}
