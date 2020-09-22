/*
 * start.c
 *
 *  Created on: Jul 15, 2019
 *      Author: joshua
 */
#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include <am_mcu_apollo.h>
#include <am_bsp.h>
#include <am_util.h>

#include <FreeRTOS.h>
#include <queue.h>

#include "nm_devices_lora.h"
#include "lora_direct_config.h"
#include "application.h"

TaskHandle_t xApplicationTask;

static const lora_radio_modulation_t defaultLoRaModulationParameter =
{
    .eSpreadingFactor = LORA_RADIO_SF7,
    .eBandwidth       = LORA_RADIO_BW_125,
    .eCodingRate      = LORA_CR_4_5,
    .eLowDataRateOptimization = LORA_RADIO_LDR_OPT_OFF
};

static const lora_radio_packet_t defaultLoRaPacketParameter =
{
    .ui16PreambleLength = 0x0008,
    .ePacketLength = LORA_RADIO_PACKET_LENGTH_VARIABLE,
    .ui8PayloadLength = LORA_RADIO_MAX_PHYSICAL_PACKET,
    .eCRC          = LORA_RADIO_CRC_OFF,
    .eIQ           = LORA_RADIO_IQ_INVERTED
};

void lora_direct_radio_configuration_reset()
{
    lora_radio_frequency = 915000000;
    lora_radio_power     = 22;
    lora_radio_syncword  = 0x3444;
    lora_radio_transmit_period = 2;

    memcpy(&gsLoRaModulationParameter, &defaultLoRaModulationParameter, sizeof(lora_radio_modulation_t));
    memcpy(&gsLoRaPacketParameter, &defaultLoRaPacketParameter, sizeof(lora_radio_packet_t));
}

void application_task(void *pvParameters)
{
    while (1)
    {
        am_hal_gpio_state_write(10, AM_HAL_GPIO_OUTPUT_TOGGLE);
        vTaskDelay(500);
    }
}
