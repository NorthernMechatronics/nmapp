/*
 * main.c
 *
 *  Created on: Jul 15, 2019
 *      Author: joshua
 */
//*****************************************************************************
//
// Required built-ins.
//
//*****************************************************************************
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdlib.h>

//*****************************************************************************
//
// Standard AmbiqSuite includes.
//
//*****************************************************************************
#include "am_mcu_apollo.h"
#include "am_bsp.h"
#include "am_util.h"
#include "am_devices_led.h"
#include "am_hal_ctimer.h"

#include "FreeRTOS.h"
#include "task.h"

#include "console_task.h"
#include "gpio.h"
#include "iom.h"
#include "application.h"

//*****************************************************************************
//
// Sleep function called from FreeRTOS IDLE task.
// Do necessary application specific Power down operations here
// Return 0 if this function also incorporates the WFI, else return value same
// as idleTime
//
//*****************************************************************************
uint32_t am_freertos_sleep(uint32_t idleTime)
{
    am_hal_sysctrl_sleep(AM_HAL_SYSCTRL_SLEEP_DEEP);
    return 0;
}

//*****************************************************************************
//
// Recovery function called from FreeRTOS IDLE task, after waking up from Sleep
// Do necessary 'wakeup' operations here, e.g. to power up/enable peripherals etc.
//
//*****************************************************************************
void am_freertos_wakeup(uint32_t idleTime)
{
    return;
}

void am_gpio_isr(void)
{
    uint64_t ui64Status;

    am_hal_gpio_interrupt_status_get(true, &ui64Status);
    am_hal_gpio_interrupt_clear(ui64Status);
    am_hal_gpio_interrupt_service(ui64Status);
}

void am_ctimer_isr(void)
{
	uint32_t ui32Status;

	ui32Status = am_hal_ctimer_int_status_get(true);
	am_hal_ctimer_int_clear(ui32Status);
	am_hal_ctimer_int_service(ui32Status);
}

//*****************************************************************************
//
// FreeRTOS debugging functions.
//
//*****************************************************************************
void
vApplicationMallocFailedHook(void)
{
    //
    // Called if a call to pvPortMalloc() fails because there is insufficient
    // free memory available in the FreeRTOS heap.  pvPortMalloc() is called
    // internally by FreeRTOS API functions that create tasks, queues, software
    // timers, and semaphores.  The size of the FreeRTOS heap is set by the
    // configTOTAL_HEAP_SIZE configuration constant in FreeRTOSConfig.h.
    //
    while (1);
}

void
vApplicationStackOverflowHook(TaskHandle_t pxTask, char *pcTaskName)
{
    (void) pcTaskName;
    (void) pxTask;

    //
    // Run time stack overflow checking is performed if
    // configconfigCHECK_FOR_STACK_OVERFLOW is defined to 1 or 2.  This hook
    // function is called if a stack overflow is detected.
    //
    while (1)
    {
        __asm("BKPT #0\n") ; // Break into the debugger
    }
}


void system_setup(void)
{
    //
    // Set the clock frequency.
    //
    am_hal_clkgen_control(AM_HAL_CLKGEN_CONTROL_SYSCLK_MAX, 0);

    //
    // Set the default cache configuration
    //
    am_hal_cachectrl_config(&am_hal_cachectrl_defaults);
    am_hal_cachectrl_enable();

    am_hal_sysctrl_fpu_enable();
    am_hal_sysctrl_fpu_stacking_enable(true);

    //
    // Configure the board for low power.
    //
    am_hal_pwrctrl_low_power_init();
    am_hal_rtc_osc_disable();

    am_devices_led_array_init(am_bsp_psLEDs, AM_BSP_NUM_LEDS);
    am_devices_led_array_out(am_bsp_psLEDs, AM_BSP_NUM_LEDS, 0x0);

    am_hal_interrupt_master_enable();
}

void system_start(void)
{
	xTaskCreate(g_gpio_task, "GPIO", 512, 0, 4, &gpio_task_handle);
	xTaskCreate(g_iom_task, "IOM", 512, 0, 4, &iom_task_handle);
	xTaskCreate(g_console_task, "Console", 512, 0, 4, &console_task_handle);
	xTaskCreate(application_task, "Application", 512, 0, 3, &xApplicationTask);
	//
    // Start the scheduler.
    //
    vTaskStartScheduler();
}

int main(void)
{
	system_setup();
	system_start();

	while (1)
	{
	}

	return 0;
}
