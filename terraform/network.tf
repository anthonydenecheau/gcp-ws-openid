resource "google_compute_network" "default" {
  name                    = var.network-name
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "default" {
  name                     = var.network-name
  ip_cidr_range            = "10.126.0.0/20"
  network                  = google_compute_network.default.self_link
  region                   = var.region
  private_ip_google_access = true
}

resource "google_compute_global_address" "openid-ws-lb" {
  name       = "${var.network-name}-lb"
  ip_version = var.ip-version
}
