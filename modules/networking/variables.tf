# Common
variable "name_prefix" {
  default = "ocs"
}

# Identities
variable "compartment_id" {}

# Networking
variable "public_cidr_block" {
  default = "0.0.0.0/0"
}

variable "vcn_cidr_block" {}
variable "pub_subnet_cidr" {}
