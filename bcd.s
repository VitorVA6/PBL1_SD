.global _start
_start:
	
	ldr r1, =value
	ldr r1, [r1]
	
subBCD:
	mov r2, #1
	mov r0, #0
	mov r6, #0
	mov r8, #0
	mov r7, #8
	
subBCDb:
	and r3, r1, #0x0000000f
	and r4, r2, #0x0000000f
	
	sub r3, r3, r4
	sub r3, r3, r6
	
	mov r6, #0
	
	cmp r3, #0
	bge subBCD_NoOverFlow
	sub r3, r3, #6
	and r3, r3, #0x0000000f
	mov r6, #1
	
subBCD_NoOverFlow:
	orr r0, r0, r3, lsl r8
	mov r1, r1, lsr #4
	mov r2, r2, lsr #4
	
	add r8, r8, #4
	
	subs r7, r7, #1
	bne subBCDb
	
	mov r1, r0
	mov r10, r1 
	cmp r1, #0
	beq end
	ldr r11, =delay
	ldr r11, [r11]
atraso:
	subs r11, #1
	bne atraso
	b subBCD

end:
	
.data
	value: .word 0x2220
	delay: .word 0xfffff