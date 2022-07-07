output "webserver-public_ip" {
  value = module.webserver.ws-instance.public_ip
}
output "gitlab-runner-public_ip" {
  value = module.gitlab_runner.ws-instance.public_ip
}

output "carshare-backend-user-id" {
  value = data.oci_identity_user.carshare-backend-user.id
}

output "carshare-backend-user-id-key-fingerprint" {
  value = data.oci_identity_api_keys.carshare-backend-user-api-keys.api_keys[0].fingerprint
}