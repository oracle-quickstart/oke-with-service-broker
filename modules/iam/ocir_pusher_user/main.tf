## Copyright © 2021, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

# OCIR user, used to create, push, pull images to OCI Registry

resource "oci_identity_user" "ocir_pusher_user" {
    #Required
    compartment_id = var.tenancy_ocid
    description = "OCIR pusher user for ${var.cluster_id}"
    name = "ocir_pusher_${md5(var.cluster_id)}"
}

resource "oci_identity_group" "ocir_pushers_group" {
    #Required
    compartment_id = var.tenancy_ocid
    description = "OCIR Pushers"
    name = "ocir_pushers"
}

resource "oci_identity_user_group_membership" "ocir_pushers_group_membership" {
    #Required
    group_id = oci_identity_group.ocir_pushers_group.id
    user_id = oci_identity_user.ocir_pusher_user.id
}

resource "oci_identity_policy" "ocir_pushers_policy" {
    depends_on = [oci_identity_group.ocir_pushers_group]
    #Required
    compartment_id = var.tenancy_ocid
    description = "OCIR pushers user policy"
    name = "OCIR_pushers_policy"
    statements = [
        "allow group ocir_pushers to use repos in tenancy",
        "allow group ocir_pushers to manage repos in tenancy where ANY {request.permission = 'REPOSITORY_CREATE', request.permission = 'REPOSITORY_UPDATE'}"
    ]
}

resource "oci_identity_auth_token" "ocir_pusher_auth_token" {
    #Required
    description = "OCIR Token"
    user_id = oci_identity_user.ocir_pusher_user.id
}
