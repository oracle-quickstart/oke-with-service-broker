
output credentials {
  value = {
    user_ocid = oci_identity_user.cluster_admin_user.id
    tenancy_ocid = var.tenancy_ocid
    region = var.region
    private_key_path       = local_file.cluster_admin_private_key_file.filename
    fingerprint = oci_identity_api_key.cluster_admin_api_key.fingerprint
  }
}
