#!/bin/bash
set -exuo pipefail

if [ "$1" = "fluent-bit" ]; then
    exec fluent-bit -c /etc/fluent-bit/fluent-bit.conf
else
    exec "$@"
fi
