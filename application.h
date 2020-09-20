/*
 * application.h
 *
 *  Created on: Jul 15, 2019
 *      Author: joshua
 */

#ifndef _APPLICATION_H_
#define _APPLICATION_H_

#include "FreeRTOS.h"
#include "task.h"

#define APPLICATION_TASK_ID	9000

extern TaskHandle_t xApplicationTask;

extern void application_task(void *pvParameters);

#endif /* _APPLICATION_H_ */
