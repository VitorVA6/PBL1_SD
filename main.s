.equ sys_open, 5
.equ sys_map, 192
.equ page_len, 4096
.equ prot_read, 1
.equ prot_write, 2
.equ map_shared, 1
.equ reg_lvl, 52
.equ O_RDWR, 00000002 
.equ O_SYNC, 00010000 
.equ setregoffset, 28
.equ clrregoffset, 40
.equ buttonp, 0x4000000
.equ buttond, 0x20
.equ buttonr, 0x80000

.global _start

.macro setOut pin
        ldr r2, =\pin 
        ldr r2, [r2]
        ldr r1, [r8, r2]
        ldr r3, =\pin 
        add r3, #4
        ldr r3, [r3]
        mov r0, #0b111
        lsl r0, r3
        bic r1, r0 
        mov r0, #1 
        lsl r0, r3 
        orr r1, r0 
        str r1, [r8, r2]
.endm

.macro setLvl pin, lvl
    mov r0, #40
    mov r2, #12
    mov r1, \lvl
    mul r5, r1, r2
    sub r0, r0, r5 
    mov r2, r8
    add r2, r2, r0
    mov r0, #1
    ldr r3, =\pin
    add r3, #8
    ldr r3, [r3]
    lsl r0, r3
    str r0, [r2]
.endm

.macro setLcd lvlrs, lvldb7, lvldb6, lvldb5, lvldb4
    
    setLvl rs, #\lvlrs
    setLvl db7, #\lvldb7
    setLvl db6, #\lvldb6
    setLvl db5, #\lvldb5
    setLvl db4, #\lvldb4
    setLvl e, #0
    delay timespecnano150
    setLvl e, #1
    delay timespecnano150
    setLvl e, #0
    .ltorg
.endm 

.macro timer

    setLvl rs, #1
	mov r9, #1
	and r1, r9, r10
	
    mov r0, #40
    mov r2, #12
    mul r5, r1, r2
    sub r0, r0, r5 
    mov r2, r8
    add r2, r2, r0
    mov r0, #1
    ldr r3, =db4
    add r3, #8
    ldr r3, [r3]
    lsl r0, r3
    str r0, [r2]
	
	lsl r9, #1
	and r1, r9, r10
	lsr r1, #1

	mov r0, #40
    mov r2, #12
    mul r5, r1, r2
    sub r0, r0, r5 
    mov r2, r8
    add r2, r2, r0
    mov r0, #1
    ldr r3, =db5
    add r3, #8
    ldr r3, [r3]
    lsl r0, r3
    str r0, [r2]
	
	lsl r9, #1
	and r1, r9, r10
	lsr r1, #2

	mov r0, #40
    mov r2, #12
    mul r5, r1, r2
    sub r0, r0, r5 
    mov r2, r8
    add r2, r2, r0
    mov r0, #1
    ldr r3, =db6
    add r3, #8
    ldr r3, [r3]
    lsl r0, r3
    str r0, [r2]
	
	lsl r9, #1
	and r1, r9, r10
	lsr r1, #3

	mov r0, #40
    mov r2, #12
    mul r5, r1, r2
    sub r0, r0, r5 
    mov r2, r8
    add r2, r2, r0
    mov r0, #1
    ldr r3, =db7
    add r3, #8
    ldr r3, [r3]
    lsl r0, r3
    str r0, [r2]

    setLvl e, #0
    delay timespecnano150
    setLvl e, #1
    delay timespecnano150
    setLvl e, #0
    
.endm

.macro delay time
    ldr r0, =\time
    ldr r1, =\time
    mov r7, #162
    swi 0
.endm

_start:
    ldr r0, =fileName
    mov r2, #0x1b0
    orr r2, #0x006
    mov r1, r2
    mov r7, #sys_open
    swi 0
    movs r4, r0

    ldr r5, =gpioaddr
    ldr r5, [r5]
    mov r1, #page_len
    mov r2, #(prot_read + prot_write)
    mov r3, #map_shared
    mov r0, #0
    mov r7, #sys_map
    swi 0
    movs r8, r0

mapping_lcd:    
    setOut rs
    setOut e
    setOut db4
    setOut db5
    setOut db6
    setOut db7

init_lcd:
    
    setLcd 0, 0, 0, 1, 1
    delay timespecnano5
    
    setLcd 0, 0, 0, 1, 1    
    
    setLcd 0, 0, 0, 1, 1   
    setLcd 0, 0, 0, 1, 0
 
    setLcd 0, 0, 0, 1, 0   
    setLcd 0, 0, 0, 0, 0
       
    setLcd 0, 0, 0, 0, 0
    setLcd 0, 1, 0, 0, 0

    setLcd 0, 0, 0, 0, 0   
    setLcd 0, 0, 0, 0, 1

    setLcd 0, 0, 0, 0, 0   
    setLcd 0, 0, 1, 1, 0

    setLcd 0, 0, 0, 0, 0
    setLcd 0, 1, 1, 1, 0

    setLcd 0, 0, 0, 0, 0
    setLcd 0, 0, 1, 1, 0

begin:

    setLcd 0, 0, 0, 0, 0  
    delay timespecnano150
    setLcd 0, 0, 0, 0, 1
    delay timespecnano150

    setLcd 1, 0, 1, 0, 1  
    delay timespecnano150
    setLcd 1, 0, 0, 1, 1
    delay timespecnano150

    setLcd 1, 0, 1, 1, 1  
    delay timespecnano150
    setLcd 1, 0, 1, 0, 0
    delay timespecnano150

    setLcd 1, 0, 1, 1, 0 
    delay timespecnano150
    setLcd 1, 0, 0, 0, 1
    delay timespecnano150

    setLcd 1, 0, 1, 1, 1
    delay timespecnano150
    setLcd 1, 0, 0, 1, 0
    delay timespecnano150

    setLcd 1, 0, 1, 1, 1  
    delay timespecnano150
    setLcd 1, 0, 1, 0, 0
    delay timespecnano150

    ldr r11, =value
    ldr r11, [r11]

debounce:
    delay time1s

check:
    ldr r9, [r8, #reg_lvl]
    and r9, r9, #buttonp
    cmp r9, #0
    beq subBCD
    b check
	
subBCD:

    setLcd 0, 0, 0, 0, 0  
    delay timespecnano150
    setLcd 0, 0, 0, 0, 1
    delay timespecnano150

	mov r2, #1
	mov r0, #0
	mov r6, #0
	mov r4, #0
	mov r7, #8
	
subBCDb:

	and r12, r11, #0x0000000f
	and r1, r2, #0x0000000f
	
	sub r12, r12, r1
	sub r12, r12, r6
	
	mov r6, #0
	
	cmp r12, #0
	bge subBCD_NoOverFlow
	sub r12, r12, #6
	and r12, r12, #0x0000000f
	mov r6, #1
	
subBCD_NoOverFlow:
	orr r0, r0, r12, lsl r4
	mov r11, r11, lsr #4
	mov r2, r2, lsr #4
	
	add r4, r4, #4
	
	subs r7, r7, #1
	bne subBCDb
	
	mov r11, r0
	
	and r10, r11, #0xf0000000
	lsr r10, #28
    setLcd 1, 0, 0, 1, 1
    delay timespecnano150
    timer
	and r10, r11, #0x0f000000
	lsr r10, #24
    setLcd 1, 0, 0, 1, 1
    delay timespecnano150
    timer
	and r10, r11, #0x00f00000
	lsr r10, #20
    setLcd 1, 0, 0, 1, 1
    delay timespecnano150
    timer
	and r10, r11, #0x000f0000
	lsr r10, #16
    setLcd 1, 0, 0, 1, 1
    delay timespecnano150
    timer
	and r10, r11, #0x0000f000
	lsr r10, #12
    setLcd 1, 0, 0, 1, 1
    delay timespecnano150
    timer
	and r10, r11, #0x00000f00
	lsr r10, #8
    setLcd 1, 0, 0, 1, 1
    delay timespecnano150
    timer
	and r10, r11, #0x000000f0
	lsr r10, #4
    setLcd 1, 0, 0, 1, 1
    delay timespecnano150
    timer
	and r10, r11, #0x0000000f
    setLcd 1, 0, 0, 1, 1
    delay timespecnano150
    timer
	cmp r11, #0
	beq end

buttons:
    delay time1s
    ldr r9, [r8, #reg_lvl]
    and r9, r9, #buttonp
    cmp r9, #0
    beq debounce

    ldr r9, [r8, #reg_lvl]
    and r9, r9, #buttonr
    cmp r9, #0
    beq begin

    b subBCD

end:
    mov r7, #1
    swi 0

.data 
flags:	.word O_RDWR + O_SYNC
fileName: .asciz "/dev/mem"
gpioaddr: .word 0x20200
timespecnano5: .word 0
                .word 5000000
timespecnano150: .word 0 
                .word 1500000
time1s: .word 1
        .word 000000000
value: .word 0x90204122
rs:  .word 8
     .word 15
     .word 25
e:   .word 0
     .word 3
     .word 1
db4: .word 4
     .word 6
     .word 12
db5: .word 4
     .word 18
     .word 16
db6: .word 8
     .word 0
     .word 20
db7: .word 8
     .word 3
     .word 21