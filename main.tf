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
  display_name = "${var.env_prefix}vcn"
  dns_label    = "${var.env_prefix}vcn"
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
  public_key_path                = var.public_key_path # this is ssh key for the vm
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
  public_key_path                = var.public_key_path # this is ssh key for the vm
  image_operating_system         = var.image_operating_system
  image_operating_system_version = var.image_operating_system_version
  env_prefix                     = var.env_prefix
  user_data_path                 = "./init-instance-gitlab-runner.sh"
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

# Object storage bucket for database backups

resource "oci_objectstorage_bucket" "db-backup-bucket" {
  #Required
  compartment_id = var.compartment_id
  name           = var.db_backup_bucket_name
  namespace      = var.db_bucket_namespace

  #Optional
  access_type  = var.db_bucket_access_type
  storage_tier = var.db_bucket_storage_tier
  auto_tiering = var.db_bucket_auto_tiering
  versioning   = var.db_bucket_versioning
}

# user (for carshare app)
module "carshare_backend_user" {
  user_name        = "carshare-backend-user"
  source           = "./modules/machine_user"
  user_description = "backend user for carshare app"
  group_id         = var.admin_group_id
  public_key_path  = var.machine_user_public_key_path
  tenancy          = var.tenancy
}

# user (for gitlab-runner distributed cache)
module "gitlab_runner_user" {
  user_name        = "gitlab-runner-user"
  source           = "./modules/machine_user"
  user_description = "gitlab runner user for distributed cache bucket"
  group_id         = var.admin_group_id
  public_key_path  = var.gitlab_user_public_key_path
  tenancy          = var.tenancy
}
resource "oci_identity_customer_secret_key" "gitlab-runner-customer" {
  #Required
  display_name = var.gitlab_runner_customer_secret_key_display_name
  user_id      = module.gitlab_runner_user.oci_identity_user_id
}

# user (for database backups)
module "pgbackups_user" {
  user_name        = "pgbackups-user"
  source           = "./modules/machine_user"
  user_description = "pgbackups user for db backups bucket"
  group_id         = var.admin_group_id # TODO assign it to another group that only has access to the bucket
  public_key_path  = var.pgbackups_user_public_key_path
  tenancy          = var.tenancy
}

# user (for strapi cms) needs these policy actions https://www.npmjs.com/package/@strapi/provider-upload-aws-s3
#"Action": [
#  "s3:PutObject",
#  "s3:GetObject",
#  "s3:ListBucket",
#  "s3:DeleteObject",
#  "s3:PutObjectAcl"
#],
module "strapi_user" {
  user_name        = "strapi-user"
  source           = "./modules/machine_user"
  user_description = "strapi user for cms"
  group_id         = var.admin_group_id # TODO assign it to another group that only has access to the bucket
  public_key_path  = var.strapi_user_public_key_path
  tenancy          = var.tenancy
}

resource "oci_identity_customer_secret_key" "strapi-user-customer" {
  #Required
  display_name = var.strapi_customer_secret_key_display_name
  user_id      = module.strapi_user.oci_identity_user_id
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

resource "oci_objectstorage_bucket" "strapi-media-bucket" {
  #Required
  compartment_id = var.compartment_id
  name           = var.strapi_media_bucket_name
  namespace      = var.bucket_namespace

  #Optional
  access_type  = var.strapi_media_bucket_access_type
  storage_tier = var.strapi_media_bucket_storage_tier
  auto_tiering = var.strapi_media_bucket_auto_tiering
  versioning   = var.strapi_media_bucket_versioning
}