# -----------------------------------------------------------------------------
# vm instances
# -----------------------------------------------------------------------------

# description (default: my new instance)
# type (default: n1-standard-2)
# name_prefix (default: new_instance_)
# subnetwork          (mandatory)

variable "gce_instance" {
  description = "GCE Instance configuration"
  type        = map
}

# family (mandatory) The image used by GCE instances.
variable "gce_image" {
  description = "GCE Image configuration"
  type        = map
}

# name (default: default_igm) The name of the instance group manager.
# region (default: europe-west1) Region for GCE instances.
# base_instance_name (default: default)
variable "gce_igm" {
  description = "GCE Instance Group Manager configuration"
  type        = map
}

# public_ip_address (mandatory) The public IP address the load-balancer has to be associated to
variable "gce_lb" {
  description = "GCE Load-balancer configuration"
  type        = map
}
