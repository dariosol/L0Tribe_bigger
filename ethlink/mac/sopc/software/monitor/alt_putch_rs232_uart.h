/*
   alt_putch_rs232_uart.h
*/

#ifndef _ALT_PUTCH_RS232_UART_H_
#define _ALT_PUTCH_RS232_UART_H_

int alt_putch_rs232_uart(int c, int blockflag, void (* const in_loop_callback)(void));
int alt_test_rs232_uart(void);

#endif /* _ALT_PUTCH_RS232_UART_H_ */
