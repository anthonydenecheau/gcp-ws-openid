# -----------------------------------------------------------------------------
# database user & schema
# -----------------------------------------------------------------------------

# db_version (default: POSTGRES_9_6) The version of the database. For example, `MYSQL_5_6` or `POSTGRES_9_6`.
# user_name (mandatory) The name of the default user.
# user_host (mandatory) The host for the default user.
# db_instance_name (mandatory)
# db_charset (default: UTF8) The charset for the default database.
# db_collation (default: en_US.UTF8) The collation for the default database. Example for MySQL databases: 'utf8_general_ci', and Postgres: 'en_US.UTF8'.
# db_name (mandatory) Name of the default database to create.
variable "database_user" {
  description = "Database user configuration"
  type        = map
}

variable "database_user_password" {
  description = "The password for the default user. If not set, a random one will be generated and available in the generated_user_password output variable."
  default     = ""
}
