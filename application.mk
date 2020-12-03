#******************************************************************************
#
# Step 1
# Define the locations of the various SDKs and libraries.
#
#******************************************************************************
NM_SDK    ?= $(shell pwd)/../nmsdk
AMBIQ_SDK ?= $(shell pwd)/../AmbiqSuite-R2.5.1
FREERTOS  ?= $(shell pwd)/../FreeRTOS/FreeRTOS
CORDIO    ?= $(shell pwd)/../AmbiqSuite-R2.5.1/third_party/cordio
UECC      ?= $(shell pwd)/../AmbiqSuite-R2.5.1/third_party/uecc
LORAMAC   ?= $(shell pwd)/../LoRaMac-node

#******************************************************************************
#
# Step 2
# Specify the location of the board support package to be used.
#
#******************************************************************************
BSP_DIR := $(NM_SDK)/bsp/nm180100evb

#******************************************************************************
#
# Step 3
# Specify output target name
#
#******************************************************************************
ifdef DEBUG
    TARGET   := nmapp-dev
else
    TARGET   := nmapp
endif

#******************************************************************************
#
# Step 4
# Include additional source, header, libraries or paths below.
#
# Examples:
#   INCLUDES += -Iadditional_include_path
#   VPATH    += additional_source_path
#   LIBS     += -ladditional_library
#******************************************************************************

####################################################
#
# BLE OTA Profile
# Uncomment the following if your application
# supports BLE over the air firwmware updates.
#
####################################################
#INCLUDES += -I$(AMBIQ_SDK)/bootloader
#VPATH += $(AMBIQ_SDK)/bootloader
#SRC += am_bootloader.c
#SRC += am_multi_boot.c
#
#INCLUDES += -I$(AMBIQ_SDK)/ambiq_ble/services
#VPATH += $(AMBIQ_SDK)/ambiq_ble/services
#SRC += svc_amotas.c
#
#INCLUDES += -I$(AMBIQ_SDK)/ambiq_ble/profiles/amota
#VPATH += $(AMBIQ_SDK)/ambiq_ble/profiles/amota
#SRC += amotas_main.c
#
#INCLUDES += -I$(AMBIQ_SDK)/ambiq_ble/apps/amota
#VPATH += $(AMBIQ_SDK)/ambiq_ble/apps/amota
#SRC += amota_main.c
#
####################################################

INCLUDES += -I$(NM_SDK)/platform/console

VPATH += $(NM_SDK)/platform/console

SRC += console_task.c
SRC += gpio_service.c
SRC += iom_service.c

SRC += application.c

