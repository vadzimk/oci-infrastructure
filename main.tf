# https://registry.terraform.io/providers/oracle/oci/latest/docs
#  https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/terraformproviderconfiguration.htm#APIKeyAuth
terraform {
  backend "http" {
    username = "gitlab-ci-token"
    password = "$CI_JOB_TOKEN"
    address = "$TF_ADDRESS"
    lock_address = "$TF_ADDRESS/lock"
    unlock_address = "$TF_ADDRESS/lock"
    lock_method = "POST"
    unlock_method = "DELETE"
    retry_wait_min = "5"
  }

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

# Virtual cloud network

resource "oci_core_vcn" "my-vcn" {
  #Required
  compartment_id = var.compartment_id

  #Optional
  cidr_block   = var.vcn_cidr_block
  display_name = "${var.env_prefix}-vcn"

}

# Internet gateway [Resource limit 1 per vcn]

resource "oci_core_internet_gateway" "internet-gateway" {
  #Required
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.my-vcn.id

  #Optional
  enabled      = var.internet_gateway_enabled
  display_name = "${var.env_prefix}-vcn-ig"

}



# Subnet
module "subnet1" {
  source                   = "./modules/subnet"
  subnet_cidr_block        = var.subnet_cidr_block
  compartment_id           = var.compartment_id
  vcn_id                   = oci_core_vcn.my-vcn.id
  env_prefix               = var.env_prefix
  internet_gateway_enabled = var.internet_gateway_enabled
  nametag                  = "1"
  internet_gateway_id      = oci_core_internet_gateway.internet-gateway.id

}


# Instance

module "webserver" {
  source                         = "./modules/webserver"
  compartment_id                 = var.compartment_id
  vcn_id                         = oci_core_vcn.my-vcn.id
  allow_ssh_from_anywhere        = var.allow_ssh_from_anywhere
  myip                           = var.myip
  instance_shape                 = var.instance_shape
  subnet_id                      = module.subnet1.subnet_obj.id
  web_server_private_ip          = var.web_server_private_ip
  public_key_path                = var.public_key_path
  image_operating_system         = var.image_operating_system
  image_operating_system_version = var.image_operating_system_version
  env_prefix                     = var.env_prefix
  user_data_path                 = "./init-webserver.sh"
}

# Object storage bucket

resource "oci_objectstorage_bucket" "test_bucket" {
    #Required
    compartment_id = var.compartment_id
    name = var.bucket_name
    namespace = var.bucket_namespace

    #Optional
    access_type = var.bucket_access_type
    storage_tier = var.bucket_storage_tier
    auto_tiering = var.bucket_auto_tiering
    versioning = var.bucket_versioning
}

