

## Rancher Install

### Install Helm

    helm init --service-account tiller

### Install certificates used by ingress and rancher

    kubectl -n cattle-system create secret tls tls-rancher-ingress \
      --cert=tls.crt --key=tls.key
    kubectl -n cattle-system create secret generic tls-ca \
      --from-file=cacerts.pem

### Install Rancher

    helm repo add rancher-latest https://releases.rancher.com/server-charts/latest
    helm upgrade --install rancher \
      rancher-latest/rancher \
      --namespace cattle-system \
      -f rancher-values.yaml
    kubectl -n cattle-system rollout status deploy/rancher

### Install ingress-nginx

    helm upgrade --install ingress-nginx \
      stable/nginx-ingress \
      --namespace ingress \
      -f ingress-values.yaml

## SSL Certificates

### Generate key: 

    openssl genrsa -aes256 -out tls.key.tmp 4096
    openssl rsa -in tls.key.tmp -out tls.key

### Self signed certificate:

    openssl req -new -x509 -days 365 \
      -extensions req_ext \
      -key tls.key \
      -out tls.crt
    openssl x509 -req -days 365 \
      -extensions req_ext \
      -signkey tls.key \
      -in tls.csr \
      -out tls.crt
    openssl x509 -in tls.crt -text -noout

### Certificate signed by local CA:

#### Create certificate Signing Request:

    openssl req -config openssl.cnf -new -sha256 \
      -key tls.key \
      -out tls.csr
    openssl req -text -noout -verify -in tls.csr

#### Sign certificate with local authority:

    openssl ca -config /var/root/ca/openssl.cnf \
      -extensions server_cert -days 375 -notext -md sha256 \
      -in tls.csr \
      -out tls.crt.raw

    cp /var/root/ca/certs/ca.cert.pem cacerts.pem
    cat tls.crt.raw cacerts.pem > tls.crt
    openssl x509 -in tls.crt -text -noout

