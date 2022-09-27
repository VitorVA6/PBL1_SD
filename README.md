<div id="inicio">
    <h1>PROBLEMA 1 TEC 499 Sitemas Digitas- Temporizador e respectivos comandos no LCD em Assembly</h1>
	<p align="justify"> 
		Para o problema 1 de Sistemas Digitais, foi solicitado o desenvolvimento de um aplicativo de temporização (timer) que apresente a contagem num
		display LCD. O tempo inicial deveia ser configurado diretamente no código. Além disso,
		o problema exigia que fossem usados 2 botões de controle: 1 para iniciar/parar a contagem e outro para reiniciar a partir do tempo definido.	
</div>

<div id="equipe">
    <h1>Equipe de Desenvolvimento</h1>
    <ul>
		<li><a href="https://github.com/VitorVA6"> Vitor </li>
		<li><a href="https://github.com/ViniciusDJM"> Vinícius Dias de Jesus Maciel </a></li>
	</ul>
    <h1>Tutor</h1>
    <ul>
        <li><a href="https://github.com/thiagocj">Thiago Cerqueira de Jesus</a></li>
    </ul>
</div>

<div id="sumario">
    <h1>Sumário</h1>
	<ul>
		<li><a href="#inicio"> <b>Início</b></li>
        	<li><a href="#equipe"> <b>Equipe de Desenvolvimento</b></li>
		<li><a href="#recursos-utilizados"> <b>Recursos Utilizados</b> </a></li>
        	<li><a href="#implementacao"> <b>Implementação</b> </a> </li>
        	<li><a href="#conclusoes"> <b>Conclusões</b> </a> </li>
		<li><a href="#anexos"> <b>Anexos</b> </a></li>
	</ul>	
</div>

<div id="recursos-utilizados">
	<h1> Recursos Utilizados </h1>
	<ul>
	<h2>Ferramentas aplicadas ao projeto.</h2>
        <li>Raspberry Pi Zero: Ferramenta onde o sistema operacional em que o solução para o problema 1 foi feito e testado.</li>
	<li>Visual Studio Code: IDE utilizada para alteração, confecção e manuseio do código em Assembly.</li>
	<li>CPUlator: Software utilizado para fazer os testes do código fora do ambiente de laboratório.</li>
	</ul>
	<ul>
	 <h2>ROADMAP, descrição das instruções usadas para a resolução do problema.</h2>
	     <p>

		.global = Torna um símbolo global, necessário para ser referência de outros arquivos pois informa onde a execução do programa começa.
		
		.equ = A instrução EQU atribui valores absolutos ou realocáveis aos símbolos

		.macro e .endm = Uma macro é uma sequência de instruções, atribuída por um nome e pode ser usada em qualquer lugar do programa. Já o .endm é o que indica o fim de uma macro.

		.LTORG = .

		.data = Usada para declarar dados ou constantes inicializados, estes dados  não mudam em tempo de execução.

		.word = Define o armazenamento para inteiros de 32 bits

		.asciz = Define a memória para uma string ASCII e adiciona um terminador NULL. Apesar de ser parecido ao .ascii o .asciz difere por montar cada string seguido por um byte zero.

		
		ADD = Soma o valor do operando destino com o valor do operando fonte, armazena o valor em um operador informado ou no próprio operador destino.
		MUL = Executa uma multiplicação sem sinal do primeiro operando (operando de destino) e do segundo operando (operando de origem) e armazena o resultado no operando de destino.
		SUB = Subtrai o valor do operando destino com o valor do operando fonte.

		LSL = Deslocamento lógico para a esquerda.
		LSR = Deslocamento lógico para a direita.

		BIC = Utilizado para limpar bits.

		AND = Faz uma operação "E" bit a bit nos operandos e armazena o resultado no operando destino.
		ORR = Faz uma operação "OU" bit a bit nos operandos e armazena o resultado no operando destino.

		CMP = Compara o valor dos dois operandos.

		BEQ = Condição para quando os operadores comparados forem iguais.
		BGE = Condição para quando um operador comparado for maior ou igual que o outro.
		BNE = Condição para quando os operadores comparados forem diferentes.
		B = .
		
		MOV = Copia o valor do operando fonte para o operando destino.
		MOVS = é usada para copiar um item de dados, podendo ser byte ou word, da string de origem para a string de destino.
		SVC = o modo do processador muda para Supervisor podendo, entre outras coisas, encerrar a chamada.
		STR = Armazena um valor de registro na memória.
		LDR = Carrega um valor de registro na memória.

		</ul>
</div>

<div id="como-executar">
    <h1>Como executar</h1>
    <p>
        Para executar, é necessário dispor do Raspberry Pi Zero, após possuí-lo deve-se:
		<li> Download do projeto presente neste repositório. </li>
		<li> Transfira os arquivos make, main e a biblioteca write para o Rapsberry Pi Zero. </li>
		<li> Execute os seguintes comandos: (make) e (sudo ./_start) </li>
    </p>
 
<div id="funcionamento">
 /div>

<div id="implementacao">
    <h1>Breve descrição da implementação</h1> 
</div>

<div id="conclusoes">
    <h1>Conclusões</h1>
    <p>
       </p>
</div>

<div id="anexos">
		
</div>
