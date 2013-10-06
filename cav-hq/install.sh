#!/bin/sh

dest_path="$1"

if [ -z "$dest_path" ]; then
    echo "USAGE: install.sh <target_directory>"
    exit 1
fi

sed "s|%BLOG_ROOT%|$dest_path|g" cav-blog.scm.in >cav-blog.scm

mkdir -p ${dest_path}/data/content
cp -R dynamic $dest_path
csc cav-blog.scm
mv cav-blog $dest_path
csc setup.scm
mv setup $dest_path

cp -R static ${dest_path}
