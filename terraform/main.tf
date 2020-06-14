
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
        
        private_network = google_service_networking_connection.private_vpc_connection.network
    }
    user_labels = {
        app = var.application_name
        owner = "adenecheau"
    }
    authorized_networks = [
        { 
            name = "adenecheau",
            value = "86.245.15.48/32"
        },
        {
            name = "cloudrun"
            value = "216.239.36.53/32"
        }
    ]
}

# User WS pedigree
module "postgres_db_user_pedigree" {
    source = "./database_user"

    database_user = {
        project          = var.project
        db_instance_name = module.postgres_ha_db.instance_sql_name
        user_name        = var.database_user_pedigree
        db_name          = var.database_user_pedigree
    }
}

# User keycloak
module "postgres_db_user_openid" {
    source = "./database_user"

    database_user = {
        project          = var.project
        db_instance_name = module.postgres_ha_db.instance_sql_name
        user_name        = var.database_user_openid
        db_name          = var.database_user_openid
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
        network = google_compute_network.private_network.self_link
        database_private_ip         = module.postgres_ha_db.instance_sql_private_ipv4
        database_user               = var.database_user_openid
        database_name               = var.database_user_openid
        database_generated_password = module.postgres_db_user_openid.generated_user_password
        application_name       = var.application_name
    }

    gce_lb = {
        public_ip_address = google_compute_global_address.openid-ws-lb.address
        web_domain        = var.web_domain
        project           = var.project
    }
}

# -----------------------------------------------------------------------------
# cloud run
# -----------------------------------------------------------------------------
module "scc-api" {
    source = "./api"

    gcr_igm = {
        region                      = var.region
        project                     = "ws-pedigree-api"
        database_private_ip         = module.postgres_ha_db.instance_sql_private_ipv4
        db_connection_name          = module.postgres_ha_db.connection_name
        database_user               = var.database_user_pedigree
        database_name               = var.database_user_pedigree
        database_generated_password = module.postgres_db_user_pedigree.generated_user_password
        service_account             = var.service_account
    }
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE A CLOUD BUILD TRIGGER
# ---------------------------------------------------------------------------------------------------------------------
module "scc-cicd" {
    source = "./cicd"

}

# ---------------------------------------------------------------------------------------------------------------------
# CONFIGURE THE GCR REGISTRY TO STORE THE CLOUD BUILD ARTIFACTS
# ---------------------------------------------------------------------------------------------------------------------
module "scc-registry" {
  # When using these modules in your own templates, you will need to use a Git URL with a ref attribute that pins you
  # to a specific version of the modules, such as the following example:
  # source = "github.com/gruntwork-io/terraform-google-ci.git//modules/gcr-registry?ref=v0.1.0"
  source = "./registry"

  project         = var.project
  registry_region = ""

  # allow the custom service account to pull images from the GCR registry
  readers = ["serviceAccount:${var.service_account}"]

}
