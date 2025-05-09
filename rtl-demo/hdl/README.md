## Folder Descriptions 

- `msp430core/`  
  Contains the ASIC design files for a single-core OpenMSP430 processor, including peripherals.  
  *Note: Memory banks are not included in this release.*

- `tb/`  
  Contains the necessary testbench files. In this case, a CW305 testbench wrapper is used for the ASIC design. An I2C master is also included in the testbench to communicate with the OpenMSP430 processor using the I2C protocol
