
resource "google_cloud_run_service" "default" {
  name     = "ws-pedigree-service"
  location = var.gcr_igm["region"]

  template {
    spec {
      containers {
        image = "gcr.io/rugged-shuttle-277619/cloud-run-hello"
        env {
            name = "URL_TO_KEYCLOAK"
            value = "https://[url2KeyCloak]"
            }
        }
    }
    
    metadata {
        labels = {
            owner       = "anthony-denecheau"
            project     = var.gcr_igm["project"]
            environment = "dev"
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
}

resource "google_cloud_run_service_iam_policy" "noauth" {
  location    = google_cloud_run_service.default.location
  project     = google_cloud_run_service.default.project
  service     = google_cloud_run_service.default.name

  policy_data = data.google_iam_policy.noauth.policy_data
}