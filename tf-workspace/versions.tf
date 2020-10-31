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
      source = "codefresh.io/app/codefresh"
    }
  }
  required_version = ">= 0.13"
}
