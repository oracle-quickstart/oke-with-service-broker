## Copyright © 2021, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

variable "tenancy_ocid" {}
variable "compartment_ocid" {}
variable "region" {}
variable "user_ocid" {
  default = null
}
variable auth_token {
  default = null
}
variable "ssh_authorized_key" {}

variable "deployment_name" {
  default = "OKE"
}

variable "ocir_puller_user_ocid" {
  default = null
}
variable "ocir_puller_group_ocid" {
  default = null
}
variable "ocir_puller_auth_token" {
  default = null
}
variable "osb_user_ocid" {
  default = null
}
variable "osb_group_ocid" {
  default = null
}

variable "vcn_cidr" {
  default = "10.0.0.0/16"
}

variable "oke_cluster" {
  default = {
    k8s_version                                             = "v1.21.5"
    pods_cidr                                               = "10.1.0.0/16"
    services_cidr                                           = "10.2.0.0/16"
    cluster_options_add_ons_is_kubernetes_dashboard_enabled = true
    cluster_options_add_ons_is_tiller_enabled               = true
  }
}

variable "node_pools" {
  default = [
    {
      pool_name  = "pool1"
      node_shape = "VM.Standard2.1"
      node_count = 3
      node_labels = {
        "pool_name" = "pool1"
      }
    }
  ]
}

variable "secrets_encryption_key_ocid" {
  default = null
}
