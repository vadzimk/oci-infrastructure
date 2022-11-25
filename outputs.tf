output "webserver-public_ip" {
  value = module.webserver.instance.public_ip
  sensitive = true
}
output "gitlab-runner-public_ip" {
  value = module.gitlab_runner.instance.public_ip
  sensitive = true
}

output "carshare-backend-user-id" {
  value = module.carshare_backend_user.oci_identity_user_id
  sensitive = true
}

output "carshare-backend-user-id-key-fingerprint" {
  value = module.carshare_backend_user.machine-user-id-key-fingerprint
  sensitive = true
}

output "gitlab-runner-user-id" {
  value = module.gitlab_runner_user.oci_identity_user_id
  sensitive = true
}

output "gitlab_runner_customer_secret_key_id" {
  value = oci_identity_customer_secret_key.gitlab-runner-customer.id
  sensitive = true
}

output "gitlab_runner_customer_secret_key_value" {
  value = oci_identity_customer_secret_key.gitlab-runner-customer.key
  sensitive = true
}

output "gitlab-cache-bucket-name" {
  value = oci_objectstorage_bucket.gitlab-cache-bucket.name
  sensitive = true
}

output "webserver-FQDN" {
  value = "${module.webserver.instance.hostname_label}.${oci_core_subnet.dsubnet.dns_label}.${oci_core_vcn.my-vcn.dns_label}.oraclevcn.com"
  sensitive = true
}

output "gitlab_runner-FQDN" {
  value = "${module.gitlab_runner.instance.hostname_label}.${oci_core_subnet.dsubnet.dns_label}.${oci_core_vcn.my-vcn.dns_label}.oraclevcn.com"
  sensitive = true
}