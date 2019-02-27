

    helm upgrade --install cert-manager \
      stable/cert-manager \
      --namespace kube-system
    kubectl -n kube-system rollout status deploy/cert-manager

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
