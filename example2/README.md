## Folder Descriptions

This example is used in **Section 6.3**.

*Note: We do not release the gate-level netlist.*

- `software/`  
  Contains the software applications that run on the processor during simulation. This folder includes a buffer overflow vulnerability code.

- `fault-free/`  
  Holds the fault-free simulation setup. This directory documents the scan state data and illustrates how the Dynamic State Transition Graph (DSTG) is constructed from the scan state data.

- `fault-1st/`  
  Contains results from the first injected fault experiment. This folder captures the processor response and scan state after injecting a fault at a selected cycle.

- `fault-2nd/`  
  Contains results from the second injected fault experiment. A second fault is introduced at a different point in execution to evaluate cumulative or chained fault effects on system behavior.
