A container to build [Linux bpf-next tree](https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git) and be able run `tools/testing/selftests/bpf/vmtest.sh`.

`./build-docker.sh` will build a docker image based on Debian
(bullseye) with [qemu](https://www.qemu.org/),
[llvm](https://llvm.org/) and
[pahole](https://git.kernel.org/pub/scm/devel/pahole/pahole.git)
installed.

`./start-docker.sh` will run this image under current user, mounting a
repo directory (default `./linux`) and `~/.bpf_selftests` and passing
`/dev/kvm` device.

`kernel-build.config` is a sample config for kernel build. You may
copy it to the repo dir on the host (e.g. `./linux`) and then generate
an actual config with a command like this one:

```bash
/opt/linux$ ./scripts/kconfig/merge_config.sh \
    tools/testing/selftests/bpf/config \
    tools/testing/selftests/bpf/config.vm \
    tools/testing/selftests/bpf/config.x86_64 \
    ./kernel-build.config
```
