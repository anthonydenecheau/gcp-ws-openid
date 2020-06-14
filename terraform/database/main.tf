
resource "google_sql_database_instance" "default" {
  provider = google-beta
  
  name                 = lookup(var.database_instance, "db_instance_name", "a_new_instance")
  project              = var.database_instance["project"]
  region               = var.database_instance["region"]
  database_version     = lookup(var.database_instance, "db_version", "POSTGRES_9_6")

  settings {
    tier              = lookup(var.database_instance, "tier", "db-f1-micro")
    disk_type         = "PD_SSD"
    disk_size         = lookup(var.database_instance, "disk_size", 10)
    disk_autoresize   = lookup(var.database_instance, "disk_autoresize", true)

    activation_policy = "ALWAYS"
    availability_type = lookup(var.database_instance, "availability_type", "REGIONAL")
    replication_type  = lookup(var.database_instance, "replication_type", "SYNCHRONOUS")
    pricing_plan      = lookup(var.database_instance, "pricing_plan", "PER_USE")

    user_labels = var.user_labels

    ip_configuration {
      dynamic "authorized_networks" {
        for_each = var.authorized_networks
        content {
          name  = lookup(authorized_networks.value, "name", null)
          value = authorized_networks.value.value
        }
      }
      ipv4_enabled        = lookup(var.database_instance, "ipv4_enabled", true)
      require_ssl         = lookup(var.database_instance, "require_ssl", false)
      private_network     = var.database_instance["private_network"]
    }

    backup_configuration {
      binary_log_enabled = false
      enabled            = lookup(var.database_instance, "backup_enabled", true)
      start_time         = "02:30" # every 2:30AM
    }

    maintenance_window {
      day          = lookup(var.database_instance, "maintenance_day", 1)          # Monday
      hour         = lookup(var.database_instance, "maintenance_hour", 2)         # 2AM
      update_track = lookup(var.database_instance, "maintenance_track", "stable")
    }
  }

}