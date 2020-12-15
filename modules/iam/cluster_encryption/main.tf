resource "oci_identity_dynamic_group" "cluster_dynamic_group" {
    #Required
    compartment_id = var.tenancy_ocid
    description = "OKE Clusters"
    matching_rule = "ALL {resource.type = 'cluster', resource.compartment.id = '${var.compartment_ocid}'}"
    name = "oke_${md5(var.compartment_ocid)}"
}

resource "oci_identity_policy" "k8s_secrets_policy" {
    count = var.secrets_encryption_key_ocid == null ? 0 : 1
    depends_on = [oci_identity_dynamic_group.cluster_dynamic_group]
    #Required
    compartment_id = var.tenancy_ocid
    description = "OKE Secrets encryption policies"
    name = "OKE_Secrets"
    statements = [
        # "Allow dynamic-group oke_${md5(var.compartment_ocid)} to use keys in compartment id ${var.compartment_ocid} where target.key.id = '${var.secrets_encryption_key_ocid}'",
        # "Allow service oke to use keys in compartment id ${var.compartment_ocid} where target.key.id = '${var.secrets_encryption_key_ocid}'"
        "Allow dynamic-group oke_${md5(var.compartment_ocid)} to use keys in tenancy where target.key.id = '${var.secrets_encryption_key_ocid}'",
        "Allow service oke to use keys in tenancy where target.key.id = '${var.secrets_encryption_key_ocid}'"
    ]
}
