data "oci_identity_user" "machine-user" {
  #Required
  user_id = oci_identity_user.machine-user.id
}

data "oci_identity_api_keys" "machine-user-api-keys" {
  #Required
  user_id = oci_identity_user.machine-user.id
}