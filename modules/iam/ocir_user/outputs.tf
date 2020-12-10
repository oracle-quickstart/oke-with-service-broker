output "ocir_credentials" {
    value = {
        username = oci_identity_user.ocir_user.name
        token = oci_identity_auth_token.ocir_auth_token.token
    }
}