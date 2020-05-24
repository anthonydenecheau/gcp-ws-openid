# -----------------------------------------------------------------------------
# database schema
# -----------------------------------------------------------------------------

output generated_user_password {
  description = "The auto generated default user password if no input password was provided"
  value       = random_id.user-password.hex
  sensitive   = true
}

output db_name {
  description = "The database name"
  value       = google_sql_database.default.name
}
