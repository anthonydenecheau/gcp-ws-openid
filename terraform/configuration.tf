terraform {
  backend "gcs" {
    prefix  = "terraform/state"
  }
}

// Configure Google Cloud provider
provider "google" {
  version         = "~> 3.0"
  project         = var.project
  region          = var.region
  credentials     = var.credentials
  # billing_account = var.billing_account
  # org_id          = var.org_id
}
