# kubernetes_forge

##

### Initial Setup

    ansible-galaxy install -r requirements.yml -p roles/
    kitchen converge all -p
    ssh-add $(find .kitchen -name private_key)

### RKE 

    ansible-playbook -i vagrant/hosts.yml rke/preload_images.yml
    rke up --config=rke/cluster.yml
    export KUBECONFIG=rke/kube_config_cluster.yml

### Kubespray 

    ansible-playbook -i vagrant/hosts.yml kubespray/cluster.yml
    git submodule update --init
    export KUBECONFIG=vagrant/artifacts/admin.conf
