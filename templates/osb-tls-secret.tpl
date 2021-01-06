## Copyright © 2021, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

cd ./keys
mkdir -p osb
cd osb

cat > ssl.conf <<EOF
[req]
prompt = no
distinguished_name = req_distinguished_name
req_extensions = v3_req

[req_distinguished_name]
C = US
ST = California
L = San Francisco
O = ACME
CN = oci-service-broker.oci-service-broker.svc.cluster.local

[v3_req]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
EOF

openssl req -newkey rsa:2048 -config ssl.conf -nodes -keyout key.pem -x509 -days 3650 -out certificate.pem
# package in PKCS12 keystore
openssl pkcs12 -inkey key.pem -in certificate.pem -export -out certificate.p12 -passout pass:${password}

kubectl create secret generic osb-client-tls-cert --from-literal=keyStore.password=${password} --from-file=keyStore=certificate.p12
