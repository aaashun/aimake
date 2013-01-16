#! /bin/bash

#
# http://www.fadai8.net/2012/07/18/build-libcurl-for-ios-sdk-5-1/
#
if [[ $# < 2 ]]; then
    echo "Usage: $0 target platform [confopt]"
    echo "Examples:"
    echo "    $0 armv7  iPhoneOS '--disable-shared --enable-static'"
    echo "    $0 armv7s iPhoneOS '--disable-shared --enable-static'"
    echo "    $0 i386   iPhoneSimulator '--disable-shared --enable-static'"
    echo "PS: you can make a fat library comtains armv7, armv7s and i386 lib, the following is the command"
    echo "    xcrun -sdk iphoneos lipo -create -arch armv7 libogg.armv7.a -arch armv7s libogg.armv7s.a -arch i386 libogg.i386.a -output libogg.a"
    exit;
fi

target=$1
platform=$2
confopt=$3

SDK=6.0
DEVROOT="/Applications/Xcode.app/Contents/Developer/Platforms"

export CC="${DEVROOT}/${platform}.platform/Developer/usr/bin/gcc"
export LD="${DEVROOT}/${platform}.platform/Developer/usr/bin/ld"
export CFLAGS="-arch ${target} -isysroot ${DEVROOT}/${platform}.platform/Developer/SDKs/${platform}${SDK}.sdk -D__IPHONE_OS__ -miphoneos-version-min=4.0"
export CPP="${DEVROOT}/${platform}.platform/Developer/usr/bin/llvm-cpp-4.2"
export CXX="${DEVROOT}/${platform}.platform/Developer/usr/bin/g++"
export CXXCPP="${DEVROOT}/${platform}.platform/Developer/usr/bin/llvm-cpp-4.2"
export AS="${DEVROOT}/${platform}.platform/Developer/usr/bin/as"
export NM="${DEVROOT}/${platform}.platform/Developer/usr/bin/nm"
export AR="${DEVROOT}/${platform}.platform/Developer/usr/bin/ar"
export RANLIB="${DEVROOT}/${platform}.platform/Developer/usr/bin/ranlib"

./configure --host=${target}-apple-darwin10 $confopt

make clean all
