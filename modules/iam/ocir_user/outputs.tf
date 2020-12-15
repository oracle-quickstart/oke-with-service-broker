output "ocir_puller_credentials" {
    value = {
        username = "${data.oci_objectstorage_namespace.tenancy_namespace.namespace}/${oci_identity_user.ocir_puller_user.name}"
        token = oci_identity_auth_token.ocir_puller_auth_token.token
    }
}

output "ocir_pusher_credentials" {
    value = {
        username = "${data.oci_objectstorage_namespace.tenancy_namespace.namespace}/${oci_identity_user.ocir_pusher_user.name}"
        token = oci_identity_auth_token.ocir_pusher_auth_token.token
    }
}