data "oci_core_instance_pool_instances" "instance_pool" {
  compartment_id = "${var.compartment_id}"
  instance_pool_id = "${oci_core_instance_pool.instance_pool.id}"
}

data "oci_core_instance" "instance" {
  instance_id = "${lookup(data.oci_core_instance_pool_instances.instance_pool.instances[0], "id")}"
}
