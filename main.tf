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
    vcn_id = oci_core_vcn.my-vcn.id

    #Optional
    enabled = var.internet_gateway_enabled #TODO check the default value
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
    vcn_id = oci_core_vcn.my-vcn.id

    #Optional
   
    display_name = "${var.env_prefix}-my-vcn-rt"
   
    route_rules {
        #Required
        network_entity_id = oci_core_internet_gateway.internet_gateway.id

        #Optional
        description = "internet gateway"  
        destination = "0.0.0.0/0" # required
        destination_type = "CIDR_BLOCK"
    }
}

