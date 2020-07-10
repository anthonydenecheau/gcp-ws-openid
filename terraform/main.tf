locals {
    description = "A list of maps including the required values for every environment"
    environments = {
    "dev" = {
      user_prefix = "dev"
      git_branch = "dev"
    }
    "qa" = {
      user_prefix = "qa"
      git_branch = "qa"
    }
    "prod" = {
      user_prefix = "prod"
      git_branch = "master"
    }
  }
}

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
        },
        {
            name = "domainmapping.1"
            value = "213.186.33.5"
        },        
        {
            name = "domainmapping.2"
            value = "216.239.34.21"
        },        
        {
            name = "domainmapping.3"
            value = "216.239.36.21"
        },        
        {
            name = "domainmapping.4"
            value = "216.239.38.21"
        },        
    ]
}

# User WS pedigree
module "postgres_db_user_pedigree" {
    source = "./database_user"
    for_each = local.environments

    database_user = {
        project          = var.project
        db_instance_name = module.postgres_ha_db.instance_sql_name
        user_name        = "${each.value.user_prefix}-${var.database_user_pedigree}"
        db_name          = "${each.value.user_prefix}-${var.database_user_pedigree}"
    }
    #depends_on = [module.postgres_ha_db]
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
    depends_on = [module.postgres_ha_db]
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

    depends_on = [module.postgres_db_user_openid]

}
# -----------------------------------------------------------------------------
# cloud run
# -----------------------------------------------------------------------------
module "scc-api" {
    source = "./api"
    for_each = local.environments

    environment         = each.key

    gcr_igm = {
        region                      = var.region
        project                     = var.project
        database_private_ip         = module.postgres_ha_db.instance_sql_private_ipv4
        db_connection_name          = module.postgres_ha_db.connection_name
        service_account             = var.service_account
    }

    environment_variables = [
        {
            name = "DISABLE_SIGNAL_HANDLERS"
            value = "1"
        },
        {
            name = "URL_TO_KEYCLOAK"
            value = "https://open-id.elhadir.com/auth/realms/ws"
        },
        {
          name = "DATASOURCE_USER"
          value = "${each.value.user_prefix}-${var.database_user_pedigree}"
        },
        {
          name = "DATASOURCE_PWD"
          value = module.postgres_db_user_pedigree[each.key].generated_user_password
        },
        {
          name = "DATASOURCE_URL"
          value = module.postgres_ha_db.connection_name
        },
        {
          name = "DATASOURCE_DBNAME"
          value = "${each.value.user_prefix}-${var.database_user_pedigree}"
        },
        {
          name = "AUTHENTICATION_KEY"
          value = "Kt7AXQVCDtUppWllOozehM98cJB0oUpn"
        },
        
    ]

    depends_on = [module.postgres_db_user_pedigree]
}

# -----------------------------------------------------------------------------
# secrets
# -----------------------------------------------------------------------------
module "scc-secrets" {
    source = "./secret"
}
# ---------------------------------------------------------------------------------------------------------------------
# CREATE A CLOUD BUILD TRIGGER
# ---------------------------------------------------------------------------------------------------------------------
module "scc-cicd" {
    source = "./cicd"
    for_each = local.environments

    github_owner        = "anthonydenecheau"
    github_repository   = "pedigree-service"
    branch_name         = each.value.git_branch
}

/*
module "scc-cicd-dev" {
    source              = "./cicd"
    github_owner        = "anthonydenecheau"
    github_repository   = "pedigree-service"
    branch_name         = "featCloudRun"
}
*/

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
