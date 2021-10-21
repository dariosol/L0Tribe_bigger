/******************************************************************************
*                                                                             *
* License Agreement                                                           *
*                                                                             *
* Copyright (c) 2006 Altera Corporation, San Jose, California, USA.           *
* All rights reserved.                                                        *
*                                                                             *
* Permission is hereby granted, free of charge, to any person obtaining a     *
* copy of this software and associated documentation files (the "Software"),  *
* to deal in the Software without restriction, including without limitation   *
* the rights to use, copy, modify, merge, publish, distribute, sublicense,    *
* and/or sell copies of the Software, and to permit persons to whom the       *
* Software is furnished to do so, subject to the following conditions:        *
*                                                                             *
* The above copyright notice and this permission notice shall be included in  *
* all copies or substantial portions of the Software.                         *
*                                                                             *
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR  *
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,    *
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE *
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER      *
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING     *
* FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER         *
* DEALINGS IN THE SOFTWARE.                                                   *
*                                                                             *
* This agreement shall be governed in all respects by the laws of the State   *
* of California and by the laws of the United States of America.              *
*                                                                             *
* Altera does not recommend, suggest or require that this reference design    *
* file be used in conjunction or combination with any other product.          *
******************************************************************************/

/******************************************************************************
*                                                                             *
* THIS IS A LIBRARY READ-ONLY SOURCE FILE. DO NOT EDIT IT DIRECTLY.           *
*                                                                             *
* Overriding HAL Functions                                                    *
*                                                                             *
* To provide your own implementation of a HAL function, include the file in   *
* your Nios II IDE application project. When building the executable, the     *
* Nios II IDE finds your function first, and uses it in place of the HAL      *
* version.                                                                    *
*                                                                             *
******************************************************************************/

// Note: source file 'alt_putchar.c' modified for non-blocking write
//       operations (direct access to low-level drivers)  

#include <fcntl.h>
#include <errno.h>

#ifdef ALT_USE_DIRECT_DRIVERS
#include "system.h"
#include "sys/alt_driver.h"
#include "sys/alt_stdio.h"
#endif

#ifdef ALT_USE_DIRECT_DRIVERS

#define ALT_PUTCH_DEV  jtag_uart
// Note: macro 'ALT_PUTCH_DEV' defines the device name (function calls are built by 
//       nested macro expansions --> ALT_DRIVER_READ/WRITE macros concatenate and expand 
//       "ALT_MODULE_CLASS_" ## ALT_PUTCH_DEV ## "_read/_write" to select the corresponding 
//       device driver and i/o operation)      
//
//       '[projectname]_bsp\system.h'                  system description
//       '[projectname]_bsp\HAL\inc\sys\alt_driver.h'  macro description
//       '[projectname]_bsp\drivers\src'               device drivers

ALT_DRIVER_WRITE_EXTERNS(ALT_PUTCH_DEV);
// Note: 'extern' driver prototype must precedes all functions (nios IDE 9.1 builds
// a default 'alt_putchar.c' with a syntax bug that still compiles; the latest version of 
// nios2-gcc generates errors when 'extern' inside function body --> local declarations are removed)   

/*
 * Uses the ALT_DRIVER_WRITE() macro to call directly to driver if available.
 */
int
alt_putch_jtag_uart(int c, int blockflag, void (* const in_loop_callback)(void))
{
   //ALT_DRIVER_WRITE_EXTERNS(ALT_PUTCH_DEV);
   char c1 = (char)(c & 0xff);
   int e;

   while (1)
   {
      //// polling read
      //alt_getch_jtag_uart();
      if (in_loop_callback != NULL)
         (in_loop_callback)();

      e = ALT_DRIVER_WRITE(ALT_PUTCH_DEV, &c1, 1, O_NONBLOCK);
      if (e == 1)
      {
         // putch done
         return (c);
      }
      else if (e == -EWOULDBLOCK)
      {
         // jtag uart not ready
         if (!blockflag)
         {
            // non-blocking mode: exit
            return (e);
         }
         else
         {
            // blocking mode: retry
         }
      }
      else
      {
         // error/timeout: exit
         return (e);
      } 
   }
}


int
alt_test_jtag_uart(void)
{
    //ALT_DRIVER_WRITE_EXTERNS(ALT_PUTCH_DEV);

    return ALT_DRIVER_WRITE(ALT_PUTCH_DEV, NULL, 0, O_NONBLOCK);
    // Note: write op using count = zero with O_NONBLOCK flag to get driver status 
    // (output char never emitted, timeout test only)
}
#else
#error "function 'alt_putch_jtag_uart' --> ALT_USE_DIRECT_DRIVERS not defined"
#endif
