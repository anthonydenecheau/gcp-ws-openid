resource "google_compute_managed_ssl_certificate" "default" {
  provider = google-beta
  project  = var.gce_lb["project"]

  name = "scc-docker-server-ssl-certificate"

  managed {
    domains = [ var.gce_lb["web_domain"] ]
  }
}

resource "google_compute_http_health_check" "openid-server" {
  name                = "openid-server"
  request_path        = "/"
  port                = 8080
  check_interval_sec  = 5
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 3

}

resource "google_compute_url_map" "default" {
  name            = "openid-url-map"
  description     = "access to openid server on GCE instances"
  default_service = google_compute_backend_service.scc-docker-server-openid.self_link

  host_rule {
    hosts        = ["*.elhadir.com"]
    path_matcher = "allpaths"
  }

  path_matcher {
    name            = "allpaths"
    default_service = google_compute_backend_service.scc-docker-server-openid.self_link

    path_rule {
      paths   = ["/*"]
      service = google_compute_backend_service.scc-docker-server-openid.self_link
    }
  }
}

resource "google_compute_backend_service" "scc-docker-server-openid" {
  name        = "scc-docker-server-openid"
  protocol    = "HTTP"
  port_name   = "openid"
  timeout_sec = 5

  backend {
    group                 = google_compute_region_instance_group_manager.default.instance_group
    balancing_mode        = "RATE"
    max_rate_per_instance = 100
  }
  
  health_checks = [google_compute_http_health_check.openid-server.self_link]
}

resource "google_compute_target_https_proxy" "default" {
  name             = "openid-proxy"
  url_map          = google_compute_url_map.default.self_link
  ssl_certificates = [ google_compute_managed_ssl_certificate.default.self_link ]
}

resource "google_compute_global_forwarding_rule" "default" {
  name   = "openidserver-rule"

  target = google_compute_target_https_proxy.default.self_link
  port_range = "443"
  load_balancing_scheme = "EXTERNAL"
  ip_protocol           = "TCP"
  ip_address            = var.gce_lb["public_ip_address"]
}
