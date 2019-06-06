resource "oci_core_instance" "pub_instance" {
  compartment_id      = "${var.compartment_id}"
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[0], "name")}"
  shape               = "${var.instance_shape}"

  create_vnic_details {
    subnet_id = "${var.subnet_id}"

    assign_public_ip = true
    hostname_label   = "${var.name_prefix}-${var.instance_name}"
    private_ip       = "${var.pub_instance_private_ip}"
  }

  display_name   = "${var.name_prefix}-${var.instance_name}"
  hostname_label = "${var.name_prefix}-${var.instance_name}"

  metadata {
    ssh_authorized_keys = "${var.ssh_public_key}"
  }

  source_details {
    source_id   = "${var.instance_image_id}"
    source_type = "image"
  }

  preserve_boot_volume = false
}
