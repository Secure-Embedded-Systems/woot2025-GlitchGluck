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
Copyright 2025 Zhenyuan Liu, Dillibabu Shanmugam, Patrick Schaumont

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
