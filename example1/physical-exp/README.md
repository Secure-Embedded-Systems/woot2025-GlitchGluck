## File Descriptions

This directory contains the scan chain configuration before and after the physical attack.

### Scan Chain Configuration

- `scan-chain.def`  
  Describes the scan chain configuration, including the order and mapping of flip-flops in the scan path. This file is essential for interpreting both scan-in and scan-out data at the bit level.

### Input

- `scanin/`  
  Contains the scan-in scan state obtained during the fault-free simulation. This data is prepared to set up the processor for the attack.

### Fault-Free Output

- `fault-free-scanout/`  
  Stores the scan-out results captured from the processor after the fault-free simulation completes. These outputs help verify correct scan chain behavior and are used for comparison against fault injection results.

### Physical Experiment Output

- `fault-scanout/`  
  Includes scan-out data collected from the chip during physical experiments. This is used to compare hardware behavior against fault-free simulation results.
