variable "compartment_id" {}
variable "topic_id" {}
variable "name_prefix" {
  default = "ocs"
}

variable "alarm_body" {
  default = "High CPU utilization reached"
}

variable "alarm_compartment_id_in_subtree" {
  default = false
}

variable "alarm_is_enabled" {
  default = true
}

variable "alarm_metric_compartment_id_in_subtree" {
  default = false
}

variable "alarm_namespace" {
  default = "oci_computeagent"
}

variable "alarm_pending_duration" {
  default = "PT5M"
}

variable "alarm_query" {
  default = "CpuUtilization[10m].percentile(0.9) < 85"
}

variable "alarm_repeat_notification_duration" {
  default = "PT2H"
}

variable "alarm_resolution" {
  default = "1m"
}

variable "alarm_severity" {
  default = "WARNING"
}

variable "alarm_state" {
  default = "ACTIVE"
}

variable "alarm_suppression_description" {
  default = "System Maintenance"
}

variable "alarm_history_collection_alarm_historytype" {
  default = "STATE_TRANSITION_HISTORY"
}

variable "alarm_status_compartment_id_in_subtree" {
  default = false
}

variable "alarm_status_display_name" {
  default = "High CPU Utilization"
}

variable "instance_pool_id" {
  default = ""
}

locals {
  alarm_query_ = "CPUUtilization[1m]{instancePoolId = \"${var.instance_pool_id}\"}.mean() > 80"
}

