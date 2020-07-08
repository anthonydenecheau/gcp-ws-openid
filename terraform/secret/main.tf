
resource "google_secret_manager_secret" "secret-credentials" {
  provider    = google-beta
  secret_id = "ws-openid-enc"

  labels = {
    ws-openid = "credentials"
  }

  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "secret-version-credentials" {
  provider    = google-beta
  secret = google_secret_manager_secret.secret-credentials.id
  secret_data = file("/secrets/ws-openid.json")
}