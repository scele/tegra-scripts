if [[ -z "$TOP" ]]; then
    echo "Error: TOP env var not set."
    exit 1
fi

status()
{
    echo -e "\e[1m"$*"\e[0m "
}

LINARO_GCC_VERSION=4.8
LINARO_GCC_RELEASE=14.04
LINARO_GCC_PACKAGE=gcc-linaro-arm-linux-gnueabihf-${LINARO_GCC_VERSION}-20${LINARO_GCC_RELEASE}_linux

PATH="$TOP/$LINARO_GCC_PACKAGE/bin:$PATH"
CROSS_COMPILE=arm-linux-gnueabihf-

NPROC=`nproc`
PREFIX=/home/ubuntu/usr
SYSROOT="$TOP/out/root"

export PKG_CONFIG_SYSROOT_DIR=$SYSROOT
export PKG_CONFIG_LIBDIR="$SYSROOT/usr/lib/arm-linux-gnueabihf/pkgconfig:$SYSROOT/usr/lib/pkgconfig:$SYSROOT/$PREFIX/lib/pkgconfig:$SYSROOT/usr/share/pkgconfig"
export PKG_CONFIG_PATH="$SYSROOT/$PREFIX/lib/pkgconfig"
# Use system pkg-config as the toolchain's one is too old (0.25) to handle PKG_CONFIG_SYSROOT_DIR correctly.
export PKG_CONFIG=pkg-config

export CFLAGS="--sysroot=$SYSROOT -I$SYSROOT/usr/include/arm-linux-gnueabihf -I$SYSROOT/usr/include -L$SYSROOT/lib/arm-linux-gnueabihf -L$SYSROOT/usr/lib/arm-linux-gnueabihf"
export CXXFLAGS="$CFLAGS"
