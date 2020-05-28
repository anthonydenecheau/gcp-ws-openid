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

variable "gcp_service_list" {
  description = "List of GCP service to be enabled for a project."
  type        = list
  default = [
  "bigquery-json.googleapis.com",     # BigQuery API
  "bigquerystorage.googleapis.com",   # BigQuery Storage API
  "cloudapis.googleapis.com",         # Google Cloud APIs
  "clouddebugger.googleapis.com",     # Stackdriver Debugger API
  "cloudtrace.googleapis.com",        # Stackdriver Trace API
  "compute.googleapis.com",           # Compute Engine API
  "iam.googleapis.com",               # Identity and Access Management (IAM) API
  "iamcredentials.googleapis.com",    # IAM Service Account Credentials API
  "logging.googleapis.com",           # Stackdriver Logging API
  "monitoring.googleapis.com",        # Stackdriver Monitoring API
  "oslogin.googleapis.com",           # Cloud OS Login API
  "servicemanagement.googleapis.com", # Service Management API
  "serviceusage.googleapis.com",      # Service Usage API
  "sourcerepo.googleapis.com",        # Cloud Source Repositories API
  "sql-component.googleapis.com",     # Cloud SQL
  "storage-api.googleapis.com",       # Google Cloud Storage JSON API
  "storage-component.googleapis.com", # Cloud Storage
  ]     
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
