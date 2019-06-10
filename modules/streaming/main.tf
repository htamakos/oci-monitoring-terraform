resource "oci_streaming_stream" "streaming" {
  compartment_id = "${var.compartment_id}"
  name = "${var.name_prefix}_${var.streaming_name}"
  partitions = "${var.partitions}"
}
