# OCI Service Broker user
resource "oci_identity_user" "cluster_admin_user" {
    #Required
    compartment_id = var.tenancy_ocid
    description = "cluster-admin user for ${var.cluster_id}"
    name = "cluster_admin_user_${md5(var.cluster_id)}"
}

resource "oci_identity_group" "cluster_admins_group" {
    #Required
    compartment_id = var.tenancy_ocid
    description = "cluster_admin users for ${var.cluster_id}"
    name = "cluster_admin_users_${md5(var.cluster_id)}"
}

resource "oci_identity_user_group_membership" "cluster_admins_group_membership" {
    #Required
    group_id = oci_identity_group.cluster_admins_group.id
    user_id = oci_identity_user.cluster_admin_user.id
}

resource "oci_identity_policy" "cluster_admins_policy" {
    depends_on = [oci_identity_group.cluster_admins_group]
    #Required
    compartment_id = var.tenancy_ocid
    description = "Cluster admins policy"
    name = "cluster_admins_policy"
    statements = [
        "allow group cluster_admin_users_${md5(var.cluster_id)} to use clusters in tenancy where request.region='${var.region}'"
    ]
}

resource "tls_private_key" "cluster_admin_private_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "local_file" "cluster_admin_private_key_file" {
  filename          = "./cluster_admin_rsa_private_key.pem"
  sensitive_content = tls_private_key.cluster_admin_private_key.private_key_pem
}

resource "oci_identity_api_key" "cluster_admin_api_key" {
  user_id   = oci_identity_user.cluster_admin_user.id
  key_value = tls_private_key.cluster_admin_private_key.public_key_pem
}

resource "local_file" "cluster_admin_oci_config_file" {
  filename          = "./cluster_admin_oci_config.txt"
  content = templatefile("./templates/oci_config.tpl", {
    fingerprint = oci_identity_api_key.cluster_admin_api_key.fingerprint
    user_ocid = oci_identity_user.cluster_admin_user.id
    private_key_path = local_file.cluster_admin_private_key_file.filename
    tenancy_ocid = var.tenancy_ocid
    region = var.region
  })
}
