#! /usr/bin/env bash
#
# this is reverse of 'lipo'
# extract thin lib from lipo, and then extract objects from thin lib
#

if [[ $# < 3 ]]; then
    echo "Usage: $0 arch outdir fatlibs ..."
    echo "Examples:"
    echo "    $0 armv7s .xlipo third/libcurl_fat.a third/libogg_fat.a"
    exit
fi

arch=$1
outdir=$2

rm -rf $outdir
mkdir -p $outdir

for i in ${@:3}; do
    if [[ $i =~ ".a"$ ]]; then
        libname=`basename $i`
        libname=${libname%%.*}
        libname=${libname%%-*}
        libname=${libname%%_*}
        thinlib=$libname.$arch.a
        subdir=$outdir/$libname
        mkdir $subdir

        # extract thin library from fat library
        xcrun -sdk iphoneos lipo $i -thin $arch -output $subdir/$thinlib

        # extract objects for thin library
        cd $subdir
        ar -x $thinlib

        # rename objects, in case that objects in different libraries have the some name
        for o in *.o; do
            o1=${o%%.o}.$arch.o
            if ! [[ $o1 =~ ^$libname.* ]]; then
                o1=$libname"_"$o1
            fi
            mv $o $o1
        done

        cd - >/dev/null
    fi
done
