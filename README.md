A container to build https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git and be able run `tools/testing/selftests/bpf/vmtest.sh`.

`./build-docker.sh` will clone the tree to `linux` directory (if it doesn't exist) and then build a docker image based on Debian (bullseye) with
[qemu](https://www.qemu.org/), [llvm](https://llvm.org/) and [pahole](https://git.kernel.org/pub/scm/devel/pahole/pahole.git).

`./start-docker.sh` will run this image under current user, mounting `./linux` and `~/.bpf_selftests` and passing `/dev/kvm` device.
