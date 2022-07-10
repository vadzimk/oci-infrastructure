# Security group

resource "oci_core_network_security_group" "gitlab-runner-nsg" {
  #Required
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.my-vcn.id

  #Optional
  display_name = "gitlab-runner-nsg"
}

