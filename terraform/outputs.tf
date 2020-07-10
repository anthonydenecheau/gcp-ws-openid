# -----------------------------------------------------------------------------
# network
# -----------------------------------------------------------------------------
output external_ip {
  description = "The external IP assigned to the global fowarding rule."
  value       = google_compute_global_address.openid-ws-lb.address
}

# -----------------------------------------------------------------------------
# database
# -----------------------------------------------------------------------------
output instance_sql_name {
  description = "The name of the database instance"
  value       = module.postgres_ha_db.instance_sql_name
}

output instance_sql_public_ipv4 {
  description = "The IPv4 public address of the master database instance"
  value       = module.postgres_ha_db.instance_sql_public_ipv4
}
output instance_sql_private_ipv4 {
  description = "The IPv4 private address of the master database instance"
  value       = module.postgres_ha_db.instance_sql_private_ipv4
}

output instance_address_time_to_retire {
  description = "The time the master instance IP address will be retired. RFC 3339 format."
  value       = module.postgres_ha_db.instance_address_time_to_retire
}

output instance_ip_addresses {
  description = "The private IPv4 address of the master database instance"
  value       = module.postgres_ha_db.instance_ip_addresses
}

output instance_service_account_email_address {
  description = "The service account email address assigned to the instance. This property is applicable only to Second Generation instances."
  value       = module.postgres_ha_db.instance_service_account_email_address
}
output self_link {
  description = "Self link to the master instance"
  value       = module.postgres_ha_db.self_link
}

output generated_db_user_openid_password {
  description = "The auto generated openid user password if no input password was provided"
  value       = module.postgres_db_user_openid.generated_user_password
}

output dev_generated_db_user_pedigree_password {
  description = "The auto generated pedigree user password if no input password was provided"
  value       = module.postgres_db_user_pedigree["dev"].generated_user_password
}

output qa_generated_db_user_pedigree_password {
  description = "The auto generated pedigree user password if no input password was provided"
  value       = module.postgres_db_user_pedigree["qa"].generated_user_password
}

output prod_generated_db_user_pedigree_password {
  description = "The auto generated pedigree user password if no input password was provided"
  value       = module.postgres_db_user_pedigree["prod"].generated_user_password
}

/*
# -----------------------------------------------------------------------------
# cloud run
# -----------------------------------------------------------------------------
output ws {
  description = "Url to cloud run service"
  value = module.scc-api.ws-pedigree-service-url
}
*/