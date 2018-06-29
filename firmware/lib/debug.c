/*
 * File:   debug.c
 * Author: Ted Salmon <tass2001@gmail.com>
 * Description:
 *     Implementation of logging mechanisms that we can use throughout the project
 */
#include <stdarg.h>
#include <string.h>
#include <stdio.h>
#include "../io_mappings.h"
#include "uart.h"

/**
 * LogMessage()
 *     Description:
 *         Send a message over the system UART, for the given syslog level.
 *         Implicitly adds CRLF
 *     Params:
 *         const char *type
 *         char *data
 *         ...
 *     Returns:
 *         void
 */
void LogMessage(const char *type, char *data)
{
    struct UART_t *debugger = UARTGetModuleHandler(SYSTEM_UART_MODULE);
    if (debugger != 0) {
        char output[255];
        sprintf(output, "%s: %s\r\n", type, data);
        UARTSendString(debugger, output);
    }
}

/**
 * LogRaw()
 *     Description:
 *         Send a message over the system UART. Implicitly pad with newline
 *     Params:
 *         const char *data
 *     Returns:
 *         void
 */
void LogRaw(char *data)
{
    struct UART_t *debugger = UARTGetModuleHandler(SYSTEM_UART_MODULE);
    if (debugger != 0) {
        UARTSendString(debugger, data);
        UARTSendString(debugger, "\r\n");
    }
}

/**
 * LogDebug()
 *     Description:
 *         Send a debug message over the system UART
 *     Params:
 *         const char *format
 *         ...
 *     Returns:
 *         void
 */
void LogDebug(const char *format, ...)
{
    char buffer[255];
    va_list args;
    va_start(args, format);
    vsprintf(buffer, format, args);
    va_end(args);
    LogMessage("DEBUG", buffer);
}

/**
 * LogError()
 *     Description:
 *         Send an error message over the system UART
 *         ...
 *     Params:
 *         const char *format
 *     Returns:
 *         void
 */
void LogError(const char *format, ...)
{
    char buffer[255];
    va_list args;
    va_start(args, format);
    vsprintf(buffer, format, args);
    va_end(args);
    LogMessage("ERROR", buffer);
}

/**
 * LogInfo()
 *     Description:
 *         Send an info message over the system UART
 *         ...
 *     Params:
 *         const char *format
 *     Returns:
 *         void
 */
void LogInfo(const char *format, ...)
{
    char buffer[255];
    va_list args;
    va_start(args, format);
    vsprintf(buffer, format, args);
    va_end(args);
    LogMessage("INFO", buffer);
}

/**
 * LogWarning()
 *     Description:
 *         Send a warning message over the system UART
 *     Params:
 *         const char *format
 *         ...
 *     Returns:
 *         void
 */
void LogWarning(const char *format, ...)
{
    char buffer[255];
    va_list args;
    va_start(args, format);
    vsprintf(buffer, format, args);
    va_end(args);
    LogMessage("WARNING", buffer);
}
