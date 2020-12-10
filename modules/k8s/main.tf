## Copyright © 2020, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

resource "oci_containerengine_cluster" "cluster" {
  #Required
  compartment_id     = var.compartment_ocid
  kubernetes_version = var.oke_cluster["k8s_version"]
  name               = var.oke_cluster["name"]
  vcn_id             = var.vcn_id
  kms_key_id         = var.secrets_encryption_key_ocid

  #Optional
  options {
    service_lb_subnet_ids = [var.cluster_lb_subnet_id]

    #Optional
    add_ons {
      #Optional
      is_kubernetes_dashboard_enabled = var.cluster_options_add_ons_is_kubernetes_dashboard_enabled
      is_tiller_enabled               = var.cluster_options_add_ons_is_tiller_enabled
    }

    kubernetes_network_config {
      #Optional
      pods_cidr     = var.oke_cluster["pods_cidr"]
      services_cidr = var.oke_cluster["services_cidr"]
    }
  }
}
