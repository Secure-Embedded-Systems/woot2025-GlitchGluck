## Folder Descriptions

This example is used in **Section 6.2**.

*Note: We do not release the gate-level netlist.*

- `software/`  
  Contains the software applications that run on the processor during simulation. This includes the buffer overflow vulnerability example described in **Section 6.2**.

- `fault-free/`  
  Contains the fault-free simulation setup. This folder includes scan state documentation and the construction of the Dynamic State Transition Graph (DSTG), as explained in **Section 6.2**.

- `fault/`  
  Contains the fault simulation setup using the identified attack parameters. This includes simulation results showing how injected faults influence system behavior.

- `physical-exp/`  
  Contains data and results from physical fault injection experiments that support the simulation-based findings and help validate fault parameters accuracy.
