# OCIR user, used to create, push, pull images to OCI Registry

resource "oci_identity_user" "ocir_user" {
    #Required
    compartment_id = var.tenancy_ocid
    description = "OCIR user for ${var.cluster_id}"
    name = "ocir_user_${md5(var.cluster_id)}"
}

resource "oci_identity_group" "ocir_users_group" {
    #Required
    compartment_id = var.tenancy_ocid
    description = "OCIR users for ${var.cluster_id}"
    name = "ocir_users_${md5(var.cluster_id)}"
}

resource "oci_identity_user_group_membership" "ocir_group_membership" {
    #Required
    group_id = oci_identity_group.ocir_users_group.id
    user_id = oci_identity_user.ocir_user.id
}

resource "oci_identity_policy" "ocir_user_policy" {
    #Required
    compartment_id = var.tenancy_ocid
    description = "OCIR user policy"
    name = "OCIR_user_policy"
    statements = [
        "allow group ocir_users_${md5(var.cluster_id)} to use repos in tenancy"
    ]
}

resource "oci_identity_auth_token" "ocir_auth_token" {
    #Required
    description = "OCIR Token"
    user_id = oci_identity_user.ocir_user.id
}
