#resource "google_compute_network" "default" {
#  name                    = var.network-name
#  auto_create_subnetworks = "false"
#}

resource "google_compute_network" "private_network" {
  provider = google-beta
  name = var.network-name
}

resource "google_compute_global_address" "private_ip_address" {
  provider = google-beta

  name          = "private-ip-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.private_network.self_link
}

resource "google_service_networking_connection" "private_vpc_connection" {
  provider = google-beta

  network                 = google_compute_network.private_network.self_link
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}

resource "google_compute_global_address" "openid-ws-lb" {
  name       = "${var.network-name}-lb"
  ip_version = var.ip-version
}

#resource "google_compute_subnetwork" "default" {
#  name                     = var.network-name
#  ip_cidr_range            = "10.126.0.0/20"
#  network                  = google_compute_network.default.self_link
#  region                   = var.region
#  private_ip_google_access = true
#}

#resource "google_compute_global_address" "openid-ws-lb" {
#  name       = "${var.network-name}-lb"
#  ip_version = var.ip-version
#}
