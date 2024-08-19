#!/bin/bash

tag=${1:-bpfdev}
volume_name=${2:-bpfdev_volume}
LLVM=${LLVM:-18}

if [ ! -d "linux" ]; then
    git clone --depth 1 \
        https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git \
        linux
fi

if ! docker volume inspect $volume_name > /dev/null 2>&1; then
    docker volume create $volume_name
fi

# KVM_GID=$(getent group kvm | cut -d: -f3)
#       --build-arg KVM_GID=$KVM_GID 

docker build -t $tag                 \
       --build-arg LLVM=$LLVM        \
       --build-arg C_GID=$(id -g)    \
       --build-arg C_GROUP=$(id -gn) \
       --build-arg C_UID=$(id -u)    \
       --build-arg C_USER=$(id -un)  \
       .

