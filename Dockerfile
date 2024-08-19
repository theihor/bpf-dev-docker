FROM debian:bullseye-slim

ENV DEBIAN_FRONTEND=noninteractive

# ARG KVM_GID
ARG C_GID
ARG C_GROUP
ARG C_UID
ARG C_USER
ARG LLVM

RUN groupadd --gid $C_GID $C_GROUP && adduser --gid $C_GID --uid $C_UID $C_USER

# RUN groupadd --gid $KVM_GID kvm && usermod -aG kvm $C_USER

# Give $C_USER passwordless sudo permissions
RUN mkdir -p /etc/sudoers.d && \
    echo $C_USER "ALL=(ALL) NOPASSWD:ALL" \
    > /etc/sudoers.d/$C_USER


# Install build prerequisites
RUN apt-get update
RUN apt-get install -y --no-install-recommends                         \
    bc bison build-essential cmake curl docutils-common e2fsprogs flex \
    git gnupg libdw-dev libelf-dev libssl-dev lsb-release              \
    python3-docutils rsync software-properties-common sudo wget zstd
RUN apt-get install -y --no-install-recommends qemu-system-x86


# Pull and install LLVM
RUN curl https://apt.llvm.org/llvm.sh --output /tmp/llvm.sh && \
    bash /tmp/llvm.sh $LLVM
RUN apt-get install -y clang-tools-${LLVM} && \
    ln -s /usr/bin/clang-${LLVM} /usr/bin/clang && \
    ln -s /usr/bin/llvm-strip-${LLVM} /usr/bin/llvm-strip


# Clone, build and install pahole
RUN cd /opt && \
    git clone --depth 1 https://git.kernel.org/pub/scm/devel/pahole/pahole.git
RUN cd /opt/pahole && \
    git submodule update --init --recursive
RUN mkdir /opt/pahole/build
WORKDIR /opt/pahole/build
RUN cmake -D__LIB=lib/pahole .. && \
    make -j && make install     && \
    echo '/usr/local/lib/pahole' > /etc/ld.so.conf.d/pahole.conf && ldconfig

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/linux

# --device /dev/kvm must be passed to the container
CMD ["sh", "-c", "sudo chmod 666 /dev/kvm; trap exit TERM; while :; do sleep 1; done"]

