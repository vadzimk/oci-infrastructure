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
variable "instance_shape" {}
variable "image_operating_system" {}
variable "image_operating_system_version" {}
variable "public_key_path" {}
variable "image_shape" {}