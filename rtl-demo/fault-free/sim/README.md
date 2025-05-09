## File Descriptions 

- `filelist.v`  
  A Verilog file that includes a list of all ASIC Verilog files to be included in the simulation.

- `tb_filelist.v`  
  A Verilog file that lists all the testbench files to be included in the simulation.

- `tb.v`  
  The Verilog testbench file used for simulating the processor design. It contains the necessary setup for running the simulation and may include stimulus for the design under test.

- `document_scan`  
  This file likely contains documentation or metadata related to the scan states observed during the fault-free simulation.

- `cycle_start_end_time.txt`  
  This file contains the start and end times of cycles during the simulation. It might track when certain processes or operations begin and end in the simulation, which is useful for debugging and analysis.

- `pc.txt`  
  A file that likely stores the program counter (PC) values during the simulation, potentially logging the execution flow of the processor at different time steps.

- `scandata.json`  
  This file stores the scan state data in JSON format. It likely contains detailed information about the scan chain states during the simulation, useful for fault analysis and generating the DSTG.

- `valuedata_Q.json`  
  This file likely contains data about specific values observed in the simulation, stored in JSON format. It could be tracking the values of certain signals or registers at specific points in time during the simulation.
