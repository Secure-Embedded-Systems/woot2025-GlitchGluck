#include <stdint.h>

#include "hal.h"

unsigned int get_mepc() {
  uint32_t result;
  __asm__ volatile("csrr %0, mepc;" : "=r"(result));
  return result;
}

unsigned int get_mcause() {
  uint32_t result;
  __asm__ volatile("csrr %0, mcause;" : "=r"(result));
  return result;
}

unsigned int get_mtval() {
  uint32_t result;
  __asm__ volatile("csrr %0, mtval;" : "=r"(result));
  return result;
}

uint32_t get_mcycle(void) {
  uint32_t result;
  __asm__ volatile("csrr %0, mcycle;" : "=r"(result));
  return result;
}

void reset_mcycle(void) { __asm__ volatile("csrw mcycle, x0"); }

extern uint32_t _vectors_start;
volatile uint32_t* exc_vectors = &_vectors_start;

int install_exception_handler(uint32_t vector_num, void (*handler_fn)(void)) {
  if (vector_num >= 32) return 1;

  volatile uint32_t* handler_jmp_loc = exc_vectors + vector_num;
  int32_t offset                     = (uint32_t)handler_fn - (uint32_t)handler_jmp_loc;

  if ((offset >= (1 << 19)) || (offset < -(1 << 19))) {
    return 2;
  }

  uint32_t offset_uimm = offset;

  uint32_t jmp_ins = ((offset_uimm & 0x7fe) << 20) |     // imm[10:1] -> 21
                     ((offset_uimm & 0x800) << 9) |      // imm[11] -> 20
                     (offset_uimm & 0xff000) |           // imm[19:12] -> 12
                     ((offset_uimm & 0x100000) << 11) |  // imm[20] -> 31
                     0x6f;                               // J opcode

  *handler_jmp_loc = jmp_ins;

  __asm__ volatile("fence.i;");

  return 0;
}

void enable_interrupts(uint32_t enable_mask) { asm volatile("csrs mie, %0\n" : : "r"(enable_mask)); }

void disable_interrupts(uint32_t disable_mask) { asm volatile("csrc mie, %0\n" : : "r"(disable_mask)); }

void set_global_interrupt_enable(uint32_t enable) {
  if (enable) {
    asm volatile("csrs mstatus, %0\n" : : "r"(1 << 3));
  } else {
    asm volatile("csrc mstatus, %0\n" : : "r"(1 << 3));
  }
}

void simple_exc_handler(void) {
  
  while (1)
    ;
}

void uart_enable_rx_int(void) {
  enable_interrupts(UART_IRQ);
  set_global_interrupt_enable(1);
}

int uart_in(uart_t uart) {
  int res = UART_EOF;

  if (!(DEV_READ(uart + UART_STATUS_REG) & UART_STATUS_RX_EMPTY)) {
    res = DEV_READ(uart + UART_RX_REG);
  }

  return res;
}

void uart_out(uart_t uart, char c) {
  while (DEV_READ(uart + UART_STATUS_REG) & UART_STATUS_TX_FULL)
    ;

  DEV_WRITE(uart + UART_TX_REG, c);
}

void set_outputs(gpio_t gpio, uint32_t outputs) { DEV_WRITE(gpio, outputs); }

uint32_t read_gpio(gpio_t gpio) { return DEV_READ(gpio); }

void set_output_bit(gpio_t gpio, uint32_t output_bit_index, uint32_t output_bit) {
  output_bit &= 1;

  uint32_t output_bits = read_gpio(gpio);
  output_bits &= ~(1 << output_bit_index);
  output_bits |= (output_bit << output_bit_index);

  set_outputs(gpio, output_bits);
}

uint32_t get_output_bit(gpio_t gpio, uint32_t output_bit_index) {
  uint32_t output_bits = read_gpio(gpio);
  output_bits >>= output_bit_index;
  output_bits &= 1;

  return output_bits;
}

void platform_init() {

}

void ledon(uint8_t v) {

}

void ledoff(uint8_t v) {

}

char getch() {
  int32_t c;
  c = uart_in(DEFAULT_UART);
  return (char) c;
}

void putch(char c) {
  if (c == '\n') {
    uart_out(DEFAULT_UART, '\r');
  }

  uart_out(DEFAULT_UART, '\r');
}

void trigger_high() {
  set_output_bit(GPIO_OUT, TRIGGERBIT, 1);
}

void trigger_low() {
  set_output_bit(GPIO_OUT, TRIGGERBIT, 0);
}

void flashio(uint8_t *data, int len, uint8_t wrencmd) {

}

void set_flash_qspi_flag() {

}

void set_flash_mode_spi() {

}

void set_flash_mode_dual() {

}

void set_flash_mode_quad() {

}

void set_flash_mode_qddr() {

}

void enable_flash_crm() {

}

void configure_ro_max() {

}

void configure_ro_min() {

}

void enable_ro_config(uint8_t v) {

}

void enable_ro() {

}

void disable_ro() {

}
