# GlitchGlück  
This repository contains the files and results of the experiments in GlitchGlück paper at WOOT 2025.
This project is licensed under the Apache License 2.0.

## References
Z. Liu, D, Shanmugam and P. Schaumont, “GlitchGlück: Enabling Software Vulnerabilities through Guided Hardware Fault Injection”. Accepted at 19th USENIX WOOT Conference on Offensive Technologies, 2025.

## Directory Overview

This directory contains the experimental case studies referenced in the paper:

- `rtl-demo/`  
  Provides an RTL-level walkthrough demonstrating how to document scan states within a simulation testbench and how to generate the Dynamic State Transition Graph (DSTG).  

- `example0/`  
  Walkthrough example described in **Section 5** of the paper.

- `example1/`  
  Demonstrating a `buffer overflow` application on `OpenMSP430` from **Section 6.2**.

- `example2/`  
  Demonstrating an `instruction duplication` application on `IBEX` from **Section 6.3**.

- `example3/`  
  Demonstrating a `pin_verification_5` application on `PicoRV32` from **Section 6.4**.

- `Dockerfile`
  To set up a virtual environment with all tool requirements, you can use the Dockerfile. Inside of the virtual machine, the examples are available under `/woot2025-GlitchGLuck`.

```
docker build . -f Dockerfile -t glitchgluck
docker run --rm -it glitchgluck
```

## License
Unless otherwise noted, everything in this repository is covered by the Apache License, Version 2.0 (see LICENSE for full text).
