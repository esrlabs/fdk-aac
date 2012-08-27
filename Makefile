BUILDROOT	:= ..
TOOLCHAIN	:= $(BUILDROOT)/tools/arm-bcm2708/x86-linux64-cross-arm-linux-hardfp
ROOTFS		:= $(BUILDROOT)/rootfs
SYSROOT		:= $(BUILDROOT)/tools/arm-bcm2708/x86-linux64-cross-arm-linux-hardfp/arm-bcm2708hardfp-linux-gnueabi/sys-root
CC			:= $(TOOLCHAIN)/bin/arm-bcm2708hardfp-linux-gnueabi-gcc --sysroot=$(SYSROOT)
CXX         := $(TOOLCHAIN)/bin/arm-bcm2708hardfp-linux-gnueabi-g++ --sysroot=$(SYSROOT)

CFLAGS		:= -IlibAACdec/include -IlibAACenc/include -IlibPCMutils/include -IlibFDK/include -IlibSYS/include -IlibMpegTPDec/include -IlibMpegTPEnc/include -IlibSBRdec/include -IlibSBRenc/include
CFLAGS 		+= -march=armv6 -mfpu=vfp -mfloat-abi=hard
CFLAGS		+= -fPIC -O2
LDFLAGS		+= -shared -lc
LIBS		:= -L$(ROOTFS)/lib

aacdec_sources := $(wildcard libAACdec/src/*.cpp)
aacdec_sources := $(aacdec_sources:libAACdec/src/%=%)

aacenc_sources := $(wildcard libAACenc/src/*.cpp)
aacenc_sources := $(aacenc_sources:libAACenc/src/%=%)

pcmutils_sources := $(wildcard libPCMutils/src/*.cpp)
pcmutils_sources := $(pcmutils_sources:libPCMutils/src/%=%)

fdk_sources := $(wildcard libFDK/src/*.cpp)
fdk_sources := $(fdk_sources:libFDK/src/%=%)

sys_sources := $(wildcard libSYS/src/*.cpp)
sys_sources := $(sys_sources:libSYS/src/%=%)

mpegtpdec_sources := $(wildcard libMpegTPDec/src/*.cpp)
mpegtpdec_sources := $(mpegtpdec_sources:libMpegTPDec/src/%=%)

mpegtpenc_sources := $(wildcard libMpegTPEnc/src/*.cpp)
mpegtpenc_sources := $(mpegtpenc_sources:libMpegTPEnc/src/%=%)

sbrdec_sources := $(wildcard libSBRdec/src/*.cpp)
sbrdec_sources := $(sbrdec_sources:libSBRdec/src/%=%)

sbrenc_sources := $(wildcard libSBRenc/src/*.cpp)
sbrenc_sources := $(sbrenc_sources:libSBRenc/src/%=%)

SRCS := \
    $(aacdec_sources:%=libAACdec/src/%) \
    $(aacenc_sources:%=libAACenc/src/%) \
    $(pcmutils_sources:%=libPCMutils/src/%) \
    $(fdk_sources:%=libFDK/src/%) \
    $(sys_sources:%=libSYS/src/%) \
    $(mpegtpdec_sources:%=libMpegTPDec/src/%) \
    $(mpegtpenc_sources:%=libMpegTPEnc/src/%) \
    $(sbrdec_sources:%=libSBRdec/src/%) \
    $(sbrenc_sources:%=libSBRenc/src/%)

OBJS += $(filter %.o,$(SRCS:.cpp=.o))

libaac.so: $(OBJS)
	$(CXX) $(LDFLAGS) -o libaac.so $(OBJS) $(LIBS)

%.o: %.cpp
	@rm -f $@ 
	$(CXX) $(CFLAGS) $(INCLUDES) -c $< -o $@

clean:
	for i in $(OBJS); do (if test -e "$$i"; then ( rm $$i ); fi ); done
	@rm -f libaac.so
