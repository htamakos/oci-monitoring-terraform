output "instance_id" {
  value = "${oci_core_instance.pub_instance.id}"
}

output "instance_gip" {
  value = "${oci_core_instance.pub_instance.public_ip}"
}

output "instance_pri_ip" {
  value = "${oci_core_instance.pub_instance.private_ip}"
}

output "instance_image_id" {
  value = "${lookup(oci_core_instance.pub_instance.source_details[0], "source_id")}"
}

output "AD" {
  value = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[0], "name")}"
}
