#!/bin/bash

tag=${1:-bpfdev}

mkdir -p ${HOME}/.bpf_selftests

function docker_run {
    docker run -d --privileged \
           --device=/dev/kvm \
           --cap-add ALL \
           --user "$(id -u):$(id -g)" \
           -v ${HOME}/.bpf_selftests:${HOME}/.bpf_selftests \
           -v $(pwd):/opt \
           $tag
}

container_id=$(docker_run)

docker exec -it $container_id /bin/bash

echo "Container $container_id is still running."
read -p "Would you like to stop it? (y/n): " confirm
if [[ $confirm =~ ^[Yy]$ ]]; then
    docker stop $container_id
else
    exit 0
fi

