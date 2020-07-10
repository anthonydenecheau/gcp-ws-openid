terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
    google-beta = {
      source = "terraform-providers/google-beta"
    }
    random = {
      source = "hashicorp/random"
    }
  }
  required_version = ">= 0.13"
}
