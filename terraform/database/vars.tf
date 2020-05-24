# -----------------------------------------------------------------------------
# database instance
# -----------------------------------------------------------------------------

# db_version (default: POSTGRES_9_6) The version of of the database. For example, `MYSQL_5_6` or `POSTGRES_9_6`.
# db_project (mandatory)
# db_region (mandatory)
# db_instance_name (mandatory) Name for the database instance. Must be unique and cannot be reused for up to one week.

# tier (default: db-f1-micro) The machine tier (First Generation) or type (Second Generation). See this page for supported tiers and pricing: https://cloud.google.com/sql/pricing
# disk_type (default: PD_SSD) Second generation only. The type of data disk: `PD_SSD` or `PD_HDD`.
# disk_size (default: 10) Second generation only. The size of data disk, in GB. Size of a running instance cannot be reduced but can be increased.
# disk_autoresize (default: true) Second Generation only. Configuration to increase storage size automatically.
# activation_policy (default: ALWAYS) This specifies when the instance should be active. Can be either `ALWAYS`, `NEVER` or `ON_DEMAND`.
# availability_type (default: REGIONAL) This specifies whether a PostgreSQL instance should be set up for high availability (REGIONAL) or single zone (ZONAL).
# replication_type (default: SYNCHRONOUS) Replication type for this instance, can be one of `ASYNCHRONOUS` or `SYNCHRONOUS`. Already is `SYNCHRONOUS` when availability_type is `REGIONAL`
# zone (mandatory)
# pricing_plan (default: PER_USE) First generation only. Pricing plan for this instance, can be one of `PER_USE` or `PACKAGE`.
# require_ssl (default: false)
# ipv4_enabled (default: true)
# private_network (mandatory)

# backup_enabled (default: true)
# backup_time  (default: every 2:30AM)
# maintenance_day (default: 1 i.e. Monday)
# maintenance_hour (default: 2AM)
# maintenance_track (default: stable)
variable "database_instance" {
  description = "Instance configuration"
  type        = map
}

variable authorized_networks {
  description = "The location_preference settings subblock"
  type        = list
  default     = []
}

variable user_labels {
  description = "A set of key/value user label pairs to assign to the instance."
  type        = map
  default     = {}
}

variable "authorized_gae_apps" {
  description = "A list of Google App Engine (GAE) project names that are allowed to access this instance."
  type        = list
  default     = []
}

variable database_flags {
  description = "List of Cloud SQL flags that are applied to the database server"
  default     = []
}

variable replica_configuration {
  description = "The optional replica_configuration block for the database instance"
  type        = list
  default     = []
}

variable master_instance_name {
  description = "The name of the master instance to replicate. This instance should already exists or you'll get a http-403 error."
  default     = "openid-db"
}


variable dependencies {
  description = "A map to store values coming from resources this module depends on."
  type        = list
  default     = []
}
