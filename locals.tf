locals {
    # Networking
    vcn_name = "${var.deployment_name}-vcn"
    lb_subnet_name = "${var.deployment_name}-lb-subnet"
    nodes_subnet_name = "${var.deployment_name}-nodes-subnet"
    
    # OKE
    cluster_name = "${var.deployment_name}-oke"
    node_pool_name = "${var.deployment_name}-node_pool"
}