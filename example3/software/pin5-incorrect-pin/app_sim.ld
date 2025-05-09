INCLUDE memorymap.ld

SECTIONS {
    .text :
    {
        . = ALIGN(4);
        *(.text)           
        *(.text*)          
        *(.rodata)         
        *(.rodata*)        
        *(.srodata)        
        *(.srodata*)       
        . = ALIGN(4);
		_etext = .;
    } >RAMAPP

    _sidata = _etext;

	.data :
    {
        . = ALIGN(4);
        _sdata = .;        
        _ram_start = .;    
        . = ALIGN(4);
        *(.data)           
        *(.data*)          
        *(.sdata)          
        *(.sdata*)         
        . = ALIGN(4);
        _edata = .;        
    } >RAMAPP

    /* uninitialized data */
    .bss :
    {
        . = ALIGN(4);
        _sbss = .;
        *(.bss)
        *(.bss*)
        *(.sbss)
        *(.sbss*)
        *(COMMON)

        . = ALIGN(4);
        _ebss = .;   
    } >RAMAPP

    .heap :
    {
        . = ALIGN(4);
        _heap_start = .;
    } >RAMAPP
}
