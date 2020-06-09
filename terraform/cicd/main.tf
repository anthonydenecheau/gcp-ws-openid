
resource "google_cloudbuild_trigger" "cloud_build_trigger" {
  provider    = google-beta
  description = "GitHub Repository Trigger ${var.github_owner}/${var.github_repository} (${var.branch_name})"

  github {
    owner = var.github_owner
    name  = var.github_repository
    push {
      branch = var.branch_name
    }
  }

  # The filename argument instructs Cloud Build to look for a file in the root of the repository.
  # Either a filename or build template (below) must be provided.
  filename = "cloudbuild.yaml"
}
