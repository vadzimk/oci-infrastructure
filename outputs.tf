output "webserver-public_ip" {
  value = module.webserver.instance.public_ip
}
output "gitlab-runner-public_ip" {
  value = module.gitlab_runner.instance.public_ip
}

output "carshare-backend-user-id" {
  value = module.carshare_backend_user.oci_identity_user_id
}

output "carshare-backend-user-id-key-fingerprint" {
  value = module.carshare_backend_user.machine-user-id-key-fingerprint
}

output "gitlab-runner-user-id" {
  value = module.gitlab_runner_user.oci_identity_user_id
}

output "gitlab_runner_customer_secret_key_id" {
  value = oci_identity_customer_secret_key.gitlab-runner-customer.id
}

output "gitlab_runner_customer_secret_key_value" {
  value = oci_identity_customer_secret_key.gitlab-runner-customer.key
}

output "gitlab-cache-bucket-name" {
  value = oci_objectstorage_bucket.gitlab-cache-bucket.name
}