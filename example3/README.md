## Folder Descriptions

This example is used in **Section 6.4**.

The software application is executed on the `PicoRV32` processor core.


*Note: We do not release the gate-level netlist.*

- `software/`  
  Contains the software applications that run on the processor during simulation. This includes the pin verification 5 example described in **Section 6.4**.

- `fault-free/`  
  Contains the fault-free simulation setup. This folder includes scan state documentation and the construction of the Dynamic State Transition Graph (DSTG).

- `fault-1st/`  
  Contains the fault testbench and results from the first injected fault experiment. This setup introduces a single fault into the simulation.

- `fault-2nd/`  
  Contains the fault testbench and results from the second injected fault experiment. This setup includes both the first fault and the second fault into the simulation.
