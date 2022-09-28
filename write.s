@Macro que define nível lógico "0" ou "1" em um pino Output
.macro setLvl pin, lvl      @Recebe como parâmero as informações do pino e qual nível lógica colocar no pino
    mov r0, #40             @Move #40 para R0 (40 é o offset do clear register)
    mov r2, #12             @Move #12 para R2 (12 é a diferença entre os offsets do clear e do set registers)
    mov r1, \lvl            @Move para R1 o valor do nível lógico desejado
    mul r5, r1, r2          @Multiplica 12 pelo nível lógico recebido
    sub r0, r0, r5          @Subtrai 40 pelo resultado obtido na operação anterior
    mov r2, r8              @Move o endereço base dos GPIO obtido no mapeamento para o R2
    add r2, r2, r0          @Soma a esse endereço o offset calculado nas operações anteriores, podendo ser 28 (set register) ou 40 (clear register)
    mov r0, #1              @Move #1 para R0
    ldr r3, =\pin           @Carrega o endereço de memória contendo o offset do GPFSel em R3
    add r3, #8              @Adiciona 8 a esse endereço, para obter o endereço que contém a posição do bit responsável por definir o nível lógico daquele pino específico
    ldr r3, [r3]            @Carrega o valor contido nesse endereço em R3
    lsl r0, r3              @Desloca o bit colocado em R0 para a posição obtida na operação anterior
    str r0, [r2]            @Armazena no registrador de clear ou set o nível lógico do pino atualizado
.endm

@Macro que realiza a metade de um comando no LCD (Por estar no modo 4 bits, um comando é dividido em 2 partes)
.macro setLcd lvlrs, lvldb7, lvldb6, lvldb5, lvldb4 @Recebe como parâmetro os níveis lógicos a serem definidos nos pinos RS, DB7, DB6, DB5, DB4
    
    setLvl rs, #\lvlrs          @Define o nível lógico de RS (0 para dar comandos e 1 para escrever na LCD)
    setLvl db7, #\lvldb7        @Define o nível lógico de DB7
    setLvl db6, #\lvldb6        @Define o nível lógico de DB6
    setLvl db5, #\lvldb5        @Define o nível lógico de DB5
    setLvl db4, #\lvldb4        @Define o nível lógico de DB4
    setLvl e, #0                @Define nível lógico "0" no Enable (fecha o envio de dados nos pinos de dados)
    delay timespecnano150       @Aplica um delay de 1.5 milisegundos
    setLvl e, #1                @Define nível lógico "1" no Enable (habilita o envio de dados nos pinos de dados)
    delay timespecnano150       @Aplica um delay de 1.5 milisegundos
    setLvl e, #0                @Define nível lógico "0" no Enable (fecha o envio de dados nos pinos de dados)
    .ltorg                      @Certifica que uma literal pool está dentro da range exigida (sem essa instrução, códigos muito grandes tendem a "estourar" o limite da literal pool)
.endm                           @Literal pool é a distância entre o valor atual (do reg. PC) da instrução exucutada no momento e o endereço da constante que uma instrução acessa,
                                @Caso essa distância seja muito grande, o PC n consegue acessar a constante e reporta o erro de invalid literal pool

@Macro que realiza a metade de uma operação de escrita na LCD (Envia 4 dos 8 bits do ASCII)
@A macro verifica os 4 bits de um número contido em R10 e os envia para a LCD
.macro digit

    setLvl rs, #1       @Define o nível lógico "1" de RS
	mov r9, #1          @Move 1 para R9
	and r1, r9, r10     @Faz um and entre R9 e o número contido em R10 para verificar o nível lógico do primeiro bit
	
    mov r0, #40         @As 12 linhas abaixo executam a msm função da macro "setLvl"
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
	
	lsl r9, #1          @Desloca uma vez para a esquerda para verificar o segundo bit de R10
	and r1, r9, r10     @Aplica um AND para verificar
	lsr r1, #1          @Desloca 1 vez para direita, para deixar no formato adequado (A lógica do setLvl precisa usar "0" ou "1")

	mov r0, #40         @As 12 linhas abaixo executam a msm função da macro "setLvl"
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
	
	lsl r9, #1          @Desloca uma vez para a esquerda para verificar o terceiro bit de R10
	and r1, r9, r10     @Aplica um AND para verificar
	lsr r1, #2          @Desloca 2 vezes para direita, para deixar no formato adequado (A lógica do setLvl precisa usar "0" ou "1")

	mov r0, #40         @As 12 linhas abaixo executam a msm função da macro "setLvl"
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
	
	lsl r9, #1          @Desloca uma vez para a esquerda para verificar o quarto bit de R10
	and r1, r9, r10     @Aplica um AND para verificar
	lsr r1, #3          @Desloca 3 vezes para direita, para deixar no formato adequado (A lógica do setLvl precisa usar "0" ou "1")

	mov r0, #40         @As 12 linhas abaixo executam a msm função da macro "setLvl"
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

    setLvl e, #0                @Define nível lógico "0" no Enable (fecha o envio de dados nos pinos de dados)        
    delay timespecnano150       @Aplica um delay de 1.5 milisegundos
    setLvl e, #1                @Define nível lógico "1" no Enable (fecha o envio de dados nos pinos de dados)  
    delay timespecnano150       @Aplica um delay de 1.5 milisegundos
    setLvl e, #0                @Define nível lógico "0" no Enable (fecha o envio de dados nos pinos de dados)
    
.endm

@Macro que aplica um delay usando a syscall "nanosleep"
.macro delay time       @Receve como parâmetro o tempo em segundos ou nanosegundos
    ldr r0, =\time      @Carrega em R0 o tempo que o processador deve "dormir"
    ldr r1, =\time      
    mov r7, #162        @Move para R7 (Registrador que define qual Syscall será executada) o valor 162 (valor da syscall nanosleep)
    swi 0               @Executa a Syscall
.endm

@Macro que realiza um comando de escrita completo no display, utilizando os macros explicados acima
.macro write
    setLcd 1, 0, 0, 1, 1  
    delay timespecnano150
    digit
.endm
