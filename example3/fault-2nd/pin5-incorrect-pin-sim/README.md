## File Descriptions 

We use Modelsim to run the simulation.

### Inputs

- `pico_testbench_gtl.v`  
  The testbench file used for simulating the processor design. Fault is injected inside of the testbench.
  
- `document_scan`  
  Contains all the required testbench files for documenting scan state data. These files are included and instantiated within `tb.v` for simulation.

### Outputs

- `cycle_start_end_time.txt`  
  This file contains the start and end times of cycles during the simulation.
  
- `dut_start_end_time.txt`
  Provides the start and end timestamps during which the Device Under Test (DUT) is actively stimulated. Used to align scan data with meaningful execution windows.

- `pc_reg.txt`  
  A file that stores the program counter (PC) values during the simulation.

- `valuedata_Q.json`  
  Stores scan state data for each word-level register, documented per cycle, reflecting the values of registers at different points during the simulation.
