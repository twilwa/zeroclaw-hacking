#!/system/bin/sh
# Start zeroclaw daemon in Alpine chroot.
CHROOT=/data/local/alpine
ENV_FILE=/data/local/zeroclaw.env

mountpoint -q "$CHROOT/proc" 2>/dev/null || mount -t proc proc "$CHROOT/proc"
mountpoint -q "$CHROOT/sys" 2>/dev/null || mount -t sysfs sysfs "$CHROOT/sys"
mountpoint -q "$CHROOT/dev" 2>/dev/null || mount --bind /dev "$CHROOT/dev"
mountpoint -q "$CHROOT/dev/pts" 2>/dev/null || mount --bind /dev/pts "$CHROOT/dev/pts"

cp /etc/resolv.conf "$CHROOT/etc/resolv.conf" 2>/dev/null

if [ -f "$ENV_FILE" ]; then
    set -a
    . "$ENV_FILE"
    set +a
fi

exec chroot "$CHROOT" /bin/sh -c 'export HOME=/root PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin; exec zeroclaw daemon'
