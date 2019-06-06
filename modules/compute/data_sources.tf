data "oci_core_images" "images" {
  compartment_id = "${var.compartment_id}"

  operating_system         = "Oracle Linux"
  operating_system_version = "7.6"
  shape                    = "${var.instance_shape}"
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
  state                    = "AVAILABLE"
}

data "oci_core_instance" "pub_instance" {
  instance_id = "${oci_core_instance.pub_instance.id}"
}

data "oci_identity_availability_domains" "ADs" {
  compartment_id = "${var.compartment_id}"
}
