#!/bin/sh
export HOME=/root
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

if [ -f "$HOME/.zeroclaw/zeroclaw.env" ]; then
    set -a
    . "$HOME/.zeroclaw/zeroclaw.env"
    set +a
fi

exec zeroclaw daemon
