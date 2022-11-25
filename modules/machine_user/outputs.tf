output "oci_identity_user_id" {
  value = data.oci_identity_user.machine-user.id
}
#output "machine-user-id-key-fingerprint" {
#  value = data.oci_identity_api_keys.machine-user-api-keys.api_keys[0].fingerprint
#}