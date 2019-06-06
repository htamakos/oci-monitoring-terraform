output "instance_pool_instance_ip" {
  value = "${data.oci_core_instance.instance.public_ip}"
}

output "instance_pool_id" {
  value = "${oci_core_instance_pool.instance_pool.id}"
}
