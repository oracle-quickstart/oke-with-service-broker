## Copyright © 2021, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

# OCI Registry docker login credentials for image pull
module "ocir_puller" {
  source            = "./modules/iam"
  user_ocid         = var.user_ocid
  tenancy_ocid      = var.tenancy_ocid
  region            = var.region
  user_description  = local.ocir_puller_user_description
  user_name         = local.ocir_puller_user_name
  group_ocid        = var.ocir_puller_group_ocid
  group_description = local.ocir_puller_group_description
  group_name        = local.ocir_puller_group_name
  policies = [{
    description = "OCIR pullers user policy"
    name        = "OCIR_pullers_policy_${local.idx}"
    statements = [
      "allow group ${local.ocir_puller_group_name} to read repos in tenancy",
    ]
  }]
  generate_api_key    = false
  generate_auth_token = true
  auth_token = var.auth_token
}

# OCI user for the OCI Service Broker to provision services
module "osb_user" {
  source            = "./modules/iam"
  user_ocid         = var.user_ocid
  tenancy_ocid      = var.tenancy_ocid
  region            = var.region
  user_description  = local.osb_user_description
  user_name         = local.osb_user_name
  group_ocid        = var.osb_group_ocid
  group_description = local.osb_group_description
  group_name        = local.osb_group_name
  policies = [{
    description = "OCI Service broker user policy"
    name        = "OCI_Service_Broker_user_policy_${local.idx}"
    statements = [
      "allow group ${local.osb_group_name} to manage autonomous-database-family in tenancy where request.region = '${var.region}'",
      "allow group ${local.osb_group_name} to manage buckets in tenancy where request.region = '${var.region}'",
      "allow group ${local.osb_group_name} to manage streams in tenancy where request.region = '${var.region}'"
    ]
  }]
  generate_api_key    = true
  generate_auth_token = false
}
