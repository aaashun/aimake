#
# objects
#
ifneq ($(LOCAL_SRC_DIRS),)
    LOCAL_SRC_FILES += $(shell find $(LOCAL_SRC_DIRS) -name "*.c" -or -name "*.cpp" -or -name "*.cc" -or -name "*.m")
endif
ifneq ($(LOCAL_SRC_DIRS_EXCLUDE),)
    LOCAL_SRC_FILES_EXCLUDE += $(shell find $(LOCAL_SRC_DIRS_EXCLUDE) -name "*.c" -or -name "*.cpp" -or -name "*.cc" -r -name "*.m")
endif

LOCAL_SRC_FILES  := $(filter-out $(LOCAL_SRC_FILES_EXCLUDE), $(LOCAL_SRC_FILES))


OBJECTS_ARMV7  = $(subst .c,.armv7.o,  $(subst .cpp,.armv7.o,  $(subst .cc,.armv7.o,  $(subst .m,.armv7.o,  $(LOCAL_SRC_FILES)))))
OBJECTS_ARMV7S = $(subst .c,.armv7s.o, $(subst .cpp,.armv7s.o, $(subst .cc,.armv7s.o, $(subst .m,.armv7s.o, $(LOCAL_SRC_FILES)))))
OBJECTS_I386   = $(subst .c,.i386.o,   $(subst .cpp,.i386.o,   $(subst .cc,.i386.o,   $(subst .m,.i386.o,   $(LOCAL_SRC_FILES)))))


#
# goal: all
#
all: $(ALL)

$(EXECUTABLE) : $(EXECUTABLE_ARMV7)  $(EXECUTABLE_ARMV7S) $(EXECUTABLE_I386)
	xcrun -sdk iphoneos lipo -output $@ -create -arch armv7 $(EXECUTABLE_ARMV7) -arch armv7s $(EXECUTABLE_ARMV7S) -arch i386 $(EXECUTABLE_I386)

$(EXECUTABLE_ARMV7) : $(OBJECTS_ARMV7)
	$(CXX_DEV) $^ $(LOCAL_CXXFLAGS) $(CXXFLAGS_ARMV7) $(LOCAL_LDFLAGS) $(LDFLAGS_DEV) -o $@

$(EXECUTABLE_ARMV7S) : $(OBJECTS_ARMV7S)
	$(CXX_DEV) $^ $(LOCAL_CXXFLAGS) $(CXXFLAGS_ARMV7S) $(LOCAL_LDFLAGS) $(LDFLAGS_DEV) -o $@

$(EXECUTABLE_I386) : $(OBJECTS_I386)
	$(CXX_SIM) $^ $(LOCAL_CXXFLAGS) $(CXXFLAGS_I386) $(LOCAL_LDFLAGS)  $(LDFLAGS_SIM) -o $@


$(SHARED_LIBRARY) : $(SHARED_LIBRARY_ARMV7) $(SHARED_LIBRARY_ARMV7S) $(SHARED_LIBRARY_I386)
	xcrun -sdk iphoneos lipo -output $@ -create -arch armv7 $(SHARED_LIBRARY_ARMV7) -arch armv7s $(SHARED_LIBRARY_ARMV7S) -arch i386 $(SHARED_LIBRARY_I386)

$(SHARED_LIBRARY_ARMV7) : $(OBJECTS_ARMV7)
	$(CXX_DEV) $^ $(LOCAL_CXXFLAGS) $(CXXFLAGS_ARMV7) $(LOCAL_LDFLAGS) $(LDFLAGS_DEV) -o $@

$(SHARED_LIBRARY_ARMV7S) : $(OBJECTS_ARMV7S)
	$(CXX_DEV) $^ $(LOCAL_CXXFLAGS) $(CXXFLAGS_ARMV7S) $(LOCAL_LDFLAGS) $(LDFLAGS_DEV) -o $@

$(SHARED_LIBRARY_I386) : $(OBJECTS_I386)
	$(CXX_SIM) $^ $(LOCAL_CXXFLAGS) $(CXXFLAGS_I386) $(LOCAL_LDFLAGS)  $(LDFLAGS_SIM) -o $@


$(STATIC_LIBRARY) : $(STATIC_LIBRARY_ARMV7) $(STATIC_LIBRARY_ARMV7S) $(STATIC_LIBRARY_I386)
	xcrun -sdk iphoneos lipo -output $@ -create -arch armv7 $(STATIC_LIBRARY_ARMV7) -arch armv7s $(STATIC_LIBRARY_ARMV7S) -arch i386 $(STATIC_LIBRARY_I386)

$(STATIC_LIBRARY_ARMV7) : $(OBJECTS_ARMV7)
	$(AIMAKE_HOME)/$(TARGET_PLATFORM)/rlipo.sh armv7 $(LOCAL_PATH)/.rlipo.armv7 $(LOCAL_LDFLAGS) >/dev/null
	$(AR_DEV) crv $@ $^ `find $(LOCAL_PATH)/.rlipo.armv7 -type f -regex .*\.o 2>/dev/null | xargs`

$(STATIC_LIBRARY_ARMV7S) : $(OBJECTS_ARMV7S)
	$(AIMAKE_HOME)/$(TARGET_PLATFORM)/rlipo.sh armv7s $(LOCAL_PATH)/.rlipo.armv7s $(LOCAL_LDFLAGS) >/dev/null
	$(AR_DEV) crv $@ $^ `find $(LOCAL_PATH)/.rlipo.armv7s -type f -regex .*\.o 2>/dev/null | xargs`

$(STATIC_LIBRARY_I386)  : $(OBJECTS_I386)
	$(AIMAKE_HOME)/$(TARGET_PLATFORM)/rlipo.sh i386 $(LOCAL_PATH)/.rlipo.i386 $(LOCAL_LDFLAGS) >/dev/null
	$(AR_SIM) crv $@ $^ `find $(LOCAL_PATH)/.rlipo.i386 -type f -regex .*\.o 2>/dev/null | xargs`

#
# goal: clean
#
clean:
	rm -rf $(EXECUTABLE) $(EXECUTABLE_ARMV7) $(EXECUTABLE_ARMV7S) $(EXECUTABLE_I386)  $(STATIC_LIBRARY) $(STATIC_LIBRARY_ARMV7) $(STATIC_LIBRARY_ARMV7S) $(STATIC_LIBRARY_I386) $(PACKAGE) $(OBJECTS_ARMV7) $(OBJECTS_ARMV7S) $(OBJECTS_I386) $(LOCAL_PATH)/.rlipo.*

#
# goal: package
#
ifeq ($(findstring package,$(MAKECMDGOALS)),package)
    ifeq ($(VERSION),)
        $(error require argument 'VERSION' for 'package' goal)
    endif
    ifeq ($(PACKAGE_RESOURCES),)
    endif
endif

PACKAGE_TEMP_DIR = $(PACKAGE:.tar.gz=)
package: $(PACKAGE)
$(PACKAGE): $(ALL)
	@[ -e $(PACKAGE_TEMP_DIR) ] && echo "$(PACKAGE_TEMP_DIR) already exist, please delete it manually" && exit;\
	rm -rf $(PACKAGE_TEMP_DIR);\
	rm -rf $@;
	mkdir -p $(PACKAGE_TEMP_DIR);
	cp -Rf -L $(ALL) $(LOCAL_PACKAGE_RESOURCES) $(PACKAGE_TEMP_DIR);
	tar --exclude .svn -h -czf $@ $(PACKAGE_TEMP_DIR);
	rm -rf $(PACKAGE_TEMP_DIR); 
