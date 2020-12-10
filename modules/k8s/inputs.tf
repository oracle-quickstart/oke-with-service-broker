## Copyright © 2020, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

variable "compartment_ocid" {}
variable "vcn_id" {}
variable "oke_cluster" {
  default = {
    name           = "OKE_Cluster"
    k8s_version    = "v1.18.10"
    pool_name      = "Demo_Node_Pool"
    node_shape     = "VM.Standard2.1"
    pods_cidr      = "10.1.0.0/16"
    services_cidr = "10.2.0.0/16"
  }
}
variable "cluster_lb_subnet_id" {}
# variable "cluster_nodes_subnet_id" {}

variable "cluster_options_add_ons_is_kubernetes_dashboard_enabled" {
  default = true
}
variable "cluster_options_add_ons_is_tiller_enabled" {
  default = true
}
variable "secrets_encryption_key_ocid" {
  default = null
}