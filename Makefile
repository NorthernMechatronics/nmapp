NM_SDK    := $(error NM_SDK location not defined)
AMBIQ_SDK := $(error AMBIQ_SDK location not defined)
FREERTOS  := $(error FREERTOS location not defined)

UECC      := $(AMBIQ_SDK)/third_party/uecc
CORDIO    := $(AMBIQ_SDK)/third_party/exactle

include nm_application.mk
include nm_cordio.mk

ifdef DEBUG
    TARGET   := nmapp-dev
else
    TARGET   := nmapp
endif

LDSCRIPT := ./ldscript.ld
ifdef DEBUG
    BUILDDIR := ./debug
    BSP_LIB  := -lam_bsp-dev
else
    BUILDDIR := ./release
    BSP_LIB  := -lam_bsp
endif

INCLUDES += -I$(NM_SDK)/bsp/devices
INCLUDES += -I$(NM_SDK)/bsp/nm180100evb
INCLUDES += -I$(NM_SDK)/platform

INCLUDES += -I$(CORDIO_PROFILES)/sources/apps
INCLUDES += -I$(CORDIO_PROFILES)/sources/apps/app
INCLUDES += -I$(CORDIO_PROFILES)/sources/apps/app/common
INCLUDES += -I$(CORDIO_PROFILES)/sources/apps/fit

INCLUDES += -I.

VPATH  = .
VPATH += $(NM_SDK)/platform
VPATH += $(CORDIO_PROFILES)/sources/apps/fit

SRC  = startup_gcc.c
SRC += main.c
SRC += build_timestamp.c
SRC += console_task.c
SRC += gpio.c
SRC += iom.c
SRC += lora_direct_config.c
SRC += lora_direct_console.c
SRC += lora_direct_task.c

SRC += application.c
SRC += ble.c
SRC += fit_main.c

CSRC = $(filter %.c, $(SRC))
ASRC = $(filter %.s, $(SRC))

OBJS  = $(CSRC:%.c=$(BUILDDIR)/%.o)
OBJS += $(ASRC:%.s=$(BUILDDIR)/%.o)

DEPS  = $(CSRC:%.c=$(BUILDDIR)/%.d)
DEPS += $(ASRC:%.s=$(BUILDDIR)/%.d)

CFLAGS += $(INCLUDES)
LFLAGS += -Wl,--start-group
LFLAGS += -L$(AMBIQ_SDK)/CMSIS/ARM/Lib/ARM
LFLAGS += -L$(NM_SDK)/build
LFLAGS += -larm_cortexM4lf_math
LFLAGS += -lm
LFLAGS += -lc
LFLAGS += -lgcc
LFLAGS += $(LIBS)
LFLAGS += $(BSP_LIB)
LFLAGS += --specs=nano.specs
LFLAGS += --specs=nosys.specs
LFLAGS += -Wl,--end-group

all: directories $(BUILDDIR)/$(TARGET).bin

directories: $(BUILDDIR)

$(BUILDDIR):
	@mkdir -p $@

$(BUILDDIR)/%.o: %.c $(BUILDDIR)/%.d $(INCS)
	@echo "Compiling $(COMPILERNAME) $<" ;\
	$(CC) -c $(CFLAGS) $< -o $@

$(BUILDDIR)/%.o: %.s $(BUILDDIR)/%.d $(INCS)
	@echo "Assembling $(COMPILERNAME) $<" ;\
	$(CC) -c $(CFLAGS) $< -o $@

$(BUILDDIR)/$(TARGET).axf: $(OBJS)
	@echo "Linking $@" ;\
	$(CC) -Wl,-T,$(LDSCRIPT) -o $@ $(OBJS) $(LFLAGS)

$(BUILDDIR)/$(TARGET).bin: $(BUILDDIR)/$(TARGET).axf
	$(OCP) $(OCPFLAGS) $< $@
	$(OD) $(ODFLAGS) $< > $(BUILDDIR)/$(TARGET).lst

clean:
	@echo "Cleaning..." ;\
	$(RM) -f $(OBJS) $(DEPS) $(BUILDDIR)/$(TARGET).a ;\
	$(RM) -rf $(BUILDDIR)

$(BUILDDIR)/%.d: ;

-include $(DEPS)

