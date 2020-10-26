#******************************************************************************
#
# Step 1
# Define the locations of the various SDKs and libraries.
#
#******************************************************************************
NM_SDK    ?= $(PWD)/../nmsdk
AMBIQ_SDK ?= $(PWD)/../AmbiqSuite-R2.5.1
FREERTOS  ?= $(PWD)/../FreeRTOS/FreeRTOS
CORDIO    ?= $(PWD)/../AmbiqSuite-R2.5.1/third_party/cordio
UECC      ?= $(PWD)/../AmbiqSuite-R2.5.1/third_party/uecc
LORAMAC   ?= $(PWD)/../LoRaMac-node

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

INCLUDES += -I$(NM_SDK)/platform/console

VPATH += $(NM_SDK)/platform/console

SRC += console_task.c
SRC += gpio_service.c
SRC += iom_service.c

SRC += application.c
