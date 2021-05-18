#!/bin/sh

NUMTHREADS=2 # we have 2 cpus configured
export NUMTHREADS

echo /etc/local/lib > /etc/ld.so.conf.d/local.conf

cd /vagrant

mkdir build_vagrant
cd build_vagrant
cmake -DWITH_MEMCACHE=1 ..

make -j $NUMTHREADS
make install
ldconfig
