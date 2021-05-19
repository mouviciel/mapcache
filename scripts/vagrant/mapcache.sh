#!/bin/sh

cd /vagrant

# env from .travis.yml
DISTRO="xenial"
BUILD_TYPE="maximum"
# script from .travis.yml
mkdir build
cd build
if test "$BUILD_TYPE" = "maximum"; then cmake .. -DCMAKE_INSTALL_PREFIX=/usr -DWITH_TIFF=ON -DWITH_GEOTIFF=ON -DWITH_TIFF_WRITE_SUPPORT=ON -DWITH_PCRE=ON -DWITH_SQLITE=ON -DWITH_BERKELEY_DB=ON; else cmake .. -DCMAKE_INSTALL_PREFIX=/usr -DWITH_TIFF=OFF -DWITH_GEOTIFF=OFF -DWITH_TIFF_WRITE_SUPPORT=OFF -DWITH_PCRE=OFF -DWITH_SQLITE=OFF -DWITH_BERKELEY_DB=OFF -DWITH_GDAL=OFF -DWITH_GEOS=OFF -DWITH_FCGI=OFF -DWITH_CGI=OFF -DWITH_APACHE=OFF -DWITH_OGR=OFF -DWITH_MAPSERVER=OFF -DWITH_MAPCACHE_DETAIL=OFF; fi
make -j3
sudo make install
if test "$DISTRO" = "xenial" -a "$BUILD_TYPE" = "maximum"; then cd ../tests; sh ./travis_setup.sh; sh ./run_tests.sh; fi
