
#
# objects
#
ifneq ($(LOCAL_SRC_DIRS),)
    LOCAL_SRC_FILES0 += $(shell find $(LOCAL_SRC_DIRS) -name "*.c" -or -name "*.cpp" -or -name "*.rc")
endif
ifneq ($(LOCAL_SRC_DIRS_EXCLUDE),)
    LOCAL_SRC_FILES0_EXCLUDE += $(shell find $(LOCAL_SRC_DIRS_EXCLUDE) -name "*.c" -or -name "*.cpp" -or -name "*.rc")
endif

LOCAL_SRC_FILES0 := $(filter-out $(LOCAL_SRC_FILES0_EXCLUDE), $(LOCAL_SRC_FILES0))
LOCAL_SRC_FILES  := $(filter-out $(LOCAL_SRC_FILES_EXCLUDE), $(LOCAL_SRC_FILES))
LOCAL_SRC_FILES  += $(LOCAL_SRC_FILES0)



OBJECTS = $(subst .c,.o,$(subst .cpp,.o,$(subst .rc,.o,$(LOCAL_SRC_FILES))))


#
# building targets
#
EXECUTABLE = $(LOCAL_MODULE)
SHARED_LIBRARY  = $(LOCAL_MODULE).dll
STATIC_LIBRARY  = $(LOCAL_MODULE).lib
PACKAGE  = $(shell basename .t/$(LOCAL_MODULE))-$(TARGET_PLATFORM)-$(VERSION)-$(TIMESTAMP).zip

#
# explict rules
#
%.o : %.c
	$(CC) $(LOCAL_CFLAGS) $(CFLAGS) -c $< -o $@

%.o : %.cpp
	$(CXX) $(LOCAL_CXXFLAGS) $(CXXFLAGS) -c $< -o $@

%.o : %.rc
	$(WINDRES) -J rc -O coff -i $< -o $@

#
# goal: all
#
all: $(ALL)

$(EXECUTABLE) : $(OBJECTS)
	$(CXX) $^ $(LOCAL_LDFLAGS) $(LDFLAGS) -o $@

$(STATIC_LIBRARY) : $(OBJECTS)
	$(AR) crv $@ $^

#
#	$(CXX) $^ $(LDFLAGS) $(LOCAL_LDFLAGS) -Wl,--kill-at -Wl,--output-def,$(LOCAL_MODULE).def,--out-implib,lib$(LOCAL_MODULE).a -o $(LOCAL_MODULE).dll
#   dlltool -d $(LOCAL_MODULE).def --dllname $(LOCAL_MODULE).dll --output-lib $(LOCAL_MODULE).lib --kill-at
#
$(SHARED_LIBRARY) : $(OBJECTS)
	$(CXX) $^ $(LDFLAGS) $(LOCAL_LDFLAGS) -Wl,--kill-at -Wl,--output-def,$(LOCAL_MODULE).def -o $(LOCAL_MODULE).dll
	$(STRIP) --strip-unneeded $@
	sed -i 's/[^ \t]* = //g' $(LOCAL_MODULE).def
	lib /machine:i386 /def:$(LOCAL_MODULE).def /out:$(LOCAL_MODULE).lib

#
# goal: clean
#
clean:
	rm -rf $(ALL) $(OBJECTS) $(LOCAL_MODULE).lib $(LOCAL_MODULE).def


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

PACKAGE_TEMP_DIR = $(PACKAGE:.zip=)
package: $(PACKAGE)
$(PACKAGE): $(ALL)
	@[ -e $(PACKAGE_TEMP_DIR) ] && echo "$(PACKAGE_TEMP_DIR) already exist, please delete it manually" && exit;\
	rm -rf $(PACKAGE_TEMP_DIR);\
	rm -rf $@;
	mkdir -p $(PACKAGE_TEMP_DIR);
	cp -rf -L $(ALL) $(LOCAL_PACKAGE_RESOURCES) $(PACKAGE_TEMP_DIR);
	zip -x *.svn/* -r $@ $(PACKAGE_TEMP_DIR);
	rm -rf $(PACKAGE_TEMP_DIR);
