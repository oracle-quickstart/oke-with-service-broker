mkdir -p $HOME/.kube/ 
oci ce cluster create-kubeconfig --cluster-id ${cluster_id} --file $HOME/.kube/config --region ${region} --token-version 2.0.0
