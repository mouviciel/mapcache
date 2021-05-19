#!/bin/sh

# before_install from .travis.yml
sudo mv /etc/apt/sources.list.d/pgdg* /tmp
sudo apt-get purge -y libgdal* libgeos* libspatialite*
sudo add-apt-repository -y ppa:ubuntugis/ubuntugis-unstable
sudo apt-get update
sudo apt-get install -y cmake libspatialite-dev libfcgi-dev libproj-dev libgeos-dev libgdal-dev libtiff-dev libgeotiff-dev apache2-dev libpcre3-dev libsqlite3-dev libdb-dev
sudo apt-get install -y libpixman-1-dev
sudo apt-get install -y libxml2-utils apache2 gdal-bin
