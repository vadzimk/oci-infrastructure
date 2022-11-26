data "oci_objectstorage_namespace" "tenancy-details-namespace" {

  #Optional
  compartment_id = var.compartment_id
}


data "oci_identity_region_subscriptions" "tenancy-regions" {
  #Required
  tenancy_id = var.tenancy
}