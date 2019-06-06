module "networking" {
  source          = "../modules/networking"
  vcn_cidr_block  = "172.168.0.0/16"
  pub_subnet_cidr = "172.168.1.0/24"
  compartment_id  = "${oci_identity_compartment.compartment.id}"
}

module "image" {
  source         = "../modules/image"
  version        = "0.0.1"
  compartment_id = "${oci_identity_compartment.compartment.id}"
}

module "instance" {
  source                  = "../modules/compute"
  version                 = "0.0.1"
  compartment_id          = "${oci_identity_compartment.compartment.id}"
  instance_name           = "bastion"
  subnet_id               = "${module.networking.subnet_id}"
  ssh_public_key          = "${var.ssh_public_key}"
  instance_image_id       = "${module.image.image_id}"
  pub_instance_private_ip = "172.168.1.12"
}

module "auto_scaling" {
  source            = "../modules/autoscaling"
  version           = "0.0.1"
  compartment_id    = "${oci_identity_compartment.compartment.id}"
  subnet_id         = "${module.networking.subnet_id}"
  instance_image_id = "${module.image.image_id}"
  ssh_public_key    = "${var.ssh_public_key}"
  AD                = "${module.image.AD}"
}

module "notification" {
  source = "../modules/notification"
  version = "0.0.1"
  compartment_id    = "${oci_identity_compartment.compartment.id}"
  ons_sub_endpoint = "${var.ons_sub_endpoint}"
}

module "monitoring" {
  source = "../modules/monitoring"
  version = "0.0.1"
  compartment_id    = "${oci_identity_compartment.compartment.id}"
  topic_id = "${module.notification.topic_id}"
  instance_pool_id = "${module.auto_scaling.instance_pool_id}"
}

output "bastion_ip" {
  value = "${module.instance.instance_gip}"
}

output "instance_pool_instance_ip" {
  value = "${module.auto_scaling.instance_pool_instance_ip}"
}

