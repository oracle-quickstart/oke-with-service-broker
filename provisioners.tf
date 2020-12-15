# Configure the cluster with kube-config

resource "null_resource" "cluster_kube_config" {

    depends_on = [module.node_pools, module.cluster]

    provisioner "local-exec" {
        command = templatefile("./templates/cluster-kube-config.tpl",
            {
                cluster_id = module.cluster.cluster.id
                region = var.region
            })
    }
    provisioner "local-exec" {
        when = destroy
        command = "kubectl delete all --all"
        on_failure = continue
    }
}

# Create the cluster-admin user to use with the kubernetes dashboard

resource "null_resource" "oke_admin_service_account" {
    count = var.oke_cluster["cluster_options_add_ons_is_kubernetes_dashboard_enabled"] ? 1 : 0

    depends_on = [null_resource.cluster_kube_config]

    provisioner "local-exec" {
        command = "kubectl create -f ./templates/oke-admin.ServiceAccount.yaml"
    }
    provisioner "local-exec" {
        when = destroy
        command = "kubectl delete ServiceAccount oke-admin -n kube-system"
        on_failure = continue
    }
}

# Create the namespace for the OCI Service Broker and Service Catalog

resource "null_resource" "create_namespace" {

    depends_on = [null_resource.cluster_kube_config]

    provisioner "local-exec" {
        command = "kubectl create namespace oci-service-broker"
    }
    provisioner "local-exec" {
        when = destroy
        command = "kubectl delete namespace oci-service-broker"
        on_failure = continue
    }
}

# Create the OCIR user secret to use to push/pull docker images

resource "null_resource" "docker_registry" {

    depends_on = [null_resource.cluster_kube_config]

    provisioner "local-exec" {
        command = templatefile("./templates/docker-registry-secret.tpl",
            {
                region = var.region
                ocir_username = module.ocir_user.ocir_puller_credentials.username
                ocir_token = module.ocir_user.ocir_puller_credentials.token
            })
    }
    provisioner "local-exec" {
        when = destroy
        command = "kubectl delete secret ocir-secret"
        on_failure = continue
    }

}

# Create OCI credentials secret for use by the OCI Service Broker

resource "null_resource" "osb_credentials" {

    depends_on = [null_resource.create_namespace]

    provisioner "local-exec" {
        command = templatefile("./templates/osb-credentials-secret.tpl", module.osb_user.credentials)
    }
    provisioner "local-exec" {
        when = destroy
        command = "kubectl delete secret osb-credentials --namespace oci-service-broker"
        on_failure = continue
    }
}

# Deploy the Service Catalog helm chart

resource "null_resource" "deploy_service_catalog" {

    depends_on = [null_resource.create_namespace]

    provisioner "local-exec" {
        command = file("./templates/deploy-service-catalog.tpl")
    }
    provisioner "local-exec" {
        when = destroy
        command = "helm delete catalog --namespace oci-service-broker"
        on_failure = continue
    }
}



# Deploy the OCI Service Broker helm chart

resource "null_resource" "deploy_oci_service_broker" {

    depends_on = [null_resource.osb_credentials]

    provisioner "local-exec" {
        command = file("./templates/deploy-oci-service-broker.tpl")
    }
    provisioner "local-exec" {
        when = destroy
        command = "helm delete oci-service-broker --namespace oci-service-broker"
        on_failure = continue
    }
}

# Register the OCI Service Broker with the Service Catalog

resource "null_resource" "register_service_broker" {

    depends_on = [null_resource.deploy_oci_service_broker, null_resource.deploy_service_catalog]

    provisioner "local-exec" {
        command = "kubectl create -f ./templates/oci-service-broker.ClusterServiceBroker.yaml"
    }
    provisioner "local-exec" {
        when = destroy
        command = "kubectl delete ClusterServiceBroker oci-service-broker"
        on_failure = continue
    }
}
