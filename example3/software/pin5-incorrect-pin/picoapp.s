
testcase_app_0.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <__appram_start__>:
   0:	4081                	li	ra,0
   2:	4181                	li	gp,0
   4:	4201                	li	tp,0
   6:	4281                	li	t0,0
   8:	4301                	li	t1,0
   a:	4381                	li	t2,0
   c:	4401                	li	s0,0
   e:	4481                	li	s1,0
  10:	4501                	li	a0,0
  12:	4581                	li	a1,0
  14:	4601                	li	a2,0
  16:	4681                	li	a3,0
  18:	4701                	li	a4,0
  1a:	4781                	li	a5,0
  1c:	4801                	li	a6,0
  1e:	4881                	li	a7,0
  20:	4901                	li	s2,0
  22:	4981                	li	s3,0
  24:	4a01                	li	s4,0
  26:	4a81                	li	s5,0
  28:	4b01                	li	s6,0
  2a:	4b81                	li	s7,0
  2c:	4c01                	li	s8,0
  2e:	4c81                	li	s9,0
  30:	4d01                	li	s10,0
  32:	4d81                	li	s11,0
  34:	4e01                	li	t3,0
  36:	4e81                	li	t4,0
  38:	4f01                	li	t5,0
  3a:	4f81                	li	t6,0
  3c:	03000537          	lui	a0,0x3000
  40:	4585                	li	a1,1
  42:	c10c                	sw	a1,0(a0)
  44:	03000537          	lui	a0,0x3000
  48:	458d                	li	a1,3
  4a:	c10c                	sw	a1,0(a0)
  4c:	00000517          	auipc	a0,0x0
  50:	57450513          	addi	a0,a0,1396 # 5c0 <_etext>
  54:	5c000593          	li	a1,1472
  58:	5c000613          	li	a2,1472
  5c:	00c5d863          	bge	a1,a2,6c <end_init_data>

00000060 <loop_init_data>:
  60:	4114                	lw	a3,0(a0)
  62:	c194                	sw	a3,0(a1)
  64:	0511                	addi	a0,a0,4
  66:	0591                	addi	a1,a1,4
  68:	fec5cce3          	blt	a1,a2,60 <loop_init_data>

0000006c <end_init_data>:
  6c:	03000537          	lui	a0,0x3000
  70:	459d                	li	a1,7
  72:	c10c                	sw	a1,0(a0)
  74:	5c000513          	li	a0,1472
  78:	5c000593          	li	a1,1472
  7c:	00b55763          	bge	a0,a1,8a <end_init_bss>

00000080 <loop_init_bss>:
  80:	00052023          	sw	zero,0(a0) # 3000000 <__approm_size__+0x2c10000>
  84:	0511                	addi	a0,a0,4
  86:	feb54de3          	blt	a0,a1,80 <loop_init_bss>

0000008a <end_init_bss>:
  8a:	03000537          	lui	a0,0x3000
  8e:	45bd                	li	a1,15
  90:	c10c                	sw	a1,0(a0)
  92:	2ed5                	jal	486 <main>

00000094 <loop>:
  94:	a001                	j	94 <loop>
  96:	0001                	nop

00000098 <flashio_worker_begin>:
  98:	020002b7          	lui	t0,0x2000
  9c:	12000313          	li	t1,288
  a0:	00629023          	sh	t1,0(t0) # 2000000 <__approm_size__+0x1c10000>
  a4:	000281a3          	sb	zero,3(t0)
  a8:	c605                	beqz	a2,d0 <flashio_worker_L1>
  aa:	4f21                	li	t5,8
  ac:	0ff67393          	andi	t2,a2,255

000000b0 <flashio_worker_L4>:
  b0:	0073de93          	srli	t4,t2,0x7
  b4:	01d28023          	sb	t4,0(t0)
  b8:	010eee93          	ori	t4,t4,16
  bc:	01d28023          	sb	t4,0(t0)
  c0:	0386                	slli	t2,t2,0x1
  c2:	0ff3f393          	andi	t2,t2,255
  c6:	1f7d                	addi	t5,t5,-1
  c8:	fe0f14e3          	bnez	t5,b0 <flashio_worker_L4>
  cc:	00628023          	sb	t1,0(t0)

000000d0 <flashio_worker_L1>:
  d0:	cd9d                	beqz	a1,10e <flashio_worker_L3>
  d2:	4f21                	li	t5,8
  d4:	00054383          	lbu	t2,0(a0) # 3000000 <__approm_size__+0x2c10000>

000000d8 <flashio_worker_L2>:
  d8:	0073de93          	srli	t4,t2,0x7
  dc:	01d28023          	sb	t4,0(t0)
  e0:	010eee93          	ori	t4,t4,16
  e4:	01d28023          	sb	t4,0(t0)
  e8:	0002ce83          	lbu	t4,0(t0)
  ec:	002efe93          	andi	t4,t4,2
  f0:	001ede93          	srli	t4,t4,0x1
  f4:	0386                	slli	t2,t2,0x1
  f6:	01d3e3b3          	or	t2,t2,t4
  fa:	0ff3f393          	andi	t2,t2,255
  fe:	1f7d                	addi	t5,t5,-1
 100:	fc0f1ce3          	bnez	t5,d8 <flashio_worker_L2>
 104:	00750023          	sb	t2,0(a0)
 108:	0505                	addi	a0,a0,1
 10a:	15fd                	addi	a1,a1,-1
 10c:	b7d1                	j	d0 <flashio_worker_L1>

0000010e <flashio_worker_L3>:
 10e:	08000313          	li	t1,128
 112:	006281a3          	sb	t1,3(t0)
 116:	8082                	ret

00000118 <platform_init>:
 118:	1141                	addi	sp,sp,-16
 11a:	c622                	sw	s0,12(sp)
 11c:	0800                	addi	s0,sp,16
 11e:	020007b7          	lui	a5,0x2000
 122:	0791                	addi	a5,a5,4
 124:	06800713          	li	a4,104
 128:	c398                	sw	a4,0(a5)
 12a:	038007b7          	lui	a5,0x3800
 12e:	4705                	li	a4,1
 130:	c398                	sw	a4,0(a5)
 132:	038007b7          	lui	a5,0x3800
 136:	0791                	addi	a5,a5,4
 138:	4705                	li	a4,1
 13a:	c398                	sw	a4,0(a5)
 13c:	038007b7          	lui	a5,0x3800
 140:	07a1                	addi	a5,a5,8
 142:	4705                	li	a4,1
 144:	c398                	sw	a4,0(a5)
 146:	038007b7          	lui	a5,0x3800
 14a:	07b1                	addi	a5,a5,12
 14c:	4705                	li	a4,1
 14e:	c398                	sw	a4,0(a5)
 150:	038007b7          	lui	a5,0x3800
 154:	07c1                	addi	a5,a5,16
 156:	4705                	li	a4,1
 158:	c398                	sw	a4,0(a5)
 15a:	038007b7          	lui	a5,0x3800
 15e:	07d1                	addi	a5,a5,20
 160:	4705                	li	a4,1
 162:	c398                	sw	a4,0(a5)
 164:	038007b7          	lui	a5,0x3800
 168:	07e1                	addi	a5,a5,24
 16a:	4705                	li	a4,1
 16c:	c398                	sw	a4,0(a5)
 16e:	038007b7          	lui	a5,0x3800
 172:	07f1                	addi	a5,a5,28
 174:	4705                	li	a4,1
 176:	c398                	sw	a4,0(a5)
 178:	0001                	nop
 17a:	4432                	lw	s0,12(sp)
 17c:	0141                	addi	sp,sp,16
 17e:	8082                	ret

00000180 <ledon>:
 180:	1101                	addi	sp,sp,-32
 182:	ce22                	sw	s0,28(sp)
 184:	1000                	addi	s0,sp,32
 186:	87aa                	mv	a5,a0
 188:	fef407a3          	sb	a5,-17(s0)
 18c:	fef44783          	lbu	a5,-17(s0)
 190:	00279713          	slli	a4,a5,0x2
 194:	038007b7          	lui	a5,0x3800
 198:	97ba                	add	a5,a5,a4
 19a:	4705                	li	a4,1
 19c:	c398                	sw	a4,0(a5)
 19e:	fef44783          	lbu	a5,-17(s0)
 1a2:	00279713          	slli	a4,a5,0x2
 1a6:	030007b7          	lui	a5,0x3000
 1aa:	97ba                	add	a5,a5,a4
 1ac:	4705                	li	a4,1
 1ae:	c398                	sw	a4,0(a5)
 1b0:	0001                	nop
 1b2:	4472                	lw	s0,28(sp)
 1b4:	6105                	addi	sp,sp,32
 1b6:	8082                	ret

000001b8 <ledoff>:
 1b8:	1101                	addi	sp,sp,-32
 1ba:	ce22                	sw	s0,28(sp)
 1bc:	1000                	addi	s0,sp,32
 1be:	87aa                	mv	a5,a0
 1c0:	fef407a3          	sb	a5,-17(s0)
 1c4:	fef44783          	lbu	a5,-17(s0)
 1c8:	00279713          	slli	a4,a5,0x2
 1cc:	038007b7          	lui	a5,0x3800
 1d0:	97ba                	add	a5,a5,a4
 1d2:	4705                	li	a4,1
 1d4:	c398                	sw	a4,0(a5)
 1d6:	fef44783          	lbu	a5,-17(s0)
 1da:	00279713          	slli	a4,a5,0x2
 1de:	030007b7          	lui	a5,0x3000
 1e2:	97ba                	add	a5,a5,a4
 1e4:	0007a023          	sw	zero,0(a5) # 3000000 <__approm_size__+0x2c10000>
 1e8:	0001                	nop
 1ea:	4472                	lw	s0,28(sp)
 1ec:	6105                	addi	sp,sp,32
 1ee:	8082                	ret

000001f0 <getch>:
 1f0:	1101                	addi	sp,sp,-32
 1f2:	ce22                	sw	s0,28(sp)
 1f4:	1000                	addi	s0,sp,32
 1f6:	57fd                	li	a5,-1
 1f8:	fef42623          	sw	a5,-20(s0)
 1fc:	a039                	j	20a <getch+0x1a>
 1fe:	020007b7          	lui	a5,0x2000
 202:	07a1                	addi	a5,a5,8
 204:	439c                	lw	a5,0(a5)
 206:	fef42623          	sw	a5,-20(s0)
 20a:	fec42703          	lw	a4,-20(s0)
 20e:	57fd                	li	a5,-1
 210:	fef707e3          	beq	a4,a5,1fe <getch+0xe>
 214:	fec42783          	lw	a5,-20(s0)
 218:	0ff7f793          	andi	a5,a5,255
 21c:	853e                	mv	a0,a5
 21e:	4472                	lw	s0,28(sp)
 220:	6105                	addi	sp,sp,32
 222:	8082                	ret

00000224 <putch>:
 224:	1101                	addi	sp,sp,-32
 226:	ce22                	sw	s0,28(sp)
 228:	1000                	addi	s0,sp,32
 22a:	87aa                	mv	a5,a0
 22c:	fef407a3          	sb	a5,-17(s0)
 230:	020007b7          	lui	a5,0x2000
 234:	07a1                	addi	a5,a5,8
 236:	fef44703          	lbu	a4,-17(s0)
 23a:	c398                	sw	a4,0(a5)
 23c:	0001                	nop
 23e:	4472                	lw	s0,28(sp)
 240:	6105                	addi	sp,sp,32
 242:	8082                	ret

00000244 <trigger_high>:
 244:	1141                	addi	sp,sp,-16
 246:	c622                	sw	s0,12(sp)
 248:	0800                	addi	s0,sp,16
 24a:	030007b7          	lui	a5,0x3000
 24e:	07a1                	addi	a5,a5,8
 250:	4705                	li	a4,1
 252:	c398                	sw	a4,0(a5)
 254:	0001                	nop
 256:	4432                	lw	s0,12(sp)
 258:	0141                	addi	sp,sp,16
 25a:	8082                	ret

0000025c <trigger_low>:
 25c:	1141                	addi	sp,sp,-16
 25e:	c622                	sw	s0,12(sp)
 260:	0800                	addi	s0,sp,16
 262:	030007b7          	lui	a5,0x3000
 266:	07a1                	addi	a5,a5,8
 268:	0007a023          	sw	zero,0(a5) # 3000000 <__approm_size__+0x2c10000>
 26c:	0001                	nop
 26e:	4432                	lw	s0,12(sp)
 270:	0141                	addi	sp,sp,16
 272:	8082                	ret

00000274 <flashio>:
 274:	7179                	addi	sp,sp,-48
 276:	d606                	sw	ra,44(sp)
 278:	d422                	sw	s0,40(sp)
 27a:	d226                	sw	s1,36(sp)
 27c:	1800                	addi	s0,sp,48
 27e:	fca42e23          	sw	a0,-36(s0)
 282:	fcb42c23          	sw	a1,-40(s0)
 286:	86b2                	mv	a3,a2
 288:	fcd40ba3          	sb	a3,-41(s0)
 28c:	868a                	mv	a3,sp
 28e:	84b6                	mv	s1,a3
 290:	11800613          	li	a2,280
 294:	09800693          	li	a3,152
 298:	40d606b3          	sub	a3,a2,a3
 29c:	8689                	srai	a3,a3,0x2
 29e:	16fd                	addi	a3,a3,-1
 2a0:	fed42223          	sw	a3,-28(s0)
 2a4:	11800613          	li	a2,280
 2a8:	09800693          	li	a3,152
 2ac:	40d606b3          	sub	a3,a2,a3
 2b0:	8689                	srai	a3,a3,0x2
 2b2:	8e36                	mv	t3,a3
 2b4:	4e81                	li	t4,0
 2b6:	01be5693          	srli	a3,t3,0x1b
 2ba:	005e9893          	slli	a7,t4,0x5
 2be:	0116e8b3          	or	a7,a3,a7
 2c2:	005e1813          	slli	a6,t3,0x5
 2c6:	11800613          	li	a2,280
 2ca:	09800693          	li	a3,152
 2ce:	40d606b3          	sub	a3,a2,a3
 2d2:	8689                	srai	a3,a3,0x2
 2d4:	8336                	mv	t1,a3
 2d6:	4381                	li	t2,0
 2d8:	01b35693          	srli	a3,t1,0x1b
 2dc:	00539793          	slli	a5,t2,0x5
 2e0:	8fd5                	or	a5,a5,a3
 2e2:	00531713          	slli	a4,t1,0x5
 2e6:	11800713          	li	a4,280
 2ea:	09800793          	li	a5,152
 2ee:	40f707b3          	sub	a5,a4,a5
 2f2:	078d                	addi	a5,a5,3
 2f4:	9bf1                	andi	a5,a5,-4
 2f6:	07bd                	addi	a5,a5,15
 2f8:	8391                	srli	a5,a5,0x4
 2fa:	0792                	slli	a5,a5,0x4
 2fc:	40f10133          	sub	sp,sp,a5
 300:	878a                	mv	a5,sp
 302:	078d                	addi	a5,a5,3
 304:	8389                	srli	a5,a5,0x2
 306:	078a                	slli	a5,a5,0x2
 308:	fef42023          	sw	a5,-32(s0)
 30c:	09800793          	li	a5,152
 310:	fef42623          	sw	a5,-20(s0)
 314:	fe042783          	lw	a5,-32(s0)
 318:	fef42423          	sw	a5,-24(s0)
 31c:	a839                	j	33a <flashio+0xc6>
 31e:	fec42703          	lw	a4,-20(s0)
 322:	00470793          	addi	a5,a4,4
 326:	fef42623          	sw	a5,-20(s0)
 32a:	fe842783          	lw	a5,-24(s0)
 32e:	00478693          	addi	a3,a5,4
 332:	fed42423          	sw	a3,-24(s0)
 336:	4318                	lw	a4,0(a4)
 338:	c398                	sw	a4,0(a5)
 33a:	fec42703          	lw	a4,-20(s0)
 33e:	11800793          	li	a5,280
 342:	fcf71ee3          	bne	a4,a5,31e <flashio+0xaa>
 346:	fe042783          	lw	a5,-32(s0)
 34a:	fd842703          	lw	a4,-40(s0)
 34e:	fd744683          	lbu	a3,-41(s0)
 352:	8636                	mv	a2,a3
 354:	85ba                	mv	a1,a4
 356:	fdc42503          	lw	a0,-36(s0)
 35a:	9782                	jalr	a5
 35c:	8126                	mv	sp,s1
 35e:	0001                	nop
 360:	fd040113          	addi	sp,s0,-48
 364:	50b2                	lw	ra,44(sp)
 366:	5422                	lw	s0,40(sp)
 368:	5492                	lw	s1,36(sp)
 36a:	6145                	addi	sp,sp,48
 36c:	8082                	ret

0000036e <set_flash_qspi_flag>:
 36e:	1101                	addi	sp,sp,-32
 370:	ce06                	sw	ra,28(sp)
 372:	cc22                	sw	s0,24(sp)
 374:	1000                	addi	s0,sp,32
 376:	03500793          	li	a5,53
 37a:	fef40223          	sb	a5,-28(s0)
 37e:	fe0402a3          	sb	zero,-27(s0)
 382:	fe440793          	addi	a5,s0,-28
 386:	4601                	li	a2,0
 388:	4589                	li	a1,2
 38a:	853e                	mv	a0,a5
 38c:	35e5                	jal	274 <flashio>
 38e:	fe544783          	lbu	a5,-27(s0)
 392:	fef407a3          	sb	a5,-17(s0)
 396:	03100793          	li	a5,49
 39a:	fef40223          	sb	a5,-28(s0)
 39e:	fef44783          	lbu	a5,-17(s0)
 3a2:	0027e793          	ori	a5,a5,2
 3a6:	0ff7f793          	andi	a5,a5,255
 3aa:	fef402a3          	sb	a5,-27(s0)
 3ae:	fe440793          	addi	a5,s0,-28
 3b2:	05000613          	li	a2,80
 3b6:	4589                	li	a1,2
 3b8:	853e                	mv	a0,a5
 3ba:	3d6d                	jal	274 <flashio>
 3bc:	0001                	nop
 3be:	40f2                	lw	ra,28(sp)
 3c0:	4462                	lw	s0,24(sp)
 3c2:	6105                	addi	sp,sp,32
 3c4:	8082                	ret

000003c6 <set_flash_mode_spi>:
 3c6:	1141                	addi	sp,sp,-16
 3c8:	c622                	sw	s0,12(sp)
 3ca:	0800                	addi	s0,sp,16
 3cc:	020007b7          	lui	a5,0x2000
 3d0:	4394                	lw	a3,0(a5)
 3d2:	020007b7          	lui	a5,0x2000
 3d6:	ff810737          	lui	a4,0xff810
 3da:	177d                	addi	a4,a4,-1
 3dc:	8f75                	and	a4,a4,a3
 3de:	c398                	sw	a4,0(a5)
 3e0:	0001                	nop
 3e2:	4432                	lw	s0,12(sp)
 3e4:	0141                	addi	sp,sp,16
 3e6:	8082                	ret

000003e8 <set_flash_mode_dual>:
 3e8:	1141                	addi	sp,sp,-16
 3ea:	c622                	sw	s0,12(sp)
 3ec:	0800                	addi	s0,sp,16
 3ee:	020007b7          	lui	a5,0x2000
 3f2:	4398                	lw	a4,0(a5)
 3f4:	ff8107b7          	lui	a5,0xff810
 3f8:	17fd                	addi	a5,a5,-1
 3fa:	00f776b3          	and	a3,a4,a5
 3fe:	020007b7          	lui	a5,0x2000
 402:	00400737          	lui	a4,0x400
 406:	8f55                	or	a4,a4,a3
 408:	c398                	sw	a4,0(a5)
 40a:	0001                	nop
 40c:	4432                	lw	s0,12(sp)
 40e:	0141                	addi	sp,sp,16
 410:	8082                	ret

00000412 <set_flash_mode_quad>:
 412:	1141                	addi	sp,sp,-16
 414:	c622                	sw	s0,12(sp)
 416:	0800                	addi	s0,sp,16
 418:	020007b7          	lui	a5,0x2000
 41c:	4398                	lw	a4,0(a5)
 41e:	ff8107b7          	lui	a5,0xff810
 422:	17fd                	addi	a5,a5,-1
 424:	00f776b3          	and	a3,a4,a5
 428:	020007b7          	lui	a5,0x2000
 42c:	00240737          	lui	a4,0x240
 430:	8f55                	or	a4,a4,a3
 432:	c398                	sw	a4,0(a5)
 434:	0001                	nop
 436:	4432                	lw	s0,12(sp)
 438:	0141                	addi	sp,sp,16
 43a:	8082                	ret

0000043c <set_flash_mode_qddr>:
 43c:	1141                	addi	sp,sp,-16
 43e:	c622                	sw	s0,12(sp)
 440:	0800                	addi	s0,sp,16
 442:	020007b7          	lui	a5,0x2000
 446:	4398                	lw	a4,0(a5)
 448:	ff8107b7          	lui	a5,0xff810
 44c:	17fd                	addi	a5,a5,-1
 44e:	00f776b3          	and	a3,a4,a5
 452:	020007b7          	lui	a5,0x2000
 456:	00670737          	lui	a4,0x670
 45a:	8f55                	or	a4,a4,a3
 45c:	c398                	sw	a4,0(a5)
 45e:	0001                	nop
 460:	4432                	lw	s0,12(sp)
 462:	0141                	addi	sp,sp,16
 464:	8082                	ret

00000466 <enable_flash_crm>:
 466:	1141                	addi	sp,sp,-16
 468:	c622                	sw	s0,12(sp)
 46a:	0800                	addi	s0,sp,16
 46c:	020007b7          	lui	a5,0x2000
 470:	4394                	lw	a3,0(a5)
 472:	020007b7          	lui	a5,0x2000
 476:	00100737          	lui	a4,0x100
 47a:	8f55                	or	a4,a4,a3
 47c:	c398                	sw	a4,0(a5)
 47e:	0001                	nop
 480:	4432                	lw	s0,12(sp)
 482:	0141                	addi	sp,sp,16
 484:	8082                	ret

00000486 <main>:
 486:	715d                	addi	sp,sp,-80
 488:	c686                	sw	ra,76(sp)
 48a:	c4a2                	sw	s0,72(sp)
 48c:	0880                	addi	s0,sp,80
 48e:	040007b7          	lui	a5,0x4000
 492:	fef42623          	sw	a5,-20(s0)
 496:	3149                	jal	118 <platform_init>
 498:	5a000793          	li	a5,1440
 49c:	4390                	lw	a2,0(a5)
 49e:	43d4                	lw	a3,4(a5)
 4a0:	4798                	lw	a4,8(a5)
 4a2:	47dc                	lw	a5,12(a5)
 4a4:	fcc42e23          	sw	a2,-36(s0)
 4a8:	fed42023          	sw	a3,-32(s0)
 4ac:	fee42223          	sw	a4,-28(s0)
 4b0:	fef42423          	sw	a5,-24(s0)
 4b4:	5b000793          	li	a5,1456
 4b8:	4390                	lw	a2,0(a5)
 4ba:	43d4                	lw	a3,4(a5)
 4bc:	4798                	lw	a4,8(a5)
 4be:	47dc                	lw	a5,12(a5)
 4c0:	fcc42623          	sw	a2,-52(s0)
 4c4:	fcd42823          	sw	a3,-48(s0)
 4c8:	fce42a23          	sw	a4,-44(s0)
 4cc:	fcf42c23          	sw	a5,-40(s0)
 4d0:	3b95                	jal	244 <trigger_high>
 4d2:	fcc40713          	addi	a4,s0,-52
 4d6:	fec42783          	lw	a5,-20(s0)
 4da:	0791                	addi	a5,a5,4
 4dc:	4318                	lw	a4,0(a4)
 4de:	c398                	sw	a4,0(a5)
 4e0:	fec42783          	lw	a5,-20(s0)
 4e4:	07a1                	addi	a5,a5,8
 4e6:	fdc42703          	lw	a4,-36(s0)
 4ea:	c398                	sw	a4,0(a5)
 4ec:	fec42783          	lw	a5,-20(s0)
 4f0:	07b1                	addi	a5,a5,12
 4f2:	fec42703          	lw	a4,-20(s0)
 4f6:	c398                	sw	a4,0(a5)
 4f8:	fec42783          	lw	a5,-20(s0)
 4fc:	07c1                	addi	a5,a5,16
 4fe:	ffc42703          	lw	a4,-4(s0)
 502:	c398                	sw	a4,0(a5)
 504:	fdc40713          	addi	a4,s0,-36
 508:	fec42783          	lw	a5,-20(s0)
 50c:	07d1                	addi	a5,a5,20
 50e:	4318                	lw	a4,0(a4)
 510:	c398                	sw	a4,0(a5)
 512:	fec42783          	lw	a5,-20(s0)
 516:	07e1                	addi	a5,a5,24
 518:	fec42703          	lw	a4,-20(s0)
 51c:	c398                	sw	a4,0(a5)
 51e:	fec42783          	lw	a5,-20(s0)
 522:	07f1                	addi	a5,a5,28
 524:	ffc42703          	lw	a4,-4(s0)
 528:	c398                	sw	a4,0(a5)
 52a:	fec42783          	lw	a5,-20(s0)
 52e:	02078793          	addi	a5,a5,32 # 4000020 <__approm_size__+0x3c10020>
 532:	4458                	lw	a4,12(s0)
 534:	c398                	sw	a4,0(a5)
 536:	fec42783          	lw	a5,-20(s0)
 53a:	4719                	li	a4,6
 53c:	c398                	sw	a4,0(a5)
 53e:	fec42783          	lw	a5,-20(s0)
 542:	4711                	li	a4,4
 544:	c398                	sw	a4,0(a5)
 546:	0001                	nop
 548:	fec42783          	lw	a5,-20(s0)
 54c:	04478793          	addi	a5,a5,68
 550:	4398                	lw	a4,0(a5)
 552:	4785                	li	a5,1
 554:	fef71ae3          	bne	a4,a5,548 <main+0xc2>
 558:	fec42783          	lw	a5,-20(s0)
 55c:	03478793          	addi	a5,a5,52
 560:	439c                	lw	a5,0(a5)
 562:	faf42e23          	sw	a5,-68(s0)
 566:	fec42783          	lw	a5,-20(s0)
 56a:	03878793          	addi	a5,a5,56
 56e:	439c                	lw	a5,0(a5)
 570:	fcf42023          	sw	a5,-64(s0)
 574:	fec42783          	lw	a5,-20(s0)
 578:	03c78793          	addi	a5,a5,60
 57c:	439c                	lw	a5,0(a5)
 57e:	fcf42223          	sw	a5,-60(s0)
 582:	fec42783          	lw	a5,-20(s0)
 586:	04078793          	addi	a5,a5,64
 58a:	439c                	lw	a5,0(a5)
 58c:	fcf42423          	sw	a5,-56(s0)
 590:	31f1                	jal	25c <trigger_low>
 592:	0001                	nop
 594:	853e                	mv	a0,a5
 596:	40b6                	lw	ra,76(sp)
 598:	4426                	lw	s0,72(sp)
 59a:	6161                	addi	sp,sp,80
 59c:	8082                	ret
 59e:	0000                	unimp
 5a0:	e922                	fsw	fs0,144(sp)
 5a2:	b63d                	j	d0 <flashio_worker_L1>
 5a4:	c204                	sw	s1,0(a2)
 5a6:	5b19835b          	0x5b19835b
 5aa:	c6a6                	sw	s1,76(sp)
 5ac:	1ea6                	slli	t4,t4,0x29
 5ae:	d90e                	sw	gp,176(sp)
 5b0:	bc380bfb          	0xbc380bfb
 5b4:	60ad                	lui	ra,0xb
 5b6:	37736cb7          	lui	s9,0x37736
 5ba:	fd7d                	bnez	a0,5b8 <main+0x132>
 5bc:	e59c                	fsw	fa5,8(a1)
 5be:	2f69                	jal	d58 <_etext+0x798>
