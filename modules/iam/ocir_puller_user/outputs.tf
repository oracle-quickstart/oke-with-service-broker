## Copyright © 2021, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

output "credentials" {
    value = {
        username = "${data.oci_objectstorage_namespace.tenancy_namespace.namespace}/${oci_identity_user.ocir_puller_user.name}"
        token = oci_identity_auth_token.ocir_puller_auth_token.token
    }
}
