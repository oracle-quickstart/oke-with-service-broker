helm repo add bitnami https://charts.bitnami.com/bitnami

# kubectl apply -f ./templates/etcd-tls-certificates.yaml -n oci-service-broker

while [[ "$(kubectl get secrets -n oci-service-broker | grep "etcd-client-tls-cert" | wc -l | tr -d ' ')" == "0" ]]; do
    echo "waiting for etcd-client-tls-cert secret to be created" && sleep 1
done
while [[ "$(kubectl get secrets -n oci-service-broker | grep "etcd-peer-tls-cert" | wc -l | tr -d ' ')" == "0" ]]; do
    echo "waiting for etcd-peer-tls-cert secret to be created" && sleep 1
done

helm install etcd bitnami/etcd --namespace oci-service-broker --values ./templates/etcd-values.yaml

while [[ $(kubectl get pods -l app.kubernetes.io/pod-name=etcd-0 -n oci-service-broker -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do 
    echo "waiting for pod etcd-0" && sleep 1; 
done
while [[ $(kubectl get pods -l app.kubernetes.io/pod-name=etcd-1 -n oci-service-broker -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do 
    echo "waiting for pod etcd-1" && sleep 1; 
done
while [[ $(kubectl get pods -l app.kubernetes.io/pod-name=etcd-2 -n oci-service-broker -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do 
    echo "waiting for pod etcd-2" && sleep 1; 
done

echo "etcd is installed and running"
