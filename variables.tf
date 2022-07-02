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
variable "web_server_private_ip" {}

# --------------------
variable "bucket_name" {}
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
variable "carshare_public_key_path" {}
variable "admin_group_id" {}
variable "carshare_user_email" {}