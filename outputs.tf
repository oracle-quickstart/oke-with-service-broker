## Copyright © 2020, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

output "docker_login_for_CI" {
    value = module.ocir_pusher.credentials
}

output "CI_user_credentials" {
    value = module.ci_user.credentials
}

output "kube_config" {
    value = module.cluster.kube_config
}
