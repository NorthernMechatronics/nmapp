/*
 * start.c
 *
 *  Created on: Jul 15, 2019
 *      Author: joshua
 */
#include <stdint.h>
#include <stdbool.h>
#include <string.h>

//*****************************************************************************
//
// Standard AmbiqSuite includes.
//
//*****************************************************************************
#include "am_mcu_apollo.h"
#include "am_bsp.h"
#include "am_util.h"

#include "FreeRTOS.h"
#include "queue.h"

#include "application.h"

TaskHandle_t xApplicationTask;

void application_task(void *pvParameters)
{
    while (1)
    {
        am_hal_gpio_state_write(10, AM_HAL_GPIO_OUTPUT_TOGGLE);
        vTaskDelay(500);
    }
}
