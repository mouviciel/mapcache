#!/bin/sh

# Project:  MapCache
# Purpose:  MapCache tests
# Author:   Even Rouault
#
#*****************************************************************************
# Copyright (c) 2017 Regents of the University of Minnesota.
#
# Permission is hereby granted, free of charge, to any person obtaining a
# copy of this software and associated documentation files (the "Software"),
# to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies of this Software or works derived from this Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
# OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
# THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
# DEALINGS IN THE SOFTWARE.
#****************************************************************************/

set -e

if [ -n "$1" ]
then
  CHECKSUM=$1
else
  # Default with 'xenial' box
  CHECKSUM=20574
fi

MAPCACHE_CONF=/tmp/mc/mapcache.xml

# Check MapCache without involving HTTP server: build local cache from remote source
sudo rm -rf /tmp/mc/global
mapcache_seed -c /tmp/mc/mapcache.xml -t global --force -z 0,1
gdalinfo -checksum /tmp/mc/global/GoogleMapsCompatible/00/000/000/000/000/000/000.jpg | grep Checksum=$CHECKSUM >/dev/null || (echo "Did not get expected checksum"; gdalinfo -checksum /tmp/mc/global/GoogleMapsCompatible/00/000/000/000/000/000/000.jpg; /bin/false)
sudo rm -rf /tmp/mc/global

# Check basic MapCache HTTP features: WMS GetCapabilities request
curl -s "http://localhost/mapcache/?SERVICE=WMS&REQUEST=GetCapabilities" | xmllint --format - > /tmp/wms_capabilities.xml
diff -u /tmp/wms_capabilities.xml expected

# Check basic MapCache HTTP features: WMTS GetCapabilities request
curl -s "http://localhost/mapcache/wmts?SERVICE=WMTS&REQUEST=GetCapabilities" | xmllint --format - > /tmp/wmts_capabilities.xml
diff -u /tmp/wmts_capabilities.xml expected

# Check full MapCache functionality: request tile that needs to be fetched from source
curl -s "http://localhost/mapcache/wmts/1.0.0/global/default/GoogleMapsCompatible/0/0/0.jpg" > /tmp/0.jpg
gdalinfo -checksum /tmp/0.jpg | grep Checksum=$CHECKSUM >/dev/null || (echo "Did not get expected checksum"; gdalinfo -checksum /tmp/0.jpg; /bin/false)

# Check full MapCache functionality: request tile that is already cached
curl -s "http://localhost/mapcache/wmts/1.0.0/global/default/GoogleMapsCompatible/0/0/0.jpg" > /tmp/0_bis.jpg
diff /tmp/0.jpg /tmp/0_bis.jpg

