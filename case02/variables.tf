variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}

variable "region" {}
variable "region_home" {}
variable "ssh_private_key" {}
variable "ssh_public_key" {}

variable "name_prefix" {
  default = "ocs"
}

variable "compartment_name" {
  default = "ocs_monitoring"
}

variable "ons_sub_endpoint" {}

variable "exec_web_request" {
  default = false
}

variable "exec_web_request_count" {
  default = 500
}

variable "provision" {
  default = false
}
