#! /bin/bash

host_platform=`uname | awk '{print tolower($0)}'`

if [[ $host_platform == "darwin" ]];
then aimake_home=`readlink $0    | sed 's/\/[^\/]*$//'`
else aimake_home=`readlink -f $0 | sed 's/\/[^\/]*$//'`; fi; 

supported_platforms=`ls -l $aimake_home | awk '/^d/{printf("%s%s", sp, $NF); sp=" ";}'`

aimakefile="aimakefile"
target_platform=$host_platform

while getopts "t:f:m:h" opt; do
    case $opt in
        t) target_platform=$OPTARG;;
        f) aimakefile=$OPTARG;;
        m) multidir=$OPTARG;; 
        h|?) echo "usage: aimake [options] [target]"; echo ""
             echo "options:"
             echo "    -h show this help message and exit"
             echo "    -t target platform, support '$supported_platforms', the default is '$host_platform'"
             echo "    -f aimakefile, the default is 'aimakefile'"
             echo "    -m source directory for building multiple target, such as test cases"; exit 1;;
    esac
done

if ! [[ -d $aimake_home/$target_platform ]]; then echo "unsupported target platform '"$target_platform"'"; exit 1; fi
if ! [[ -f $aimakefile ]]; then echo "'$aimakefile' does not exist"; exit 1; fi

shift $((OPTIND-1))

if [[ -z $multidir ]]; then
    make -f $aimake_home/main.mk LOCAL_PATH=`pwd` TARGET_PLATFORM=$target_platform AIMAKE_HOME=$aimake_home AIMAKEFILE=$aimakefile $@
else
    echo $@ | awk -v aimake=$0 '/clean/{system(aimake" clean")}'
    find $multidir -type f | awk '/\.c$/{gsub(/^\.\//,""); printf $0; gsub(/\.[^.]*$/,""); print " "$0}' > .aimakelist
    while read line; do
        src=${line%% *}; module=${line##* }; obj=${line##* }.o
        awk -v src=$src -v module=$module '{gsub(/#SRC#/, src); gsub(/#MODULE#/, module); print $0}' $aimakefile > .aimakefile
        cmd="rm -rf $module $obj"; echo $cmd; $cmd; if [[ $@ == "clean" ]]; then continue; fi
        $0 -t $target_platform -f .aimakefile; status=$?;
        if [[ $status -ne 0 ]]; then break; fi
    done < .aimakelist

    rm -rf .aimakefile .aimakelist
fi
