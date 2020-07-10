
variable "gcr_igm" {
  description = "GCR Group Manager configuration"
  type        = map
}

variable "environment_variables" {
  description = "Environment variables which should be set on the service. Map from name to value."
  default     = {}
}

variable "max_scale" {
  description = "Maximum number of auto-scaled instances. For a container with N-workers, maxScale should be less than 1/N of the maximum connection count for the Cloud SQL instance."
  default     = "1000"
}

variable "container_concurrency" {
  description = "Maximum number of concurrent requests to an instance before it is auto-scaled. Defaults to 80 which is the maximum that Cloud Run allows"
  default     = "80"
}

variable "cpu_limit" {
  description = "CPU limit for the deployed container. Defaults to 1 CPU, '1000m'."
  default     = "1000m"
}

variable "memory_limit" {
  description = "Memory limit for the deployed container. Defaults to 512 MB, '512M'."
  default     = "512M"
}

variable "allow_unauthenticated_invocations" {
  description = <<EOI
If true, the webapp will allow unauthenticated invocations. If false, the webapp requires authentication
as a Google user with the Cloud Run invoker permission on the deployment.
EOI
  type        = bool
  default     = true
}

variable "dns_name" {
  description = <<EOI
If non-empty, a domain mapping will be created for the webapp from this domain
to point to the webapp. The domain must first have been verified by Google and
the account being used by the google provider must have been added as an owner.

If and only if a domain mapping has been created, the
"domain_mapping_resource_record" output will be a non-empty map and the
"domain_mapping_present" output will be true.
EOI
  default     = "ws-pedigree-service.elhadir.com"
}

variable "service_name" {
  default = "ws-pedigree-service"
}

variable "environment" {
  default = "dev"
}