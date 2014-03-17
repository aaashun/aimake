#
# objects
#
ifneq ($(LOCAL_SRC_DIRS),)
    LOCAL_SRC_FILES += $(shell find $(LOCAL_SRC_DIRS) -name "*.c" -or -name "*.cpp" -or -name "*.cc")
endif
ifneq ($(LOCAL_SRC_DIRS_EXCLUDE),)
    LOCAL_SRC_FILES_EXCLUDE += $(shell find $(LOCAL_SRC_DIRS_EXCLUDE) -name "*.c" -or -name "*.cpp" -or -name "*.cc")
endif

LOCAL_SRC_FILES  := $(filter-out $(LOCAL_SRC_FILES_EXCLUDE), $(LOCAL_SRC_FILES))

OBJECTS = $(subst .c,.o,$(subst .cpp,.o,$(subst .cc,.o,$(LOCAL_SRC_FILES))))

#
# goal: all
#
all: $(ALL)

$(EXECUTABLE) : $(OBJECTS)
	$(CXX) $^ $(LOCAL_LDFLAGS) $(LDFLAGS) -o $@

$(STATIC_LIBRARY) : $(OBJECTS)
	$(AR) crv $@ $^

$(SHARED_LIBRARY) : $(OBJECTS)
	$(CXX) $^ $(LDFLAGS) $(LOCAL_LDFLAGS) -o $@
	$(STRIP) --strip-unneeded $@


#
# goal: clean
#
clean:
	rm -rf $(EXECUTABLE) $(STATIC_LIBRARY) $(SHARED_LIBRARY) $(PACKAGE) $(OBJECTS)


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

LOCAL_PACKAGE_RESOURCES += $(ALL)
ifneq ($(LOCAL_PACKAGE_RESOURCES_EXCLUDE),)
    LOCAL_PACKAGE_RESOURCES := $(filter-out $(LOCAL_PACKAGE_RESOURCES_EXCLUDE), $(LOCAL_PACKAGE_RESOURCES))
endif

PACKAGE_TEMP_DIR = $(PACKAGE:.tar.gz=)

package: $(PACKAGE)
$(PACKAGE): $(LOCAL_PACKAGE_RESOURCES)
	@[ -e $(PACKAGE_TEMP_DIR) ] && echo "$(PACKAGE_TEMP_DIR) already exist, please delete it manually" && exit;\
	rm -rf $(PACKAGE_TEMP_DIR);\
	rm -rf $@;
	mkdir -p $(PACKAGE_TEMP_DIR);
	cp -rf -L $(LOCAL_PACKAGE_RESOURCES) $(PACKAGE_TEMP_DIR);
	tar --exclude .svn -h -czf $@ $(PACKAGE_TEMP_DIR);
	rm -rf $(PACKAGE_TEMP_DIR);
