## Copyright © 2021, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

# output "kube_config" {
#   value = module.cluster.kube_config
# }

output "auth_token" {
  value = var.ocir_puller_user_ocid == null ? "" : module.ocir_puller.auth_token
}