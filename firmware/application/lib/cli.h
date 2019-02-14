/*
 * File: cli.h
 * Author: Ted Salmon <tass2001@gmail.com>
 * Description:
 *     Implement a CLI to pass commands to the device
 */
#ifndef CLI_H
#define CLI_H
#define _ADDED_C_LIB 1
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include "char_queue.h"
#include "config.h"
#include "ibus.h"
#include "uart.h"

#define CLI_MSG_END_CHAR 0x0D
#define CLI_MSG_DELIMETER 0x20
/**
 * CLI_t
 *     Description:
 *         This object defines our CLI object
 *     Fields:
 *         uart - The UART Object
 *         lastChar - The index of the last character echoed back to the user
 */
typedef struct CLI_t {
    UART_t *uart;
    uint8_t lastChar;
} CLI_t;
CLI_t CLIInit(UART_t *);
void CLIProcess(CLI_t *);
#endif /* CLI_H */