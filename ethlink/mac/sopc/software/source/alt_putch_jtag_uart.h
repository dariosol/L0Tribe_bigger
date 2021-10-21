/*
   alt_putch_jtag_uart.h
*/

#ifndef _ALT_PUTCH_JTAG_UART_H_
#define _ALT_PUTCH_JTAG_UART_H_

int alt_putch_jtag_uart(int c, int blockflag, void (* const in_loop_callback)(void));
int alt_test_jtag_uart(void);

#endif /* _ALT_PUTCH_JTAG_UART_H_ */
