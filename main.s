@Declaração de constantes
.equ sys_open, 5        @Valor da syscall de abertura de arquivos
.equ sys_map, 192       @Valor da syscall de mapeamento de memória (gera endereço virtual)
.equ page_len, 4096     @Tamanho da memória a ser utilizada para mapear, em número de páginas de memória (4096 = 1 página)
.equ prot_read, 1       @Flag para modo de leitura do arquivo "\dev\mem"
.equ prot_write, 2      @Flag para modo de escrita do arquivo "\dev\mem"
.equ map_shared, 1      @Libera compartilhamento de memória
.equ reg_lvl, 52        @Offset do level register (registrador de nível) do GPIO
.equ O_RDWR, 00000002 
.equ O_SYNC, 00010000 
.equ setregoffset, 28   @Offset do set register do GPIO
.equ clrregoffset, 40   @Offset do clear register do GPIO
.equ buttonp, 0x4000000 @Valor em hexadecimal de um bit "1" deslocado 26 unidades a esquerda (usado para checar o botão do pino 26)
.equ buttond, 0x20      @Valor em hexadecimal de um bit "1" deslocado 19 unidades a esquerda (usado para checar o botão do pino 19)
.equ buttonr, 0x80000   @Valor em hexadecimal de um bit "1" deslocado 5 unidades a esquerda (usado para checar o botão do pino 5)

.include "write.s"      @Inclusão do arquivo/biblioteca com o comando de escrever caracter no display
.include "clear.s"      @Inclusão do arquivo/biblioteca com o comando de limpar display
.include "cursor.s"      @Inclusão do arquivo/biblioteca com os comandos de mover cursor para esquerda e para direita

.global _start

@Macro que configura um GPIO para o modo Output
.macro setOut pin           @Recebe como parâmetro o endereço de memória contendo as informações do pino
        ldr r2, =\pin       @Carrega em R2 o endereço de memória que contém o Offset do registrador GPFSel que controla o pino
        ldr r2, [r2]        @Carrega o valor do Offset em R2
        ldr r1, [r8, r2]    @Carrega em R1 os 32 bits contidos no registrador GPFSel desejado
        ldr r3, =\pin       @Carrega em R3 o endereço de memória que contém o Offset do registrador GPFSel que controla o pino
        add r3, #4          @Adiciona 4 a esse endereço de memória para acessar a próxima Word, que contém a posição inicial dos 3 bits de FSel do pino
        ldr r3, [r3]        @Carrega em R3 o valor
        mov r0, #0b111      @Move os bits "111" para R0 (ou #7 em decimal)
        lsl r0, r3          @Aplica um deslocamento a esquerda em R0 com o valor carregado em R3, posicionando os bits na posição dos 3 bits de FSel do pino
        bic r1, r0          @Limpa os 3 bits de FSel do pino 
        mov r0, #1          @Move 1 para R0
        lsl r0, r3          @Aplica um deslocamento a esquerda em R0 para a posição inicial dos 3 bits de FSel do pino
        orr r1, r0          @Aplica um "or" para mudar o bit menos significativo do FSel para "1" (000 - Input, 001 - Output)
        str r1, [r8, r2]    @Armazena no registrador GPFSel os bits atualizados, tornando o pino uma Output
.endm

@Rotina inicial do programa
_start:
@Inicialmente é executada a abertura do arquivo "\dev\mem" para poder realizar o mapeamento
    ldr r0, =fileName       @Carrega em R0 o endereço que contém o nome do arquivo ("\dev\mem")
    mov r2, #0x1b0
    orr r2, #0x006          @Armazena em R2 o hexadecimal #0x1b6 para determinar os modos de abertura (usamos no modo de leitura e escrita)
    mov r1, r2              
    mov r7, #sys_open       @Armazena em R7 o valor da Syscall 5 (Para abertura de arquivos)
    swi 0                   @A syscall é executada
    movs r4, r0             @A syscall retorna em R0 o file descriptor (será usado no mapeamento), o file descriptor foi movido para R4

    ldr r5, =gpioaddr       @Carrega em R5 o endereço de memória que contem o endereço base dos GPIO em páginas de memória (0x20200000 \ 4096 = 0x20200)
    ldr r5, [r5]            @carrega em R5 o endereço dos GPIO (0x20200)
    mov r1, #page_len       @Move para R1 a quantidade de memória a usar em páginas de memória (foi usado 4096 bytes ou 1 página de memória)
    mov r2, #(prot_read + prot_write)   @Move para R2 os modos de acesso ao arquivo (leitura e escrita)
    mov r3, #map_shared     @Define que a memória será compartilhada
    mov r0, #0              @Define que o SO poderá definir qual endereço de memória virtual será usado para mapear
    mov r7, #sys_map        @Define a syscall de mapeamento no R7
    swi 0                   @Executa a syscall de mapeamento
    movs r8, r0             @O endereço virtual gerado é retornado em R0, em seguida é movido para R8

@Rotina que faz o mapeamento dos pinos ligados a LCD
mapping_lcd:    
    setOut rs               @O pino RS é definido como output
    setOut e                @O pino Enable é definido como output
    setOut db4              @O pino DB4 é definido como output
    setOut db5              @O pino DB5 é definido como output
    setOut db6              @O pino DB6 é definido como output
    setOut db7              @O pino DB7 é definido como output

@Rotina que faz a inicialização da LCD de acordo o datasheet
init_lcd:
    
    setLcd 0, 0, 0, 1, 1        @Comando de function set
    delay timespecnano5         @Delay de 5 milisegundos
    
    setLcd 0, 0, 0, 1, 1        @Comando de function set
    
    setLcd 0, 0, 0, 1, 1        @Comando de function set que muda o modo de operação da LCD para 4 bits
    setLcd 0, 0, 0, 1, 0
 
    setLcd 0, 0, 0, 1, 0        @Comando de function set que define número de linhas e a fonte a ser usada pelo LCD
    setLcd 0, 0, 0, 0, 0
       
    setLcd 0, 0, 0, 0, 0        @Comando que desliga o display
    setLcd 0, 1, 0, 0, 0

    setLcd 0, 0, 0, 0, 0        @Comando que limpa o display
    setLcd 0, 0, 0, 0, 1

    setLcd 0, 0, 0, 0, 0        @Comando de entry mode set (shift do cursor para direita e o endereço foi configurado para incremento)
    setLcd 0, 0, 1, 1, 0

    setLcd 0, 0, 0, 0, 0        @Comando para Ligar o display e o cursor
    setLcd 0, 1, 1, 1, 0

    setLcd 0, 0, 0, 0, 0        @Comando de entry mode set (shift do cursor para direita e o endereço foi configurado para incremento)
    setLcd 0, 0, 1, 1, 0

@Rotina que define o estado inicial do contador (limpa o display e escreve "Start" na tela)
begin:

    clear    @Comando de limpar LCD

    setLcd 1, 0, 1, 0, 1    @Operação de escrever "S"
    delay timespecnano150
    setLcd 1, 0, 0, 1, 1
    delay timespecnano150

    setLcd 1, 0, 1, 1, 1    @Operação de escrever "t"
    delay timespecnano150
    setLcd 1, 0, 1, 0, 0
    delay timespecnano150

    setLcd 1, 0, 1, 1, 0    @Operação de escrever "a"
    delay timespecnano150
    setLcd 1, 0, 0, 0, 1
    delay timespecnano150

    setLcd 1, 0, 1, 1, 1    @Operação de escrever "r"
    delay timespecnano150
    setLcd 1, 0, 0, 1, 0
    delay timespecnano150

    setLcd 1, 0, 1, 1, 1    @Operação de escrever "t"
    delay timespecnano150
    setLcd 1, 0, 1, 0, 0
    delay timespecnano150

    ldr r11, =value         @Carrega em R11 o endereço que contém o valor inicial do contador
    ldr r11, [r11]          @Carrega em R11 o valor inicial do contador

@Rotina que aplica um delay de 1s após o botão de pause ser pressionado (Necessário pelo fato do msm botão pausar e despausar)
debounce:
    delay time1s

@Rotina que representa o estado de pause, fica constantemente verificando o nível lógico do pino 26
check:
    ldr r9, [r8, #reg_lvl]      @Carrega os níveis lógicos dos 32 primeiros pinos
    and r9, r9, #buttonp        @Aplica uma and para verificar o nível lógico do pino 26 (botão de pause e despause) e armazena em R9
    cmp r9, #0                  
    beq subBCD                  @Caso R9 seja igual a 0, o botão foi pressionado, um desvio para a rotina de contagem é feito
    b check                     @Caso não seja, o botão não foi pressionado, o looping continua verificando o pino 26
	
@Rotina que inicia a configuração inicial do BCD, a função dela é apenas de colocar os registradores usados no BCD em seu estado inicial e limplar o display
@Ela é chamada sempre que o decremento de uma unidade é feito e o número é exibido no display 
subBCD:

    clear    @Comando de limpar o display

	mov r2, #1      @Número que irá decrementar (nesse problema irá decrementar de 1 em 1)
	mov r0, #0      @Acumulador que irá guardar cada dígito dos 8 a medida que o BCD realiza a subtração
	mov r6, #0      @Armazena o carry (0 quando não há, 1 quando há)
	mov r4, #0      @Contagem do caracter (cada caracter usa 4 bits, logo, a cada dígito calculado, o r4 incrementa 4)
	mov r7, #8
	
@Rotina que irá realizar a subtração (Esse BCD pode calcular operação de subtração entre quaisquer números de 8 dígitos)
subBCDb:

	and r12, r11, #0x0000000f   @Aplica um AND para pegar os últimos 4 bits (que representam o último dígito) do número especificado
	and r1, r2, #0x0000000f     @Aplica um AND para pegar os últimos 4 bits do subtrator (nesse caso, o subtrator é 1)
	
	sub r12, r12, r1            @Realiza a subtração entre os dígitos
	sub r12, r12, r6            @Subtrai o resultado pelo carry
	
	mov r6, #0                  @Define o carry como 0
	
	cmp r12, #0                 @Compara o resultado da subtração com 0
	bge subBCD_NoOverFlow       @Caso seja maior ou igual a 0, não precisa de nenhum tratamento, desvia para a rotina de mudar para o próximo dígito
	sub r12, r12, #6            @Caso seja menor que 0, ocorreu overflow, como está em hexadecimal e o BCD opera de 0 a 9, é decrementado 6 unidades
	and r12, r12, #0x0000000f   @Aplica uma AND para pegar o último dígito (O resultado do overflow é 0xffffffff, após subtrair 6 --> 0xfffffff9), só precisamos do 9 (últimos 4 bits)
	mov r6, #1                  @Como ocorreu overflow, o carry recebe 1
	
@Rotina que atualiza o acumulador R0 e descarta o digito que foi processado
subBCD_NoOverFlow:
	orr r0, r0, r12, lsl r4     @É feito um deslocamento para esquerda (move o dígito para sua posição correta) e em seguida aplica um OR para salvar o dígito que foi processador no acumulador R0
	mov r11, r11, lsr #4        @Desloca 4 vezes para direita (para descartar o dígito que acabou de ser processado)
	mov r2, r2, lsr #4          @Descarta o último dígito do subtrator
	
	add r4, r4, #4              @O R4 que contém a posição que o dígito processado deve ser adicionado no acumulador, incrementa 4 unidades
	
	subs r7, r7, #1             @R7 faz a contagem de quantos dígitos já foram processados (o total é 8, quando r7 é zero, a subtração foi finalizada)
	bne subBCDb                 @Caso seja maior que 0, vai processar o próximo dígito
	
	mov r11, r0                 @Caso já tenho processado os 8 dígitos, move para R11 (registrador que guarda o número do contador) o valor contido no acumulador R0

@Rotina que realiza o envio dos bits para a LCD
write_digits:	

    and r10, r11, #0xf0000000       @aplica um AND para selecionar o dígito a ser enviado
	lsr r10, #28                    @Desloca para o bit menos significativo
    write                           @Envia o dígito armazenado em R10
	
    and r10, r11, #0x0f000000       @Seleciona e escreve outro dígito
	lsr r10, #24                    @Desloca para o bit menos significativo
    write                           @Envia o dígito armazenado em R10
	
    and r10, r11, #0x00f00000       @Seleciona e escreve outro dígito
	lsr r10, #20                    @Desloca para o bit menos significativo
    write                           @Envia o dígito armazenado em R10
	
    and r10, r11, #0x000f0000       @Seleciona e escreve outro dígito
	lsr r10, #16                    @Desloca para o bit menos significativo
    write                           @Envia o dígito armazenado em R10
	
    and r10, r11, #0x0000f000       @Seleciona e escreve outro dígito
	lsr r10, #12                    @Desloca para o bit menos significativo
    write                           @Envia o dígito armazenado em R10
	
    and r10, r11, #0x00000f00       @Seleciona e escreve outro dígito
	lsr r10, #8                     @Desloca para o bit menos significativo
    write                           @Envia o dígito armazenado em R10
	
    and r10, r11, #0x000000f0       @Seleciona e escreve outro dígito
	lsr r10, #4                     @Desloca para o bit menos significativo
    write                           @Envia o dígito armazenado em R10
	
    and r10, r11, #0x0000000f       @Seleciona e escreve outro dígito
    write                           @Envia o dígito armazenado em R10
	
    cmp r11, #0                     @Verifica se o contador já chegou a 0
	beq end                         @Caso seja 0, é feito um desvio para o rotina que encerra o programa
@Caso n seja 0, é feita a verificação se os botões foram pressionados

@A rotina abaixo verifica o botão de pause e de reinício
buttons:
    delay time1s                @Aplica um delay de 1s (para o contador decrementar de 1 em 1 segundo)
    ldr r9, [r8, #reg_lvl]      @Carrega os 32 bits do registrador de nível
    and r9, r9, #buttonp        @Verifica o bit 27 (bit que representa o nível lógico do botão do pino 26, o pause)
    cmp r9, #0                  @Compara com 0
    beq debounce                @Caso seja igual a 0, desvia para o debounce e em seguida entra no estado de pause

    ldr r9, [r8, #reg_lvl]      @Carrega os 32 bits do registrador de nível
    and r9, r9, #buttonr        @Verifica o bit 19 (bit que representa o nível lógico do botão do pino 26, o restart)
    cmp r9, #0                  @Compara com 0
    beq begin                   @Caso seja igual a 0, desvia para a rotina inicial

    b subBCD                    @Caso nenhum botão seja pressionado, a contagem continua

@Rotina que finaliza o programa
end:
    mov r7, #1
    swi 0

.data 
flags:	.word O_RDWR + O_SYNC
fileName: .asciz "/dev/mem"     @Diretório usado para o mapeamento de memória
gpioaddr: .word 0x20200         @Endereço dos GPIO / 4096
timespecnano5: .word 0          @Delay de 5 milisegundos
                .word 5000000
timespecnano150: .word 0        @Delay de 1.5 milisegundos
                .word 1500000
time1s: .word 1                 @Delay de 1 segundo  
        .word 000000000
value: .word 0x90204122         @Valor do contador
rs:  .word 8                    @Offset do GPFSel do pino RS
     .word 15                   @Posição dos bits de FSel do pino RS
     .word 25                   @Posição do bit para clear e set register do pino RS
e:   .word 0                    @Offset do GPFSel do pino Enable
     .word 3                    @Posição dos bits de FSel do pino Enable
     .word 1                    @Posição do bit para clear e set register do pino Enable
db4: .word 4                    @Offset do GPFSel do pino DB4
     .word 6                    @Posiçã o dos bits de FSel do pino DB4
     .word 12                   @Posição do bit para clear e set register do pino DB4
db5: .word 4                    @Offset do GPFSel do pino DB5
     .word 18                   @Posição dos bits de FSel do pino DB5
     .word 16                   @Posição do bit para clear e set register do pino DB5
db6: .word 8                    @Offset do GPFSel do pino DB6
     .word 0                    @Posição dos bits de FSel do pino DB6
     .word 20                   @Posição do bit para clear e set register do pino DB6
db7: .word 8                    @Offset do GPFSel do pino DB7
     .word 3                    @Posição dos bits de FSel do pino DB7
     .word 21                   @Posição do bit para clear e set register do pino DB7