# https://registry.terraform.io/providers/oracle/oci/latest/docs
# https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/terraformproviderconfiguration.htm#APIKeyAuth

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

# Webserver Instance

module "webserver" {
  display_name                   = "webserver"
  source                         = "./modules/micro_instance"
  compartment_id                 = var.compartment_id
  vcn_id                         = oci_core_vcn.my-vcn.id
  allow_ssh_from_anywhere        = var.allow_ssh_from_anywhere
  myip                           = var.myip
  instance_shape                 = var.instance_shape
  subnet_id                      = oci_core_subnet.dsubnet.id
  nsg_ids                        = [oci_core_network_security_group.webserver-nsg.id]
  private_ip                     = var.web_server_private_ip
  public_key_path                = var.public_key_path
  image_operating_system         = var.image_operating_system
  image_operating_system_version = var.image_operating_system_version
  env_prefix                     = var.env_prefix
  user_data_path                 = "./init-instance.sh"
}


# Gitlab runner Instance

module "gitlab_runner" {
  display_name            = "gitlab-runner"
  source                  = "./modules/micro_instance"
  compartment_id          = var.compartment_id
  vcn_id                  = oci_core_vcn.my-vcn.id
  allow_ssh_from_anywhere = var.allow_ssh_from_anywhere
  myip                    = var.myip
  instance_shape          = var.instance_shape
  subnet_id               = oci_core_subnet.dsubnet.id
  nsg_ids                 = [
    oci_core_network_security_group.webserver-nsg.id,
    oci_core_network_security_group.gitlab-runner-nsg.id
  ]
  private_ip                     = var.gitlab_runner_private_ip
  public_key_path                = var.public_key_path
  image_operating_system         = var.image_operating_system
  image_operating_system_version = var.image_operating_system_version
  env_prefix                     = var.env_prefix
  user_data_path                 = "./init-instance.sh"
}

# Object storage bucket (for carshare app)

resource "oci_objectstorage_bucket" "image-bucket" {
  #Required
  compartment_id = var.compartment_id
  name           = var.carshare_bucket_name
  namespace      = var.bucket_namespace

  #Optional
  access_type  = var.bucket_access_type
  storage_tier = var.bucket_storage_tier
  auto_tiering = var.bucket_auto_tiering
  versioning   = var.bucket_versioning
}

# user (for carshare app)
module "carshare_backend_user" {
  user_name        = "carshare-backend-user"
  source       = "./modules/machine_user"
  user_description = "backend user for carshare app"
  group_id         = var.admin_group_id
  public_key_path  = var.carshare_public_key_path
  tenancy          = var.tenancy
  user_email       = var.carshare_user_email
}

# user (for gitlab-runner distributed cache)
module "gitlab_runner_user" {
  user_name        = "gitlab-runner-user"
  source       = "./modules/machine_user"
  user_description = "gitlab runner user for distributed cache bucket"
  group_id         = var.admin_group_id
  public_key_path  = var.carshare_public_key_path
  tenancy          = var.tenancy
  user_email       = var.carshare_user_email
}

resource "oci_identity_customer_secret_key" "gitlab-runner-customer"{
  #Required
  display_name = var.gitlab_runer_customer_secret_key_display_name
  user_id = module.gitlab_runner_user.oci_identity_user_id
}

# Object storage bucket (for gitlab distributed cache)

resource "oci_objectstorage_bucket" "gitlab-cache-bucket" {
  #Required
  compartment_id = var.compartment_id
  name           = var.gitlab_bucket_name
  namespace      = var.bucket_namespace

  #Optional
  access_type  = var.bucket_access_type
  storage_tier = var.bucket_storage_tier
  auto_tiering = var.bucket_auto_tiering
  versioning   = var.bucket_versioning
}
