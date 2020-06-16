# roles/cloudbuild.builds.builder
# roles/cloudsql.admin
# roles/compute.admin
# roles/editor
# roles/storage.admin
# role/secretmanager.secretAccessor
# role/secretmanager.admin

data "google_project" "project" {
}

resource "google_project_iam_member" "cloud-sql-client" {
  provider    = google-beta
  project = var.project
  role = "roles/cloudsql.client"
  member = "serviceAccount:${data.google_project.project.number}-compute@developer.gserviceaccount.com"
}

resource "google_project_iam_member" "secret-manager-accessor" {
  provider    = google-beta
  project = var.project
  role = "roles/secretmanager.secretAccessor"
  member = "serviceAccount:${data.google_project.project.number}@cloudbuild.gserviceaccount.com"
}

resource "google_project_iam_member" "cloud_run_admin" {
  provider    = google-beta
  project = var.project
  role = "roles/run.admin"
  member = "serviceAccount:${data.google_project.project.number}@cloudbuild.gserviceaccount.com"
}