# https://registry.terraform.io/providers/oracle/oci/latest/docs
#  https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/terraformproviderconfiguration.htm#APIKeyAuth
terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "4.79.0"
    }
  }
}

provider "oci" {
  tenancy_ocid     = var.tenancy
  user_ocid        = var.user
  fingerprint      = var.fingerprint
  private_key_path = var.key_file
  region           = var.region
}

# virtual cloud network

resource "oci_core_vcn" "my-vcn" {
  #Required
  compartment_id = var.compartment_id

  #Optional
  cidr_block   = var.vcn_cidr_block
  display_name = "${var.env_prefix}-vcn"

}

# subnet

resource "oci_core_subnet" "subnet-1" {
  #Required
  cidr_block     = var.subnet_cidr_block
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.my-vcn.id

  #Optional
  display_name   = "${var.env_prefix}-subnet-1"
  route_table_id = oci_core_route_table.my-vcn-rt.id
}

# # duplicates the optional route_table_id parameter above
# resource "oci_core_route_table_attachment" "my-vcn-rt_attachment_subnet-1" {
#   #Required    
#   subnet_id = oci_core_subnet.subnet-1.id
#   route_table_id =oci_core_route_table.my-vcn-rt.id
# }

# internet gateway

resource "oci_core_internet_gateway" "internet_gateway" {
  #Required
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.my-vcn.id

  #Optional
  enabled      = var.internet_gateway_enabled #TODO check the default value
  display_name = "${var.env_prefix}-my-vcn-ig"

}

# routing table

/*
Each VCN automatically comes with a default route table that has no rules. If you don't specify otherwise, every subnet uses the VCN's default route table. When you add route rules to your VCN, you can simply add them to the default table if that suits your needs. However, if you need both a public subnet and a private subnet (for example, see Scenario C: Public and Private Subnets with a VPN), you instead create a separate (custom) route table for each subnet. 
*/

# new routing table
resource "oci_core_route_table" "my-vcn-rt" {
  #Required
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.my-vcn.id

  #Optional

  display_name = "${var.env_prefix}-my-vcn-rt"

  route_rules {
    #Required
    network_entity_id = oci_core_internet_gateway.internet_gateway.id

    #Optional
    description      = "internet gateway"
    destination      = "0.0.0.0/0" # required
    destination_type = "CIDR_BLOCK"
  }
}

# Security group

resource "oci_core_network_security_group" "vm1-NSG" {
  #Required
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.my-vcn.id

  #Optional
  display_name = "${var.env_prefix}-SG"
}

# SSH rule

resource "oci_core_network_security_group_security_rule" "ssh-rule" {
  #Required
  network_security_group_id = oci_core_network_security_group.vm1-NSG.id
  direction                 = "INGRESS"
  protocol                  = "6" # TCP protocol

  #Optional
  description = "Allow ssh"
  # destination = var.network_security_group_security_rule_destination
  # destination_type = var.network_security_group_security_rule_destination_type
  # usually limited number ip adresses can access but i allow it from anywhere in case i travel
  source      = "${var.myip}/32" # CIDR block consisting of just one address
  source_type = "CIDR_BLOCK"
  tcp_options {
    #Optional
    destination_port_range {
      #Required
      max = "22"
      min = "22"
    }
    source_port_range {
      #Required
      max = "22"
      min = "22"
    }

  }
}

# HTTP rule

resource "oci_core_network_security_group_security_rule" "http-rule" {
  #Required
  network_security_group_id = oci_core_network_security_group.vm1-NSG.id
  direction                 = "INGRESS"
  protocol                  = "6" # TCP protocol

  #Optional
  description = "Allow http"
  source      = "0.0.0.0/0" # all
  source_type = "CIDR_BLOCK"
  tcp_options {
    #Optional
    destination_port_range {
      #Required
      max = "8080"
      min = "8080"
    }
  }
}

# HTTPS rule

resource "oci_core_network_security_group_security_rule" "https-rule" {
  #Required
  network_security_group_id = oci_core_network_security_group.vm1-NSG.id
  direction                 = "INGRESS"
  protocol                  = "6" # TCP protocol

  #Optional
  description = "Allow https"
  source      = "0.0.0.0/0" # all
  source_type = "CIDR_BLOCK"
  tcp_options {
    #Optional
    destination_port_range {
      #Required
      max = "443"
      min = "443"
    }
  }
}

# Egress rule

resource "oci_core_network_security_group_security_rule" "egress-rule" {
  #Required
  network_security_group_id = oci_core_network_security_group.vm1-NSG.id
  direction                 = "EGRESS"
  protocol                  = "all" # TCP protocol

  #Optional
  description      = "Allow egress"
  destination      = "0.0.0.0/0"
  destination_type = "CIDR_BLOCK"

}

# Instance

resource "oci_core_instance" "vm1" {
  # Required
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  compartment_id      = var.compartment_id
  shape               = var.instance_shape
  source_details {
    source_id   = data.oci_core_images.available_images.images[0].id
    source_type = "image"
  }

  # Optional
  display_name = "vm1"
  create_vnic_details {
    assign_public_ip = true
    # private_ip = var.instance_create_vnic_details_private_ip
    subnet_id        = oci_core_subnet.subnet-1.id
    nsg_ids = [
      oci_core_network_security_group.vm1-NSG.id
    ]
  }
  metadata = {
    ssh_authorized_keys = file(var.public_key_path)
    user_data = filebase64("init-vm1.sh")
  }

}
