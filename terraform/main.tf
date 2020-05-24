
# -----------------------------------------------------------------------------
# database
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# instances
# -----------------------------------------------------------------------------

module "scc-docker-servers" {
    source = "./instances"


    gce_image = {
        family = "scc-docker-server-image"
    }

    gce_igm = {
        name = "scc-docker-server-igm"
        region = var.region
        base_instance_name = "scc-docker-server"
        target_size = 1
    }

    gce_instance = {
        description = "This template is used to create docker server instances."
        type        = "n1-standard-2"
        name_prefix = "scc-docker-server-"
        #subnetwork  = google_compute_subnetwork.default.self_link
        #network     = google_compute_network.default.self_link
        network = google_compute_network.private_network.self_link
        application_name       = var.application_name
    }

    gce_lb = {
        public_ip_address = google_compute_global_address.openid-ws-lb.address
        web_domain        = var.web_domain
        project           = var.project
    }
}
