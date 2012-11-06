#
# ios sdk configuration
# ios6 does not support armv6, so I removed it
#
#DEVROOT_IOS_DEV = /Developer/Platforms/iPhoneOS.platform/Developer
#DEVROOT_IOS_SIM = /Developer/Platforms/iPhoneSimulator.platform/Developer

#SDKROOT_IOS_DEV = $(DEVROOT_IOS_DEV)/SDKs/iPhoneOS5.0.sdk
#SDKROOT_IOS_SIM = $(DEVROOT_IOS_SIM)/SDKs/iPhoneSimulator5.0.sdk

DEVROOT_IOS_DEV = /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer
DEVROOT_IOS_SIM = /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer

SDKROOT_IOS_DEV = $(DEVROOT_IOS_DEV)/SDKs/iPhoneOS6.0.sdk
SDKROOT_IOS_SIM = $(DEVROOT_IOS_SIM)/SDKs/iPhoneSimulator6.0.sdk



#
# optimize configuration
#
CFLAGS_IOS_DEV_ARMV7_OPTIMIZE = -mcpu=cortex-a8 -mfpu=neon -ftree-vectorize -mfloat-abi=softfp -ffast-math
#-fsingle-precision-constant


#
# build variables
#

# device armv7
CC_IOS_DEV      = $(DEVROOT_IOS_DEV)/usr/bin/llvm-gcc
LD_IOS_DEV      = $(DEVROOT_IOS_DEV)/usr/bin/ld
CPP_IOS_DEV     = $(DEVROOT_IOS_DEV)/usr/bin/cpp
CXX_IOS_DEV     = $(DEVROOT_IOS_DEV)/usr/bin/llvm-g++
AR_IOS_DEV      = $(DEVROOT_IOS_DEV)/usr/bin/ar
AS_IOS_DEV      = $(DEVROOT_IOS_DEV)/usr/bin/as
NM_IOS_DEV      = $(DEVROOT_IOS_DEV)/usr/bin/nm
CXXCPP_IOS_DEV  = $(DEVROOT_IOS_DEV)/usr/bin/cpp
RANLIB_IOS_DEV  = $(DEVROOT_IOS_DEV)/usr/bin/ranlib

#CFLAGS_IOS_DEV  = -std=gnu99 -no-cpp-precomp -isysroot $(SDKROOT_IOS_DEV) -I$(SDKROOT_IOS_DEV)/usr/include -D__IPHONE_OS__
CFLAGS_IOS_DEV  = -no-cpp-precomp -isysroot $(SDKROOT_IOS_DEV) -I$(SDKROOT_IOS_DEV)/usr/include -D__IPHONE_OS__ -miphoneos-version-min=4.0
LDFLAGS_IOS_DEV = -L$(SDKROOT_IOS_DEV)/usr/lib -lstdc++

CFLAGS_IOS_DEV_ARMV7 = -arch armv7 $(CFLAGS_IOS_DEV_ARMV7_OPTIMIZE) $(CFLAGS_IOS_DEV)

CXXFLAGS_IOS_DEV_ARMV7 = $(CFLAGS_IOS_DEV_ARMV7)

# simulator i386
CC_IOS_SIM      = $(DEVROOT_IOS_SIM)/usr/bin/gcc
LD_IOS_SIM      = $(DEVROOT_IOS_SIM)/usr/bin/ld
CPP_IOS_SIM     = $(DEVROOT_IOS_SIM)/usr/bin/cpp
CXX_IOS_SIM     = $(DEVROOT_IOS_SIM)/usr/bin/g++
AR_IOS_SIM      = $(DEVROOT_IOS_SIM)/usr/bin/ar
AS_IOS_SIM      = $(DEVROOT_IOS_SIM)/usr/bin/as
NM_IOS_SIM      = $(DEVROOT_IOS_SIM)/usr/bin/nm
CXXCPP_IOS_SIM  = $(DEVROOT_IOS_SIM)/usr/bin/cpp
RANLIB_IOS_SIM  = $(DEVROOT_IOS_SIM)/usr/bin/ranlib

CFLAGS_IOS_SIM  := -no-cpp-precomp -isysroot $(SDKROOT_IOS_SIM) -I$(SDKROOT_IOS_SIM)/usr/include  -D__IPHONE_OS__
LDFLAGS_IOS_SIM := -L$(SDKROOT_IOS_SIM)/usr/lib -lstdc++

CFLAGS_IOS_SIM_I386 := -arch i386 $(CFLAGS_IOS_SIM)

CXXFLAGS_IOS_SIM_I386 := $(CFLAGS_IOS_SIM_I386)
