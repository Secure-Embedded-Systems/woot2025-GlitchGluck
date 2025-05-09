## Folder Descriptions

This example is used in **Section 5**.

The software application is executed on the `OpenMSP430` processor core.

*Note: We do not release the gate-level netlist.*

- `software/`  
  Contains the software applications that run on the processor during simulation. This folder includes a buffer overflow vulnerability code.

- `fault-free/`  
  Holds the fault-free simulation setup. This directory documents the scan state data and illustrates how the Dynamic State Transition Graph (DSTG) is constructed from the scan state data.

- `fault/`  
  Contains the fault simulation setup using the identified attack parameters. This folder includes the simulation data that demonstrates how faults are injected based on the attack parameters, analyzing their impact on processor behavior.

