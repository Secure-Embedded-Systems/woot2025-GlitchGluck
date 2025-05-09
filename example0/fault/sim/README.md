## File Descriptions 

We use Modelsim to run the simulation.

### Inputs

- `tb.v`  
  The Verilog testbench file used for simulating the processor design. Fault is injected inside of the testbench.
  
- `document_scan`  
  Contains all the required testbench files for documenting scan state data. These files are included and instantiated within `tb.v` for simulation.

### Outputs

- `cycle_start_end_time.txt`  
  This file contains the start and end times of cycles during the simulation. 

- `pc.txt`  
  A file that stores the program counter (PC) values during the simulation.

- `valuedata_Q.json`  
  Stores scan state data for each word-level register, documented per cycle, reflecting the values of registers at different points during the simulation.
