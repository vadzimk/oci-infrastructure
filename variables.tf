variable "tenancy" {}
variable "user" {}
variable "fingerprint" {}
variable "key_file" {}
variable "region" {}
variable "compartment_id" {}
variable "env_prefix" {
  default="dev"
}
variable "vcn_cidr_block" {}
variable "subnet_cidr_block" {}
variable "internet_gateway_enabled" {}
variable "myip" {}
variable "allow_ssh_from_anywhere"{
  default = false
}
variable "instance_shape" {}
variable "image_operating_system" {}
variable "image_operating_system_version" {}
variable "public_key_path" {}
variable "machine_user_public_key_path" {}
variable "machine_user_email" {}
variable "web_server_private_ip" {}
# --------------------

#variable "vcn_id" {}
#variable "nametag" {}
#variable "internet_gateway_id" {}


# --------------------
variable "carshare_bucket_name" {}
variable "bucket_namespace" {}
variable "bucket_access_type" {
  default = "NoPublicAccess"
}
variable "bucket_storage_tier" {
  default = "Standard"
}
variable "bucket_auto_tiering" {
  default = "Disabled"
}
variable "bucket_versioning" {
  default = "Disabled"
}

# ----------------------------
variable "pgbackups_user_public_key_path" {}
variable "db_backup_bucket_name" {}
variable "db_bucket_namespace" {}
variable "db_bucket_access_type" {
  default = "NoPublicAccess"
}
variable "db_bucket_storage_tier" {
  default = "Standard"
}
variable "db_bucket_auto_tiering" {
  default = "Disabled"
}
variable "db_bucket_versioning" {
  default = "Disabled"
}

variable "gitlab_runner_private_ip" {}
variable "gitlab_user_public_key_path" {}
variable "admin_group_id" {}

variable "gitlab_bucket_name" {}
variable "gitlab_runner_customer_secret_key_display_name" {}
variable "strapi_customer_secret_key_display_name" {}

variable "strapi_user_public_key_path" {}
variable "strapi_media_bucket_name" {}
variable "strapi_media_bucket_access_type" {
  default = "NoPublicAccess"
}
variable "strapi_media_bucket_storage_tier" {
  default = "Standard"
}
variable "strapi_media_bucket_auto_tiering" {
  default = "Disabled"
}
variable "strapi_media_bucket_versioning" {
  default = "Disabled"
}