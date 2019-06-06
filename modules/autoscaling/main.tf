resource "oci_core_instance_configuration" "instance_config" {
  compartment_id = "${var.compartment_id}"
  display_name   = "${var.name_prefix}_instance_config"

  instance_details {
    instance_type = "compute"

    launch_details {
      compartment_id = "${var.compartment_id}"
      shape          = "${var.instance_shape}"
      display_name   = "${var.name_prefix}_instance_config_launch_detail"

      create_vnic_details {
        assign_public_ip       = true
        display_name           = "${var.name_prefix}_instance_config"
        skip_source_dest_check = false
      }

      source_details {
        source_type = "image"
        image_id    = "${var.instance_image_id}"
      }

      metadata {
        ssh_authorized_keys = "${var.ssh_public_key}"
      }
    }
  }
}

resource "oci_core_instance_pool" "instance_pool" {
  compartment_id            = "${var.compartment_id}"
  instance_configuration_id = "${oci_core_instance_configuration.instance_config.id}"
  size                      = 1
  state                     = "RUNNING"
  display_name              = "${var.name_prefix}_instance_pool"

  placement_configurations {
    availability_domain = "${var.AD}"
    primary_subnet_id   = "${var.subnet_id}"
  }
}

resource "oci_autoscaling_auto_scaling_configuration" "auto_scaling_config" {
  compartment_id       = "${var.compartment_id}"
  cool_down_in_seconds = "60"
  display_name         = "${var.name_prefix}_autoscaling"
  is_enabled           = "true"

  policies {
    capacity {
      initial = "1"
      max     = "2"
      min     = "1"
    }

    display_name = "${var.name_prefix}_autoscaling_policy"
    policy_type  = "threshold"

    rules {
      display_name = "${var.name_prefix}_autoscaling_rule_out"

      action {
        type  = "CHANGE_COUNT_BY"
        value = "1"
      }

      metric {
        metric_type = "CPU_UTILIZATION"

        threshold {
          operator = "GT"
          value    = "80"
        }
      }
    }

    rules {
      display_name = "${var.name_prefix}_autoscaling_rule_in"

      action {
        type  = "CHANGE_COUNT_BY"
        value = "-1"
      }

      metric {
        metric_type = "CPU_UTILIZATION"

        threshold {
          operator = "LT"
          value    = "30"
        }
      }
    }
  }

  auto_scaling_resources {
    id   = "${oci_core_instance_pool.instance_pool.id}"
    type = "instancePool"
  }
}
