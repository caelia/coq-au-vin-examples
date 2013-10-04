#!/bin/sh

demo_path="$1"

if [ -z "$demo_path" ]; then
    echo "USAGE: setup-sh <target_directory>"
    exit 1
fi

mkdir -p ${demo_path}/data
cp -R dynamic $demo_path
csc live-demo02.scm
mv live-demo02 $demo_path

cd ../common
cp -R data/content ${demo_path}/data
cp -R static ${demo_path}
