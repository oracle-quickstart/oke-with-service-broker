helm repo add bitnami https://charts.bitnami.com/bitnami

# kubectl apply -f ./templates/etcd-tls-certificates.yaml -n oci-service-broker

helm install etcd bitnami/etcd --namespace oci-service-broker --values ./templates/etcd-values.yaml

while [[ $(kubectl get pod etcd-0 -n oci-service-broker -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do 
    echo "waiting for pod etcd-0" && sleep 1; 
done
while [[ $(kubectl get pod etcd-1 -n oci-service-broker -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do 
    echo "waiting for pod etcd-1" && sleep 1; 
done
while [[ $(kubectl get pod etcd-2 -n oci-service-broker -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do 
    echo "waiting for pod etcd-2" && sleep 1; 
done

echo "etcd is installed and running"
