set -e

status()
{
    echo -e "\e[1m"$*"\e[0m "
}

error()
{
    echo -e "\e[91m"$*"\e[0m "
    exit 1
}

if [[ -z "$TOP" ]]; then
    error "Error: TOP env var not set."
    exit 1
fi

#### helpers
if [[ -z "$PACKAGE" ]]; then
    error "Error: PACKAGE var not set."
    exit 1
fi

cd_package()
{
    mkdir -p $TOP/out/build/$PACKAGE
    cd $TOP/out/build/$PACKAGE
}

package_success()
{
    status "Installation of $PACKAGE successful!"
}

run_autogen()
{
    if [ ! -f "$TOP/out/build/$PACKAGE/Makefile" ]; then
        $TOP/$PACKAGE/autogen.sh --host=${CROSS_COMPILE%"-"} --prefix=$PREFIX --with-sysroot=$SYSROOT $*
    fi
}

run_make()
{
	make DESTDIR=$SYSROOT -j$NPROC $*
}
####

NPROC=$(nproc)

#### toolchain-specific settings
CROSS_COMPILE=arm-linux-gnueabihf-
LINARO_GCC_VERSION=4.8
LINARO_GCC_RELEASE=14.04
LINARO_GCC_PACKAGE=gcc-linaro-arm-linux-gnueabihf-${LINARO_GCC_VERSION}-20${LINARO_GCC_RELEASE}_linux
PATH="$TOP/$LINARO_GCC_PACKAGE/bin:$PATH"
####

# TODO change this!
PREFIX=/home/ubuntu/usr

DISTRO=L4T

#### user-space only flags!
export SYSROOT="$TOP/out/target/$DISTRO"
export CFLAGS="--sysroot=$SYSROOT"
export CXXFLAGS="$CFLAGS"
export PKG_CONFIG_SYSROOT_DIR=$SYSROOT
export PKG_CONFIG_LIBDIR="$SYSROOT/usr/lib/pkgconfig:$SYSROOT/usr/share/pkgconfig"
export PKG_CONFIG_PATH="$SYSROOT/$PREFIX/lib/pkgconfig"
# Use system pkg-config as the toolchain's one is too old (0.25) to handle PKG_CONFIG_SYSROOT_DIR correctly.
export PKG_CONFIG=pkg-config
####

#### ubuntu-specific user-space flags
NEWCFLAGS="-I$SYSROOT/usr/include/arm-linux-gnueabihf -L$SYSROOT/lib/arm-linux-gnueabihf -L$SYSROOT/usr/lib/arm-linux-gnueabihf"
export CFLAGS="$CFLAGS $NEWCFLAGS"
export CXXFLAGS="$CXXFLAGS $NEWCFLAGS"
export PKG_CONFIG_LIBDIR="$SYSROOT/usr/lib/arm-linux-gnueabihf/pkgconfig:$PKG_CONFIG_LIBDIR"
####
