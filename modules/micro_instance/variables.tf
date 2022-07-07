variable "compartment_id"{}
variable "vcn_id"{}
variable "allow_ssh_from_anywhere"{
    default = false
}
variable "myip"{}
variable "instance_shape"{}
variable "subnet_id"{}
variable "public_key_path"{}
variable "image_operating_system_version" {}
variable "env_prefix" {}
variable "image_operating_system" {}
variable "user_data_path" {}
variable "private_ip" {}
variable "display_name" {}
variable "nsg_ids" {
    type = list(string)
}
