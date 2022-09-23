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

.macro write
    setLcd 1, 0, 0, 1, 1  
    delay timespecnano150
    timer
.endm
