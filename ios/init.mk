#
# ios sdk configuration
# ios6 does not support armv6, so I removed it
#
#DEVROOT_DEV = /Developer/Platforms/iPhoneOS.platform/Developer
#DEVROOT_SIM = /Developer/Platforms/iPhoneSimulator.platform/Developer

#SDKROOT_DEV = $(DEVROOT_DEV)/SDKs/iPhoneOS5.0.sdk
#SDKROOT_SIM = $(DEVROOT_SIM)/SDKs/iPhoneSimulator5.0.sdk

DEVROOT_DEV = /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer
DEVROOT_SIM = /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer

SDKROOT_DEV = $(DEVROOT_DEV)/SDKs/iPhoneOS6.0.sdk
SDKROOT_SIM = $(DEVROOT_SIM)/SDKs/iPhoneSimulator6.0.sdk

#
# optimize configuration
#
CFLAGS_ARMV7_OPTIMIZE = -mcpu=cortex-a8 -mfpu=neon -ftree-vectorize -mfloat-abi=softfp -ffast-math
CFLAGS_ARMV7S_OPTIMIZE = $(CFLAGS_ARMV7_OPTIMIZE)
#-fsingle-precision-constant

#
# build variables
#

# device armv7, armv7s
CC_DEV      = $(DEVROOT_DEV)/usr/bin/llvm-gcc
LD_DEV      = $(DEVROOT_DEV)/usr/bin/ld
CPP_DEV     = $(DEVROOT_DEV)/usr/bin/cpp
CXX_DEV     = $(DEVROOT_DEV)/usr/bin/llvm-g++
AR_DEV      = $(DEVROOT_DEV)/usr/bin/ar
AS_DEV      = $(DEVROOT_DEV)/usr/bin/as
NM_DEV      = $(DEVROOT_DEV)/usr/bin/nm
CXXCPP_DEV  = $(DEVROOT_DEV)/usr/bin/cpp
RANLIB_DEV  = $(DEVROOT_DEV)/usr/bin/ranlib

#CFLAGS_DEV  = -std=gnu99 -no-cpp-precomp -isysroot $(SDKROOT_DEV) -I$(SDKROOT_DEV)/usr/include -D__IPHONE_OS__
CFLAGS_DEV  = -no-cpp-precomp -isysroot $(SDKROOT_DEV) -I$(SDKROOT_DEV)/usr/include -D__IPHONE_OS__ -miphoneos-version-min=4.0
LDFLAGS_DEV = -L$(SDKROOT_DEV)/usr/lib -lstdc++

CFLAGS_ARMV7 = -arch armv7 $(CFLAGS_ARMV7_OPTIMIZE) $(CFLAGS_DEV)
CFLAGS_ARMV7S = -arch armv7s $(CFLAGS_ARMV7S_OPTIMIZE) $(CFLAGS_DEV)

CXXFLAGS_ARMV7 = $(CFLAGS_ARMV7)
CXXFLAGS_ARMV7S = $(CFLAGS_ARMV7S)

# simulator i386
CC_SIM      = $(DEVROOT_SIM)/usr/bin/gcc
LD_SIM      = $(DEVROOT_SIM)/usr/bin/ld
CPP_SIM     = $(DEVROOT_SIM)/usr/bin/cpp
CXX_SIM     = $(DEVROOT_SIM)/usr/bin/g++
AR_SIM      = $(DEVROOT_SIM)/usr/bin/ar
AS_SIM      = $(DEVROOT_SIM)/usr/bin/as
NM_SIM      = $(DEVROOT_SIM)/usr/bin/nm
CXXCPP_SIM  = $(DEVROOT_SIM)/usr/bin/cpp
RANLIB_SIM  = $(DEVROOT_SIM)/usr/bin/ranlib

CFLAGS_SIM  := -no-cpp-precomp -isysroot $(SDKROOT_SIM) -I$(SDKROOT_SIM)/usr/include  -D__IPHONE_OS__
LDFLAGS_SIM := -L$(SDKROOT_SIM)/usr/lib -lstdc++

CFLAGS_I386 := -arch i386 $(CFLAGS_SIM)

CXXFLAGS_I386 := $(CFLAGS_I386)
