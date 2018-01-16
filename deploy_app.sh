#!/bin/bash
set -e

APP_NAME=
NGINX_AVAILABLE_DIR="/etc/nginx/sites-available"
NGINX_ENABLED_DIR="/etc/nginx/sites-enabled"

nginx_reset() {
    if [ ! -f "$NGINX_AVAILABLE_DIR/$1" ]; then
        cat nginx > $NGINX_AVAILABLE_DIR/$1
        chmod 644 $NGINX_AVAILABLE_DIR/$1
    fi
    if [ ! -f "$NGINX_ENABLED_DIR/$1" ]; then
        ln -s $NGINX_AVAILABLE_DIR/$1 $NGINX_ENABLED_DIR/$1
    fi
    /etc/init.d/nginx start
}

get_help() {
    echo "Usage: $0 [-n <app name>]"
}

if [ "${1:0:1}" = '-' ]; then
    while getopts :n:h opt; do
        case "$opt" in
    	n)
    	    APP_NAME=${OPTARG}
            echo "The app $APP_NAME is to be deployed."
    	    ;;
    	h)
    	    get_help
    	    exit 0
    	    ;;
    	:)
    	    echo "The option -$OPTARG requires an argument."
    	    exit 1
            ;;
    	?)
    	    echo "The option -$OPTARG is invalid."
    	    get_help
            exit 1
    	    ;;
        esac
    done
    if [ -d "$APP_NAME" ]; then
        nginx_reset $APP_NAME
	cp uwsgi.ini $APP_NAME/uwsgi.ini
        uwsgi --ini $APP_NAME/uwsgi.ini 
    else
        echo "The directory $APP_NAME does not exist."
	exit 1
    fi
else
    exec "$@"
fi
