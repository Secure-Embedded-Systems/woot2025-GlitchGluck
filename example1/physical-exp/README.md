## File Descriptions

This directory contains the scan chain configuration and simulation outputs associated with the fault-free setup. These files support analyzing scan input/output behavior and assist in aligning scan data to fault injection or DSTG cycles.

### Scan Chain Configuration

- `scan-chain.def`  
  Describes the scan chain configuration, including the order and mapping of flip-flops in the scan path. This file is essential for interpreting both scan-in and scan-out data at the bit level.

### Input

- `scanin/`  
  Contains the scan-in scan state obtained during the fault-free simulation.

### Fault-Free Output

- `fault-free-scanout/`  
  Stores the scan-out results captured from the processor after the fault-free simulation completes. These outputs help verify correct scan chain behavior and are used for comparison against fault injection results.

### Physical Experiment Output

- `physical-exp/`  
  Includes scan-out data collected from the chip during physical experiments. This is used to compare hardware behavior against fault-free simulation results.
