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

variable "tenancy" {}
variable "user" {}
variable "fingerprint" {}
variable "key_file" {}
variable "region" {}
variable "compartment_id" {}
variable "env_prefix" {
  default="development"
}
variable "vcn_cidr_block" {}
variable "subnet_cidr_block" {}




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

}
