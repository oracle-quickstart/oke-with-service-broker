data "oci_objectstorage_namespace" "tenancy_namespace" {

    #Optional
    compartment_id = var.tenancy_ocid
}