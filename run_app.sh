#!/bin/bash
set -e

app_name=
work_dir="/app"
docker_file="Dockerfile"
build_tag=
port="8000"

prepare_to_build(){
    local build_dir="/tmp/build"
    if [ -d "$build_dir" ]; then
        rm -f $build_dir/*
    else
        mkdir -p $build_dir
    fi
    cp $3 uwsgi.ini nginx pip.conf requirements.txt deploy_app.sh $build_dir
    sed -Ei -e 's#\$WORK_DIR#'$1'#g' -e 's#\$APP_NAME#'$2'#g' $build_dir/uwsgi.ini
    sed -Ei -e 's#\$APP_NAME#'$2'#g' $build_dir/$3
}

get_help() {
    echo "Usage: $0 [-d <work directory>] [-f <docker file>] [-t <build tag>] [-p <port>] <app name>"
}

while getopts :d:f:t:p:h opt; do
    case "$opt" in
	d)
	    work_dir=${OPTARG%/}
	    echo "INFO: The work directory for the app is $work_dir."
	    ;;
	f)
	    docker_file=${OPTARG}
	    echo "INFO: The dockerfile for the build is $docker_file."
	    ;;
	t)
	    build_tag=${OPTARG}
	    echo "INFO: The tag for the build is $build_tag."
	    ;;
	p)
	    port=${OPTARG}
	    echo "INFO: The port for the app is $port."
	    ;;
	h)
	    get_help
	    exit 0
	    ;;
	:)
	    echo "WARNING: The option -$OPTARG requires an argument."
	    exit 1
            ;;
	?)
	    echo "ERROR: The option -$OPTARG is invalid."
	    get_help
            exit 1
	    ;;
    esac
done
shift $(($OPTIND -1 ))
if [ "$#" = 0 ]; then
    echo "WARNING: There is no app specified to deployed. Exit!"
    get_help
    exit 0
else
    app_name=$1
fi
if [ ! -f "$docker_file" ]; then
    echo "ERROR: The dockerfile $docker_file is not found!"
    exit 1
fi
if [ -z "$build_tag" ]; then
    echo "ERROR: The tag for the build is not specified!"
    exit 1
fi
prepare_to_build $work_dir $app_name $docker_file
docker build -f /tmp/build/$docker_file --force-rm --build-arg WORK_DIR=$work_dir -t $build_tag /tmp/build
if [ "$?" = 0 ]; then
    current_dir=$(pwd)
    docker_id=$(docker run -p $port:8080 -v $current_dir/$app_name:$work_dir/$app_name -d $build_tag)
    docker_info=$(docker ps -a -f ID=$docker_id --format "{{.ID}}:{{.Names}}:{{.Status}}")
    if [ -z "$docker_info" ]; then
	echo "ERROR: The app is not run."
        docker_id=""
	exit 1
    else
	docker_id=$(echo $docker_info | awk -F ':' '{print $1}')
	docker_name=$(echo $docker_info | awk -F ':' '{print $2}')
	docker_status=$(echo $docker_info | awk -F ':' '{print $3}')
	echo "INFO: The container \"$docker_name\" is $docker_status."
	exit 0
    fi
else
    echo "ERROR: $app is not successfully built."
    exit 1
fi
