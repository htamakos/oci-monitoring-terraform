output "image_id" {
  value = "${lookup(data.oci_core_images.images.images[0], "id")}"
}

output "AD" {
  value = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[0], "name")}"
}
