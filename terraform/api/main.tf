
resource "google_cloud_run_service" "default" {
  name     = "${var.environment}-${var.service_name}"
  location = var.gcr_igm["region"]
  project  = var.gcr_igm["project"]

  autogenerate_revision_name = true

  template {
    spec {

      # Maximum number of concurrent requests to an instance before it is
      # auto-scaled. For webapps which use connection pooling, it should be safe
      # to set this number without regard to the connection limit of the Cloud
      # SQL instance. This can be no greater than 80.
      #
      # See https://cloud.google.com/run/docs/about-concurrency.
      container_concurrency = var.container_concurrency

      #service_account_name = var.gcr_igm["service_account"]

      containers {
        image = "gcr.io/rugged-shuttle-277619/pedigree-service"

        resources {
          limits = {
            cpu    = var.cpu_limit
            memory = var.memory_limit
          }
        }

        dynamic "env" {
          for_each = var.environment_variables
          content {
            name  = lookup(env.value, "name", null)
            value = env.value.value
          }
        }

      }
    }
    
    metadata {
        labels = {
            owner       = "anthony-denecheau"
            project     = var.gcr_igm["project"]
            environment = var.environment
        }
        annotations = {
          # Maximum number of auto-scaled instances.  For a container with
          # N-workers, maxScale should be less than 1/N of the maximum connection
          # count for the Cloud SQL instance.
          "autoscaling.knative.dev/maxScale" = var.max_scale

          # Cloud SQL instances to auto-magically make appear in the container as
          # Unix sockets.
          "run.googleapis.com/cloudsql-instances" = var.gcr_igm["db_connection_name"]

          # As mentioned at https://www.terraform.io/docs/configuration/resources.html#ignore_changes
          # placeholders need to be created as the adding the key to the map is
          # considered a change and not ignored by ignore_changes
          "client.knative.dev/user-image"     = "placeholder"
          "run.googleapis.com/client-name"    = "terraform"
          "run.googleapis.com/client-version" = "placeholder"
          #"run.googleapis.com/vpc-access-connector" = "ws-openid-network-vpc"
        }
    }

  }

  traffic {
    percent         = 100
    latest_revision = true
  }

}

data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

# Allow unauthenticated invocations
resource "google_cloud_run_service_iam_policy" "noauth" {
  count       = var.allow_unauthenticated_invocations ? 1 : 0
  location    = google_cloud_run_service.default.location
  project     = google_cloud_run_service.default.project
  service     = google_cloud_run_service.default.name

  policy_data = data.google_iam_policy.noauth.policy_data
}

# Domain mapping for default web-application. Only present if the domain is
# verified. We use the custom DNS name of the webapp if provided but otherwise
# the webapp is hosted at [SERVICE NAME].[PROJECT DNS ZONE]. We can't create
# the domain mapping if the domain is *not* verified because Google won't let
# us.
resource "google_cloud_run_domain_mapping" "default" {
  count = local.domain_mapping_present ? 1 : 0
  location = var.gcr_igm["region"]
  name     = "${var.environment}.${var.dns_name}"

  metadata {
    namespace = var.gcr_igm["project"]
  }

  spec {
    route_name = google_cloud_run_service.default.name
  }
}