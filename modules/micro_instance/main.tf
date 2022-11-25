terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "4.79.0"
    }
  }
}

resource "oci_core_instance" "micro_instance" {
  # Required
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  compartment_id      = var.compartment_id
  shape               = var.instance_shape
  source_details {
    source_id   = data.oci_core_images.available_images.images[0].id
    source_type = "image"
  }

  # Optional
  display_name = var.display_name
  create_vnic_details {
    assign_public_ip = true
    private_ip = var.private_ip
    subnet_id = var.subnet_id
    nsg_ids = var.nsg_ids
#    https://docs.oracle.com/en-us/iaas/Content/Network/Concepts/dns.htm#About
    hostname_label = var.display_name
  }

  metadata = {
    ssh_authorized_keys = file(var.public_key_path)
    user_data           = filebase64(var.user_data_path)
  }
}
