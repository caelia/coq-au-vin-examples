#!/bin/sh

demo_path="$1"

mkdir -p ${demo_path}/data
cp -R dynamic $demo_path
csc live-demo01.scm
mv live-demo01 $demo_path

cd ../common
cp -R data/content ${demo_path}/data
cp -R static ${demo_path}
