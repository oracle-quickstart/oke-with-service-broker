cd keys
mkdir -p client peer
# create CA if it doesn't exist
if [[ ! -f ca.pem ]]; then
    cfssl gencert -initca ca-csr.json | cfssljson -bare ca -
fi

# gen peer certificate and key
cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=peer peer.json | cfssljson -bare peer
cp ca.pem peer/ca.crt
cp peer.pem peer/tls.crt
cp peer-key.pem peer/tls.key

# gen client certificate and key for etcd
cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=client client.json | cfssljson -bare client
cp ca.pem client/ca.crt
cp client.pem client/tls.crt
cp client-key.pem client/tls.key

# convert cert and key for OSB
openssl pkcs8 -topk8 -nocrypt -in client-key.pem -out client/etcd-client.key
cp ca.pem client/etcd-client-ca.crt
cp client.pem client/etcd-client.crt

pushd peer
kubectl create secret generic etcd-peer-tls-cert -n oci-service-broker \
--from-file=ca.crt \
--from-file=tls.key \
--from-file=tls.crt
popd

pushd client
# cert for etcd
kubectl create secret generic etcd-client-tls-cert -n oci-service-broker \
--from-file=ca.crt \
--from-file=tls.key \
--from-file=tls.crt

# modified cert for OSB
kubectl create secret generic etcd-client-tls-cert-osb  -n oci-service-broker \
--from-file=etcd-client-ca.crt \
--from-file=etcd-client.key \
--from-file=etcd-client.crt
popd

while [[ "$(kubectl get secrets -n oci-service-broker | grep "etcd-client-tls-cert" | wc -l | tr -d ' ')" == "0" ]]; do
    echo "waiting for etcd-client-tls-cert secret to be created" && sleep 1
done
while [[ "$(kubectl get secrets -n oci-service-broker | grep "etcd-peer-tls-cert" | wc -l | tr -d ' ')" == "0" ]]; do
    echo "waiting for etcd-peer-tls-cert secret to be created" && sleep 1
done