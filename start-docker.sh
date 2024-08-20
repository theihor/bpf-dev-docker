#!/bin/bash

repo_dir=${1:-linux}
tag=${2:-bpfdev}

if [ ! -d "$repo_dir" ]; then
    echo "Directory $repo_dir does not exist."
    read -p "Would you like to clone bpf-next into ${repo_dir} ? (y/n): " confirm
    if [[ $confirm =~ ^[Yy]$ ]]; then
        git clone --depth 1 \
            https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git \
            $repo_dir
    fi
fi

mkdir -p ${HOME}/.bpf_selftests

function docker_run {
    docker run -d --privileged \
           --device=/dev/kvm \
           --cap-add ALL \
           --user "$(id -u):$(id -g)" \
           -v ${HOME}/.bpf_selftests:${HOME}/.bpf_selftests \
           -v $(realpath $repo_dir):/opt/linux \
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

