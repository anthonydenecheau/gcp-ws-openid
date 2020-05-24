# -----------------------------------------------------------------------------
# project
# -----------------------------------------------------------------------------

variable "credentials" {
  description = "The JSON file generated by GCP when asking for a service account token"
  default     = "myGCP-ServiceAccount-Token.json"
}

variable "billing_account" {
  description = "GCP billing account resources of your project are billing to"
  default     = "xxxxxx-xxxxxx-xxxxxx"
}

variable "org_id" {
  description = "The Organization ID your GCP project belongs to"
  default     = "xxxxx"
}

variable "project" {
  description = "The project to deploy to, if not set the default provider project is used."
  default     = "ws-openid"
}

variable "region" {
  description = "Region for cloud resources"
  default     = "europe-west1"
}

variable "application_name" {
  description = "The name of the business application."
  default     = "ws-openid"
}

variable "service_account" {
  description = "The service account email that is used to run Google Functions"
  default     = "ws-openid-terraform-accnt@rugged-shuttle-277619.iam.gserviceaccount.com"
}

# -----------------------------------------------------------------------------
# storage-buckets
# -----------------------------------------------------------------------------


# -----------------------------------------------------------------------------
# network
# -----------------------------------------------------------------------------

variable "network-name" {
  description = "The name of the network."
  default     = "ws-openid-network"
}

variable ip-version {
  description = "IP version for the Global address (IPv4 or v6) - Empty defaults to IPV4"
  default     = "IPV4"
}

# -----------------------------------------------------------------------------
# database
# -----------------------------------------------------------------------------
variable "database_instance_name" {
  description = "The database instance used by the project."
  default     = "openid-db"
}

variable "database_user" {
  description = "The database user dedicated to the application."
  default     = "openid-user"
}


# -----------------------------------------------------------------------------
# instances
# -----------------------------------------------------------------------------

variable "web_domain" {
  description = "the Web domain that is protected by the managed SSL certificate exposed by the load-balancer."
  default     = "open-id.elhadir.com"
}

# -----------------------------------------------------------------------------
# function
# -----------------------------------------------------------------------------
