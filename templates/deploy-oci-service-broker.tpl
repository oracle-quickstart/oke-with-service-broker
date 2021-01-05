CHART_VERSION=1.5.2
# if editing the CHART_VERSION also make sure to edit the image tag in the osb-values.yaml to match the image version

helm install oci-service-broker https://github.com/oracle/oci-service-broker/releases/download/v$CHART_VERSION/oci-service-broker-$CHART_VERSION.tgz \
  --namespace oci-service-broker \
  --values ./templates/osb-values.yaml


while [[ $(kubectl get pods -l app=oci-service-broker -n oci-service-broker -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do 
    echo "waiting for oci-service-broker pod" && sleep 1; 
done
