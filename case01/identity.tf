# Compartment
resource "oci_identity_compartment" "compartment" {
  provider       = "oci.home"
  compartment_id = "${var.tenancy_ocid}"
  description    = "ocs compartment"
  name           = "${var.compartment_name}"
}
