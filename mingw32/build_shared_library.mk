ifeq ($(LOCAL_DLL_NAME_IN_LIB,)
    LOCAL_DLL_NAME_IN_LIB = $(LOCAL_MODULE).dll
endif
LDFLAGS := -shared $(LDFLAGS) #-Wl,--enable-stdcall-fixup
ALL = $(SHARED_LIBRARY)
include $(BUILD_ALL)
