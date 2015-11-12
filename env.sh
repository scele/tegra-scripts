set -e

if [[ -z "$DISTRO" ]]; then
    DISTRO=ArchLinuxArm
fi

if [[ -z "$ARCH" ]]; then
	ARCH=arm
fi

# Where all the programs/libraries from these scripts will be installed
if [[ -z "$NV_PREFIX" ]]; then
    NV_PREFIX=/opt/nouveau
fi

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
cd_package()
{
    if [[ -z "$PACKAGE" ]]; then
        error "Error: PACKAGE var not set."
        exit 1
    fi

    mkdir -p $BUILDROOT/$PACKAGE
    cd $BUILDROOT/$PACKAGE
}

package_success()
{
    status "Installation of $PACKAGE successful!"
}

run_autogen()
{
    if [[ -z "$PACKAGE" ]]; then
        error "Error: PACKAGE var not set."
        exit 1
    fi

    if [ ! -f "$BUILDROOT/$PACKAGE/Makefile" ]; then
        $TOP/$PACKAGE/autogen.sh --host=${CROSS_COMPILE%"-"} --prefix=$NV_PREFIX --with-sysroot=$SYSROOT $*
    fi
}

run_make()
{
    make DESTDIR=$SYSROOT -j$NPROC $*
}
####

NPROC=$(nproc)

BUILDROOT=$TOP/out/build/$ARCH/$DISTRO

#### toolchain-specific settings
LINARO_GCC_VERSION=4.8
LINARO_GCC_RELEASE=15.06
case $ARCH in
	arm)
	LINARO_GCC_VARIANT=arm-linux-gnueabihf
	;;
	aarch64)
	LINARO_GCC_VARIANT=aarch64-linux-gnu
	;;
esac
LINARO_GCC_PACKAGE=gcc-linaro-${LINARO_GCC_VERSION}-2015.06-x86_64_${LINARO_GCC_VARIANT}
CROSS_COMPILE=${LINARO_GCC_VARIANT}-

SYSTEM_PATH="$PATH"
PATH="$TOP/$LINARO_GCC_PACKAGE/bin:$PATH"
####

#### user-space only flags!
export SYSROOT="$TOP/out/target/$ARCH/$DISTRO"
export CFLAGS="--sysroot=$SYSROOT"
export CXXFLAGS="$CFLAGS"

export ACLOCAL_PATH="${SYSROOT}/usr/share/aclocal"
export PKG_CONFIG_DIR=
export PKG_CONFIG_LIBDIR="${SYSROOT}/usr/lib/arm-linux-gnueabihf/pkgconfig":"${SYSROOT}/usr/lib/pkgconfig":"${SYSROOT}/usr/share/pkgconfig"
export PKG_CONFIG_SYSROOT_DIR="${SYSROOT}"
export PKG_CONFIG_PATH="${SYSROOT}/${NV_PREFIX}/lib/pkgconfig"
# Use our own pkg-config as the toolchain's one is too old (0.25) to handle PKG_CONFIG_SYSROOT_DIR correctly.
export PKG_CONFIG=pkg-config
####

if [ -f scripts/distro/env-$DISTRO ]; then
    . scripts/distro/env-$DISTRO
fi
