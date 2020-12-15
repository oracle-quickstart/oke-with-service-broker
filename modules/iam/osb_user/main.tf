# OCI Service Broker user
resource "oci_identity_user" "osb_user" {
    #Required
    compartment_id = var.tenancy_ocid
    description = "OCI Service Broker user for ${var.cluster_id}"
    name = "osb_user_${md5(var.cluster_id)}"
}

resource "oci_identity_group" "osb_users_group" {
    #Required
    compartment_id = var.tenancy_ocid
    description = "OCI Service Broker users for ${var.cluster_id}"
    name = "osb_users_${md5(var.cluster_id)}"
}

resource "oci_identity_user_group_membership" "osb_group_membership" {
    #Required
    group_id = oci_identity_group.osb_users_group.id
    user_id = oci_identity_user.osb_user.id
}

resource "oci_identity_policy" "osb_user_policy" {
    depends_on = [oci_identity_group.osb_users_group]
    #Required
    compartment_id = var.tenancy_ocid
    description = "OCI Service broker user policy"
    name = "OCI_Service_Broker_user_policy"
    statements = [
        "allow group osb_users_${md5(var.cluster_id)} to manage autonomous-database-family in tenancy where request.region='${var.region}'",
        "allow group osb_users_${md5(var.cluster_id)} to manage buckets in tenancy where request.region='${var.region}'",
        "allow group osb_users_${md5(var.cluster_id)} to manage streams in tenancy where request.region='${var.region}'"
    ]
}

resource tls_private_key osb_user_private_key {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource local_file private_key_file {
  filename          = "./rsa_private_key.pem"
  sensitive_content = tls_private_key.osb_user_private_key.private_key_pem
}

resource oci_identity_api_key api_key {
  user_id   = oci_identity_user.osb_user.id
  key_value = tls_private_key.osb_user_private_key.public_key_pem
}
