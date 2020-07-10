terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
    google-beta = {
      source = "terraform-providers/google-beta"
    }
  }
  required_version = ">= 0.13"
}
