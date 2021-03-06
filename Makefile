BUILDROOT := ..
TOOLCHAIN := $(BUILDROOT)/tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian
CC		  := $(TOOLCHAIN)/bin/arm-linux-gnueabihf-gcc
CXX       := $(TOOLCHAIN)/bin/arm-linux-gnueabihf-g++
LD        := $(TOOLCHAIN)/bin/arm-linux-gnueabihf-g++
CFLAGS    := -D__ARM_CPU_ARCH__ -D__ARMv6_CPU_ARCH__ -fPIC -march=armv6 -mfpu=vfp -mfloat-abi=hard -O2
LDFLAGS   := -shared -lpthread -lrt

MODULES   := libAACdec libAACenc libPCMutils libFDK libSYS libMpegTPDec libMpegTPEnc libSBRdec libSBRenc
SRC_DIR   := $(addsuffix /src,$(MODULES))
BUILD_DIR := $(addprefix out/,$(SRC_DIR))

SRCS      := $(foreach sdir,$(SRC_DIR),$(wildcard $(sdir)/*.cpp))
OBJS      := $(patsubst %.cpp,out/%.o,$(SRCS))
INCLUDES  := $(addsuffix /include,$(addprefix -I,$(MODULES)))

vpath %.cpp $(SRC_DIR)

define make-srcs
$1/%.o: %.cpp
	$(CXX) $(CFLAGS) $(INCLUDES) -c $$< -o $$@
endef

.PHONY: all checkdirs clean

all: checkdirs libaac.so

libaac.so: $(OBJS)
	$(LD) $(LDFLAGS) $^ -o $@

checkdirs: $(BUILD_DIR)

$(BUILD_DIR):
	@mkdir -p $@

clean:
	@rm -rf $(BUILD_DIR)

$(foreach bdir,$(BUILD_DIR),$(eval $(call make-srcs,$(bdir))))

