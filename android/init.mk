#
# android ndk configuration
#
ANDROID_NDK_HOME = /usr/local/android-ndk
TOOLCHAINS = $(ANDROID_NDK_HOME)/toolchains/arm-linux-androideabi-4.4.3/prebuilt/linux-x86
PLATFORM = $(ANDROID_NDK_HOME)/platforms/android-3/arch-arm
CXX_STL = $(ANDROID_NDK_HOME)/sources/cxx-stl/gnu-libstdc++

CC  = $(TOOLCHAINS)/bin/arm-linux-androideabi-gcc
LD  = $(TOOLCHAINS)/bin/arm-linux-androideabi-ld
CPP = $(TOOLCHAINS)/bin/arm-linux-androideabi-cpp
CXX = $(TOOLCHAINS)/bin/arm-linux-androideabi-g++
AR  = $(TOOLCHAINS)/bin/arm-linux-androideabi-ar
AS  = $(TOOLCHAINS)/bin/arm-linux-androideabi-as
NM  = $(TOOLCHAINS)/bin/arm-linux-androideabi-nm
STRIP = $(TOOLCHAINS)/bin/arm-linux-androideabi-strip

# optimize and debug flags should be set in 'aimakefile'
# -Os -O3 -DNDEBUG -g
# -fpic
#
CFLAGS   := -fPIC -pipe -ffunction-sections -funwind-tables -fstack-protector -D__ARM_ARCH_5__ -D__ARM_ARCH_5T__ -D__ARM_ARCH_5E__ -D__ARM_ARCH_5TE__  -Wno-psabi -march=armv5te -mtune=xscale -msoft-float -mthumb -fomit-frame-pointer -fno-strict-aliasing -finline-limit=64 -I$(CXX_STL)/include -I$(CXX_STL)/libs/armeabi/include -DANDROID -Wa,--noexecstack -I$(PLATFORM)/usr/include

CXXFLAGS := $(CFLAGS) -fexceptions -frtti

LDFLAGS := -Wl,-z,nocopyreloc -Wl,--no-undefined -Wl,-z,noexecstack -Wl,--gc-sections --sysroot=$(PLATFORM) -L$(PLATFORM)/usr/lib -llog -lc -lsupc++ $(CXX_STL)/libs/armeabi/libstdc++.a $(TOOLCHAINS)/lib/gcc/arm-linux-androideabi/4.4.3/libgcc.a
