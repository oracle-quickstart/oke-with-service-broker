
output credentials {
  value = {
    user_ocid = oci_identity_user.osb_user.id
    tenancy_ocid = var.tenancy_ocid
    region = var.region
    private_key_path       = local_file.private_key_file.filename
    fingerprint = oci_identity_api_key.api_key.fingerprint
  }
}