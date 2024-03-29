#******************************************************************************
#
# Step 1
# Define the locations of the various SDKs and libraries.
#
#******************************************************************************
NM_SDK    ?= $(shell pwd)/../nmsdk
AMBIQ_SDK ?= $(shell pwd)/../AmbiqSuite-R2.5.1
FREERTOS  ?= $(shell pwd)/../FreeRTOS-Kernel
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
# Specify output target version and name
#
#******************************************************************************
TARGET_VERSION := 0x00

ifdef DEBUG
    TARGET      := nmapp-dev
    TARGET_OTA  := nmapp_ota-dev
    TARGET_WIRE := nmapp_wire-dev
else
    TARGET      := nmapp
    TARGET_OTA  := nmapp_ota
    TARGET_WIRE := nmapp_wire
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

INCLUDES += -I$(NM_SDK)/platform/console

VPATH += $(NM_SDK)/platform/console

SRC += console_task.c
SRC += gpio_service.c
SRC += iom_service.c

SRC += application.c
