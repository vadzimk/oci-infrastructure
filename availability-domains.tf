

# Source from https://registry.terraform.io/providers/hashicorp/oci/latest/docs/data-sources/identity_availability_domains

# <tenancy-ocid> is the compartment OCID for the root compartment.
# Use <tenancy-ocid> for the compartment OCID.

data "oci_identity_availability_domains" "ads" {
  compartment_id = var.compartment_id
}

data "oci_core_images" "available_images" {
  #Required
  compartment_id = var.compartment_id

  #Optional
  operating_system = var.image_operating_system
  operating_system_version = var.image_operating_system_version
  shape = var.instance_shape  # only compatible wiht the instance shape 
}



