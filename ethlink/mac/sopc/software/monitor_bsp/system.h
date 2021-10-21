/*
 * system.h - SOPC Builder system and BSP software package information
 *
 * Machine generated for CPU 'cpu' in SOPC Builder design 'nios'
 * SOPC Builder design path: ../../nios.sopcinfo
 *
 * Generated: Fri Jan 03 13:02:21 CET 2014
 */

/*
 * DO NOT MODIFY THIS FILE
 *
 * Changing this file will have subtle consequences
 * which will almost certainly lead to a nonfunctioning
 * system. If you do modify this file, be aware that your
 * changes will be overwritten and lost when this file
 * is generated again.
 *
 * DO NOT MODIFY THIS FILE
 */

/*
 * License Agreement
 *
 * Copyright (c) 2008
 * Altera Corporation, San Jose, California, USA.
 * All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 *
 * This agreement shall be governed in all respects by the laws of the State
 * of California and by the laws of the United States of America.
 */

#ifndef __SYSTEM_H_
#define __SYSTEM_H_

/* Include definitions from linker script generator */
#include "linker.h"


/*
 * CPU configuration
 *
 */

#define NIOS2_BIG_ENDIAN 0
#define NIOS2_BREAK_ADDR 0x20
#define NIOS2_CPU_FREQ 50000000u
#define NIOS2_CPU_ID_SIZE 1
#define NIOS2_CPU_ID_VALUE 0x0
#define NIOS2_CPU_IMPLEMENTATION "tiny"
#define NIOS2_DATA_ADDR_WIDTH 14
#define NIOS2_DCACHE_LINE_SIZE 0
#define NIOS2_DCACHE_LINE_SIZE_LOG2 0
#define NIOS2_DCACHE_SIZE 0
#define NIOS2_EXCEPTION_ADDR 0x2020
#define NIOS2_FLUSHDA_SUPPORTED
#define NIOS2_HARDWARE_DIVIDE_PRESENT 0
#define NIOS2_HARDWARE_MULTIPLY_PRESENT 0
#define NIOS2_HARDWARE_MULX_PRESENT 0
#define NIOS2_HAS_DEBUG_CORE 1
#define NIOS2_HAS_DEBUG_STUB
#define NIOS2_HAS_JMPI_INSTRUCTION
#define NIOS2_ICACHE_LINE_SIZE 0
#define NIOS2_ICACHE_LINE_SIZE_LOG2 0
#define NIOS2_ICACHE_SIZE 0
#define NIOS2_INST_ADDR_WIDTH 14
#define NIOS2_RESET_ADDR 0x2000


/*
 * Define for each module class mastered by the CPU
 *
 */

#define __ALTERA_AVALON_JTAG_UART
#define __ALTERA_AVALON_ONCHIP_MEMORY2
#define __ALTERA_AVALON_UART
#define __ALTERA_NIOS2
#define __MMSLAVEINT


/*
 * System configuration
 *
 */

#define ALT_CPU_ARCHITECTURE "altera_nios2"
#define ALT_CPU_FREQ 50000000
#define ALT_CPU_NAME "cpu"
#define ALT_DEVICE_FAMILY "STRATIXIV"
#define ALT_ENHANCED_INTERRUPT_API_PRESENT
#define ALT_IRQ_BASE NULL
#define ALT_LOG_PORT "/dev/null"
#define ALT_LOG_PORT_BASE 0x0
#define ALT_LOG_PORT_DEV null
#define ALT_LOG_PORT_TYPE ""
#define ALT_NUM_EXTERNAL_INTERRUPT_CONTROLLERS 0
#define ALT_NUM_INTERNAL_INTERRUPT_CONTROLLERS 1
#define ALT_NUM_INTERRUPT_CONTROLLERS 1
#define ALT_STDERR "/dev/jtag_uart"
#define ALT_STDERR_BASE 0x800
#define ALT_STDERR_DEV jtag_uart
#define ALT_STDERR_PRESENT
#define ALT_STDERR_TYPE "altera_avalon_jtag_uart"
#define ALT_STDIN "/dev/jtag_uart"
#define ALT_STDIN_BASE 0x800
#define ALT_STDIN_DEV jtag_uart
#define ALT_STDIN_PRESENT
#define ALT_STDIN_TYPE "altera_avalon_jtag_uart"
#define ALT_STDOUT "/dev/jtag_uart"
#define ALT_STDOUT_BASE 0x800
#define ALT_STDOUT_DEV jtag_uart
#define ALT_STDOUT_PRESENT
#define ALT_STDOUT_TYPE "altera_avalon_jtag_uart"
#define ALT_SYSTEM_NAME "nios"


/*
 * altera_extended_hal_bsp configuration
 *
 */

#define ALT_MAX_FD 4
#define ALT_SYS_CLK none
#define ALT_TIMESTAMP_CLK none


/*
 * iobusMAC_0 configuration
 *
 */

#define ALT_MODULE_CLASS_iobusMAC_0 MMslaveint
#define IOBUSMAC_0_BASE 0x840
#define IOBUSMAC_0_IRQ -1
#define IOBUSMAC_0_IRQ_INTERRUPT_CONTROLLER_ID -1
#define IOBUSMAC_0_NAME "/dev/iobusMAC_0"
#define IOBUSMAC_0_SPAN 64
#define IOBUSMAC_0_TYPE "MMslaveint"


/*
 * iobusMAC_1 configuration
 *
 */

#define ALT_MODULE_CLASS_iobusMAC_1 MMslaveint
#define IOBUSMAC_1_BASE 0x880
#define IOBUSMAC_1_IRQ -1
#define IOBUSMAC_1_IRQ_INTERRUPT_CONTROLLER_ID -1
#define IOBUSMAC_1_NAME "/dev/iobusMAC_1"
#define IOBUSMAC_1_SPAN 64
#define IOBUSMAC_1_TYPE "MMslaveint"


/*
 * iobusMAC_2 configuration
 *
 */

#define ALT_MODULE_CLASS_iobusMAC_2 MMslaveint
#define IOBUSMAC_2_BASE 0x8c0
#define IOBUSMAC_2_IRQ -1
#define IOBUSMAC_2_IRQ_INTERRUPT_CONTROLLER_ID -1
#define IOBUSMAC_2_NAME "/dev/iobusMAC_2"
#define IOBUSMAC_2_SPAN 64
#define IOBUSMAC_2_TYPE "MMslaveint"


/*
 * iobusMAC_3 configuration
 *
 */

#define ALT_MODULE_CLASS_iobusMAC_3 MMslaveint
#define IOBUSMAC_3_BASE 0x900
#define IOBUSMAC_3_IRQ -1
#define IOBUSMAC_3_IRQ_INTERRUPT_CONTROLLER_ID -1
#define IOBUSMAC_3_NAME "/dev/iobusMAC_3"
#define IOBUSMAC_3_SPAN 64
#define IOBUSMAC_3_TYPE "MMslaveint"


/*
 * iobusMAC_4 configuration
 *
 */

#define ALT_MODULE_CLASS_iobusMAC_4 MMslaveint
#define IOBUSMAC_4_BASE 0x940
#define IOBUSMAC_4_IRQ -1
#define IOBUSMAC_4_IRQ_INTERRUPT_CONTROLLER_ID -1
#define IOBUSMAC_4_NAME "/dev/iobusMAC_4"
#define IOBUSMAC_4_SPAN 64
#define IOBUSMAC_4_TYPE "MMslaveint"


/*
 * iobusMAC_5 configuration
 *
 */

#define ALT_MODULE_CLASS_iobusMAC_5 MMslaveint
#define IOBUSMAC_5_BASE 0x980
#define IOBUSMAC_5_IRQ -1
#define IOBUSMAC_5_IRQ_INTERRUPT_CONTROLLER_ID -1
#define IOBUSMAC_5_NAME "/dev/iobusMAC_5"
#define IOBUSMAC_5_SPAN 64
#define IOBUSMAC_5_TYPE "MMslaveint"


/*
 * iobusMAC_6 configuration
 *
 */

#define ALT_MODULE_CLASS_iobusMAC_6 MMslaveint
#define IOBUSMAC_6_BASE 0x9c0
#define IOBUSMAC_6_IRQ -1
#define IOBUSMAC_6_IRQ_INTERRUPT_CONTROLLER_ID -1
#define IOBUSMAC_6_NAME "/dev/iobusMAC_6"
#define IOBUSMAC_6_SPAN 64
#define IOBUSMAC_6_TYPE "MMslaveint"


/*
 * iobusMAC_7 configuration
 *
 */

#define ALT_MODULE_CLASS_iobusMAC_7 MMslaveint
#define IOBUSMAC_7_BASE 0xa00
#define IOBUSMAC_7_IRQ -1
#define IOBUSMAC_7_IRQ_INTERRUPT_CONTROLLER_ID -1
#define IOBUSMAC_7_NAME "/dev/iobusMAC_7"
#define IOBUSMAC_7_SPAN 64
#define IOBUSMAC_7_TYPE "MMslaveint"


/*
 * iobusMDIO_0 configuration
 *
 */

#define ALT_MODULE_CLASS_iobusMDIO_0 MMslaveint
#define IOBUSMDIO_0_BASE 0xb00
#define IOBUSMDIO_0_IRQ -1
#define IOBUSMDIO_0_IRQ_INTERRUPT_CONTROLLER_ID -1
#define IOBUSMDIO_0_NAME "/dev/iobusMDIO_0"
#define IOBUSMDIO_0_SPAN 16
#define IOBUSMDIO_0_TYPE "MMslaveint"


/*
 * iobusMDIO_1 configuration
 *
 */

#define ALT_MODULE_CLASS_iobusMDIO_1 MMslaveint
#define IOBUSMDIO_1_BASE 0xb10
#define IOBUSMDIO_1_IRQ -1
#define IOBUSMDIO_1_IRQ_INTERRUPT_CONTROLLER_ID -1
#define IOBUSMDIO_1_NAME "/dev/iobusMDIO_1"
#define IOBUSMDIO_1_SPAN 16
#define IOBUSMDIO_1_TYPE "MMslaveint"


/*
 * iobusMDIO_2 configuration
 *
 */

#define ALT_MODULE_CLASS_iobusMDIO_2 MMslaveint
#define IOBUSMDIO_2_BASE 0xb20
#define IOBUSMDIO_2_IRQ -1
#define IOBUSMDIO_2_IRQ_INTERRUPT_CONTROLLER_ID -1
#define IOBUSMDIO_2_NAME "/dev/iobusMDIO_2"
#define IOBUSMDIO_2_SPAN 16
#define IOBUSMDIO_2_TYPE "MMslaveint"


/*
 * iobusMDIO_3 configuration
 *
 */

#define ALT_MODULE_CLASS_iobusMDIO_3 MMslaveint
#define IOBUSMDIO_3_BASE 0xb30
#define IOBUSMDIO_3_IRQ -1
#define IOBUSMDIO_3_IRQ_INTERRUPT_CONTROLLER_ID -1
#define IOBUSMDIO_3_NAME "/dev/iobusMDIO_3"
#define IOBUSMDIO_3_SPAN 16
#define IOBUSMDIO_3_TYPE "MMslaveint"


/*
 * iobusMDIO_4 configuration
 *
 */

#define ALT_MODULE_CLASS_iobusMDIO_4 MMslaveint
#define IOBUSMDIO_4_BASE 0xb40
#define IOBUSMDIO_4_IRQ -1
#define IOBUSMDIO_4_IRQ_INTERRUPT_CONTROLLER_ID -1
#define IOBUSMDIO_4_NAME "/dev/iobusMDIO_4"
#define IOBUSMDIO_4_SPAN 16
#define IOBUSMDIO_4_TYPE "MMslaveint"


/*
 * iobusMDIO_5 configuration
 *
 */

#define ALT_MODULE_CLASS_iobusMDIO_5 MMslaveint
#define IOBUSMDIO_5_BASE 0xb50
#define IOBUSMDIO_5_IRQ -1
#define IOBUSMDIO_5_IRQ_INTERRUPT_CONTROLLER_ID -1
#define IOBUSMDIO_5_NAME "/dev/iobusMDIO_5"
#define IOBUSMDIO_5_SPAN 16
#define IOBUSMDIO_5_TYPE "MMslaveint"


/*
 * iobusMDIO_6 configuration
 *
 */

#define ALT_MODULE_CLASS_iobusMDIO_6 MMslaveint
#define IOBUSMDIO_6_BASE 0xb60
#define IOBUSMDIO_6_IRQ -1
#define IOBUSMDIO_6_IRQ_INTERRUPT_CONTROLLER_ID -1
#define IOBUSMDIO_6_NAME "/dev/iobusMDIO_6"
#define IOBUSMDIO_6_SPAN 16
#define IOBUSMDIO_6_TYPE "MMslaveint"


/*
 * iobusMDIO_7 configuration
 *
 */

#define ALT_MODULE_CLASS_iobusMDIO_7 MMslaveint
#define IOBUSMDIO_7_BASE 0xb70
#define IOBUSMDIO_7_IRQ -1
#define IOBUSMDIO_7_IRQ_INTERRUPT_CONTROLLER_ID -1
#define IOBUSMDIO_7_NAME "/dev/iobusMDIO_7"
#define IOBUSMDIO_7_SPAN 16
#define IOBUSMDIO_7_TYPE "MMslaveint"


/*
 * jtag_uart configuration
 *
 */

#define ALT_MODULE_CLASS_jtag_uart altera_avalon_jtag_uart
#define JTAG_UART_BASE 0x800
#define JTAG_UART_IRQ 0
#define JTAG_UART_IRQ_INTERRUPT_CONTROLLER_ID 0
#define JTAG_UART_NAME "/dev/jtag_uart"
#define JTAG_UART_READ_DEPTH 64
#define JTAG_UART_READ_THRESHOLD 8
#define JTAG_UART_SPAN 8
#define JTAG_UART_TYPE "altera_avalon_jtag_uart"
#define JTAG_UART_WRITE_DEPTH 64
#define JTAG_UART_WRITE_THRESHOLD 8


/*
 * mem configuration
 *
 */

#define ALT_MODULE_CLASS_mem altera_avalon_onchip_memory2
#define MEM_ALLOW_IN_SYSTEM_MEMORY_CONTENT_EDITOR 0
#define MEM_ALLOW_MRAM_SIM_CONTENTS_ONLY_FILE 0
#define MEM_BASE 0x2000
#define MEM_CONTENTS_INFO ""
#define MEM_DUAL_PORT 0
#define MEM_GUI_RAM_BLOCK_TYPE "Automatic"
#define MEM_INIT_CONTENTS_FILE "mem"
#define MEM_INIT_MEM_CONTENT 1
#define MEM_INSTANCE_ID "NONE"
#define MEM_IRQ -1
#define MEM_IRQ_INTERRUPT_CONTROLLER_ID -1
#define MEM_NAME "/dev/mem"
#define MEM_NON_DEFAULT_INIT_FILE_ENABLED 1
#define MEM_RAM_BLOCK_TYPE "Auto"
#define MEM_READ_DURING_WRITE_MODE "DONT_CARE"
#define MEM_SIZE_MULTIPLE 1
#define MEM_SIZE_VALUE 8192u
#define MEM_SPAN 8192
#define MEM_TYPE "altera_avalon_onchip_memory2"
#define MEM_WRITABLE 1


/*
 * rs232_uart configuration
 *
 */

#define ALT_MODULE_CLASS_rs232_uart altera_avalon_uart
#define RS232_UART_BASE 0x820
#define RS232_UART_BAUD 19200
#define RS232_UART_DATA_BITS 8
#define RS232_UART_FIXED_BAUD 1
#define RS232_UART_FREQ 50000000u
#define RS232_UART_IRQ 1
#define RS232_UART_IRQ_INTERRUPT_CONTROLLER_ID 0
#define RS232_UART_NAME "/dev/rs232_uart"
#define RS232_UART_PARITY 'N'
#define RS232_UART_SIM_CHAR_STREAM ""
#define RS232_UART_SIM_TRUE_BAUD 0
#define RS232_UART_SPAN 32
#define RS232_UART_STOP_BITS 1
#define RS232_UART_SYNC_REG_DEPTH 2
#define RS232_UART_TYPE "altera_avalon_uart"
#define RS232_UART_USE_CTS_RTS 0
#define RS232_UART_USE_EOP_REGISTER 0

#endif /* __SYSTEM_H_ */
