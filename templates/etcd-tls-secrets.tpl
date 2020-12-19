mkdir -p client peer
# create CA
cfssl gencert -initca ca-csr.json | cfssljson -bare ca -

# gen peer certificate and key
cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=peer peer.json | cfssljson -bare peer
cp ca.pem peer/ca.crt
cp peer.pem peer/tls.crt
cp peer-key.pem peer/tls.key

cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=client client.json | cfssljson -bare client
openssl pkcs8 -topk8 -nocrypt -in client-key.pem -out client/tls.key
cp ca.pem client/ca.crt
cp client.pem client/tls.crt

pushd peer
kubectl create secret generic etcd-peer-tls-cert \
--from-file=ca.crt \
--from-file=tls.key \
--from-file=tls.crt
popd

pushd client
kubectl create secret generic etcd-client-tls-cert \
--from-file=ca.crt \
--from-file=tls.key \
--from-file=tls.crt
popd