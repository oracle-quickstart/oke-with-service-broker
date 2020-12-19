helm repo add bitnami https://charts.bitnami.com/bitnami

# check that the nodes are ready, and we have 3, or PVCs may fail to provision

while [[ $(for i in $(kubectl get nodes -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}'); do if [[ "$i" == "True" ]]; then echo $i; fi; done | wc -l | tr -d " ") -lt 3 ]]; do
    echo "waiting for at least 3 nodes to be ready..." && sleep 1;
done

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
