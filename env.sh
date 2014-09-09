if [[ -z "$TOP" ]]; then
    echo "Error: TOP env var not set."
    exit 1
fi

LINARO_GCC_VERSION=4.8
LINARO_GCC_RELEASE=14.04
LINARO_GCC_PACKAGE=gcc-linaro-arm-linux-gnueabihf-${LINARO_GCC_VERSION}-20${LINARO_GCC_RELEASE}_linux

PATH="$TOP/$LINARO_GCC_PACKAGE/bin:$PATH"
CROSS_COMPILE=arm-linux-gnueabihf-
PREFIX=/home/ubuntu/usr
export DESTDIR=$TOP/out/root
export PKG_CONFIG_PATH="$TOP/out/root/usr/lib/pkgconfig:$DESTDIR/$PREFIX/lib/pkgconfig"
