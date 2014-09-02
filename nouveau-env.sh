NVD=$HOME/usr
LD_LIBRARY_PATH=$NVD/lib
PKG_CONFIG_PATH=$NVD/lib/pkgconfig/:$NVD/share/pkgconfig/
ACLOCAL="aclocal -I $NVD/share/aclocal"
export NVD LD_LIBRARY_PATH PKG_CONFIG_PATH ACLOCAL
export PATH="$NVD/bin:$PATH"
