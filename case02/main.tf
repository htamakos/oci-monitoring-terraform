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

module "compute_grafana" {
  source                  = "../modules/compute"
  version                 = "0.0.1"
  compartment_id          = "${oci_identity_compartment.compartment.id}"
  ssh_public_key          = "${var.ssh_public_key}"
  instance_image_id       = "${module.image.image_id}"
  instance_name           = "graphana"
  subnet_id               = "${module.networking.subnet_id}"
  pub_instance_private_ip = "172.168.1.11"
}

module "compute_web" {
  source                  = "../modules/compute"
  version                 = "0.0.1"
  compartment_id          = "${oci_identity_compartment.compartment.id}"
  ssh_public_key          = "${var.ssh_public_key}"
  instance_image_id       = "${module.image.image_id}"
  instance_name           = "web"
  subnet_id               = "${module.networking.subnet_id}"
  pub_instance_private_ip = "172.168.1.12"
}

module "streaming" {
  source         = "../modules/streaming"
  version        = "0.0.1"
  compartment_id = "${oci_identity_compartment.compartment.id}"
}

module "notification" {
  source           = "../modules/notification"
  version          = "0.0.1"
  compartment_id   = "${oci_identity_compartment.compartment.id}"
  ons_sub_endpoint = "${var.ons_sub_endpoint}"
}

module "monitoring" {
  source         = "../modules/monitoring"
  version        = "0.0.1"
  compartment_id = "${oci_identity_compartment.compartment.id}"
  topic_id       = "${module.notification.topic_id}"
  alarm_query    = "PutMessagesSuccess.Count[1m]{resourceId = \"${module.streaming.streaming_id}\"}.sum()"
}

output "grafana_ip" {
  value = "${module.compute_grafana.instance_gip}"
}

output "web_ip" {
  value = "${module.compute_web.instance_gip}"
}

output "streaming_id" {
  value = "${module.streaming.streaming_id}"
}
