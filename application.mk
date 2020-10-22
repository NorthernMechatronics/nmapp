#******************************************************************************
#
# Define the locations of the various SDKs and libraries.
#
#******************************************************************************
NM_SDK    := $(HOME)/git/nmsdk
AMBIQ_SDK := $(HOME)/git/AmbiqSuite-R2.5.1
FREERTOS  := $(HOME)/git/FreeRTOS/FreeRTOS
CORDIO    := $(HOME)/git/AmbiqSuite-R2.5.1/third_party/cordio
UECC      := $(HOME)/git/AmbiqSuite-R2.5.1/third_party/uecc
LORAMAC   := $(HOME)/git/loramac-node

#******************************************************************************
#
# Specify the location of the board support package to be used.
#
#******************************************************************************
BSP_DIR := $(NM_SDK)/bsp/nm180100evb
