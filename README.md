# GlitchGlück  
This repository contains the files and results of the experiments in GlitchGlück paper at WOOT 2025.

## References
Z. Liu, D, Shanmugam and P. Schaumont, “GlitchGlück: Enabling Software Vulnerabilities through Guided Hardware Fault Injection”.

## Directory Overview

This directory contains the experimental case studies referenced in the paper:

- `rtl-demo/`  
  Provides an RTL-level walkthrough demonstrating how to document scan states within a simulation testbench and how to generate the Dynamic State Transition Graph (DSTG).  

- `example0/`  
  Walkthrough example described in **Section 5** of the paper.

- `example1/`  
  Demonstrating a `buffer overflow` application on OpenMSP430 from **Section 6.1**.

- `exp2/`  
  Demonstrating an `instruction duplication` application on IBEX from **Section 6.2**.

- `exp3/`  
  Demonstrating a `pin_verification_5` application on PicoRV32 from **Section 6.3**.

