#!/bin/sh

export UWSGI_PROTOCOL=fastcgi
export UWSGI_UID=http
export UWSGI_GID=http
export UWSGI_PIDFILE=/run/cav_blog.pid
export UWSGI_EXEC_AS_USER=/srv/http/cav-hq/cav-blog
export UWSGI_SOCKET=127.0.0.1:3128 
# export UWSGI_LOG_SYSTEMD=yanagi-dev
# export UWSGI_LOG_SYSTEMD=1
export UWSGI_LOGTO2=/tmp/cav-blog.log
export UWSGI_MASTER=1
export UWSGI_PROCESSES=4

exec /usr/bin/uwsgi
