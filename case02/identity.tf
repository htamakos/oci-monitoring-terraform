# Compartment
resource "oci_identity_compartment" "compartment" {
  provider       = "oci.home"
  compartment_id = "${var.tenancy_ocid}"
  description    = "ocs compartment"
  name           = "${var.compartment_name}"
}

resource "oci_identity_dynamic_group" "dynamic_group" {
  provider       = "oci.home"
  compartment_id = "${var.tenancy_ocid}"
  description    = "For Graphana"
  matching_rule  = "ALL {instance.compartment.id = '${oci_identity_compartment.compartment.id}' }"
  name           = "${var.name_prefix}_graphana"
}

resource "oci_identity_policy" "policy" {
  provider       = "oci.home"
  compartment_id = "${var.tenancy_ocid}"
  description    = "For Grafana"
  name           = "${var.name_prefix}_grapfana_policy"

  statements = [
    "Allow dynamic-group ${oci_identity_dynamic_group.dynamic_group.name} to read metrics in tenancy",
    "Allow dynamic-group ${oci_identity_dynamic_group.dynamic_group.name} to read compartments in tenancy",
  ]
}
