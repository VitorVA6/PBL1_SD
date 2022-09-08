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

@00111110011111111001000001111111
@00111010011111111001000001111111

.global _start

.macro delay
    ldr r0, =timespec
    ldr r1, =timespecnano
    mov r7, #162
    swi 0
.endm

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
    mov r12, #0x3a000000
    orr r12, #0x00fb0000
    orr r12, #0x00009100
    orr r12, #0x000000ff
    mov r10, #9
    ldr r1, =message
    mov r11, #0xfffffff

debounce2:
    delay

check:
    ldr r9, [r8, #reg_lvl]
    cmp r9, r12
    bne debounce
    b check

print:
    mov r11, #0xfffffff
    mov r0, #1
    mov r2, #2
    mov r7, #4
    swi 0

    add r1, r1, #2
    sub r10, r10, #1
    cmp r10, #0
    bne atraso

    mov r7, #1
    swi 0

debounce:
    delay
atraso:
    ldr r9, [r8, #reg_lvl]
    cmp r9, r12
    bne debounce2
    sub r11, #1
    cmp r11, #0
    bne atraso 
    b print

end:
    mov r7, #1
    swi 0

.data 
flags:	.word O_RDWR + O_SYNC
fileName: .asciz "/dev/mem"
gpioaddr: .word 0x20200
timespec: .word 0
timespecnano: .word 200000000
pin6: .word 0
      .word 18
message: .asciz "1\n2\n3\n4\n5\n6\n7\n8\n9\n"