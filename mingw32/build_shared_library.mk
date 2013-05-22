LDFLAGS := -shared $(LDFLAGS) #-Wl,--enable-stdcall-fixup
ALL = $(SHARED_LIBRARY)
include $(BUILD_ALL)
