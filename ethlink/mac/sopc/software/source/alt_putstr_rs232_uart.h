/*
   alt_putstr_rs232_uart.h
*/

#ifndef _ALT_PUTSTR_RS232_UART_H_
#define _ALT_PUTSTR_RS232_UART_H_

int alt_putstr_rs232_uart(const char* str, int blockflag, void (* const in_loop_callback)(void));

#endif /* _ALT_PUTSTR_RS232_UART_H_ */
