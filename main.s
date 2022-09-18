@Declaração de constantes

.equ sys_open, 5        @Syscall de abertura de arquivos    
.equ sys_map, 192       @Syscall que faz o mapeamento de memória (cria um endereço virtual para um endereço físico) 
.equ page_len, 4096     @Tamanho de memória utilizada no mapeamento, é obrigatório ser em tamanho de página de memória, nesse caso utilizamos 1 página (4096 bytes)
.equ prot_read, 1       @Modo de leitura no acesso ao arquivo "\dev\mem" (Usado pela Syscall 192)
.equ prot_write, 2      @Modo de escrita no acesso ao arquivo "\dev\mem" (Usado pela Syscall 192)
.equ map_shared, 1      @Permite compartilhamento de memória
.equ reg_lvl, 52        @Offset entre o endereço base dos GPIOs e os Registradores de nível (Level Registers) 
.equ setregoffset, 28   @Offset entre o endereço base dos GPIOs e os Registradores de Set (Set Registers) 
.equ clrregoffset, 40   @Offset entre o endereço base dos GPIOs e os Registradores de Set (Clear Registers)

.global _start

@Macro criada para configurar um pino no modo output (Por padrão, todos os pinos são inputs)
.macro setOut pin           @A macro recebe como parâmetro as informações do pino a ser configurado
        ldr r2, =\pin       @Carrega em R2 o endereço da Word com o offset do GPFSel que contêm o pino
        ldr r2, [r2]        @Carrega de fato o valor da Word contento o offset
        ldr r1, [r8, r2]    @Carrega os 32 bits contidos no registrador GPFSel especificado pelo offset
        ldr r3, =\pin       @Carrega em R3 o endereço da Word com o offset do GPFSel que contêm o pino
        add r3, #4          @Adiciona #4 ao endereço carrego em R3
        ldr r3, [r3]        @Carrega de fato o valor da Word, essa Word contém a posicição dos 3 bits que controlam a função (FSel) do GPIO
        mov r0, #0b111      @Move para R0 o binário "111"
        lsl r0, r3          @Aplica uma operação de Shift para a esquerda, movendo os 3 bits para a posição dos bits de FSel do GPIO
        bic r1, r0          @Limpa (torna "0") os 3 bits do FSel especificado
        mov r0, #1          @Move "1" para R0
        lsl r0, r3          @Aplica uma operação de Shift para a esquerda, movendo o bit "1" para a posição dos bits de FSel do GPIO
        orr r1, r0          @Aplica um "ou lógico", para transformar os bits do FSel no formato de output (000 - Input, 001 - Output)
        str r1, [r8, r2]    @Armazena no endereço do GPSel os valores dos bits atualizados
.endm

@Macro que define valor lógica 0 ou 1 em um pino de output
.macro setLvl pin, lvl      @Recebe como parâmetro as informações de endereço do pino e o nível lógico a ser definido
    mov r0, #40             @Move o valor 40 para R0 (40 é o offset para o registrador clear)
    mov r2, #12             @Move o valor 12 para R2 (12 é a diferença entre o offset do clear e o offset do set que é 28)
    mov r1, \lvl            @Move para R1 o valor lógica a ser definido
    mul r5, r1, r2          @Multiplica 12 pelo valor lógico (0x12 ou 1x12)
    sub r0, r0, r5          @Subtrai 40 pelo resultado da operação anterior e armazena em R0
    mov r2, r8              @Move o endereço de memória base dos GPIO mapeado para R2
    add r2, r2, r0          @Adiciona ao endereço base o offset calculado e armazenado em R0
    mov r0, #1              @Move 1 para R0
    ldr r3, =\pin           @Carrega em R3 o endereço da Word contendo GPFSel do pino
    add r3, #8              @Adiciona 8 ao endereço para acessar a Word que contém a posição do bit que define o valor lógico de saída do pino
    ldr r3, [r3]            @Carrega o valor contido na Word
    lsl r0, r3              @Aplica uma operação de shift left em R0 para mover o bit "1" para a posição correta do pino
    str r0, [r2]            @Armazena ou no set register ou no clear register "1" na posição do respectivo pino
.endm

@Macro que realiza metade de um comando na LCD (Como está no modo 4-bits, um comando tem 2 etapas, esse macro executa 1 metade a cada vez que é chamado)
.macro setLcd lvlrs, lvldb7, lvldb6, lvldb5, lvldb4     @Recebe como parâmetro o nível lógico a ser definido pelos pinos RS, DB7, DB6, DB5, DB4 
    setLvl e, #0                                        @Coloca "0" no enable, bloqueando o envio nos pinos de dados 
    setLvl rs, #\lvlrs                                  @Coloca o parâmetro "lvlrs" no pino RS 
    setLvl e, #1                                        @Coloca "1" no enable, permitindo o envio nos pinos de dados
    setLvl db7, #\lvldb7                                @Coloca o parâmetro "lvldb7" no pino DB7 
    setLvl db6, #\lvldb6                                @Coloca o parâmetro "lvldb6" no pino DB6
    setLvl db5, #\lvldb5                                @Coloca o parâmetro "lvldb5" no pino DB5
    setLvl db4, #\lvldb4                                @Coloca o parâmetro "lvldb4" no pino DB4
    setLvl e, #0                                        @Coloca "0" no enable, bloqueando o envio nos pinos de dados 

.endm 


@Macro que realiza a segunda metade do comando de escrita de um caracter ASC numérico
@Ela recebe um digito e decodifica o decimal em um binário de 4 bits (Por exemplo: 9 -> 1001, 8 -> 1000 e etc.) e envia para o LCD
@A primeira metade do comando é realizada pela macro setLCD explicada anteriormente (Fizemos assim pois todo caracter numérico começa com "0011")
.macro timer val        @Recebe como parâmetro o valor do dígito decimal que será enviado (Pode variar de 0 a 9)

    setLvl e, #0        @Coloca nível lógico 0 no pino de Enable
    setLvl rs, #1       @Coloca nível lógico 1 no pino RS, isso faz o LCD alternar do Instruction Register para o Data Register, permitindo escerver caracteres no LCD 
    setLvl e, #1        @Coloca nível lógico 1 do pino de Enable, , permitindo o envio nos pinos de dados
    mov r10, \val       @Move para R10 o dígito passado como parâmetro 
	mov r9, #1          @Move 1 para R9
	and r1, r9, r10     @Aplica uma operação de AND para verificar o nível lógico do primeiro bit do dígito enviado e armazena em R1
	
    mov r0, #40         @Essas 12 linhas são equivalentes à macro "setLvl"
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
	
	lsl r9, #1          @Aplica um shfit left de 1 no valor contido em R9 (0001 -> 0010)
	and r1, r9, r10     @Aplica um AND para verificar o nível lógico do segundo bit do dígito e armazena em R1
	lsr r1, #1          @Aplica um shift right em R1 para caso seja nível lógico 1, voltar a ter o formato adequado para a lógica do setLvl (0010 -> 0001)

	mov r0, #40         @Essas 12 linhas são equivalentes à macro "setLvl"
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
	
	lsl r9, #1          @Aplica um shfit left de 1 no valor contido em R9 (0010 -> 0100)
	and r1, r9, r10     @Aplica um AND para verificar o nível lógico do terceiro bit do dígito e armazena em R1
	lsr r1, #2          @Aplica um shift right em R1 para caso seja nível lógico 1, voltar a ter o formato adequado para a lógica do setLvl (0100 -> 0001)

	mov r0, #40         @Essas 12 linhas são equivalentes à macro "setLvl"
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
	
	lsl r9, #1          @Aplica um shfit left de 1 no valor contido em R9 (0100 -> 1000)
	and r1, r9, r10     @Aplica um AND para verificar o nível lógico do quarto bit do dígito e armazena em R1
	lsr r1, #3          @Aplica um shift right em R1 para caso seja nível lógico 1, voltar a ter o formato adequado para a lógica do setLvl (1000 -> 0001)

	mov r0, #40         @Essas 12 linhas são equivalentes à macro "setLvl"
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

    setLvl e, #0        @Coloca "0" no enable, bloqueando o envio nos pinos de dados         
.endm

@Macro que cria um delay a partir de um tempo especificado utilizanso a Syscall 162 (nanoseleep)
.macro delay timespecnano       @Recebe como parâmetro o delay em nano segundos
    ldr r0, =timespecsec        @Carrega em R0 o endereço da Word que contém o tempo em segundos (é sempre 0)
    ldr r1, =\timespecnano      @Carrega em R1 o endereço da Word que contém o tempo em nano segundos
    mov r7, #162                @Move para R7 o valor da Syscall nanosleep
    swi 0                       @Executa a instrução software interrrupt (instrução que executa as syscalls do SO)
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
    mov r12, #0x1ffffff
check:
    mov r6, #1
    lsl r6, #26
    ldr r9, [r8, #reg_lvl]
    and r9, r9, r6
    cmp r9, #0
    beq atraso
    b check

contador:
    mov r12, #0x1ffffff

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
    mov r5, #1
    lsl r5, #5
    ldr r9, [r8, #reg_lvl]
    and r9, r9, r5
    cmp r9, #0
    beq check
    sub r12, #1
    cmp r12, #0
    bne atraso 
    b contador

end:
    mov r7, #1
    swi 0

.data 
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