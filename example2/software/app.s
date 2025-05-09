
testcase_app.elf:     file format elf32-littleriscv


Disassembly of section .text:

00100000 <_vectors_start>:
  100000:	0840006f          	j	100084 <_vectors_end>
  100004:	0800006f          	j	100084 <_vectors_end>
  100008:	07c0006f          	j	100084 <_vectors_end>
  10000c:	0780006f          	j	100084 <_vectors_end>
  100010:	0740006f          	j	100084 <_vectors_end>
  100014:	0700006f          	j	100084 <_vectors_end>
  100018:	06c0006f          	j	100084 <_vectors_end>
  10001c:	0680006f          	j	100084 <_vectors_end>
  100020:	0640006f          	j	100084 <_vectors_end>
  100024:	0600006f          	j	100084 <_vectors_end>
  100028:	05c0006f          	j	100084 <_vectors_end>
  10002c:	0580006f          	j	100084 <_vectors_end>
  100030:	0540006f          	j	100084 <_vectors_end>
  100034:	0500006f          	j	100084 <_vectors_end>
  100038:	04c0006f          	j	100084 <_vectors_end>
  10003c:	0480006f          	j	100084 <_vectors_end>
  100040:	0440006f          	j	100084 <_vectors_end>
  100044:	0400006f          	j	100084 <_vectors_end>
  100048:	03c0006f          	j	100084 <_vectors_end>
  10004c:	0380006f          	j	100084 <_vectors_end>
  100050:	0340006f          	j	100084 <_vectors_end>
  100054:	0300006f          	j	100084 <_vectors_end>
  100058:	02c0006f          	j	100084 <_vectors_end>
  10005c:	0280006f          	j	100084 <_vectors_end>
  100060:	0240006f          	j	100084 <_vectors_end>
  100064:	0200006f          	j	100084 <_vectors_end>
  100068:	01c0006f          	j	100084 <_vectors_end>
  10006c:	0180006f          	j	100084 <_vectors_end>
  100070:	0140006f          	j	100084 <_vectors_end>
  100074:	0100006f          	j	100084 <_vectors_end>
  100078:	00c0006f          	j	100084 <_vectors_end>
  10007c:	0080006f          	j	100084 <_vectors_end>
  100080:	0080006f          	j	100088 <reset_handler>

00100084 <_vectors_end>:
  100084:	20a0006f          	j	10028e <simple_exc_handler>

00100088 <reset_handler>:
  100088:	00000093          	li	ra,0
  10008c:	8106                	mv	sp,ra
  10008e:	8186                	mv	gp,ra
  100090:	8206                	mv	tp,ra
  100092:	8286                	mv	t0,ra
  100094:	8306                	mv	t1,ra
  100096:	8386                	mv	t2,ra
  100098:	8406                	mv	s0,ra
  10009a:	8486                	mv	s1,ra
  10009c:	8506                	mv	a0,ra
  10009e:	8586                	mv	a1,ra
  1000a0:	8606                	mv	a2,ra
  1000a2:	8686                	mv	a3,ra
  1000a4:	8706                	mv	a4,ra
  1000a6:	8786                	mv	a5,ra
  1000a8:	8806                	mv	a6,ra
  1000aa:	8886                	mv	a7,ra
  1000ac:	8906                	mv	s2,ra
  1000ae:	8986                	mv	s3,ra
  1000b0:	8a06                	mv	s4,ra
  1000b2:	8a86                	mv	s5,ra
  1000b4:	8b06                	mv	s6,ra
  1000b6:	8b86                	mv	s7,ra
  1000b8:	8c06                	mv	s8,ra
  1000ba:	8c86                	mv	s9,ra
  1000bc:	8d06                	mv	s10,ra
  1000be:	8d86                	mv	s11,ra
  1000c0:	8e06                	mv	t3,ra
  1000c2:	8e86                	mv	t4,ra
  1000c4:	8f06                	mv	t5,ra
  1000c6:	8f86                	mv	t6,ra
  1000c8:	00010117          	auipc	sp,0x10
  1000cc:	f3810113          	addi	sp,sp,-200 # 110000 <_stack_start>

001000d0 <_start>:
  1000d0:	00000d17          	auipc	s10,0x0
  1000d4:	53cd0d13          	addi	s10,s10,1340 # 10060c <_bss_end>
  1000d8:	00000d97          	auipc	s11,0x0
  1000dc:	534d8d93          	addi	s11,s11,1332 # 10060c <_bss_end>
  1000e0:	01bd5763          	bge	s10,s11,1000ee <main_entry>

001000e4 <zero_loop>:
  1000e4:	000d2023          	sw	zero,0(s10)
  1000e8:	0d11                	addi	s10,s10,4
  1000ea:	ffaddde3          	bge	s11,s10,1000e4 <zero_loop>

001000ee <main_entry>:
  1000ee:	4501                	li	a0,0
  1000f0:	4581                	li	a1,0
  1000f2:	4dc000ef          	jal	ra,1005ce <main>

001000f6 <sleep_loop>:
  1000f6:	10500073          	wfi
  1000fa:	bff5                	j	1000f6 <sleep_loop>

001000fc <get_mepc>:
  1000fc:	1101                	addi	sp,sp,-32
  1000fe:	ce22                	sw	s0,28(sp)
  100100:	1000                	addi	s0,sp,32
  100102:	341027f3          	csrr	a5,mepc
  100106:	fef42623          	sw	a5,-20(s0)
  10010a:	fec42783          	lw	a5,-20(s0)
  10010e:	853e                	mv	a0,a5
  100110:	4472                	lw	s0,28(sp)
  100112:	6105                	addi	sp,sp,32
  100114:	8082                	ret

00100116 <get_mcause>:
  100116:	1101                	addi	sp,sp,-32
  100118:	ce22                	sw	s0,28(sp)
  10011a:	1000                	addi	s0,sp,32
  10011c:	342027f3          	csrr	a5,mcause
  100120:	fef42623          	sw	a5,-20(s0)
  100124:	fec42783          	lw	a5,-20(s0)
  100128:	853e                	mv	a0,a5
  10012a:	4472                	lw	s0,28(sp)
  10012c:	6105                	addi	sp,sp,32
  10012e:	8082                	ret

00100130 <get_mtval>:
  100130:	1101                	addi	sp,sp,-32
  100132:	ce22                	sw	s0,28(sp)
  100134:	1000                	addi	s0,sp,32
  100136:	343027f3          	csrr	a5,mtval
  10013a:	fef42623          	sw	a5,-20(s0)
  10013e:	fec42783          	lw	a5,-20(s0)
  100142:	853e                	mv	a0,a5
  100144:	4472                	lw	s0,28(sp)
  100146:	6105                	addi	sp,sp,32
  100148:	8082                	ret

0010014a <get_mcycle>:
  10014a:	1101                	addi	sp,sp,-32
  10014c:	ce22                	sw	s0,28(sp)
  10014e:	1000                	addi	s0,sp,32
  100150:	b00027f3          	csrr	a5,mcycle
  100154:	fef42623          	sw	a5,-20(s0)
  100158:	fec42783          	lw	a5,-20(s0)
  10015c:	853e                	mv	a0,a5
  10015e:	4472                	lw	s0,28(sp)
  100160:	6105                	addi	sp,sp,32
  100162:	8082                	ret

00100164 <reset_mcycle>:
  100164:	1141                	addi	sp,sp,-16
  100166:	c622                	sw	s0,12(sp)
  100168:	0800                	addi	s0,sp,16
  10016a:	b0001073          	csrw	mcycle,zero
  10016e:	0001                	nop
  100170:	4432                	lw	s0,12(sp)
  100172:	0141                	addi	sp,sp,16
  100174:	8082                	ret

00100176 <install_exception_handler>:
  100176:	7179                	addi	sp,sp,-48
  100178:	d622                	sw	s0,44(sp)
  10017a:	1800                	addi	s0,sp,48
  10017c:	fca42e23          	sw	a0,-36(s0)
  100180:	fcb42c23          	sw	a1,-40(s0)
  100184:	fdc42703          	lw	a4,-36(s0)
  100188:	47fd                	li	a5,31
  10018a:	00e7f463          	bgeu	a5,a4,100192 <install_exception_handler+0x1c>
  10018e:	4785                	li	a5,1
  100190:	a871                	j	10022c <install_exception_handler+0xb6>
  100192:	001007b7          	lui	a5,0x100
  100196:	5e87a703          	lw	a4,1512(a5) # 1005e8 <exc_vectors>
  10019a:	fdc42783          	lw	a5,-36(s0)
  10019e:	078a                	slli	a5,a5,0x2
  1001a0:	97ba                	add	a5,a5,a4
  1001a2:	fef42623          	sw	a5,-20(s0)
  1001a6:	fd842703          	lw	a4,-40(s0)
  1001aa:	fec42783          	lw	a5,-20(s0)
  1001ae:	40f707b3          	sub	a5,a4,a5
  1001b2:	fef42423          	sw	a5,-24(s0)
  1001b6:	fe842703          	lw	a4,-24(s0)
  1001ba:	000807b7          	lui	a5,0x80
  1001be:	00f75863          	bge	a4,a5,1001ce <install_exception_handler+0x58>
  1001c2:	fe842703          	lw	a4,-24(s0)
  1001c6:	fff807b7          	lui	a5,0xfff80
  1001ca:	00f75463          	bge	a4,a5,1001d2 <install_exception_handler+0x5c>
  1001ce:	4789                	li	a5,2
  1001d0:	a8b1                	j	10022c <install_exception_handler+0xb6>
  1001d2:	fe842783          	lw	a5,-24(s0)
  1001d6:	fef42223          	sw	a5,-28(s0)
  1001da:	fe442783          	lw	a5,-28(s0)
  1001de:	01479713          	slli	a4,a5,0x14
  1001e2:	7fe007b7          	lui	a5,0x7fe00
  1001e6:	8f7d                	and	a4,a4,a5
  1001e8:	fe442783          	lw	a5,-28(s0)
  1001ec:	00979693          	slli	a3,a5,0x9
  1001f0:	001007b7          	lui	a5,0x100
  1001f4:	8ff5                	and	a5,a5,a3
  1001f6:	8f5d                	or	a4,a4,a5
  1001f8:	fe442683          	lw	a3,-28(s0)
  1001fc:	000ff7b7          	lui	a5,0xff
  100200:	8ff5                	and	a5,a5,a3
  100202:	8f5d                	or	a4,a4,a5
  100204:	fe442783          	lw	a5,-28(s0)
  100208:	00b79693          	slli	a3,a5,0xb
  10020c:	800007b7          	lui	a5,0x80000
  100210:	8ff5                	and	a5,a5,a3
  100212:	8fd9                	or	a5,a5,a4
  100214:	06f7e793          	ori	a5,a5,111
  100218:	fef42023          	sw	a5,-32(s0)
  10021c:	fec42783          	lw	a5,-20(s0)
  100220:	fe042703          	lw	a4,-32(s0)
  100224:	c398                	sw	a4,0(a5)
  100226:	0000100f          	fence.i
  10022a:	4781                	li	a5,0
  10022c:	853e                	mv	a0,a5
  10022e:	5432                	lw	s0,44(sp)
  100230:	6145                	addi	sp,sp,48
  100232:	8082                	ret

00100234 <enable_interrupts>:
  100234:	1101                	addi	sp,sp,-32
  100236:	ce22                	sw	s0,28(sp)
  100238:	1000                	addi	s0,sp,32
  10023a:	fea42623          	sw	a0,-20(s0)
  10023e:	fec42783          	lw	a5,-20(s0)
  100242:	3047a073          	csrs	mie,a5
  100246:	0001                	nop
  100248:	4472                	lw	s0,28(sp)
  10024a:	6105                	addi	sp,sp,32
  10024c:	8082                	ret

0010024e <disable_interrupts>:
  10024e:	1101                	addi	sp,sp,-32
  100250:	ce22                	sw	s0,28(sp)
  100252:	1000                	addi	s0,sp,32
  100254:	fea42623          	sw	a0,-20(s0)
  100258:	fec42783          	lw	a5,-20(s0)
  10025c:	3047b073          	csrc	mie,a5
  100260:	0001                	nop
  100262:	4472                	lw	s0,28(sp)
  100264:	6105                	addi	sp,sp,32
  100266:	8082                	ret

00100268 <set_global_interrupt_enable>:
  100268:	1101                	addi	sp,sp,-32
  10026a:	ce22                	sw	s0,28(sp)
  10026c:	1000                	addi	s0,sp,32
  10026e:	fea42623          	sw	a0,-20(s0)
  100272:	fec42783          	lw	a5,-20(s0)
  100276:	c789                	beqz	a5,100280 <set_global_interrupt_enable+0x18>
  100278:	47a1                	li	a5,8
  10027a:	3007a073          	csrs	mstatus,a5
  10027e:	a021                	j	100286 <set_global_interrupt_enable+0x1e>
  100280:	47a1                	li	a5,8
  100282:	3007b073          	csrc	mstatus,a5
  100286:	0001                	nop
  100288:	4472                	lw	s0,28(sp)
  10028a:	6105                	addi	sp,sp,32
  10028c:	8082                	ret

0010028e <simple_exc_handler>:
  10028e:	1141                	addi	sp,sp,-16
  100290:	c622                	sw	s0,12(sp)
  100292:	0800                	addi	s0,sp,16
  100294:	a001                	j	100294 <simple_exc_handler+0x6>

00100296 <uart_enable_rx_int>:
  100296:	1141                	addi	sp,sp,-16
  100298:	c606                	sw	ra,12(sp)
  10029a:	c422                	sw	s0,8(sp)
  10029c:	0800                	addi	s0,sp,16
  10029e:	6541                	lui	a0,0x10
  1002a0:	3f51                	jal	100234 <enable_interrupts>
  1002a2:	4505                	li	a0,1
  1002a4:	37d1                	jal	100268 <set_global_interrupt_enable>
  1002a6:	0001                	nop
  1002a8:	40b2                	lw	ra,12(sp)
  1002aa:	4422                	lw	s0,8(sp)
  1002ac:	0141                	addi	sp,sp,16
  1002ae:	8082                	ret

001002b0 <uart_in>:
  1002b0:	7179                	addi	sp,sp,-48
  1002b2:	d622                	sw	s0,44(sp)
  1002b4:	1800                	addi	s0,sp,48
  1002b6:	fca42e23          	sw	a0,-36(s0)
  1002ba:	57fd                	li	a5,-1
  1002bc:	fef42623          	sw	a5,-20(s0)
  1002c0:	fdc42783          	lw	a5,-36(s0)
  1002c4:	07a1                	addi	a5,a5,8 # 80000008 <_stack_start+0x7fef0008>
  1002c6:	439c                	lw	a5,0(a5)
  1002c8:	8b85                	andi	a5,a5,1
  1002ca:	e791                	bnez	a5,1002d6 <uart_in+0x26>
  1002cc:	fdc42783          	lw	a5,-36(s0)
  1002d0:	439c                	lw	a5,0(a5)
  1002d2:	fef42623          	sw	a5,-20(s0)
  1002d6:	fec42783          	lw	a5,-20(s0)
  1002da:	853e                	mv	a0,a5
  1002dc:	5432                	lw	s0,44(sp)
  1002de:	6145                	addi	sp,sp,48
  1002e0:	8082                	ret

001002e2 <uart_out>:
  1002e2:	1101                	addi	sp,sp,-32
  1002e4:	ce22                	sw	s0,28(sp)
  1002e6:	1000                	addi	s0,sp,32
  1002e8:	fea42623          	sw	a0,-20(s0)
  1002ec:	87ae                	mv	a5,a1
  1002ee:	fef405a3          	sb	a5,-21(s0)
  1002f2:	0001                	nop
  1002f4:	fec42783          	lw	a5,-20(s0)
  1002f8:	07a1                	addi	a5,a5,8
  1002fa:	439c                	lw	a5,0(a5)
  1002fc:	8b89                	andi	a5,a5,2
  1002fe:	fbfd                	bnez	a5,1002f4 <uart_out+0x12>
  100300:	fec42783          	lw	a5,-20(s0)
  100304:	0791                	addi	a5,a5,4
  100306:	feb44703          	lbu	a4,-21(s0)
  10030a:	c398                	sw	a4,0(a5)
  10030c:	0001                	nop
  10030e:	4472                	lw	s0,28(sp)
  100310:	6105                	addi	sp,sp,32
  100312:	8082                	ret

00100314 <set_outputs>:
  100314:	1101                	addi	sp,sp,-32
  100316:	ce22                	sw	s0,28(sp)
  100318:	1000                	addi	s0,sp,32
  10031a:	fea42623          	sw	a0,-20(s0)
  10031e:	feb42423          	sw	a1,-24(s0)
  100322:	fec42783          	lw	a5,-20(s0)
  100326:	fe842703          	lw	a4,-24(s0)
  10032a:	c398                	sw	a4,0(a5)
  10032c:	0001                	nop
  10032e:	4472                	lw	s0,28(sp)
  100330:	6105                	addi	sp,sp,32
  100332:	8082                	ret

00100334 <read_gpio>:
  100334:	1101                	addi	sp,sp,-32
  100336:	ce22                	sw	s0,28(sp)
  100338:	1000                	addi	s0,sp,32
  10033a:	fea42623          	sw	a0,-20(s0)
  10033e:	fec42783          	lw	a5,-20(s0)
  100342:	439c                	lw	a5,0(a5)
  100344:	853e                	mv	a0,a5
  100346:	4472                	lw	s0,28(sp)
  100348:	6105                	addi	sp,sp,32
  10034a:	8082                	ret

0010034c <set_output_bit>:
  10034c:	7179                	addi	sp,sp,-48
  10034e:	d606                	sw	ra,44(sp)
  100350:	d422                	sw	s0,40(sp)
  100352:	1800                	addi	s0,sp,48
  100354:	fca42e23          	sw	a0,-36(s0)
  100358:	fcb42c23          	sw	a1,-40(s0)
  10035c:	fcc42a23          	sw	a2,-44(s0)
  100360:	fd442783          	lw	a5,-44(s0)
  100364:	8b85                	andi	a5,a5,1
  100366:	fcf42a23          	sw	a5,-44(s0)
  10036a:	fdc42503          	lw	a0,-36(s0)
  10036e:	37d9                	jal	100334 <read_gpio>
  100370:	fea42623          	sw	a0,-20(s0)
  100374:	fd842783          	lw	a5,-40(s0)
  100378:	4705                	li	a4,1
  10037a:	00f717b3          	sll	a5,a4,a5
  10037e:	fff7c793          	not	a5,a5
  100382:	873e                	mv	a4,a5
  100384:	fec42783          	lw	a5,-20(s0)
  100388:	8ff9                	and	a5,a5,a4
  10038a:	fef42623          	sw	a5,-20(s0)
  10038e:	fd842783          	lw	a5,-40(s0)
  100392:	fd442703          	lw	a4,-44(s0)
  100396:	00f717b3          	sll	a5,a4,a5
  10039a:	fec42703          	lw	a4,-20(s0)
  10039e:	8fd9                	or	a5,a5,a4
  1003a0:	fef42623          	sw	a5,-20(s0)
  1003a4:	fec42583          	lw	a1,-20(s0)
  1003a8:	fdc42503          	lw	a0,-36(s0)
  1003ac:	37a5                	jal	100314 <set_outputs>
  1003ae:	0001                	nop
  1003b0:	50b2                	lw	ra,44(sp)
  1003b2:	5422                	lw	s0,40(sp)
  1003b4:	6145                	addi	sp,sp,48
  1003b6:	8082                	ret

001003b8 <get_output_bit>:
  1003b8:	7179                	addi	sp,sp,-48
  1003ba:	d606                	sw	ra,44(sp)
  1003bc:	d422                	sw	s0,40(sp)
  1003be:	1800                	addi	s0,sp,48
  1003c0:	fca42e23          	sw	a0,-36(s0)
  1003c4:	fcb42c23          	sw	a1,-40(s0)
  1003c8:	fdc42503          	lw	a0,-36(s0)
  1003cc:	37a5                	jal	100334 <read_gpio>
  1003ce:	fea42623          	sw	a0,-20(s0)
  1003d2:	fd842783          	lw	a5,-40(s0)
  1003d6:	fec42703          	lw	a4,-20(s0)
  1003da:	00f757b3          	srl	a5,a4,a5
  1003de:	fef42623          	sw	a5,-20(s0)
  1003e2:	fec42783          	lw	a5,-20(s0)
  1003e6:	8b85                	andi	a5,a5,1
  1003e8:	fef42623          	sw	a5,-20(s0)
  1003ec:	fec42783          	lw	a5,-20(s0)
  1003f0:	853e                	mv	a0,a5
  1003f2:	50b2                	lw	ra,44(sp)
  1003f4:	5422                	lw	s0,40(sp)
  1003f6:	6145                	addi	sp,sp,48
  1003f8:	8082                	ret

001003fa <platform_init>:
  1003fa:	1141                	addi	sp,sp,-16
  1003fc:	c622                	sw	s0,12(sp)
  1003fe:	0800                	addi	s0,sp,16
  100400:	0001                	nop
  100402:	4432                	lw	s0,12(sp)
  100404:	0141                	addi	sp,sp,16
  100406:	8082                	ret

00100408 <ledon>:
  100408:	1101                	addi	sp,sp,-32
  10040a:	ce22                	sw	s0,28(sp)
  10040c:	1000                	addi	s0,sp,32
  10040e:	87aa                	mv	a5,a0
  100410:	fef407a3          	sb	a5,-17(s0)
  100414:	0001                	nop
  100416:	4472                	lw	s0,28(sp)
  100418:	6105                	addi	sp,sp,32
  10041a:	8082                	ret

0010041c <ledoff>:
  10041c:	1101                	addi	sp,sp,-32
  10041e:	ce22                	sw	s0,28(sp)
  100420:	1000                	addi	s0,sp,32
  100422:	87aa                	mv	a5,a0
  100424:	fef407a3          	sb	a5,-17(s0)
  100428:	0001                	nop
  10042a:	4472                	lw	s0,28(sp)
  10042c:	6105                	addi	sp,sp,32
  10042e:	8082                	ret

00100430 <getch>:
  100430:	1101                	addi	sp,sp,-32
  100432:	ce06                	sw	ra,28(sp)
  100434:	cc22                	sw	s0,24(sp)
  100436:	1000                	addi	s0,sp,32
  100438:	80001537          	lui	a0,0x80001
  10043c:	3d95                	jal	1002b0 <uart_in>
  10043e:	fea42623          	sw	a0,-20(s0)
  100442:	fec42783          	lw	a5,-20(s0)
  100446:	0ff7f793          	zext.b	a5,a5
  10044a:	853e                	mv	a0,a5
  10044c:	40f2                	lw	ra,28(sp)
  10044e:	4462                	lw	s0,24(sp)
  100450:	6105                	addi	sp,sp,32
  100452:	8082                	ret

00100454 <putch>:
  100454:	1101                	addi	sp,sp,-32
  100456:	ce06                	sw	ra,28(sp)
  100458:	cc22                	sw	s0,24(sp)
  10045a:	1000                	addi	s0,sp,32
  10045c:	87aa                	mv	a5,a0
  10045e:	fef407a3          	sb	a5,-17(s0)
  100462:	fef44703          	lbu	a4,-17(s0)
  100466:	47a9                	li	a5,10
  100468:	00f71663          	bne	a4,a5,100474 <putch+0x20>
  10046c:	45b5                	li	a1,13
  10046e:	80001537          	lui	a0,0x80001
  100472:	3d85                	jal	1002e2 <uart_out>
  100474:	45b5                	li	a1,13
  100476:	80001537          	lui	a0,0x80001
  10047a:	35a5                	jal	1002e2 <uart_out>
  10047c:	0001                	nop
  10047e:	40f2                	lw	ra,28(sp)
  100480:	4462                	lw	s0,24(sp)
  100482:	6105                	addi	sp,sp,32
  100484:	8082                	ret

00100486 <trigger_high>:
  100486:	1141                	addi	sp,sp,-16
  100488:	c606                	sw	ra,12(sp)
  10048a:	c422                	sw	s0,8(sp)
  10048c:	0800                	addi	s0,sp,16
  10048e:	4605                	li	a2,1
  100490:	4589                	li	a1,2
  100492:	80000537          	lui	a0,0x80000
  100496:	3d5d                	jal	10034c <set_output_bit>
  100498:	0001                	nop
  10049a:	40b2                	lw	ra,12(sp)
  10049c:	4422                	lw	s0,8(sp)
  10049e:	0141                	addi	sp,sp,16
  1004a0:	8082                	ret

001004a2 <trigger_low>:
  1004a2:	1141                	addi	sp,sp,-16
  1004a4:	c606                	sw	ra,12(sp)
  1004a6:	c422                	sw	s0,8(sp)
  1004a8:	0800                	addi	s0,sp,16
  1004aa:	4601                	li	a2,0
  1004ac:	4589                	li	a1,2
  1004ae:	80000537          	lui	a0,0x80000
  1004b2:	3d69                	jal	10034c <set_output_bit>
  1004b4:	0001                	nop
  1004b6:	40b2                	lw	ra,12(sp)
  1004b8:	4422                	lw	s0,8(sp)
  1004ba:	0141                	addi	sp,sp,16
  1004bc:	8082                	ret

001004be <flashio>:
  1004be:	1101                	addi	sp,sp,-32
  1004c0:	ce22                	sw	s0,28(sp)
  1004c2:	1000                	addi	s0,sp,32
  1004c4:	fea42623          	sw	a0,-20(s0)
  1004c8:	feb42423          	sw	a1,-24(s0)
  1004cc:	87b2                	mv	a5,a2
  1004ce:	fef403a3          	sb	a5,-25(s0)
  1004d2:	0001                	nop
  1004d4:	4472                	lw	s0,28(sp)
  1004d6:	6105                	addi	sp,sp,32
  1004d8:	8082                	ret

001004da <set_flash_qspi_flag>:
  1004da:	1141                	addi	sp,sp,-16
  1004dc:	c622                	sw	s0,12(sp)
  1004de:	0800                	addi	s0,sp,16
  1004e0:	0001                	nop
  1004e2:	4432                	lw	s0,12(sp)
  1004e4:	0141                	addi	sp,sp,16
  1004e6:	8082                	ret

001004e8 <set_flash_mode_spi>:
  1004e8:	1141                	addi	sp,sp,-16
  1004ea:	c622                	sw	s0,12(sp)
  1004ec:	0800                	addi	s0,sp,16
  1004ee:	0001                	nop
  1004f0:	4432                	lw	s0,12(sp)
  1004f2:	0141                	addi	sp,sp,16
  1004f4:	8082                	ret

001004f6 <set_flash_mode_dual>:
  1004f6:	1141                	addi	sp,sp,-16
  1004f8:	c622                	sw	s0,12(sp)
  1004fa:	0800                	addi	s0,sp,16
  1004fc:	0001                	nop
  1004fe:	4432                	lw	s0,12(sp)
  100500:	0141                	addi	sp,sp,16
  100502:	8082                	ret

00100504 <set_flash_mode_quad>:
  100504:	1141                	addi	sp,sp,-16
  100506:	c622                	sw	s0,12(sp)
  100508:	0800                	addi	s0,sp,16
  10050a:	0001                	nop
  10050c:	4432                	lw	s0,12(sp)
  10050e:	0141                	addi	sp,sp,16
  100510:	8082                	ret

00100512 <set_flash_mode_qddr>:
  100512:	1141                	addi	sp,sp,-16
  100514:	c622                	sw	s0,12(sp)
  100516:	0800                	addi	s0,sp,16
  100518:	0001                	nop
  10051a:	4432                	lw	s0,12(sp)
  10051c:	0141                	addi	sp,sp,16
  10051e:	8082                	ret

00100520 <enable_flash_crm>:
  100520:	1141                	addi	sp,sp,-16
  100522:	c622                	sw	s0,12(sp)
  100524:	0800                	addi	s0,sp,16
  100526:	0001                	nop
  100528:	4432                	lw	s0,12(sp)
  10052a:	0141                	addi	sp,sp,16
  10052c:	8082                	ret

0010052e <configure_ro_max>:
  10052e:	1141                	addi	sp,sp,-16
  100530:	c622                	sw	s0,12(sp)
  100532:	0800                	addi	s0,sp,16
  100534:	0001                	nop
  100536:	4432                	lw	s0,12(sp)
  100538:	0141                	addi	sp,sp,16
  10053a:	8082                	ret

0010053c <configure_ro_min>:
  10053c:	1141                	addi	sp,sp,-16
  10053e:	c622                	sw	s0,12(sp)
  100540:	0800                	addi	s0,sp,16
  100542:	0001                	nop
  100544:	4432                	lw	s0,12(sp)
  100546:	0141                	addi	sp,sp,16
  100548:	8082                	ret

0010054a <enable_ro_config>:
  10054a:	1101                	addi	sp,sp,-32
  10054c:	ce22                	sw	s0,28(sp)
  10054e:	1000                	addi	s0,sp,32
  100550:	87aa                	mv	a5,a0
  100552:	fef407a3          	sb	a5,-17(s0)
  100556:	0001                	nop
  100558:	4472                	lw	s0,28(sp)
  10055a:	6105                	addi	sp,sp,32
  10055c:	8082                	ret

0010055e <enable_ro>:
  10055e:	1141                	addi	sp,sp,-16
  100560:	c622                	sw	s0,12(sp)
  100562:	0800                	addi	s0,sp,16
  100564:	0001                	nop
  100566:	4432                	lw	s0,12(sp)
  100568:	0141                	addi	sp,sp,16
  10056a:	8082                	ret

0010056c <disable_ro>:
  10056c:	1141                	addi	sp,sp,-16
  10056e:	c622                	sw	s0,12(sp)
  100570:	0800                	addi	s0,sp,16
  100572:	0001                	nop
  100574:	4432                	lw	s0,12(sp)
  100576:	0141                	addi	sp,sp,16
  100578:	8082                	ret

0010057a <error_handler>:
  10057a:	1101                	addi	sp,sp,-32
  10057c:	ce06                	sw	ra,28(sp)
  10057e:	cc22                	sw	s0,24(sp)
  100580:	1000                	addi	s0,sp,32
  100582:	4795                	li	a5,5
  100584:	fef42623          	sw	a5,-20(s0)
  100588:	a031                	j	100594 <error_handler+0x1a>
  10058a:	fec42783          	lw	a5,-20(s0)
  10058e:	17fd                	addi	a5,a5,-1
  100590:	fef42623          	sw	a5,-20(s0)
  100594:	fec42783          	lw	a5,-20(s0)
  100598:	fef049e3          	bgtz	a5,10058a <error_handler+0x10>
  10059c:	3719                	jal	1004a2 <trigger_low>
  10059e:	0001                	nop
  1005a0:	40f2                	lw	ra,28(sp)
  1005a2:	4462                	lw	s0,24(sp)
  1005a4:	6105                	addi	sp,sp,32
  1005a6:	8082                	ret

001005a8 <runbench>:
  1005a8:	1141                	addi	sp,sp,-16
  1005aa:	c606                	sw	ra,12(sp)
  1005ac:	c422                	sw	s0,8(sp)
  1005ae:	0800                	addi	s0,sp,16
  1005b0:	3dd9                	jal	100486 <trigger_high>
  1005b2:	001007b7          	lui	a5,0x100
  1005b6:	5ec78793          	addi	a5,a5,1516 # 1005ec <pt>
  1005ba:	4390                	lw	a2,0(a5)
  1005bc:	4394                	lw	a3,0(a5)
  1005be:	fad61ee3          	bne	a2,a3,10057a <error_handler>
  1005c2:	35c5                	jal	1004a2 <trigger_low>
  1005c4:	0001                	nop
  1005c6:	40b2                	lw	ra,12(sp)
  1005c8:	4422                	lw	s0,8(sp)
  1005ca:	0141                	addi	sp,sp,16
  1005cc:	8082                	ret

001005ce <main>:
  1005ce:	1141                	addi	sp,sp,-16
  1005d0:	c606                	sw	ra,12(sp)
  1005d2:	c422                	sw	s0,8(sp)
  1005d4:	0800                	addi	s0,sp,16
  1005d6:	3515                	jal	1003fa <platform_init>
  1005d8:	3fc1                	jal	1005a8 <runbench>
  1005da:	35e1                	jal	1004a2 <trigger_low>
  1005dc:	4781                	li	a5,0
  1005de:	853e                	mv	a0,a5
  1005e0:	40b2                	lw	ra,12(sp)
  1005e2:	4422                	lw	s0,8(sp)
  1005e4:	0141                	addi	sp,sp,16
  1005e6:	8082                	ret
