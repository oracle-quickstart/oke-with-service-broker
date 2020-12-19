## Copyright © 2020, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

# OCI Registry docker login credentials for image pull
module "ocir_puller" {
  source = "./modules/iam/ocir_puller_user"
  tenancy_ocid = var.tenancy_ocid
  cluster_id = module.cluster.cluster.id
}

# OCI user for the OCI Service Broker to provision services
module "osb_user" {
  source = "./modules/iam/osb_user"
  tenancy_ocid = var.tenancy_ocid
  compartment_ocid = var.compartment_ocid
  cluster_id = module.cluster.cluster.id
  region = var.region
}

# OCI Registry docker loging credentials for CI to push images to registry
module "ocir_pusher" {
  source = "./modules/iam/ocir_pusher_user"
  tenancy_ocid = var.tenancy_ocid
  cluster_id = module.cluster.cluster.id
}

# OCI user with k8s cluster admin role for CI to deploy 
module "ci_user" {
  source = "./modules/iam/cluster_admin"
  tenancy_ocid = var.tenancy_ocid
  compartment_ocid = var.compartment_ocid
  cluster_id = module.cluster.cluster.id
  region = var.region
}
