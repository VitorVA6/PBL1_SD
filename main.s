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

.macro setZero pin
    mov r2, r8
    add r2, #clrregoffset
    mov r0, #1
    ldr r3, =/pin
    add r3, #8
    ldr r3, [r3]
    lsl r0, #r3
    str r0, [r2]
.endm

.macro setOne pin
    mov r2, r8
    add r2, #setregoffset
    mov r0, #1
    ldr r3, =/pin
    add r3, #8
    ldr r3, [r3]
    lsl r0, #r3
    str r0, [r2]
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

    setOut rs
    setOut e
    setOut db4
    setOut db5
    setOut db6
    setOut db7

delay:
    ldr r0, =timespec
    ldr r1, =timespecnano
    mov r7, #162
    swi 0

setZero:
    mov r2, r8
    add r2, #setregoffset
    mov r0, #1
    lsl r0, #6
    str r0, [r2]

end:
    mov r7, #1
    swi 0

.data 
flags:	.word O_RDWR + O_SYNC
fileName: .asciz "/dev/mem"
gpioaddr: .word 0x20200
timespec: .word 0
timespecnano: .word 100000000
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
     