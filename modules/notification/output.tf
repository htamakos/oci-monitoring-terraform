output "ons_sub_id" {
  value = "${oci_ons_subscription.email.id}"
}

output "topic_id" {
  value = "${oci_ons_notification_topic.topic.id}"
}
