output ws-pedigree-service-url {
  description = "Url to cloud run service"
  value = google_cloud_run_service.default.status[0].url
}

output "service" {
  description = "API Cloud Run service resource"
  value       = google_cloud_run_service.default
}

#output "service_account" {
#  description = "Service account which service runs as"
#  value       = google_service_account.default
#}

output "domain_mapping_present" {
  description = "Flag indicating if a domain mapping is present for the webapp"
  value       = local.domain_mapping_present
}

output "domain_mapping_resource_record" {
  description = <<EOI
Resource record for domain mapping. If a domain mapping is configured the
following keys will be set: type and rrdata. If no mapping is configured, the
map will be empty.
EOI
  value = local.domain_mapping_present ? {
    type   = google_cloud_run_domain_mapping.default[0].status[0].resource_records[0].type
    rrdata = google_cloud_run_domain_mapping.default[0].status[0].resource_records[0].rrdata
  } : {}
}

output "domain_mapping_dns_name" {
  description = <<EOI
DNS name (minus trailing dot) of webapp. Will be blank if no DNS name
configured.
EOI
  value       = var.dns_name
}
