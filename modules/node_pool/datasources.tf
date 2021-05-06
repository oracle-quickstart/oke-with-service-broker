## Copyright © 2021, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

data "oci_containerengine_node_pool_option" "node_pool_options" {
  node_pool_option_id = "all"
}

locals {
  node_pool_images = [for x in data.oci_containerengine_node_pool_option.node_pool_options.sources: x if replace(replace(x.source_name, "GPU", ""), "aarch64", "") == x.source_name]
}

data "oci_identity_availability_domains" "ads" {
  compartment_id = var.compartment_ocid
}
