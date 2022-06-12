# https://registry.terraform.io/providers/oracle/oci/latest/docs
#  https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/terraformproviderconfiguration.htm#APIKeyAuth
terraform {
  required_providers {
    oci = {
      source = "oracle/oci"
      version = "4.79.0"
    }
  }
}

provider "oci" {
   tenancy_ocid = var.tenancy
   user_ocid = var.user
   fingerprint = var.fingerprint
   private_key_path = var.key_file
   region = var.region
}

# virtual cloud network

resource "oci_core_vcn" "my-vcn" {
    #Required
    compartment_id = var.compartment_id

    #Optional
    cidr_block = var.vcn_cidr_block
    display_name = "${var.env_prefix}-vcn"

}

# subnet

resource "oci_core_subnet" "subnet-1" {
    #Required
    cidr_block = var.subnet_cidr_block
    compartment_id = var.compartment_id
    vcn_id = oci_core_vcn.my-vcn.id

    #Optional
    display_name = "${var.env_prefix}-subnet-1"
    # route_table_id = oci_core_route_table.test_route_table.id

}

# internet gateway

resource "oci_core_internet_gateway" "internet_gateway" {
    #Required
    compartment_id = var.compartment_id
    vcn_id = oci_core_vcn.my-vcn.id

    #Optional
    # enabled = var.internet_gateway_enabled #TODO check the default value
    display_name = "${var.env_prefix}-my-vcn-ig"

}

# routing table

resource "oci_core_route_table" "my-vcn-rt" {
    #Required
    compartment_id = var.compartment_id
    vcn_id = oci_core_vcn.my-vcn.id

    #Optional
   
    display_name = "${var.env_prefix}-my-vcn-rt"
   
    route_rules {
        #Required
        network_entity_id = oci_core_internet_gateway.internet_gateway.id

        #Optional
        # description = "internet gateway"  #check if it provides the correct destination 
        # destination = "0.0.0.0/0"
        # destination_type = "CIDR_BLOCK"
    }
}