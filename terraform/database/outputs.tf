
# -----------------------------------------------------------------------------
# database
# -----------------------------------------------------------------------------

output instance_sql_name {
  description = "The name of the database instance"
  value       = google_sql_database_instance.default.name
}

output instance_sql_public_ipv4 {
  description = "The IPv4 public address of the master database instance"
  value       = google_sql_database_instance.default.ip_address.0.ip_address
}
output instance_sql_private_ipv4 {
  description = "The IPv4 private address of the master database instance"
  value       = google_sql_database_instance.default.private_ip_address
}

output instance_address_time_to_retire {
  description = "The time the master instance IP address will be reitred. RFC 3339 format."
  value       = google_sql_database_instance.default.ip_address.0.time_to_retire
}

output instance_ip_addresses {
  description = "The private IPv4 address of the master database instance"
  value       = google_sql_database_instance.default.ip_address
}

output instance_service_account_email_address {
  description = "The service account email address assigned to the instance. This property is applicable only to Second Generation instances."
  value       = google_sql_database_instance.default.service_account_email_address
}

output self_link {
  description = "Self link to the master instance"
  value       = google_sql_database_instance.default.self_link
}


output connection_name {
  description = "Connection to the master instance"
  value       = google_sql_database_instance.default.connection_name
}
