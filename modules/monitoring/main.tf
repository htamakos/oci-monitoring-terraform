resource "oci_monitoring_alarm" "alarm" {
  compartment_id = "${var.compartment_id}"
  destinations = ["${var.topic_id}"]
  display_name = "${var.name_prefix}_alarm"
  is_enabled = true
  metric_compartment_id = "${var.compartment_id}"
  namespace = "${var.alarm_namespace}"
  query = "${var.instance_pool_id ==  "" ? var.alarm_query : local.alarm_query_}"
  severity = "CRITICAL"
}

