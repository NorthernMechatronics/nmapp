NM_SDK         := /home/joshua/git/nmsdk
AMBIQ_SDK      := /home/joshua/git/AmbiqSuite-R2.4.2
FREERTOS       := /home/joshua/git/FreeRTOS/FreeRTOS

BSP_DIR        := $(NM_SDK)/bsp/nm180100evb/build

include nm_application.mk

ifdef DEBUG
    TARGET   := nmapp-dev
else
    TARGET   := nmapp
endif

LDSCRIPT := ./ldscript.ld
ifdef DEBUG
    BUILDDIR := ./debug
    BSP_LIB  := am_bsp-dev
else
    BUILDDIR := ./release
    BSP_LIB  := am_bsp
endif

INCLUDES += -I$(NM_SDK)/bsp/devices
INCLUDES += -I$(NM_SDK)/bsp/nm180100evb
INCLUDES += -I$(NM_SDK)/platform
INCLUDES += -I.

VPATH  = $(NM_SDK)/platform
VPATH += .

SRC  = startup_gcc.c
SRC += main.c
SRC += build_timestamp.c
SRC += application.c
SRC += console_task.c
SRC += gpio.c
SRC += iom.c
SRC += lora_direct_console.c
SRC += lora_direct_config.c
SRC += lora_direct_task.c

LIBS += -l$(BSP_LIB)

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
LFLAGS += -L$(BSP_DIR)
LFLAGS += -larm_cortexM4lf_math
LFLAGS += -lm
LFLAGS += -lc
LFLAGS += -lgcc
LFLAGS += $(LIBS)
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

