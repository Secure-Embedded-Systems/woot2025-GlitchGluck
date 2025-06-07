force -freeze {sim:/testbench/chip/picosocInst_cpu/cpuregs/regs} 0 0 -cancel 15000

mem load -filldata 0 /testbench/chip/picosocInst_genblk1_ocram_controller_RAM_blk13/uut/mem_core_array
mem load -filldata 0 /testbench/chip/picosocInst_genblk1_ocram_controller_RAM_blk12/uut/mem_core_array
mem load -filldata 0 /testbench/chip/picosocInst_genblk1_ocram_controller_RAM_blk11/uut/mem_core_array
mem load -filldata 0 /testbench/chip/picosocInst_genblk1_ocram_controller_RAM_blk10/uut/mem_core_array
mem load -filldata 0 /testbench/chip/picosocInst_genblk1_ocram_controller_RAM_blk03/uut/mem_core_array
mem load -filldata 0 /testbench/chip/picosocInst_genblk1_ocram_controller_RAM_blk02/uut/mem_core_array
mem load -filldata 0 /testbench/chip/picosocInst_genblk1_ocram_controller_RAM_blk01/uut/mem_core_array
mem load -filldata 0 /testbench/chip/picosocInst_genblk1_ocram_controller_RAM_blk00/uut/mem_core_array

mem load -filldata 0 /testbench/spiflash/memory
mem load -infile flash.mem -format hex /testbench/spiflash/memory

# do ./dofiles/wave_aes_gtl_sim.do

onbreak {resume}

if {![info exists env(HDLDEBUG)]} {
   run -all
}

#restart
#exit
