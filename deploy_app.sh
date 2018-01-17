#!/bin/bash
set -e

app_name=
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

uwsgi_reset() {
    local work_dir=$(pwd)
    sed -Ei -e 's#\$WORK_DIR#'$work_dir'#g' -e 's#\$APP_NAME#'$1'#g' uwsgi.ini
    cp uwsgi.ini $1/uwsgi.ini
    uwsgi --ini $1/uwsgi.ini 
}

get_help() {
    echo "Usage: $0 [-n <app name>]"
}

if [ "${1:0:1}" = '-' ]; then
    while getopts :n:h opt; do
        case "$opt" in
    	n)
    	    app_name=${OPTARG}
    	    ;;
    	h)
    	    get_help
    	    exit 0
    	    ;;
    	:)
    	    echo "ERROR: The option -$OPTARG requires an argument."
            ;;
    	?)
    	    echo "ERROR: The option -$OPTARG is invalid."
    	    get_help
            exit 2
    	    ;;
        esac
    done
    if [ -z "$app_name" ]; then
        echo "ERROR: There is no app specified to run."
	exit 2
    else
        if [ -d "$app_name" ]; then
            echo "INFO: The app $app_name is to be deployed."
            nginx_reset $app_name
            uwsgi_reset $app_name
        else
            echo "ERROR: The directory $app_name is not found."
            exit 1
        fi
    fi
else
    exec "$@"
fi
