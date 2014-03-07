CC  = gcc
LD  = ld
CPP = cpp
CXX = g++
AR  = ar
AS  = as
NM  = nm
STRIP = strip

CFLAGS   := #-fPIC -pipe
CXXFLAGS := $(CFLAGS)
LDFLAGS :=


#
# explict rules
#
%.o : %.c
	$(CC) $(LOCAL_CFLAGS) $(CFLAGS) -c $< -o $@

%.o : %.cc
	$(CXX) $(LOCAL_CXXFLAGS) $(CXXFLAGS) -c $< -o $@

%.o : %.cpp
	$(CXX) $(LOCAL_CXXFLAGS) $(CXXFLAGS) -c $< -o $@


#
# building targets
#
EXECUTABLE = $(LOCAL_MODULE)
SHARED_LIBRARY  = lib$(LOCAL_MODULE).so
STATIC_LIBRARY  = lib$(LOCAL_MODULE).a
PACKAGE  = $(shell basename .t/$(LOCAL_MODULE))-$(shell cat /etc/issue | head -n 1 | awk '{os=tolower($$1);for(i=2;i<=NF;i++){if(match($$i,/[0-9\.]+/)){os=os"_"$$i;break;}};printf(os);}')-$(shell uname -m)-$(VERSION)-$(TIMESTAMP).tar.gz
