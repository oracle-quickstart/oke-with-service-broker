if [[ ! $(kubectl get secret osb-credentials -n oci-service-broker) ]]; then
    kubectl create secret generic osb-credentials \
    -n oci-service-broker \
    --from-literal=tenancy=${tenancy_ocid} \
    --from-literal=user=${user_ocid} \
    --from-literal=fingerprint=${fingerprint} \
    --from-literal=region=${region} \
    --from-literal=passphrase="" \
    --from-file=privatekey=${private_key_path}
fi 

