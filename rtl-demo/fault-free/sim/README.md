## File Descriptions 

### Inputs

- `filelist.v`  
  A Verilog file that includes a list of all ASIC Verilog files to be included in the simulation.

- `tb_filelist.v`  
  A Verilog file that lists all the testbench files to be included in the simulation.

- `tb.v`  
  The Verilog testbench file used for simulating the processor design.
  
- `document_scan`  
  Contains all the required testbench files for documenting scan state data. These files are included and instantiated within `tb.v` for simulation.

### Outputs

- `cycle_start_end_time.txt`  
  This file contains the start and end times of cycles during the simulation. 

- `pc.txt`  
  A file that stores the program counter (PC) values during the simulation.

- `scandata.json`  
  Contains scan state data in binary format, documented per cycle, capturing the state transitions throughout the simulation.

- `valuedata_Q.json`  
  Stores scan state data for each word-level register, documented per cycle, reflecting the values of registers at different points during the simulation.
