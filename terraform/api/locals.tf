# locals.tf defines common expressions used by the module.

locals {
  # Project containing existing Cloud SQL instance.
  sql_instance_project = coalesce(var.gcr_igm["db_connection_name"], var.gcr_igm["project"])

  # Should a DNS domain mapping be created?
  domain_mapping_present = var.dns_name != ""
}
