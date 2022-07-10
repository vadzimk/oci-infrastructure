# Output the "list" of all availability domains.
output "all-availability-domains-in-your-tenancy" {
  value = data.oci_identity_availability_domains.ads.availability_domains
}

locals {
  image_name_id = [
    for img in data.oci_core_images.available_images.images : {
      id : img.id,
      name : img.display_name
    }
  ]
}

output "available-images" {
  value = local.image_name_id
  # value = data.oci_core_images.available_images.images
}

output "instance" {
  value = oci_core_instance.micro_instance
}