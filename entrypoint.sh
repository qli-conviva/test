#!/bin/bash
set -exuo pipefail

if [ "$1" = "node_exporter" ]; then
    exec node_exporter \
        --web.listen-address=":9100" \
        --path.rootfs="/rootfs" \
        --path.procfs="/rootfs/proc" \
        --path.sysfs="/rootfs/sys" \
        --collector.filesystem.ignored-mount-points="^/(rootfs/)?(run|proc|sys|dev|snap|etc|var/lib/docker|var/lib/kubelet|var/run)($|/)" \
        --collector.filesystem.ignored-fs-types="^(autofs|binfmt_misc|bpf|cgroup2?|configfs|debugfs|devpts|devtmpfs|fusectl|hugetlbfs|iso9660|mqueue|nsfs|overlay2?|proc|procfs|pstore|rpc_pipefs|securityfs|selinuxfs|squashfs|sysfs|tracefs)$" \
        --log.level=info \
        --log.format=json
else
    exec "$@"
fi



