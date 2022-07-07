resource "oci_core_subnet" "dsubnet" {
  #Required
  cidr_block     = var.subnet_cidr_block
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.my-vcn.id

  #Optional
  display_name   = "${var.env_prefix}-subnet"
  route_table_id = oci_core_route_table.routing-table.id
}

# # duplicates the optional route_table_id parameter above but allows to attach multiple
# resource "oci_core_route_table_attachment" "my-vcn-rt_attachment_subnet-1" {
#   #Required    
#   subnet_id = oci_core_subnet.subnet-1.id
#   route_table_id =oci_core_route_table.my-vcn-rt.id
# }


# routing table

/*
Each VCN automatically comes with a default route table that has no rules. If you don't specify otherwise, every subnet uses the VCN's default route table. When you add route rules to your VCN, you can simply add them to the default table if that suits your needs. However, if you need both a public subnet and a private subnet (for example, see Scenario C: Public and Private Subnets with a VPN), you instead create a separate (custom) route table for each subnet. 
*/

# new routing table
resource "oci_core_route_table" "routing-table" {
  #Required
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.my-vcn.id

  #Optional

  display_name = "${var.env_prefix}-subnet-rt"

  route_rules {
    #Required
    network_entity_id = oci_core_internet_gateway.internet-gateway.id

    #Optional
    description      = "internet gateway"
    destination      = "0.0.0.0/0" # required
    destination_type = "CIDR_BLOCK"
  }
}
