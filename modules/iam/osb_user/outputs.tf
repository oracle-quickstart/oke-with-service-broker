## Copyright © 2021, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

output credentials {
  value = {
    user_ocid = oci_identity_user.osb_user.id
    tenancy_ocid = var.tenancy_ocid
    region = var.region
    private_key_path       = local_file.private_key_file.filename
    fingerprint = oci_identity_api_key.api_key.fingerprint
  }
}