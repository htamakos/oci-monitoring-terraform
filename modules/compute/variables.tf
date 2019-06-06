# Common
variable "name_prefix" {
  default = "ocs"
}

# Identities
variable "compartment_id" {}

# Networking
variable "subnet_id" {}

# Compute
variable "instance_name" {
  default = "instance"
}

variable "ssh_public_key" {}

variable "instance_shape" {
  default = "VM.Standard2.1"
}

variable "instance_image_id" {}

variable "pub_instance_private_ip" {}
