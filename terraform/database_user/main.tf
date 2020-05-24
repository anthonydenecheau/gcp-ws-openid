resource "random_id" "user-password" {
  byte_length = 20
}

resource "google_sql_user" "default" {
  # count    = var.master_instance_name == "" ? 1 : 0
  name     = var.database_user["user_name"]
  project  = var.database_user["project"]
  instance = var.database_user["db_instance_name"]
  # host     = lookup(var.database_user, "user_host", "%")
  password = var.database_user_password == "" ? random_id.user-password.hex : var.database_user_password
}

resource "google_sql_database" "default" {
  # count     = var.master_instance_name == "" ? 1 : 0
  name      = var.database_user["db_name"]
  project   = var.database_user["project"]
  instance  = var.database_user["db_instance_name"]
  charset   = lookup(var.database_user, "db_charset", "UTF8")
  collation = lookup(var.database_user, "db_collation", "en_US.UTF8")
}
