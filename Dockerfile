FROM ubuntu:24.04

RUN apt update
RUN apt install python3 vim-common wget curl srecord graphviz git bzip2 libmpc3 libmpc-dev xz-utils -y

RUN git clone https://github.com/Secure-Embedded-Systems/woot2025-GlitchGluck.git

RUN wget https://dr-download.ti.com/software-development/ide-configuration-compiler-or-debugger/MD-LlCjWuAbzH/9.3.1.2/msp430-gcc-9.3.1.11_linux64.tar.bz2
RUN tar xf msp430-gcc-9.3.1.11_linux64.tar.bz2
ENV PATH="$PATH:/msp430-gcc-9.3.1.11_linux64/bin/"

RUN wget https://github.com/riscv-collab/riscv-gnu-toolchain/releases/download/2025.05.30/riscv32-elf-ubuntu-24.04-gcc-nightly-2025.05.30-nightly.tar.xz
RUN tar xf riscv32-elf-ubuntu-24.04-gcc-nightly-2025.05.30-nightly.tar.xz
ENV PATH="$PATH:/riscv/bin"
