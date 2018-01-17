#!/bin/bash
set -e

app_name=
work_dir="/app"
docker_file="Dockerfile"
build_tag=
port="8000"

prepare_to_build(){
    if [ ! -f "$1" ]; then
        echo "ERROR: The dockerfile $1 is not found."
        exit 1
    fi
    if [ -z "$2" ]; then
        echo "ERROR: The tag for the build is not specified."
        exit 2
    fi
    for i in uwsgi.ini nginx pip.conf requirements.txt deploy_app.sh; do
        if [ ! -f "$i" ]; then
            echo "ERROR: $i is not found."
	    exit 1
	fi
    done
}

get_help() {
    echo "Usage: $0 [-d <work directory>] [-f <docker file>] [-t <build tag>] [-p <port>] <app name>"
}

while getopts :d:f:t:p:h opt; do
    case "$opt" in
	d)
	    work_dir=${OPTARG%/}
	    ;;
	f)
	    docker_file=${OPTARG}
	    ;;
	t)
	    build_tag=${OPTARG}
	    ;;
	p)
	    port=${OPTARG}
	    ;;
	h)
	    get_help
	    exit 0
	    ;;
	:)
	    echo "WARNING: The option -$OPTARG requires an argument."
            ;;
	?)
	    echo "ERROR: The option -$OPTARG is invalid."
	    get_help
            exit 2
	    ;;
    esac
done
shift $(($OPTIND -1 ))
if [ "$#" = 0 ]; then
    app_name=""
else
    app_name=$1
fi
prepare_to_build $docker_file $build_tag
image_info=$(docker images $build_tag --format "{{.Repository}}:{{.Tag}}")
if [ -z "$image_info" ]; then
    echo "INFO: \"$build_tag\" has not been built. Start to build it. The work directory is $work_dir"
    docker build -f $docker_file --force-rm --build-arg WORK_DIR=$work_dir -t $build_tag .
    if [ "$?" = 0 ]; then
        echo "INFO: \"$build_tag\" is successfully built."
    else
        echo "ERROR: \"$build_tag\" is not successfully built."
        exit 1
    fi
else
    work_dir=$(docker run -i $build_tag pwd)
    docker container prune -f
    echo "INFO: \"$build_tag\" has been built. The work directory is $work_dir"
fi
if [ -z "$app_name" ]; then
    echo "WARNING: There is no app specified to run."
    exit 0
else
    current_dir=$(pwd)
    if [ -d "$current_dir/$app_name" ]; then
        docker_id=$(docker run -p $port:8080 -v $current_dir/$app_name:$work_dir/$app_name -d $build_tag -n $app_name)
        docker_info=$(docker ps -a -f ID=$docker_id --format "{{.ID}}:{{.Names}}:{{.Status}}")
        if [ -z "$docker_info" ]; then
            echo "ERROR: The app \"$app_name\" is not run."
            docker_id=""
            exit 1
        else
            docker_id=$(echo $docker_info | awk -F ':' '{print $1}')
            docker_name=$(echo $docker_info | awk -F ':' '{print $2}')
            docker_status=$(echo $docker_info | awk -F ':' '{print $3}')
            echo "INFO: \"$app_name\" is $docker_status on the container \"$docker_name\". The port for the app is $port."
            exit 0
        fi
    else
        echo "ERROR: The home directory for \"$app_name\" is not found."
        exit 1
    fi
fi
