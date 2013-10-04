#!/bin/sh

export UWSGI_PROTOCOL=fastcgi
export UWSGI_UID=http
export UWSGI_GID=http
export UWSGI_PIDFILE=/run/yanagi_dev.pid
export UWSGI_EXEC_AS_USER=/srv/http/studioyanagi.com/dynamic/yanagi-web
export UWSGI_SOCKET=127.0.0.1:3121 
# export UWSGI_LOG_SYSTEMD=yanagi-dev
# export UWSGI_LOG_SYSTEMD=1
# export UWSGI_LOGTO2=/tmp/uwsgi.log
export UWSGI_MASTER=1
export UWSGI_PROCESSES=4

exec /usr/bin/uwsgi
