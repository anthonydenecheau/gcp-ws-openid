resource "google_compute_target_pool" "default" {
  name = "scc-docker-server-instance-pool"
  
  health_checks = [
    google_compute_http_health_check.openid-server.name
  ]

}

resource "google_compute_region_instance_group_manager" "default" {
  name = lookup(var.gce_igm, "name", "default_igm")
  region = lookup(var.gce_igm, "region", "europe-west1")
  version {
    instance_template  = google_compute_instance_template.default.self_link
  }
  base_instance_name = lookup(var.gce_igm, "base_instance_name", "default")

  target_pools = [google_compute_target_pool.default.self_link]
  target_size = lookup(var.gce_igm, "target_size", 3)

  named_port {
    name = "openid"
    port = 8080
  }

}
