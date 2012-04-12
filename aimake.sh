#! /bin/bash

supported_platforms=`ls -l | awk '/^d/{printf("%s%s", sp, $NF); sp=" ";}'`
host_platform=`uname | awk '{print tolower($0)}'`
target_platform=$host_platform
aimake_home=`readlink -f $0 | sed 's/\/[^\/]*$//'`
aimakefile="aimakefile"

while getopts "t:f:h" opt; do
    case $opt in
        t) target_platform=$OPTARG;;
        f) aimakefile=$OPTARG;;
        h|?) echo "usage: aimake [options] [target]"; echo ""
             echo "options:"
             echo "    -h show this help message and exit"
             echo "    -t target platform, support '$supported_platforms', the default is '$host_platform'"
             echo "    -f aimakefile, the default is 'aimakefile'"; exit 1;;
    esac
done

if ! [[ -d $aimake_home/$target_platform ]]; then echo "unsupported target platform '"$target_platform"'"; exit 1; fi
if ! [[ -f $aimakefile ]]; then echo "'$aimakefile' does not exist"; exit 1; fi

shift $((OPTIND-1))
make -f $aimake_home/main.mk LOCAL_PATH=`pwd` TARGET_PLATFORM=$target_platform AIMAKE_HOME=$aimake_home AIMAKEFILE=$aimakefile $@
