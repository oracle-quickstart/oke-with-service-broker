helm install oci-service-broker https://github.com/oracle/oci-service-broker/releases/download/v1.5.1/oci-service-broker-1.5.1.tgz \
  --namespace oci-service-broker \
  --set ociCredentials.secretName=osb-credentials \
  --set storage.etcd.useEmbedded=true \
  --set tls.enabled=false

while [[ $(kubectl get pods -l app=oci-service-broker -n oci-service-broker -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do 
    echo "waiting for oci-service-broker pod" && sleep 1; 
done
