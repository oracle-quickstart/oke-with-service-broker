# OCIR user, used to create, push, pull images to OCI Registry

resource "oci_identity_user" "ocir_puller_user" {
    #Required
    compartment_id = var.tenancy_ocid
    description = "OCIR puller user for ${var.cluster_id}"
    name = "ocir_puller_${md5(var.cluster_id)}"
}

resource "oci_identity_user" "ocir_pusher_user" {
    #Required
    compartment_id = var.tenancy_ocid
    description = "OCIR pusher user for ${var.cluster_id}"
    name = "ocir_pusher_${md5(var.cluster_id)}"
}

resource "oci_identity_group" "ocir_pullers_group" {
    #Required
    compartment_id = var.tenancy_ocid
    description = "OCIR Pullers"
    name = "ocir_pullers"
}

resource "oci_identity_group" "ocir_pushers_group" {
    #Required
    compartment_id = var.tenancy_ocid
    description = "OCIR Pushers"
    name = "ocir_pushers"
}

resource "oci_identity_user_group_membership" "ocir_pullers_group_membership" {
    #Required
    group_id = oci_identity_group.ocir_pullers_group.id
    user_id = oci_identity_user.ocir_puller_user.id
}

resource "oci_identity_user_group_membership" "ocir_pushers_group_membership" {
    #Required
    group_id = oci_identity_group.ocir_pushers_group.id
    user_id = oci_identity_user.ocir_pusher_user.id
}

resource "oci_identity_policy" "ocir_pullers_policy" {
    depends_on = [oci_identity_group.ocir_pullers_group]
    #Required
    compartment_id = var.tenancy_ocid
    description = "OCIR pullers user policy"
    name = "OCIR_pullers_policy"
    statements = [
        "allow group ocir_pullers to use repos in tenancy"
    ]
}

resource "oci_identity_policy" "ocir_pushers_policy" {
    depends_on = [oci_identity_group.ocir_pushers_group]
    #Required
    compartment_id = var.tenancy_ocid
    description = "OCIR pushers user policy"
    name = "OCIR_pushers_policy"
    statements = [
        "allow group ocir_pushers to manage repos in tenancy"
    ]
}

resource "oci_identity_auth_token" "ocir_puller_auth_token" {
    #Required
    description = "OCIR Token"
    user_id = oci_identity_user.ocir_puller_user.id
}

resource "oci_identity_auth_token" "ocir_pusher_auth_token" {
    #Required
    description = "OCIR Token"
    user_id = oci_identity_user.ocir_pusher_user.id
}
