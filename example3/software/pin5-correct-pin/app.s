
testcase_app.elf:     file format elf32-littleriscv


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
  4c:	00001517          	auipc	a0,0x1
  50:	93c50513          	addi	a0,a0,-1732 # 988 <_etext>
  54:	00001597          	auipc	a1,0x1
  58:	93458593          	addi	a1,a1,-1740 # 988 <_etext>
  5c:	00001617          	auipc	a2,0x1
  60:	93460613          	addi	a2,a2,-1740 # 990 <romap>
  64:	00c5d863          	bge	a1,a2,74 <end_init_data>

00000068 <loop_init_data>:
  68:	4114                	lw	a3,0(a0)
  6a:	c194                	sw	a3,0(a1)
  6c:	0511                	addi	a0,a0,4
  6e:	0591                	addi	a1,a1,4
  70:	fec5cce3          	blt	a1,a2,68 <loop_init_data>

00000074 <end_init_data>:
  74:	03000537          	lui	a0,0x3000
  78:	459d                	li	a1,7
  7a:	c10c                	sw	a1,0(a0)
  7c:	00001517          	auipc	a0,0x1
  80:	91450513          	addi	a0,a0,-1772 # 990 <romap>
  84:	00001597          	auipc	a1,0x1
  88:	95858593          	addi	a1,a1,-1704 # 9dc <_ebss>
  8c:	00b55763          	bge	a0,a1,9a <end_init_bss>

00000090 <loop_init_bss>:
  90:	00052023          	sw	zero,0(a0)
  94:	0511                	addi	a0,a0,4
  96:	feb54de3          	blt	a0,a1,90 <loop_init_bss>

0000009a <end_init_bss>:
  9a:	03000537          	lui	a0,0x3000
  9e:	45bd                	li	a1,15
  a0:	c10c                	sw	a1,0(a0)
  a2:	0cb000ef          	jal	ra,96c <main>

000000a6 <loop>:
  a6:	a001                	j	a6 <loop>

000000a8 <flashio_worker_begin>:
  a8:	020002b7          	lui	t0,0x2000
  ac:	12000313          	li	t1,288
  b0:	00629023          	sh	t1,0(t0) # 2000000 <__approm_size__+0x1c10000>
  b4:	000281a3          	sb	zero,3(t0)
  b8:	c605                	beqz	a2,e0 <flashio_worker_L1>
  ba:	4f21                	li	t5,8
  bc:	0ff67393          	zext.b	t2,a2

000000c0 <flashio_worker_L4>:
  c0:	0073de93          	srli	t4,t2,0x7
  c4:	01d28023          	sb	t4,0(t0)
  c8:	010eee93          	ori	t4,t4,16
  cc:	01d28023          	sb	t4,0(t0)
  d0:	0386                	slli	t2,t2,0x1
  d2:	0ff3f393          	zext.b	t2,t2
  d6:	1f7d                	addi	t5,t5,-1
  d8:	fe0f14e3          	bnez	t5,c0 <flashio_worker_L4>
  dc:	00628023          	sb	t1,0(t0)

000000e0 <flashio_worker_L1>:
  e0:	cd9d                	beqz	a1,11e <flashio_worker_L3>
  e2:	4f21                	li	t5,8
  e4:	00054383          	lbu	t2,0(a0) # 3000000 <__approm_size__+0x2c10000>

000000e8 <flashio_worker_L2>:
  e8:	0073de93          	srli	t4,t2,0x7
  ec:	01d28023          	sb	t4,0(t0)
  f0:	010eee93          	ori	t4,t4,16
  f4:	01d28023          	sb	t4,0(t0)
  f8:	0002ce83          	lbu	t4,0(t0)
  fc:	002efe93          	andi	t4,t4,2
 100:	001ede93          	srli	t4,t4,0x1
 104:	0386                	slli	t2,t2,0x1
 106:	01d3e3b3          	or	t2,t2,t4
 10a:	0ff3f393          	zext.b	t2,t2
 10e:	1f7d                	addi	t5,t5,-1
 110:	fc0f1ce3          	bnez	t5,e8 <flashio_worker_L2>
 114:	00750023          	sb	t2,0(a0)
 118:	0505                	addi	a0,a0,1
 11a:	15fd                	addi	a1,a1,-1
 11c:	b7d1                	j	e0 <flashio_worker_L1>

0000011e <flashio_worker_L3>:
 11e:	08000313          	li	t1,128
 122:	006281a3          	sb	t1,3(t0)
 126:	8082                	ret

00000128 <platform_init>:
 128:	1141                	addi	sp,sp,-16
 12a:	c606                	sw	ra,12(sp)
 12c:	c422                	sw	s0,8(sp)
 12e:	0800                	addi	s0,sp,16
 130:	2c91                	jal	384 <set_flash_qspi_flag>
 132:	020007b7          	lui	a5,0x2000
 136:	0791                	addi	a5,a5,4 # 2000004 <__approm_size__+0x1c10004>
 138:	06800713          	li	a4,104
 13c:	c398                	sw	a4,0(a5)
 13e:	038007b7          	lui	a5,0x3800
 142:	4705                	li	a4,1
 144:	c398                	sw	a4,0(a5)
 146:	038007b7          	lui	a5,0x3800
 14a:	0791                	addi	a5,a5,4 # 3800004 <__approm_size__+0x3410004>
 14c:	4705                	li	a4,1
 14e:	c398                	sw	a4,0(a5)
 150:	038007b7          	lui	a5,0x3800
 154:	07a1                	addi	a5,a5,8 # 3800008 <__approm_size__+0x3410008>
 156:	4705                	li	a4,1
 158:	c398                	sw	a4,0(a5)
 15a:	038007b7          	lui	a5,0x3800
 15e:	07b1                	addi	a5,a5,12 # 380000c <__approm_size__+0x341000c>
 160:	4705                	li	a4,1
 162:	c398                	sw	a4,0(a5)
 164:	038007b7          	lui	a5,0x3800
 168:	07c1                	addi	a5,a5,16 # 3800010 <__approm_size__+0x3410010>
 16a:	4705                	li	a4,1
 16c:	c398                	sw	a4,0(a5)
 16e:	038007b7          	lui	a5,0x3800
 172:	07d1                	addi	a5,a5,20 # 3800014 <__approm_size__+0x3410014>
 174:	4705                	li	a4,1
 176:	c398                	sw	a4,0(a5)
 178:	038007b7          	lui	a5,0x3800
 17c:	07e1                	addi	a5,a5,24 # 3800018 <__approm_size__+0x3410018>
 17e:	4705                	li	a4,1
 180:	c398                	sw	a4,0(a5)
 182:	038007b7          	lui	a5,0x3800
 186:	07f1                	addi	a5,a5,28 # 380001c <__approm_size__+0x341001c>
 188:	4705                	li	a4,1
 18a:	c398                	sw	a4,0(a5)
 18c:	0001                	nop
 18e:	40b2                	lw	ra,12(sp)
 190:	4422                	lw	s0,8(sp)
 192:	0141                	addi	sp,sp,16
 194:	8082                	ret

00000196 <ledon>:
 196:	1101                	addi	sp,sp,-32
 198:	ce22                	sw	s0,28(sp)
 19a:	1000                	addi	s0,sp,32
 19c:	87aa                	mv	a5,a0
 19e:	fef407a3          	sb	a5,-17(s0)
 1a2:	fef44783          	lbu	a5,-17(s0)
 1a6:	00279713          	slli	a4,a5,0x2
 1aa:	038007b7          	lui	a5,0x3800
 1ae:	97ba                	add	a5,a5,a4
 1b0:	4705                	li	a4,1
 1b2:	c398                	sw	a4,0(a5)
 1b4:	fef44783          	lbu	a5,-17(s0)
 1b8:	00279713          	slli	a4,a5,0x2
 1bc:	030007b7          	lui	a5,0x3000
 1c0:	97ba                	add	a5,a5,a4
 1c2:	4705                	li	a4,1
 1c4:	c398                	sw	a4,0(a5)
 1c6:	0001                	nop
 1c8:	4472                	lw	s0,28(sp)
 1ca:	6105                	addi	sp,sp,32
 1cc:	8082                	ret

000001ce <ledoff>:
 1ce:	1101                	addi	sp,sp,-32
 1d0:	ce22                	sw	s0,28(sp)
 1d2:	1000                	addi	s0,sp,32
 1d4:	87aa                	mv	a5,a0
 1d6:	fef407a3          	sb	a5,-17(s0)
 1da:	fef44783          	lbu	a5,-17(s0)
 1de:	00279713          	slli	a4,a5,0x2
 1e2:	038007b7          	lui	a5,0x3800
 1e6:	97ba                	add	a5,a5,a4
 1e8:	4705                	li	a4,1
 1ea:	c398                	sw	a4,0(a5)
 1ec:	fef44783          	lbu	a5,-17(s0)
 1f0:	00279713          	slli	a4,a5,0x2
 1f4:	030007b7          	lui	a5,0x3000
 1f8:	97ba                	add	a5,a5,a4
 1fa:	0007a023          	sw	zero,0(a5) # 3000000 <__approm_size__+0x2c10000>
 1fe:	0001                	nop
 200:	4472                	lw	s0,28(sp)
 202:	6105                	addi	sp,sp,32
 204:	8082                	ret

00000206 <getch>:
 206:	1101                	addi	sp,sp,-32
 208:	ce22                	sw	s0,28(sp)
 20a:	1000                	addi	s0,sp,32
 20c:	57fd                	li	a5,-1
 20e:	fef42623          	sw	a5,-20(s0)
 212:	a039                	j	220 <getch+0x1a>
 214:	020007b7          	lui	a5,0x2000
 218:	07a1                	addi	a5,a5,8 # 2000008 <__approm_size__+0x1c10008>
 21a:	439c                	lw	a5,0(a5)
 21c:	fef42623          	sw	a5,-20(s0)
 220:	fec42703          	lw	a4,-20(s0)
 224:	57fd                	li	a5,-1
 226:	fef707e3          	beq	a4,a5,214 <getch+0xe>
 22a:	fec42783          	lw	a5,-20(s0)
 22e:	0ff7f793          	zext.b	a5,a5
 232:	853e                	mv	a0,a5
 234:	4472                	lw	s0,28(sp)
 236:	6105                	addi	sp,sp,32
 238:	8082                	ret

0000023a <putch>:
 23a:	1101                	addi	sp,sp,-32
 23c:	ce22                	sw	s0,28(sp)
 23e:	1000                	addi	s0,sp,32
 240:	87aa                	mv	a5,a0
 242:	fef407a3          	sb	a5,-17(s0)
 246:	020007b7          	lui	a5,0x2000
 24a:	07a1                	addi	a5,a5,8 # 2000008 <__approm_size__+0x1c10008>
 24c:	fef44703          	lbu	a4,-17(s0)
 250:	c398                	sw	a4,0(a5)
 252:	0001                	nop
 254:	4472                	lw	s0,28(sp)
 256:	6105                	addi	sp,sp,32
 258:	8082                	ret

0000025a <trigger_high>:
 25a:	1141                	addi	sp,sp,-16
 25c:	c622                	sw	s0,12(sp)
 25e:	0800                	addi	s0,sp,16
 260:	030007b7          	lui	a5,0x3000
 264:	07a1                	addi	a5,a5,8 # 3000008 <__approm_size__+0x2c10008>
 266:	4705                	li	a4,1
 268:	c398                	sw	a4,0(a5)
 26a:	0001                	nop
 26c:	4432                	lw	s0,12(sp)
 26e:	0141                	addi	sp,sp,16
 270:	8082                	ret

00000272 <trigger_low>:
 272:	1141                	addi	sp,sp,-16
 274:	c622                	sw	s0,12(sp)
 276:	0800                	addi	s0,sp,16
 278:	030007b7          	lui	a5,0x3000
 27c:	07a1                	addi	a5,a5,8 # 3000008 <__approm_size__+0x2c10008>
 27e:	0007a023          	sw	zero,0(a5)
 282:	0001                	nop
 284:	4432                	lw	s0,12(sp)
 286:	0141                	addi	sp,sp,16
 288:	8082                	ret

0000028a <flashio>:
 28a:	7179                	addi	sp,sp,-48
 28c:	d606                	sw	ra,44(sp)
 28e:	d422                	sw	s0,40(sp)
 290:	d226                	sw	s1,36(sp)
 292:	1800                	addi	s0,sp,48
 294:	fca42e23          	sw	a0,-36(s0)
 298:	fcb42c23          	sw	a1,-40(s0)
 29c:	86b2                	mv	a3,a2
 29e:	fcd40ba3          	sb	a3,-41(s0)
 2a2:	868a                	mv	a3,sp
 2a4:	84b6                	mv	s1,a3
 2a6:	12800613          	li	a2,296
 2aa:	0a800693          	li	a3,168
 2ae:	40d606b3          	sub	a3,a2,a3
 2b2:	8689                	srai	a3,a3,0x2
 2b4:	16fd                	addi	a3,a3,-1
 2b6:	fed42223          	sw	a3,-28(s0)
 2ba:	12800613          	li	a2,296
 2be:	0a800693          	li	a3,168
 2c2:	40d606b3          	sub	a3,a2,a3
 2c6:	8689                	srai	a3,a3,0x2
 2c8:	8e36                	mv	t3,a3
 2ca:	4e81                	li	t4,0
 2cc:	01be5693          	srli	a3,t3,0x1b
 2d0:	005e9893          	slli	a7,t4,0x5
 2d4:	0116e8b3          	or	a7,a3,a7
 2d8:	005e1813          	slli	a6,t3,0x5
 2dc:	12800613          	li	a2,296
 2e0:	0a800693          	li	a3,168
 2e4:	40d606b3          	sub	a3,a2,a3
 2e8:	8689                	srai	a3,a3,0x2
 2ea:	8336                	mv	t1,a3
 2ec:	4381                	li	t2,0
 2ee:	01b35693          	srli	a3,t1,0x1b
 2f2:	00539793          	slli	a5,t2,0x5
 2f6:	8fd5                	or	a5,a5,a3
 2f8:	00531713          	slli	a4,t1,0x5
 2fc:	12800713          	li	a4,296
 300:	0a800793          	li	a5,168
 304:	40f707b3          	sub	a5,a4,a5
 308:	078d                	addi	a5,a5,3
 30a:	9bf1                	andi	a5,a5,-4
 30c:	07bd                	addi	a5,a5,15
 30e:	8391                	srli	a5,a5,0x4
 310:	0792                	slli	a5,a5,0x4
 312:	40f10133          	sub	sp,sp,a5
 316:	878a                	mv	a5,sp
 318:	078d                	addi	a5,a5,3
 31a:	8389                	srli	a5,a5,0x2
 31c:	078a                	slli	a5,a5,0x2
 31e:	fef42023          	sw	a5,-32(s0)
 322:	0a800793          	li	a5,168
 326:	fef42623          	sw	a5,-20(s0)
 32a:	fe042783          	lw	a5,-32(s0)
 32e:	fef42423          	sw	a5,-24(s0)
 332:	a839                	j	350 <flashio+0xc6>
 334:	fec42703          	lw	a4,-20(s0)
 338:	00470793          	addi	a5,a4,4
 33c:	fef42623          	sw	a5,-20(s0)
 340:	fe842783          	lw	a5,-24(s0)
 344:	00478693          	addi	a3,a5,4
 348:	fed42423          	sw	a3,-24(s0)
 34c:	4318                	lw	a4,0(a4)
 34e:	c398                	sw	a4,0(a5)
 350:	fec42703          	lw	a4,-20(s0)
 354:	12800793          	li	a5,296
 358:	fcf71ee3          	bne	a4,a5,334 <flashio+0xaa>
 35c:	fe042783          	lw	a5,-32(s0)
 360:	fd842703          	lw	a4,-40(s0)
 364:	fd744683          	lbu	a3,-41(s0)
 368:	8636                	mv	a2,a3
 36a:	85ba                	mv	a1,a4
 36c:	fdc42503          	lw	a0,-36(s0)
 370:	9782                	jalr	a5
 372:	8126                	mv	sp,s1
 374:	0001                	nop
 376:	fd040113          	addi	sp,s0,-48
 37a:	50b2                	lw	ra,44(sp)
 37c:	5422                	lw	s0,40(sp)
 37e:	5492                	lw	s1,36(sp)
 380:	6145                	addi	sp,sp,48
 382:	8082                	ret

00000384 <set_flash_qspi_flag>:
 384:	1101                	addi	sp,sp,-32
 386:	ce06                	sw	ra,28(sp)
 388:	cc22                	sw	s0,24(sp)
 38a:	1000                	addi	s0,sp,32
 38c:	03500793          	li	a5,53
 390:	fef40223          	sb	a5,-28(s0)
 394:	fe0402a3          	sb	zero,-27(s0)
 398:	fe440793          	addi	a5,s0,-28
 39c:	4601                	li	a2,0
 39e:	4589                	li	a1,2
 3a0:	853e                	mv	a0,a5
 3a2:	35e5                	jal	28a <flashio>
 3a4:	fe544783          	lbu	a5,-27(s0)
 3a8:	fef407a3          	sb	a5,-17(s0)
 3ac:	03100793          	li	a5,49
 3b0:	fef40223          	sb	a5,-28(s0)
 3b4:	fef44783          	lbu	a5,-17(s0)
 3b8:	0027e793          	ori	a5,a5,2
 3bc:	0ff7f793          	zext.b	a5,a5
 3c0:	fef402a3          	sb	a5,-27(s0)
 3c4:	fe440793          	addi	a5,s0,-28
 3c8:	05000613          	li	a2,80
 3cc:	4589                	li	a1,2
 3ce:	853e                	mv	a0,a5
 3d0:	3d6d                	jal	28a <flashio>
 3d2:	0001                	nop
 3d4:	40f2                	lw	ra,28(sp)
 3d6:	4462                	lw	s0,24(sp)
 3d8:	6105                	addi	sp,sp,32
 3da:	8082                	ret

000003dc <set_flash_mode_spi>:
 3dc:	1141                	addi	sp,sp,-16
 3de:	c622                	sw	s0,12(sp)
 3e0:	0800                	addi	s0,sp,16
 3e2:	020007b7          	lui	a5,0x2000
 3e6:	4394                	lw	a3,0(a5)
 3e8:	020007b7          	lui	a5,0x2000
 3ec:	ff810737          	lui	a4,0xff810
 3f0:	177d                	addi	a4,a4,-1 # ff80ffff <__approm_size__+0xff41ffff>
 3f2:	8f75                	and	a4,a4,a3
 3f4:	c398                	sw	a4,0(a5)
 3f6:	0001                	nop
 3f8:	4432                	lw	s0,12(sp)
 3fa:	0141                	addi	sp,sp,16
 3fc:	8082                	ret

000003fe <set_flash_mode_dual>:
 3fe:	1141                	addi	sp,sp,-16
 400:	c622                	sw	s0,12(sp)
 402:	0800                	addi	s0,sp,16
 404:	020007b7          	lui	a5,0x2000
 408:	4398                	lw	a4,0(a5)
 40a:	ff8107b7          	lui	a5,0xff810
 40e:	17fd                	addi	a5,a5,-1 # ff80ffff <__approm_size__+0xff41ffff>
 410:	00f776b3          	and	a3,a4,a5
 414:	020007b7          	lui	a5,0x2000
 418:	00400737          	lui	a4,0x400
 41c:	8f55                	or	a4,a4,a3
 41e:	c398                	sw	a4,0(a5)
 420:	0001                	nop
 422:	4432                	lw	s0,12(sp)
 424:	0141                	addi	sp,sp,16
 426:	8082                	ret

00000428 <set_flash_mode_quad>:
 428:	1141                	addi	sp,sp,-16
 42a:	c622                	sw	s0,12(sp)
 42c:	0800                	addi	s0,sp,16
 42e:	020007b7          	lui	a5,0x2000
 432:	4398                	lw	a4,0(a5)
 434:	ff8107b7          	lui	a5,0xff810
 438:	17fd                	addi	a5,a5,-1 # ff80ffff <__approm_size__+0xff41ffff>
 43a:	00f776b3          	and	a3,a4,a5
 43e:	020007b7          	lui	a5,0x2000
 442:	00240737          	lui	a4,0x240
 446:	8f55                	or	a4,a4,a3
 448:	c398                	sw	a4,0(a5)
 44a:	0001                	nop
 44c:	4432                	lw	s0,12(sp)
 44e:	0141                	addi	sp,sp,16
 450:	8082                	ret

00000452 <set_flash_mode_qddr>:
 452:	1141                	addi	sp,sp,-16
 454:	c622                	sw	s0,12(sp)
 456:	0800                	addi	s0,sp,16
 458:	020007b7          	lui	a5,0x2000
 45c:	4398                	lw	a4,0(a5)
 45e:	ff8107b7          	lui	a5,0xff810
 462:	17fd                	addi	a5,a5,-1 # ff80ffff <__approm_size__+0xff41ffff>
 464:	00f776b3          	and	a3,a4,a5
 468:	020007b7          	lui	a5,0x2000
 46c:	00670737          	lui	a4,0x670
 470:	8f55                	or	a4,a4,a3
 472:	c398                	sw	a4,0(a5)
 474:	0001                	nop
 476:	4432                	lw	s0,12(sp)
 478:	0141                	addi	sp,sp,16
 47a:	8082                	ret

0000047c <enable_flash_crm>:
 47c:	1141                	addi	sp,sp,-16
 47e:	c622                	sw	s0,12(sp)
 480:	0800                	addi	s0,sp,16
 482:	020007b7          	lui	a5,0x2000
 486:	4394                	lw	a3,0(a5)
 488:	020007b7          	lui	a5,0x2000
 48c:	00100737          	lui	a4,0x100
 490:	8f55                	or	a4,a4,a3
 492:	c398                	sw	a4,0(a5)
 494:	0001                	nop
 496:	4432                	lw	s0,12(sp)
 498:	0141                	addi	sp,sp,16
 49a:	8082                	ret

0000049c <configure_ro_max>:
 49c:	1101                	addi	sp,sp,-32
 49e:	ce22                	sw	s0,28(sp)
 4a0:	1000                	addi	s0,sp,32
 4a2:	6785                	lui	a5,0x1
 4a4:	9887a783          	lw	a5,-1656(a5) # 988 <_etext>
 4a8:	80000737          	lui	a4,0x80000
 4ac:	c398                	sw	a4,0(a5)
 4ae:	6785                	lui	a5,0x1
 4b0:	98c7a783          	lw	a5,-1652(a5) # 98c <triro>
 4b4:	80000737          	lui	a4,0x80000
 4b8:	c398                	sw	a4,0(a5)
 4ba:	fe042623          	sw	zero,-20(s0)
 4be:	a839                	j	4dc <configure_ro_max+0x40>
 4c0:	6785                	lui	a5,0x1
 4c2:	9887a703          	lw	a4,-1656(a5) # 988 <_etext>
 4c6:	fec42783          	lw	a5,-20(s0)
 4ca:	078a                	slli	a5,a5,0x2
 4cc:	97ba                	add	a5,a5,a4
 4ce:	0007a023          	sw	zero,0(a5)
 4d2:	fec42783          	lw	a5,-20(s0)
 4d6:	0785                	addi	a5,a5,1
 4d8:	fef42623          	sw	a5,-20(s0)
 4dc:	fec42703          	lw	a4,-20(s0)
 4e0:	47ad                	li	a5,11
 4e2:	fce7dfe3          	bge	a5,a4,4c0 <configure_ro_max+0x24>
 4e6:	fe042623          	sw	zero,-20(s0)
 4ea:	a839                	j	508 <configure_ro_max+0x6c>
 4ec:	6785                	lui	a5,0x1
 4ee:	98c7a703          	lw	a4,-1652(a5) # 98c <triro>
 4f2:	fec42783          	lw	a5,-20(s0)
 4f6:	078a                	slli	a5,a5,0x2
 4f8:	97ba                	add	a5,a5,a4
 4fa:	0007a023          	sw	zero,0(a5)
 4fe:	fec42783          	lw	a5,-20(s0)
 502:	0785                	addi	a5,a5,1
 504:	fef42623          	sw	a5,-20(s0)
 508:	fec42703          	lw	a4,-20(s0)
 50c:	47ad                	li	a5,11
 50e:	fce7dfe3          	bge	a5,a4,4ec <configure_ro_max+0x50>
 512:	0001                	nop
 514:	0001                	nop
 516:	4472                	lw	s0,28(sp)
 518:	6105                	addi	sp,sp,32
 51a:	8082                	ret

0000051c <configure_ro_min>:
 51c:	1101                	addi	sp,sp,-32
 51e:	ce22                	sw	s0,28(sp)
 520:	1000                	addi	s0,sp,32
 522:	6785                	lui	a5,0x1
 524:	9887a783          	lw	a5,-1656(a5) # 988 <_etext>
 528:	80000737          	lui	a4,0x80000
 52c:	c398                	sw	a4,0(a5)
 52e:	6785                	lui	a5,0x1
 530:	98c7a783          	lw	a5,-1652(a5) # 98c <triro>
 534:	80000737          	lui	a4,0x80000
 538:	c398                	sw	a4,0(a5)
 53a:	fe042623          	sw	zero,-20(s0)
 53e:	a015                	j	562 <configure_ro_min+0x46>
 540:	6785                	lui	a5,0x1
 542:	9887a703          	lw	a4,-1656(a5) # 988 <_etext>
 546:	fec42783          	lw	a5,-20(s0)
 54a:	078a                	slli	a5,a5,0x2
 54c:	97ba                	add	a5,a5,a4
 54e:	03030737          	lui	a4,0x3030
 552:	30370713          	addi	a4,a4,771 # 3030303 <__approm_size__+0x2c40303>
 556:	c398                	sw	a4,0(a5)
 558:	fec42783          	lw	a5,-20(s0)
 55c:	0785                	addi	a5,a5,1
 55e:	fef42623          	sw	a5,-20(s0)
 562:	fec42703          	lw	a4,-20(s0)
 566:	47ad                	li	a5,11
 568:	fce7dce3          	bge	a5,a4,540 <configure_ro_min+0x24>
 56c:	fe042623          	sw	zero,-20(s0)
 570:	a015                	j	594 <configure_ro_min+0x78>
 572:	6785                	lui	a5,0x1
 574:	98c7a703          	lw	a4,-1652(a5) # 98c <triro>
 578:	fec42783          	lw	a5,-20(s0)
 57c:	078a                	slli	a5,a5,0x2
 57e:	97ba                	add	a5,a5,a4
 580:	03030737          	lui	a4,0x3030
 584:	30370713          	addi	a4,a4,771 # 3030303 <__approm_size__+0x2c40303>
 588:	c398                	sw	a4,0(a5)
 58a:	fec42783          	lw	a5,-20(s0)
 58e:	0785                	addi	a5,a5,1
 590:	fef42623          	sw	a5,-20(s0)
 594:	fec42703          	lw	a4,-20(s0)
 598:	47ad                	li	a5,11
 59a:	fce7dce3          	bge	a5,a4,572 <configure_ro_min+0x56>
 59e:	0001                	nop
 5a0:	0001                	nop
 5a2:	4472                	lw	s0,28(sp)
 5a4:	6105                	addi	sp,sp,32
 5a6:	8082                	ret

000005a8 <enable_ro_config>:
 5a8:	7179                	addi	sp,sp,-48
 5aa:	d622                	sw	s0,44(sp)
 5ac:	1800                	addi	s0,sp,48
 5ae:	87aa                	mv	a5,a0
 5b0:	fcf40fa3          	sb	a5,-33(s0)
 5b4:	fdf44783          	lbu	a5,-33(s0)
 5b8:	8bbd                	andi	a5,a5,15
 5ba:	fef407a3          	sb	a5,-17(s0)
 5be:	fdf44783          	lbu	a5,-33(s0)
 5c2:	8391                	srli	a5,a5,0x4
 5c4:	fef40723          	sb	a5,-18(s0)
 5c8:	fef44783          	lbu	a5,-17(s0)
 5cc:	6705                	lui	a4,0x1
 5ce:	99070713          	addi	a4,a4,-1648 # 990 <romap>
 5d2:	078a                	slli	a5,a5,0x2
 5d4:	97ba                	add	a5,a5,a4
 5d6:	439c                	lw	a5,0(a5)
 5d8:	86be                	mv	a3,a5
 5da:	6785                	lui	a5,0x1
 5dc:	98c7a783          	lw	a5,-1652(a5) # 98c <triro>
 5e0:	80000737          	lui	a4,0x80000
 5e4:	9736                	add	a4,a4,a3
 5e6:	c398                	sw	a4,0(a5)
 5e8:	fee44783          	lbu	a5,-18(s0)
 5ec:	6705                	lui	a4,0x1
 5ee:	99070713          	addi	a4,a4,-1648 # 990 <romap>
 5f2:	078a                	slli	a5,a5,0x2
 5f4:	97ba                	add	a5,a5,a4
 5f6:	439c                	lw	a5,0(a5)
 5f8:	86be                	mv	a3,a5
 5fa:	6785                	lui	a5,0x1
 5fc:	9887a783          	lw	a5,-1656(a5) # 988 <_etext>
 600:	80000737          	lui	a4,0x80000
 604:	9736                	add	a4,a4,a3
 606:	c398                	sw	a4,0(a5)
 608:	0001                	nop
 60a:	5432                	lw	s0,44(sp)
 60c:	6145                	addi	sp,sp,48
 60e:	8082                	ret

00000610 <enable_ro>:
 610:	1141                	addi	sp,sp,-16
 612:	c622                	sw	s0,12(sp)
 614:	0800                	addi	s0,sp,16
 616:	6785                	lui	a5,0x1
 618:	9887a783          	lw	a5,-1656(a5) # 988 <_etext>
 61c:	80080737          	lui	a4,0x80080
 620:	1761                	addi	a4,a4,-8 # 8007fff8 <__approm_size__+0x7fc8fff8>
 622:	c398                	sw	a4,0(a5)
 624:	6785                	lui	a5,0x1
 626:	98c7a783          	lw	a5,-1652(a5) # 98c <triro>
 62a:	80080737          	lui	a4,0x80080
 62e:	1761                	addi	a4,a4,-8 # 8007fff8 <__approm_size__+0x7fc8fff8>
 630:	c398                	sw	a4,0(a5)
 632:	0001                	nop
 634:	4432                	lw	s0,12(sp)
 636:	0141                	addi	sp,sp,16
 638:	8082                	ret

0000063a <disable_ro>:
 63a:	1141                	addi	sp,sp,-16
 63c:	c622                	sw	s0,12(sp)
 63e:	0800                	addi	s0,sp,16
 640:	6785                	lui	a5,0x1
 642:	9887a783          	lw	a5,-1656(a5) # 988 <_etext>
 646:	80000737          	lui	a4,0x80000
 64a:	c398                	sw	a4,0(a5)
 64c:	6785                	lui	a5,0x1
 64e:	98c7a783          	lw	a5,-1652(a5) # 98c <triro>
 652:	80000737          	lui	a4,0x80000
 656:	c398                	sw	a4,0(a5)
 658:	0001                	nop
 65a:	4432                	lw	s0,12(sp)
 65c:	0141                	addi	sp,sp,16
 65e:	8082                	ret

00000660 <uart_in>:
 660:	1101                	addi	sp,sp,-32
 662:	ce22                	sw	s0,28(sp)
 664:	1000                	addi	s0,sp,32
 666:	fea42623          	sw	a0,-20(s0)
 66a:	0001                	nop
 66c:	853e                	mv	a0,a5
 66e:	4472                	lw	s0,28(sp)
 670:	6105                	addi	sp,sp,32
 672:	8082                	ret

00000674 <uart_out>:
 674:	1101                	addi	sp,sp,-32
 676:	ce22                	sw	s0,28(sp)
 678:	1000                	addi	s0,sp,32
 67a:	fea42623          	sw	a0,-20(s0)
 67e:	87ae                	mv	a5,a1
 680:	fef405a3          	sb	a5,-21(s0)
 684:	0001                	nop
 686:	4472                	lw	s0,28(sp)
 688:	6105                	addi	sp,sp,32
 68a:	8082                	ret

0000068c <set_outputs>:
 68c:	1101                	addi	sp,sp,-32
 68e:	ce22                	sw	s0,28(sp)
 690:	1000                	addi	s0,sp,32
 692:	fea42623          	sw	a0,-20(s0)
 696:	feb42423          	sw	a1,-24(s0)
 69a:	0001                	nop
 69c:	4472                	lw	s0,28(sp)
 69e:	6105                	addi	sp,sp,32
 6a0:	8082                	ret

000006a2 <read_gpio>:
 6a2:	1101                	addi	sp,sp,-32
 6a4:	ce22                	sw	s0,28(sp)
 6a6:	1000                	addi	s0,sp,32
 6a8:	fea42623          	sw	a0,-20(s0)
 6ac:	0001                	nop
 6ae:	853e                	mv	a0,a5
 6b0:	4472                	lw	s0,28(sp)
 6b2:	6105                	addi	sp,sp,32
 6b4:	8082                	ret

000006b6 <set_output_bit>:
 6b6:	1101                	addi	sp,sp,-32
 6b8:	ce22                	sw	s0,28(sp)
 6ba:	1000                	addi	s0,sp,32
 6bc:	fea42623          	sw	a0,-20(s0)
 6c0:	feb42423          	sw	a1,-24(s0)
 6c4:	fec42223          	sw	a2,-28(s0)
 6c8:	0001                	nop
 6ca:	4472                	lw	s0,28(sp)
 6cc:	6105                	addi	sp,sp,32
 6ce:	8082                	ret

000006d0 <get_output_bit>:
 6d0:	1101                	addi	sp,sp,-32
 6d2:	ce22                	sw	s0,28(sp)
 6d4:	1000                	addi	s0,sp,32
 6d6:	fea42623          	sw	a0,-20(s0)
 6da:	feb42423          	sw	a1,-24(s0)
 6de:	0001                	nop
 6e0:	853e                	mv	a0,a5
 6e2:	4472                	lw	s0,28(sp)
 6e4:	6105                	addi	sp,sp,32
 6e6:	8082                	ret

000006e8 <byteArrayCompare>:
 6e8:	7179                	addi	sp,sp,-48
 6ea:	d606                	sw	ra,44(sp)
 6ec:	d422                	sw	s0,40(sp)
 6ee:	1800                	addi	s0,sp,48
 6f0:	fca42e23          	sw	a0,-36(s0)
 6f4:	fcb42c23          	sw	a1,-40(s0)
 6f8:	87b2                	mv	a5,a2
 6fa:	fcf40ba3          	sb	a5,-41(s0)
 6fe:	05500793          	li	a5,85
 702:	fef405a3          	sb	a5,-21(s0)
 706:	05500793          	li	a5,85
 70a:	fef40523          	sb	a5,-22(s0)
 70e:	fe042623          	sw	zero,-20(s0)
 712:	a815                	j	746 <byteArrayCompare+0x5e>
 714:	fec42783          	lw	a5,-20(s0)
 718:	fdc42703          	lw	a4,-36(s0)
 71c:	97ba                	add	a5,a5,a4
 71e:	0007c703          	lbu	a4,0(a5)
 722:	fec42783          	lw	a5,-20(s0)
 726:	fd842683          	lw	a3,-40(s0)
 72a:	97b6                	add	a5,a5,a3
 72c:	0007c783          	lbu	a5,0(a5)
 730:	00f70663          	beq	a4,a5,73c <byteArrayCompare+0x54>
 734:	faa00793          	li	a5,-86
 738:	fef40523          	sb	a5,-22(s0)
 73c:	fec42783          	lw	a5,-20(s0)
 740:	0785                	addi	a5,a5,1
 742:	fef42623          	sw	a5,-20(s0)
 746:	fd744783          	lbu	a5,-41(s0)
 74a:	fec42703          	lw	a4,-20(s0)
 74e:	fcf743e3          	blt	a4,a5,714 <byteArrayCompare+0x2c>
 752:	fd744783          	lbu	a5,-41(s0)
 756:	fec42703          	lw	a4,-20(s0)
 75a:	00f70363          	beq	a4,a5,760 <byteArrayCompare+0x78>
 75e:	20d9                	jal	824 <countermeasure>
 760:	fea44703          	lbu	a4,-22(s0)
 764:	05500793          	li	a5,85
 768:	00f71763          	bne	a4,a5,776 <byteArrayCompare+0x8e>
 76c:	faa00793          	li	a5,-86
 770:	fef405a3          	sb	a5,-21(s0)
 774:	a029                	j	77e <byteArrayCompare+0x96>
 776:	05500793          	li	a5,85
 77a:	fef405a3          	sb	a5,-21(s0)
 77e:	feb44783          	lbu	a5,-21(s0)
 782:	853e                	mv	a0,a5
 784:	50b2                	lw	ra,44(sp)
 786:	5422                	lw	s0,40(sp)
 788:	6145                	addi	sp,sp,48
 78a:	8082                	ret

0000078c <verifyPIN>:
 78c:	1141                	addi	sp,sp,-16
 78e:	c606                	sw	ra,12(sp)
 790:	c422                	sw	s0,8(sp)
 792:	0800                	addi	s0,sp,16
 794:	6785                	lui	a5,0x1
 796:	05500713          	li	a4,85
 79a:	9ce78823          	sb	a4,-1584(a5) # 9d0 <g_authenticated>
 79e:	6785                	lui	a5,0x1
 7a0:	9d178783          	lb	a5,-1583(a5) # 9d1 <g_ptc>
 7a4:	06f05963          	blez	a5,816 <verifyPIN+0x8a>
 7a8:	6785                	lui	a5,0x1
 7aa:	9d178783          	lb	a5,-1583(a5) # 9d1 <g_ptc>
 7ae:	0ff7f793          	zext.b	a5,a5
 7b2:	17fd                	addi	a5,a5,-1
 7b4:	0ff7f793          	zext.b	a5,a5
 7b8:	01879713          	slli	a4,a5,0x18
 7bc:	8761                	srai	a4,a4,0x18
 7be:	6785                	lui	a5,0x1
 7c0:	9ce788a3          	sb	a4,-1583(a5) # 9d1 <g_ptc>
 7c4:	4611                	li	a2,4
 7c6:	6785                	lui	a5,0x1
 7c8:	9d878593          	addi	a1,a5,-1576 # 9d8 <g_cardPin>
 7cc:	6785                	lui	a5,0x1
 7ce:	9d478513          	addi	a0,a5,-1580 # 9d4 <g_userPin>
 7d2:	3f19                	jal	6e8 <byteArrayCompare>
 7d4:	87aa                	mv	a5,a0
 7d6:	873e                	mv	a4,a5
 7d8:	0aa00793          	li	a5,170
 7dc:	02f71d63          	bne	a4,a5,816 <verifyPIN+0x8a>
 7e0:	4611                	li	a2,4
 7e2:	6785                	lui	a5,0x1
 7e4:	9d478593          	addi	a1,a5,-1580 # 9d4 <g_userPin>
 7e8:	6785                	lui	a5,0x1
 7ea:	9d878513          	addi	a0,a5,-1576 # 9d8 <g_cardPin>
 7ee:	3ded                	jal	6e8 <byteArrayCompare>
 7f0:	87aa                	mv	a5,a0
 7f2:	873e                	mv	a4,a5
 7f4:	0aa00793          	li	a5,170
 7f8:	00f71e63          	bne	a4,a5,814 <verifyPIN+0x88>
 7fc:	6785                	lui	a5,0x1
 7fe:	470d                	li	a4,3
 800:	9ce788a3          	sb	a4,-1583(a5) # 9d1 <g_ptc>
 804:	6785                	lui	a5,0x1
 806:	faa00713          	li	a4,-86
 80a:	9ce78823          	sb	a4,-1584(a5) # 9d0 <g_authenticated>
 80e:	0aa00793          	li	a5,170
 812:	a021                	j	81a <verifyPIN+0x8e>
 814:	2801                	jal	824 <countermeasure>
 816:	05500793          	li	a5,85
 81a:	853e                	mv	a0,a5
 81c:	40b2                	lw	ra,12(sp)
 81e:	4422                	lw	s0,8(sp)
 820:	0141                	addi	sp,sp,16
 822:	8082                	ret

00000824 <countermeasure>:
 824:	1141                	addi	sp,sp,-16
 826:	c622                	sw	s0,12(sp)
 828:	0800                	addi	s0,sp,16
 82a:	6785                	lui	a5,0x1
 82c:	4705                	li	a4,1
 82e:	9ce78923          	sb	a4,-1582(a5) # 9d2 <g_countermeasure>
 832:	0001                	nop
 834:	4432                	lw	s0,12(sp)
 836:	0141                	addi	sp,sp,16
 838:	8082                	ret

0000083a <initialize>:
 83a:	1101                	addi	sp,sp,-32
 83c:	ce22                	sw	s0,28(sp)
 83e:	1000                	addi	s0,sp,32
 840:	6785                	lui	a5,0x1
 842:	05500713          	li	a4,85
 846:	9ce78823          	sb	a4,-1584(a5) # 9d0 <g_authenticated>
 84a:	6785                	lui	a5,0x1
 84c:	470d                	li	a4,3
 84e:	9ce788a3          	sb	a4,-1583(a5) # 9d1 <g_ptc>
 852:	6785                	lui	a5,0x1
 854:	9c078923          	sb	zero,-1582(a5) # 9d2 <g_countermeasure>
 858:	fe042623          	sw	zero,-20(s0)
 85c:	a02d                	j	886 <initialize+0x4c>
 85e:	fec42783          	lw	a5,-20(s0)
 862:	0ff7f793          	zext.b	a5,a5
 866:	0785                	addi	a5,a5,1
 868:	0ff7f713          	zext.b	a4,a5
 86c:	6785                	lui	a5,0x1
 86e:	9d878693          	addi	a3,a5,-1576 # 9d8 <g_cardPin>
 872:	fec42783          	lw	a5,-20(s0)
 876:	97b6                	add	a5,a5,a3
 878:	00e78023          	sb	a4,0(a5)
 87c:	fec42783          	lw	a5,-20(s0)
 880:	0785                	addi	a5,a5,1
 882:	fef42623          	sw	a5,-20(s0)
 886:	fec42703          	lw	a4,-20(s0)
 88a:	478d                	li	a5,3
 88c:	fce7d9e3          	bge	a5,a4,85e <initialize+0x24>
 890:	fe042623          	sw	zero,-20(s0)
 894:	a02d                	j	8be <initialize+0x84>
 896:	fec42783          	lw	a5,-20(s0)
 89a:	0ff7f793          	zext.b	a5,a5
 89e:	0785                	addi	a5,a5,1
 8a0:	0ff7f713          	zext.b	a4,a5
 8a4:	6785                	lui	a5,0x1
 8a6:	9d478693          	addi	a3,a5,-1580 # 9d4 <g_userPin>
 8aa:	fec42783          	lw	a5,-20(s0)
 8ae:	97b6                	add	a5,a5,a3
 8b0:	00e78023          	sb	a4,0(a5)
 8b4:	fec42783          	lw	a5,-20(s0)
 8b8:	0785                	addi	a5,a5,1
 8ba:	fef42623          	sw	a5,-20(s0)
 8be:	fec42703          	lw	a4,-20(s0)
 8c2:	478d                	li	a5,3
 8c4:	fce7d9e3          	bge	a5,a4,896 <initialize+0x5c>
 8c8:	6785                	lui	a5,0x1
 8ca:	9d878793          	addi	a5,a5,-1576 # 9d8 <g_cardPin>
 8ce:	0037c703          	lbu	a4,3(a5)
 8d2:	6785                	lui	a5,0x1
 8d4:	9d478793          	addi	a5,a5,-1580 # 9d4 <g_userPin>
 8d8:	00e781a3          	sb	a4,3(a5)
 8dc:	0001                	nop
 8de:	4472                	lw	s0,28(sp)
 8e0:	6105                	addi	sp,sp,32
 8e2:	8082                	ret

000008e4 <oracle_auth>:
 8e4:	1141                	addi	sp,sp,-16
 8e6:	c622                	sw	s0,12(sp)
 8e8:	0800                	addi	s0,sp,16
 8ea:	6785                	lui	a5,0x1
 8ec:	9d27c703          	lbu	a4,-1582(a5) # 9d2 <g_countermeasure>
 8f0:	4785                	li	a5,1
 8f2:	00f70b63          	beq	a4,a5,908 <oracle_auth+0x24>
 8f6:	6785                	lui	a5,0x1
 8f8:	9d07c703          	lbu	a4,-1584(a5) # 9d0 <g_authenticated>
 8fc:	0aa00793          	li	a5,170
 900:	00f71463          	bne	a4,a5,908 <oracle_auth+0x24>
 904:	4785                	li	a5,1
 906:	a011                	j	90a <oracle_auth+0x26>
 908:	4781                	li	a5,0
 90a:	0ff7f793          	zext.b	a5,a5
 90e:	853e                	mv	a0,a5
 910:	4432                	lw	s0,12(sp)
 912:	0141                	addi	sp,sp,16
 914:	8082                	ret

00000916 <oracle_ptc>:
 916:	1141                	addi	sp,sp,-16
 918:	c622                	sw	s0,12(sp)
 91a:	0800                	addi	s0,sp,16
 91c:	6785                	lui	a5,0x1
 91e:	9d27c703          	lbu	a4,-1582(a5) # 9d2 <g_countermeasure>
 922:	4785                	li	a5,1
 924:	00f70a63          	beq	a4,a5,938 <oracle_ptc+0x22>
 928:	6785                	lui	a5,0x1
 92a:	9d178703          	lb	a4,-1583(a5) # 9d1 <g_ptc>
 92e:	4789                	li	a5,2
 930:	00e7d463          	bge	a5,a4,938 <oracle_ptc+0x22>
 934:	4785                	li	a5,1
 936:	a011                	j	93a <oracle_ptc+0x24>
 938:	4781                	li	a5,0
 93a:	0ff7f793          	zext.b	a5,a5
 93e:	853e                	mv	a0,a5
 940:	4432                	lw	s0,12(sp)
 942:	0141                	addi	sp,sp,16
 944:	8082                	ret

00000946 <runbench>:
 946:	1101                	addi	sp,sp,-32
 948:	ce06                	sw	ra,28(sp)
 94a:	cc22                	sw	s0,24(sp)
 94c:	1000                	addi	s0,sp,32
 94e:	35f5                	jal	83a <initialize>
 950:	3229                	jal	25a <trigger_high>
 952:	3d2d                	jal	78c <verifyPIN>
 954:	87aa                	mv	a5,a0
 956:	fef407a3          	sb	a5,-17(s0)
 95a:	fef44783          	lbu	a5,-17(s0)
 95e:	873e                	mv	a4,a5
 960:	3a09                	jal	272 <trigger_low>
 962:	0001                	nop
 964:	40f2                	lw	ra,28(sp)
 966:	4462                	lw	s0,24(sp)
 968:	6105                	addi	sp,sp,32
 96a:	8082                	ret

0000096c <main>:
 96c:	1141                	addi	sp,sp,-16
 96e:	c606                	sw	ra,12(sp)
 970:	c422                	sw	s0,8(sp)
 972:	0800                	addi	s0,sp,16
 974:	fb4ff0ef          	jal	ra,128 <platform_init>
 978:	37f9                	jal	946 <runbench>
 97a:	4781                	li	a5,0
 97c:	853e                	mv	a0,a5
 97e:	40b2                	lw	ra,12(sp)
 980:	4422                	lw	s0,8(sp)
 982:	0141                	addi	sp,sp,16
 984:	8082                	ret
	...
