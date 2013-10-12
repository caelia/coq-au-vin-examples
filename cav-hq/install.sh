#!/bin/sh

dest_path="$1"

if [ -z "$dest_path" ]; then
    echo "USAGE: install.sh <target_directory>"
    exit 1
fi

fcgi_port=3128

if [ -n "$2" ]; then
    fcgi_port="$2"
fi

sed "s|%BLOG_ROOT%|$dest_path|g" cav-blog.scm.in \
    |sed "s|%FCGI_PORT%|$fcgi_port|g" >cav-blog.scm

mkdir -p ${dest_path}/data/content
cp -R dynamic $dest_path
csc cav-blog.scm
mv cav-blog $dest_path
csc setup.scm
mv setup $dest_path

cp -R static ${dest_path}
