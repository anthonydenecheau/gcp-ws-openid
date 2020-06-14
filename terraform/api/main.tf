
resource "google_cloud_run_service" "default" {
  name     = "ws-pedigree-service"
  location = var.gcr_igm["region"]

  template {
    spec {
      #service_account_name = var.gcr_igm["service_account"]
      containers {
        image = "gcr.io/rugged-shuttle-277619/poc-json-quickstart"
        env {
            name = "DISABLE_SIGNAL_HANDLERS"
            value = "1"
        } 
        env {
            name = "URL_TO_KEYCLOAK"
            value = "https://open-id.elhadir.com/auth/realms/quarkus"
        }
        env {
          name = "DATASOURCE_USER"
          value = var.gcr_igm["database_user"]
        }
        env {
          name = "DATASOURCE_PWD"
          value = var.gcr_igm["database_generated_password"]
        }
        env {
          name = "DATASOURCE_URL"
          value = var.gcr_igm["db_connection_name"]
        }
        env {
          name = "DATASOURCE_DBNAME"
          value = var.gcr_igm["database_name"]
        }        
      }
    }
    
    metadata {
        labels = {
            owner       = "anthony-denecheau"
            project     = var.gcr_igm["project"]
            environment = "dev"
        }
        annotations = {
          "autoscaling.knative.dev/maxScale"      = "1000"
          "run.googleapis.com/cloudsql-instances" = var.gcr_igm["db_connection_name"]
          "run.googleapis.com/client-name"        = "terraform"
          #"run.googleapis.com/vpc-access-connector" = "ws-openid-network-vpc"
        }
    }

  }

  traffic {
    percent         = 100
    latest_revision = true
  }

  autogenerate_revision_name = true

}

data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }

#  binding {
#    role = "roles/cloudsql.instances.get"
#    members = [
#      "allUsers",
#    ]
#  }

#  binding {
#    role = "roles/cloudsql.instances.connect"
#    members = [
#      "allUsers",
#    ]
#  }
  
#  binding {
#    role = "roles/vpcaccess.user"
#    members = [
#      "allUsers",
#    ]
#  }
  
#  binding {
#    role = "roles/cloudsql.client"
#    members = [
#      "allUsers",
#    ]
#  }
}

resource "google_cloud_run_service_iam_policy" "noauth" {
  location    = google_cloud_run_service.default.location
  project     = google_cloud_run_service.default.project
  service     = google_cloud_run_service.default.name

  policy_data = data.google_iam_policy.noauth.policy_data
}