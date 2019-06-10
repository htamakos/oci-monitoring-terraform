### Virtual Cloud Network
resource "oci_core_vcn" "vcn" {
  compartment_id = "${var.compartment_id}"
  cidr_block     = "${var.vcn_cidr_block}"
  display_name   = "${var.name_prefix}_vcn"
  dns_label      = "vcn"
}

### Internet Gateway
resource "oci_core_internet_gateway" "ig" {
  compartment_id = "${var.compartment_id}"
  vcn_id         = "${oci_core_vcn.vcn.id}"

  display_name = "${var.name_prefix}_ig"
}

### Route Table
#### Public
resource "oci_core_route_table" "pub_rt" {
  compartment_id = "${var.compartment_id}"

  route_rules {
    destination       = "${var.public_cidr_block}"
    network_entity_id = "${oci_core_internet_gateway.ig.id}"
  }

  vcn_id       = "${oci_core_vcn.vcn.id}"
  display_name = "${var.name_prefix}_pub_rt"
}

### SecurityLists
resource "oci_core_security_list" "pub_sl" {
  compartment_id = "${var.compartment_id}"

  # Outbound
  egress_security_rules {
    destination = "${var.public_cidr_block}"
    protocol    = "all"
  }

  # Inbound
  ## SSH
  ingress_security_rules {
    protocol = 6
    source   = "${var.public_cidr_block}"

    tcp_options {
      max = 22
      min = 22
    }
  }

  ## ICMP
  ingress_security_rules {
    protocol = 1
    source   = "${var.public_cidr_block}"
  }

  ingress_security_rules {
    protocol = 6
    source   = "${var.public_cidr_block}"

    tcp_options {
      max = 80
      min = 80
    }
  }

  ingress_security_rules {
    protocol = 6
    source   = "${var.public_cidr_block}"

    tcp_options {
      max = 3000
      min = 3000
    }
  }

  vcn_id       = "${oci_core_vcn.vcn.id}"
  display_name = "${var.name_prefix}_pub_sl"
}

### Subnets
resource "oci_core_subnet" "pub_subnet" {
  cidr_block        = "${var.pub_subnet_cidr}"
  compartment_id    = "${var.compartment_id}"
  security_list_ids = ["${oci_core_security_list.pub_sl.id}"]
  vcn_id            = "${oci_core_vcn.vcn.id}"

  display_name = "${var.name_prefix}_pub_subnet"
  dns_label    = "pub"

  prohibit_public_ip_on_vnic = false
  route_table_id             = "${oci_core_route_table.pub_rt.id}"
}
