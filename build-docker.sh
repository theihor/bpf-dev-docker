#!/bin/bash

tag=${1:-bpfdev}
LLVM=${LLVM:-18}

# KVM_GID=$(getent group kvm | cut -d: -f3)
#       --build-arg KVM_GID=$KVM_GID 

docker build -t $tag                 \
       --build-arg LLVM=$LLVM        \
       --build-arg C_GID=$(id -g)    \
       --build-arg C_GROUP=$(id -gn) \
       --build-arg C_UID=$(id -u)    \
       --build-arg C_USER=$(id -un)  \
       .

