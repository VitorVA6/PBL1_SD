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

@0 -- 0
@1 -- 8
@2 -- 4
@3 -- <
@4 -- 2

@0001 -- 1000

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
    setLvl e, #0
    setLvl rs, #\lvlrs
    setLvl e, #1
    setLvl db7, #\lvldb7
    setLvl db6, #\lvldb6
    setLvl db5, #\lvldb5
    setLvl db4, #\lvldb4
    setLvl e, #0

.endm 

.macro timer val

    setLvl e, #0
    setLvl rs, #1
    setLvl e, #1
    mov r10, \val
	mov r9, #1
	and r11, r9, r10
	
    mov r0, #40
    mov r2, #12
    mov r1, r11
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
	and r11, r9, r10
	lsr r11, #1

	mov r0, #40
    mov r2, #12
    mov r1, r11
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
	and r11, r9, r10
	lsr r11, #2

	mov r0, #40
    mov r2, #12
    mov r1, r11
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
	and r11, r9, r10
	lsr r11, #3

	mov r0, #40
    mov r2, #12
    mov r1, r11
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
.endm

.macro delay timespecnano
    ldr r0, =timespecsec
    ldr r1, =\timespecnano
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
    b 1f
    .ltorg 

1:
    
    setLcd 0, 0, 0, 1, 1
    delay timespecnano5
    
    setLcd 0, 0, 0, 1, 1
    delay timespecnano150
    
    setLcd 0, 0, 0, 1, 1
   
    setLcd 0, 0, 0, 1, 0
    delay timespecnano150

    b 2f
    .ltorg 

2:   
    setLcd 0, 0, 0, 1, 0
   
    setLcd 0, 0, 0, 0, 0
    delay timespecnano150
   
    setLcd 0, 0, 0, 0, 0

    setLcd 0, 1, 0, 0, 0
    delay timespecnano150

    setLcd 0, 0, 0, 0, 0
   
    setLcd 0, 0, 0, 0, 1
    delay timespecnano150
   
    setLcd 0, 0, 0, 0, 0
   
    setLcd 0, 0, 1, 1, 0
    delay timespecnano150

    b 3f
    .ltorg 
   
3:

    setLcd 0, 0, 0, 0, 0
    setLcd 0, 1, 1, 1, 0
    delay timespecnano150

    setLcd 0, 0, 0, 0, 0
    setLcd 0, 0, 1, 1, 0
    delay timespecnano150

    mov r4, #9
    

contador:
    mov r12, #0xfffffff

    setLcd 0, 0, 0, 0, 0
   
    setLcd 0, 0, 0, 0, 1
    delay timespecnano150

    setLcd 1, 0, 0, 1, 1
    timer r4
    sub r4, #1
    cmp r4, #0
    bne atraso 
    b end

atraso:
    sub r12, #1
    cmp r12, #0
    bne atraso 
    b contador

end:
    mov r7, #1
    swi 0

.data 
flags:	.word O_RDWR + O_SYNC
fileName: .asciz "/dev/mem"
gpioaddr: .word 0x20200
timespecsec: .word 0
timespecnano20: .word 20000000
timespecnano5: .word 5000000
timespecnano150: .word 150000
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