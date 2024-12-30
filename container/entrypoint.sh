#!/bin/bash

if [ -z "$ROOT_PASSWORD" ]; then
  echo "Error: ROOT_PASSWORD must be set" >&2
  exit 1
fi

echo "root:$ROOT_PASSWORD" | chpasswd

exec /usr/sbin/sshd -D
