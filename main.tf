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

provider "oci" {
   tenancy_ocid = var.tenancy
   user_ocid = var.user
   fingerprint = var.fingerprint
   private_key_path = var.key_file
   region = var.region
}

resource "oci_core_vcn" "example" {
  dns_label = "example"
  cidr_block="172.16.0.0/20"
  compartment_id = "ocid1.compartment.oc1..aaaaaaaa5uclw46zflg3wi7ce3x2bpi4wkhrgntcmyqio3d5oayi2f7ftbtq"
  display_name = "Example vcn"
}
