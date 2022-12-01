#!/bin/bash

set -e
pwd=$(pwd)

version=$(jq -r ".version" ../src/plugin.json)
signkey=5E90FAE850ECE85E1B3096801101D2C8B78BAD31
pkgdir=$(pwd)/../..

echo "- Arranging files..."
mkdir -p /tmp/motionwebcamserverplugin/motionwebcamserverplugin_$version/opt/dsf/plugins/MotionWebcamServer
cp -r $pwd/DEBIAN /tmp/motionwebcamserverplugin/motionwebcamserverplugin_$version/DEBIAN
cp -r ../src/dsf /tmp/motionwebcamserverplugin/motionwebcamserverplugin_$version/opt/dsf/plugins/MotionWebcamServer/dsf
cp -r ../src/sd /tmp/motionwebcamserverplugin/motionwebcamserverplugin_$version/opt/dsf/plugins/MotionWebcamServer/sd
cp ../src/plugin.json /tmp/motionwebcamserverplugin/motionwebcamserverplugin_$version/opt/dsf/plugins/MotionWebcamServer.json

echo "- Preparing package index"
sed -i "s/VERSION/$version/g" /tmp/motionwebcamserverplugin/motionwebcamserverplugin_$version/DEBIAN/control
sed -i "s/VERSION/$version/g" /tmp/motionwebcamserverplugin/motionwebcamserverplugin_$version/DEBIAN/changelog

echo "- Packaging files..."
cd /tmp/motionwebcamserverplugin
dpkg-deb --build -Zxz motionwebcamserverplugin_$version
dpkg-sig -k $signkey -s builder motionwebcamserverplugin_$version.deb
mv /tmp/motionwebcamserverplugin/motionwebcamserverplugin_$version.deb $pkgdir/motionwebcamserverplugin_$version.deb
#rm -rf /tmp/motionwebcamserverplugin/motionwebcamserverplugin_$version

