data "google_compute_image" "default" {
  family  = lookup(var.gce_image, "family")
}

resource "google_compute_instance_template" "default" {
  description = lookup(var.gce_instance, "description", "no description")

  labels = {
    owner       = "anthony-denecheau"
    project     = "custom-docker-server-image"
    environment = "dev"
  }

  tags = [ "allow-ssh", "allow-openidserver" ]

  instance_description  = lookup(var.gce_instance, "description", "my new instance")
  machine_type          = lookup(var.gce_instance, "type", "n1-standard-2")
  can_ip_forward        = false
  name_prefix           = lookup(var.gce_instance, "name_prefix", "new_instance_")

  metadata = merge(
    map(
      "startup-script", file(format("%s/code/startup_script.sh", path.cwd)),
      "docker-compose-yaml", file(format("%s/code/docker-compose.yml", path.cwd)),
      "database-private-ip", var.gce_instance["database_private_ip"],
      "database-user", var.gce_instance["database_user"],
      "database-generated-password", var.gce_instance["database_generated_password"],
      "application-name", var.gce_instance["application_name"]
    )
  )

  scheduling {
    automatic_restart   = true       // cannot be TRUE if preemptible is TRUE too
    on_host_maintenance = "TERMINATE" // mandatory when preemptible is TRUE
    preemptible         = false
  }

  lifecycle {
    create_before_destroy = true
  }


  // Create a new boot disk from an image
  disk {
    source_image = data.google_compute_image.default.self_link
    auto_delete  = true
    boot         = true
  }

  network_interface {
    #subnetwork = var.gce_instance["subnetwork"]
    network = var.gce_instance["network"]
    access_config {
      // Ephemeral IP
    }
  }

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro","logging-write"]
  }
}

resource "google_compute_firewall" "default-ssh" {
  count   = "1"
  name    = "${lookup(var.gce_instance, "name_prefix", "new_instance_")}-vm-ssh"
  network = var.gce_instance["network"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["allow-ssh"]
}

resource "google_compute_firewall" "default-openidserver" {
  count   = "1"
  name    = "${lookup(var.gce_instance, "name_prefix", "new_instance_")}-vm-https"
  network = var.gce_instance["network"]

  # allow outgoing connections on TCP port 3307
  # Cf. https://github.com/GoogleCloudPlatform/cloud-sql-jdbc-socket-factory/blob/master/README.md
  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }

  source_ranges = ["130.211.0.0/22", "35.191.0.0/16" ]
  target_tags   = ["allow-openidserver"]
}
