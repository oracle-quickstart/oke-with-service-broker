resource "oci_identity_dynamic_group" "instances_dynamic_group" {
    #Required
    compartment_id = var.tenancy_ocid
    description = "Nodes for cluster ${var.cluster_id}"
    matching_rule = "ALL {instance.compartment.id = '${var.compartment_ocid}'}"
    name = "oke_nodes_${md5(var.compartment_ocid)}"
}

resource "oci_identity_policy" "oke_logging_policy" {
    depends_on = [oci_identity_dynamic_group.instances_dynamic_group]
    #Required
    compartment_id = var.tenancy_ocid
    description = "OKE logging policy"
    name = "OKE_logging_policy"
    statements = [
        "allow dynamic-group oke_nodes_${md5(var.compartment_ocid)} to use log-content in tenancy"
    ]
}

resource "oci_logging_log_group" "oke_log_group" {
    #Required
    compartment_id = var.compartment_ocid
    display_name = "OKE-cluster"
    #Optional
    description = "OKE cluster ${var.cluster_id}"
    # defined_tags = {"Operations.CostCenter"= "42"}
    # freeform_tags = {"Department"= "Finance"}
}

resource "oci_logging_log" "oke_log" {
    #Required
    display_name = "OKE-log"
    log_group_id = oci_logging_log_group.oke_log_group.id
    log_type = "CUSTOM"

    #Optional
    configuration {
        #Required
        source {
            #Required
            category = "DYNAMIC_GROUP"
            resource = oci_identity_dynamic_group.instances_dynamic_group.id
            service = "OCISERVICE"
            source_type = "OCISERVICE"
        }

        #Optional
        compartment_id = var.compartment_ocid
    }
    # defined_tags = {"Operations.CostCenter"= "42"}
    # freeform_tags = {"Department"= "Finance"}
    is_enabled = true
    retention_duration = 30
}
