#locals {
#    # Networking
#    vcn_name = "${var.deployment_name}-vcn"
#    lb_subnet_name = "${var.deployment_name}-lb-subnet"
#    nodes_subnet_name = "${var.deployment_name}-nodes-subnet"
#    
#    # OKE
#    cluster_name = "${var.deployment_name}-oke"
#    node_pool_name = "${var.deployment_name}-node_pool"
#}

# random integer id suffix for the users
resource "random_integer" "random" {
  min = 1
  max = 100
}

locals {
  cluster_name                  = "${var.deployment_name}-oke"
  cluster_idx                   = substr(md5(module.cluster.cluster.id), 0, 4)
  idx                           = random_integer.random.result
  user_idx                      = "${local.cluster_idx}_${local.idx}"
  ocir_puller_user_name         = "ocir_puller_${local.user_idx}"
  ocir_puller_user_description  = "OCIR puller user for ${module.cluster.cluster.id}"
  ocir_puller_group_name        = "ocir_pullers_${local.idx}"
  ocir_puller_group_description = "OCIR puller users ${local.idx}"
  osb_user_name                 = "osb_user_${local.user_idx}"
  osb_user_description          = "OCI Service Broker user for ${module.cluster.cluster.id}"
  osb_group_name                = "osb_users_${local.idx}"
  osb_group_description         = "OCI Service Broker users ${local.idx}"
}