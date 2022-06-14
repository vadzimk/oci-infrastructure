terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "4.79.0"
    }
  }
}

resource "oci_core_instance" "webserver" {
  # Required
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  compartment_id      = var.compartment_id
  shape               = var.instance_shape
  source_details {
    source_id   = data.oci_core_images.available_images.images[0].id
    source_type = "image"
  }

  # Optional
  display_name = "webserver"
  create_vnic_details {
    assign_public_ip = true
    # private_ip = var.instance_create_vnic_details_private_ip
    subnet_id = var.subnet_id
    nsg_ids = [
      oci_core_network_security_group.webserver-nsg.id
    ]
  }
  metadata = {
    ssh_authorized_keys = file(var.public_key_path)
    user_data           = filebase64(var.user_data_path)
  }

}
