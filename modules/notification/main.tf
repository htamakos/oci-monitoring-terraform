resource "oci_ons_notification_topic" "topic" {
  compartment_id = "${var.compartment_id}"
  name = "${var.name_prefix}_topic"
}

resource "oci_ons_subscription" "email" {
  compartment_id = "${var.compartment_id}"
  endpoint = "${var.ons_sub_endpoint}"
  protocol = "EMAIL"
  topic_id = "${oci_ons_notification_topic.topic.id}"
}
