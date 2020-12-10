## Copyright © 2020, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

output "kube_config_cmd" {
    value = "mkdir -p $HOME/.kube/ && [[ $(cat $HOME/.kube/config | grep ${module.cluster.cluster.id} 2> /dev/null | wc -l) == \"0\" ]] && oci ce cluster create-kubeconfig --cluster-id ${module.cluster.cluster.id} --file $HOME/.kube/config --region ${var.region} --token-version 2.0.0"
}

output "ocir_secret_cmd" {
    value = "kubectl create secret docker-registry ocir-secret --docker-server=${lookup(var.ocir_region_map, var.region)}.ocir.io --docker-username='${data.oci_identity_tenancy.tenancy.name}/${module.ocir_user.ocir_credentials.username}' --docker-password='${module.ocir_user.ocir_credentials.token}' --docker-email='jdoe@acme.com'"
}