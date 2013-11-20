#
# android ndk configuration
#
ANDROID_NDK_HOME = /usr/local/android-ndk
TOOLCHAINS = $(ANDROID_NDK_HOME)/toolchains/arm-linux-androideabi-4.4.3/prebuilt/linux-x86
PLATFORM = $(ANDROID_NDK_HOME)/platforms/android-8/arch-arm
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
# -D__ARM_ARCH_5__ -D__ARM_ARCH_5T__ -D__ARM_ARCH_5E__ -D__ARM_ARCH_5TE__ 
# -ffunction-sections -funwind-tables -fstack-protector -Wno-psabi -fomit-frame-pointer -fno-strict-aliasing -finline-limit=300 -Wa,--noexecstack 
# -I$(ANDROID_NDK_HOME)/sources/android/cpufeatures

ANDABI=armv6-vfp
$(warning build for ANDABI: $(ANDABI))
$(shell sleep 1)

ifeq ($(ANDABI), armv5te)
    CFLAGS :=  -march=armv5te -marm -mfloat-abi=soft
else ifeq ($(ANDABI), armv6-vfp)
    CFLAGS := -march=armv6 -marm -mfloat-abi=softfp -mfpu=vfp
else ifeq ($(ANDABI), armv7a-vfpv3)
    CFLAGS := -march=armv7-a -marm -mfloat-abi=softfp -mfpu=vfpv3
else ifeq ($(ANDABI), armv7a-neon)
    CFLAGS := -march=armv7-a -marm -mfloat-abi=softfp -mfpu=neon -ftree-vectorize
else
    $(error only support ANDABI: armv5te, armv6-vfp, armv7a-vfpv3, armv7a-neon, the default is armv6-vfp)
endif

CFLAGS += -fsigned-char -I$(PLATFORM)/usr/include 

CXXFLAGS := $(CFLAGS) -I $(CXX_STL)/include -I $(CXX_STL)/libs/armeabi/include -I $(CXX_STL)/armeabi-fexceptions -frtti

#-Wl,--fix-cortex-a8 -Wl,-z,nocopyreloc -Wl,--no-undefined -Wl,-z,noexecstack -Wl,--gc-sections 
LDFLAGS := --sysroot=$(PLATFORM) -L$(PLATFORM)/usr/lib -llog -lc $(CXX_STL)/libs/armeabi/libgnustl_static.a
#libsupc++.a

#LDFLAGS := -Wl,-z,nocopyreloc -Wl,--no-undefined -Wl,-z,noexecstack -Wl,--gc-sections --sysroot=$(PLATFORM) -L$(PLATFORM)/usr/lib -llog -lc -lsupc++ $(CXX_STL)/libs/armeabi/libstdc++.a $(TOOLCHAINS)/lib/gcc/arm-linux-androideabi/4.4.3/libgcc.a
