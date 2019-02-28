

    helm upgrade --install cert-manager \
      stable/cert-manager \
      --namespace kube-system
    kubectl -n kube-system rollout status deploy/cert-manager

    helm repo add rancher-latest https://releases.rancher.com/server-charts/latest

    helm upgrade --install ingress-nginx \
      stable/nginx-ingress \
      --namespace ingress \
      -f ingress-values.yaml
    kubectl -n ingress rollout status deployment/ingress-nginx-ingress-controller

    helm upgrade --install rancher \
      rancher-latest/rancher \
      --namespace cattle-system \
      -f rancher-values.yaml
    kubectl -n cattle-system rollout status deploy/rancher


### SSL Certificates

Self signed certificate: 

    openssl req -config openssl.cnf -x509 -sha256 -newkey rsa:2048 \
      -keyout tls.key -out tls.crt -days 1024 -nodes

Certificate Signing Request:

    openssl req -config openssl.cnf -new -newkey rsa:2048 -nodes \
      -out tls.csr \
      -keyout tls.key

    openssl x509 -req -days 3600 \
      -in tls.csr \
      -out tls.crt \
      -CAcreateserial

    openssl x509 -req -days 360 -CAcreateserial \
      -in tls.csr \
      -CA /opt/rootca/ca.pem \
      -CAkey /opt/rootca/ca.key \
      -out tls.crt

    kubectl -n cattle-system create secret tls tls-rancher-ingress \
      --cert=tls.crt --key=tls.key
