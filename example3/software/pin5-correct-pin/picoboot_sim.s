	.text

	# clear all registers
	li	ra,0
	li	gp,0
	li	tp,0
	li	t0,0
	li	t1,0
	li	t2,0
	li	s0,0
	li	s1,0
	li	a0,0
	li	a1,0
	li	a2,0
	li	a3,0
	li	a4,0
	li	a5,0
	li	a6,0
	li	a7,0
	li	s2,0
	li	s3,0
	li	s4,0
	li	s5,0
	li	s6,0
	li	s7,0
	li	s8,0
	li	s9,0
	li	s10,0
	li	s11,0
	li	t3,0
	li	t4,0
	li	t5,0
	li	t6,0
	# set SP to top of RAM
	li  a1, 0x10000
	mv  x2, a1
	# set return address to start of RAM (0x0000)
	li  a1, 0x0
	mv  x1, a1
	# jump to application
	ret
