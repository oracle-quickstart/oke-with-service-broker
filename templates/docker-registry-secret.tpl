if [[ ! $(kubectl get secret ocir-secret) ]]; then
    kubectl create secret docker-registry ocir-secret --docker-server=${region}.ocir.io --docker-username='${tenancy_name}/${ocir_username}' --docker-password='${ocir_token}' --docker-email='jdoe@acme.com'
fi