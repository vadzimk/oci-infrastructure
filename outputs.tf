output "webserver-public_ip" {
  value = module.webserver.instance.public_ip
  sensitive = true
}
output "gitlab-runner-public_ip" {
  value = module.gitlab_runner.instance.public_ip
  sensitive = true
}

output "webserver-private_ip" {
  value = module.webserver.instance.private_ip
  sensitive = true
}
output "gitlab-runner-private_ip" {
  value = module.gitlab_runner.instance.private_ip
  sensitive = true
}

output "carshare-backend-user-id" {
  value = module.carshare_backend_user.oci_identity_user_id
  sensitive = true
}

# TODO remove this (already replaced)
#output "carshare-backend-user-id-key-fingerprint" {
#  value = module.carshare_backend_user.machine-user-id-key-fingerprint
#  sensitive = true
#}

output "carshare-backend-user-api-keys-first-fingerprint" {
  value = module.carshare_backend_user.machine-user-api-keys[0].fingerprint
  sensitive = true
}

output "pgbackups_user-api-keys-first-fingerprint" {
  value = module.pgbackups_user.machine-user-api-keys[0].fingerprint
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

output "db-backup-bucket-name" {
  value = oci_objectstorage_bucket.db-backup-bucket.name
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

locals {
  namespace =data.oci_objectstorage_namespace.tenancy-details-namespace.namespace
  region = data.oci_identity_region_subscriptions.tenancy-regions.region_subscriptions[0].region_name
}

output "region" {
  value = local.region
}

output "namespace" {
  value = local.namespace
}

output "S3-ServerAddress" {
  value = "${local.namespace}.compat.objectstorage.${local.region}.oraclecloud.com"
  sensitive = true
}