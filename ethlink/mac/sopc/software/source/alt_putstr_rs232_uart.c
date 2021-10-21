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

#include <stdio.h>
#include <fcntl.h>
#include <errno.h>

#ifdef ALT_USE_DIRECT_DRIVERS
#include <string.h>
#include "system.h"
#include "sys/alt_driver.h"
#include "sys/alt_stdio.h"
#include "alt_getch_rs232_uart.h"
#endif

#ifdef ALT_USE_DIRECT_DRIVERS

#define ALT_PUTCH_DEV  rs232_uart

ALT_DRIVER_WRITE_EXTERNS(ALT_PUTCH_DEV);

/*
 * Uses the ALT_DRIVER_WRITE() macro to call directly to driver if available.
 */
int
alt_putstr_rs232_uart(const char* str, int blockflag, void (* const in_loop_callback)(void))
{
   const char *p;
   int e;

   e = 0;
   p = str;
   while (*p)
   {
      //// polling read
      //alt_getch_rs232_uart(0);
      if (in_loop_callback != NULL)
         (in_loop_callback)();

      e = ALT_DRIVER_WRITE(ALT_PUTCH_DEV, p, 1, O_NONBLOCK);
      if (e == 1)
      {
         // next char
         p++;
      }
      else if (e == -EWOULDBLOCK)
      {
         // rs232 uart not ready
         if (!blockflag)
         {
            // non-blocking mode: exit
            break;
         }
         else
         {
            // blocking mode: retry
         }
      }
      else
      {
         // error/timeout: exit
         break;
      }
   }

   if (e >= 0)
      return (p - str);
   else
      return (e);
}
#else
#error "function 'alt_putstr_rs232_uart' --> ALT_USE_DIRECT_DRIVERS not defined"
#endif
