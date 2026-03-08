#!/system/bin/sh
# Start services in Alpine chroot after boot.
ENV_FILE=/data/local/zeroclaw.env

sleep 30

if [ -f "$ENV_FILE" ]; then
    set -a
    . "$ENV_FILE"
    set +a
fi

sh /data/local/tailscale-start.sh &
sleep 5
chroot /data/local/alpine /usr/sbin/dropbear -R -p 2222 -s
sh /data/local/zeroclaw-start.sh &
