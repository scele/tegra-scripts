
```
sudo apt-get update
sudo apt-get install autoconf bison flex pkg-config libtool libpthread-stubs0-dev x11proto-gl-dev x11proto-dri2-dev x11proto-dri3-dev x11proto-present-dev x11proto-xf86vidmode-dev libffi-dev
# Mesa:
sudo apt-get install libx11-xcb-dev libxcb-glx0-dev libxcb-dri2-0-dev libxcb-dri3-dev libxcb-present-dev libxcb-sync-dev libxshmfence-dev libxdamage-dev libudev-dev libxext-dev
# Weston:
sudo apt-get install libcairo2-dev libxcursor-dev libxcb-composite0-dev libmtdev-dev libxkbcommon-dev libjpeg-dev libpam-dev

# Uncomment the "universe" from /etc/apt/sources.list and then:
sudo apt-get mesa-utils mesa-utils-extra

# If you want to attempt cross compilation on top of the device rootfs, you need to fix symlinks:
sudo apt-get install symlinks
sudo symlinks -cr /usr/local/lib
sudo symlinks -cr /usr/lib
sudo symlinks -cr /lib


# If you discover, like me, that cross compilation is not your thing, then follow Alex's instructions:
sudo apt-get install g++

cd drm
./autogen.sh --prefix=$NVD --enable-tegra-experimental-api
make -j4
make install

cd wayland
./autogen.sh --prefix=$NVD --disable-documentation
make -j4
make install

cd mesa
./autogen.sh --without-dri-drivers --with-gallium-drivers=nouveau --enable-gallium-egl --enable-gbm --enable-egl --with-egl-platforms=drm,wayland --enable-gles1 --enable-gles2 --enable-opengl --prefix=$NVD
make -j4
make install

cd weston
mkdir m4
./autogen.sh --prefix=$NVD
make -j4
sudo make install
```
