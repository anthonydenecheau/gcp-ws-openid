
# -----------------------------------------------------------------------------
# database
# -----------------------------------------------------------------------------

resource "random_id" "db_name_suffix" {
  byte_length = 4
}

module "postgres_ha_db" {
    source = "./database"

    database_instance = {
        project = var.project
        region  = var.region
        db_version = "POSTGRES_11"
        db_instance_name = "${var.database_instance_name}-${random_id.db_name_suffix.hex}"

        tier = "db-g1-small"
        disk_size = 15
        
        #private_network = google_compute_network.default.self_link
        private_network = google_service_networking_connection.private_vpc_connection.network
    }
    user_labels = {
        app = var.application_name
        owner = "adenecheau"
    }
    authorized_networks = [
        { name = "adenecheau",
            value = "86.245.15.48/32"
        }
    ]
}

module "postgres_db_user" {
    source = "./database_user"

    database_user = {
        project          = var.project
        db_instance_name = module.postgres_ha_db.instance_sql_name
        user_name        = var.database_user
        db_name          = var.database_user
    }
}

# -----------------------------------------------------------------------------
# instances
# -----------------------------------------------------------------------------

module "scc-docker-servers" {
    source = "./instances"


    gce_image = {
        family = "scc-docker-server-image"
    }

    gce_igm = {
        name = "scc-docker-server-igm"
        region = var.region
        base_instance_name = "scc-docker-server"
        target_size = 1
    }

    gce_instance = {
        description = "This template is used to create docker server instances."
        type        = "n1-standard-2"
        name_prefix = "scc-docker-server-"
        #subnetwork  = google_compute_subnetwork.default.self_link
        #network     = google_compute_network.default.self_link
        network = google_compute_network.private_network.self_link
        database_private_ip         = module.postgres_ha_db.instance_sql_private_ipv4
        database_name               = module.postgres_ha_db.instance_sql_name
        database_user               = var.database_user
        database_generated_password = module.postgres_db_user.generated_user_password
        application_name       = var.application_name
    }

    gce_lb = {
        public_ip_address = google_compute_global_address.openid-ws-lb.address
        web_domain        = var.web_domain
        project           = var.project
    }
}
