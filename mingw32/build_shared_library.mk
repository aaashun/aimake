ifeq ($(LOCAL_DLLNAME),)
    LOCAL_DLLNAME = $(LOCAL_MODULE).dll
endif
LDFLAGS := -shared $(LDFLAGS) #-Wl,--enable-stdcall-fixup
ALL = $(SHARED_LIBRARY)
include $(BUILD_ALL)
