if [[ -z "$TOP" ]]; then
    echo "Error: TOP env var not set."
    exit 1
fi

if [[ -z "$CROSS_COMPILE" ]]; then
    echo "Error: CROSS_COMPILE env var not set."
    exit 1
fi

PREFIX=/home/ubuntu/usr
export DESTDIR=$TOP/out/root
export PKG_CONFIG_PATH="$TOP/out/root/usr/lib/pkgconfig:$DESTDIR/$PREFIX/lib/pkgconfig"
