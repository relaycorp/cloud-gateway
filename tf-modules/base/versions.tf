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
    random = {
      source = "hashicorp/random"
    }
    codefresh = {
      source  = "codefresh.io/app/codefresh"
      version = ">= 0.0.5"
    }
  }
  required_version = ">= 0.13"
}
