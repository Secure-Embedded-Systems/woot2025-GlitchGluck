# GlitchGlück  
This repository contains the files and results of the experiments in GlitchGlück paper at WOOT 2025.

## References
Z. Liu, D, Shanmugam and P. Schaumont, “GlitchGlück: Enabling Software Vulnerabilities through Guided Hardware Fault Injection”.

## `rtl-demo`
This folder provides an RTL-level walkthrough demonstrating how to document scan states within a simulation testbench and how to generate the Dynamic State Transition Graph (DSTG).

## Experiments

This directory contains the experimental case studies referenced in the paper:

- `example0/`  
  Walkthrough example described in **Section 5** of the paper.

- `example1/`  
  MSP430 case from **Section 6.1**, demonstrating a buffer overflow scenario.

- `exp2/`  
  IBEX core example from **Section 6.2**, showcasing instruction duplication.

- `exp3/`  
  PicoRV32 core example from **Section 6.3**, based on the `pin_verification_5` benchmark.

