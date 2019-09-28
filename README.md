# kubernetes_forge

##

    ansible-galaxy install -r requirements.yml -p roles/
    kitchen create all -p
    ssh-add $(find .kitchen -name private_key)
