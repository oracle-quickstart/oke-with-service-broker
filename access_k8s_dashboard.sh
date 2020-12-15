echo "Use the token described below to connect"
kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep oke-admin | awk '{print $1}')

echo "Running k8s proxy..."
kubectl proxy &

echo "Opening browser..."
sleep 3
open 'http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/#!/login'
