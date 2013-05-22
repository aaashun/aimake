CC  = gcc
LD  = ld
CPP = cpp
CXX = g++
AR  = ar
AS  = as
NM  = nm
STRIP = strip
WINDRES = windres

CFLAGS   := -D WIN32 #-fPIC -pipe
CXXFLAGS := $(CFLAGS)
LDFLAGS := -static-libgcc -static-libstdc++ 
