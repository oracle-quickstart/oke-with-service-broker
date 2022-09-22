## Copyright © 2021, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

rm -rf ./service-catalog

git clone https://github.com/kubernetes-retired/service-catalog.git

pushd service-catalog/charts/catalog
# helm repo add service-catalog https://kubernetes-sigs.github.io/service-catalog

helm install catalog . --namespace oci-service-broker

while [[ $(kubectl get pods -l app=catalog-catalog-webhook -n oci-service-broker -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do 
    echo "waiting for catalog-catalog-webhook pod" && sleep 1; 
done

while [[ $(kubectl get pods -l app=catalog-catalog-controller-manager -n oci-service-broker -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do 
    echo "waiting for catalog-catalog-controller-manager pod" && sleep 1; 
done

echo "Service Catalog is installed and running"
popd

