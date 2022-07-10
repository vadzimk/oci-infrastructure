terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "4.79.0"
    }
  }
}

resource "oci_identity_user" "machine-user" {
  #Required
  compartment_id = var.tenancy
  description    = var.user_description
  name           = var.user_name
  email          = var.user_email
}

resource "oci_identity_api_key" "machine-user-key" {
  #Required
  key_value = file(var.public_key_path)
  user_id   = data.oci_identity_user.machine-user.id
}

resource "oci_identity_user_group_membership" "carshare-backend-group-membership" {
  #Required
  group_id = var.group_id
  user_id  = data.oci_identity_user.machine-user.id
}
