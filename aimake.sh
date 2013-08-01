#! /bin/bash

version="0.1"

host_platform=`uname | awk -F _ '{print tolower($1)}'`

if [[ $host_platform == "darwin" ]]; then
    aimake_home=`readlink $0 | sed 's/\/[^\/]*$//'`
    if [[ -z $aimake_home ]]; then
        aimake_home=`echo $0 | sed 's/\/[^\/]*$//'`
    fi
else
    aimake_home=`readlink -f $0 | sed 's/\/[^\/]*$//'`;
fi; 

supported_platforms=`ls -l $aimake_home | awk '/^d/{printf("%s%s", sp, $NF); sp=" ";}'`

aimakefile="aimakefile"
target_platform=$host_platform
timestamp=`date +20%y%m%d%H%M%S`

while getopts "t:f:m:h" opt; do
    case $opt in
        t) target_platform=$OPTARG;;
        f) aimakefile=$OPTARG;;
        h|?) echo "usage: aimake [options] [target]"; echo ""
             echo "options:"
             echo "    -h show this help message and exit"
             echo "    -t target platform, support '$supported_platforms', the default is '$host_platform'"
             echo "    -f aimakefile, the default is 'aimakefile'"
    esac
done

if ! [[ -d $aimake_home/$target_platform ]]; then
    echo "unsupported target platform '"$target_platform"'"
    exit 1
fi

if ! [[ -f $aimakefile ]]; then
    echo "'$aimakefile' does not exist"
    exit 1
fi

shift $((OPTIND-1))

make -f $aimake_home/main.mk LOCAL_PATH=`pwd` TIMESTAMP=$timestamp TARGET_PLATFORM=$target_platform AIMAKE_VERSION=$version AIMAKE_HOME=$aimake_home AIMAKEFILE=$aimakefile "$@"
