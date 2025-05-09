#ifndef HAL_H
#define HAL_H

#include <stdint.h>

#ifndef TRIGGERBIT
  #define TRIGGERBIT 2
#endif

// PICO
#define pico_reg_spictrl     (*(volatile uint32_t*)0x02000000)
#define pico_reg_uart_clkdiv (*(volatile uint32_t*)0x02000004)
#define pico_reg_uart_data   (*(volatile uint32_t*)0x02000008)
#define pico_reg_gpioctrl    ( (volatile uint32_t*)0x03800000) // 8 gpio ctrls
#define pico_reg_gpio        ( (volatile uint32_t*)0x03000000) // 8 gpios
#define pico_reg_aes         ( (volatile uint32_t*)0x04000000) // AES coprocessor base address
#define pico_reg_spi_master  ( (volatile uint32_t*)0x05000000) // SPI master base address
#define pico_reg_ascon       ( (volatile uint32_t*)0x06000000) // Ascon coprocessor base address

// IBEX
#define DEV_WRITE(addr, val) (*((volatile uint32_t *)(addr)) = val)
#define DEV_READ(addr) (*((volatile uint32_t *)(addr)))

#define ibex_reg_gpio        0x80000000
#define ibex_reg_uart        0x80001000
#define ibex_reg_timer       0x80002000
#define ibex_reg_myreg       0x80003000
#define ibex_reg_spi         0x80004000
#define ibex_sim_ctrl_base   0x20000
#define ibex_sim_ctrl_out    0x0
#define ibex_sim_ctrl_ctrl   0x8

typedef void* uart_t;
#define UART_FROM_BASE_ADDR(addr) ((uart_t)(addr))
#define UART_RX_REG 0
#define UART_TX_REG 4
#define UART_STATUS_REG 8

#define UART_STATUS_RX_EMPTY 1
#define UART_STATUS_TX_FULL 2
#define UART_EOF -1

#define UART_IRQ_NUM 16
#define UART_IRQ (1 << UART_IRQ_NUM)
#define DEFAULT_UART UART_FROM_BASE_ADDR(ibex_reg_uart)

#define GPIO_OUT_REG 0x0
#define GPIO_IN_REG 0x4
#define GPIO_IN_DBNC_REG 0x8
#define GPIO_OUT_SHIFT_REG 0xC

#define GPIO_OUT_MASK 0xFF  // Support 8-bit output
#define GPIO_LED_MASK 0xF0  // Top 4 bits are green LEDs

typedef void* gpio_t;

#define GPIO_FROM_BASE_ADDR(addr) ((gpio_t)addr)

#define GPIO_OUT GPIO_FROM_BASE_ADDR(ibex_reg_gpio + GPIO_OUT_REG)
#define GPIO_IN GPIO_FROM_BASE_ADDR(ibex_reg_gpio + GPIO_IN_REG)
#define GPIO_IN_DBNC GPIO_FROM_BASE_ADDR(ibex_reg_gpio + GPIO_IN_DBNC_REG)
#define GPIO_OUT_SHIFT GPIO_FROM_BASE_ADDR(ibex_reg_gpio + GPIO_OUT_SHIFT_REG)
#define TIMER_IRQ (1 << 7)
#define DEFAULT_SPI SPI_FROM_BASE_ADDR(SPI0_BASE)

char getch();
void putch(char c);
void trigger_high();
void trigger_low();
void platform_init();

void ledon (uint8_t v);
void ledoff(uint8_t v);
void set_flash_qspi_flag();
void set_flash_mode_spi();
void set_flash_mode_dual();
void set_flash_mode_quad();
void set_flash_mode_qddr();
void enable_flash_crm();

void configure_ro_max();
void configure_ro_min();
void enable_ro();
void enable_ro_config(uint8_t v);
void disable_ro();

int uart_in(uart_t uart);
void uart_out(uart_t uart, char c);

void set_outputs(gpio_t gpio, uint32_t outputs);
uint32_t read_gpio(gpio_t gpio);

void set_output_bit(gpio_t gpio, uint32_t output_bit_index, uint32_t output_bit);

uint32_t get_output_bit(gpio_t gpio, uint32_t output_bit_index);

/**
 * Install an exception handler by writing a `j` instruction to the handler in
 * at the appropriate address given the `vector_num`.
 *
 * @param vector_num Which IRQ the handler is for, must be less than 32. All
 * non-interrupt exceptions are handled at vector 0.
 *
 * @param handle_fn Function pointer to the handler function. The function is
 * responsible for interrupt prolog and epilog, such as saving and restoring
 * register to the stack and executing `mret` at the end.
 *
 * @return 0 on success, 1 if `vector_num` out of range, 2 if the address of
 * `handler_fn` is too far from the exception handler base to use with a `j`
 * instruction.
 */
int install_exception_handler(uint32_t vector_num, void (*handler_fn)(void));

/**
 * Set per-interrupt enables (`mie` CSR)
 *
 * @param enable_mask Any set bit is set in `mie`, enabling the interrupt. Bits
 * not set in `enable_mask` aren't changed.
 */
void enable_interrupts(uint32_t enable_mask);

/**
 * Clear per-interrupt enables (`mie` CSR)
 *
 * @param enable_mask Any set bit is cleared in `mie`, disabling the interrupt.
 * Bits not set in `enable_mask` aren't changed.
 */
void disable_interrupts(uint32_t disable_mask);

/**
 * Set the global interrupt enable (the `mie` field of `mstatus`). This enables
 * or disable all interrupts at once.
 *
 * @param enable Enable interrupts if set, otherwise disabled
 */
void set_global_interrupt_enable(uint32_t enable);

unsigned int get_mepc();
unsigned int get_mcause();
unsigned int get_mtval();
uint32_t get_mcycle(void);
void reset_mcycle(void);

#endif
 
