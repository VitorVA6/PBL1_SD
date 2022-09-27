<div id="inicio">
    <h1>PROBLEMA 1 TEC 499 Sitemas Digitas- Temporizador e respectivos comandos no LCD em Assembly</h1>
	<p align="justify"> 
		Para o problema 1 de Sistemas Digitais, foi solicitado o desenvolvimento de um aplicativo de temporização (timer) que apresente a contagem num
		display LCD. O tempo inicial deveia ser configurado diretamente no código. Além disso,
		o problema exigia que fossem usados 2 botões de controle: 1 para iniciar/parar a contagem e outro para reiniciar a partir do tempo definido.	
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
		<li> Download do projeto presente neste repositório, usando o comando: git clone <repository-url>. </li>
		<li> Transfira os arquivos make, main e a biblioteca write para o Rapsberry Pi Zero. </li>
		<li> Execute o seguinte comando no diretorio onde o projeto estara salvo em seu computador: make </li>
		<li> Por fim inicialize no terminal o programa com o comando: sudo ./main </li>
    </p>
</div>
 
<div id="funcionamento e testes realizados">
<h1>Resultados Obtidos</h1>
	<p> 
	As requisições do projeto foram cumpridas com exito por nossa equipe, sendo realizadas de forma satisfatória e testadas com o devido rigor. Nesta seção iremos detalhar como funciona o nosso projeto e quais testes foram necessários para termos um resultado competente aos nossos estudos. 
	</p>
	<p>
	<h3> Inicialização </h3>
	Ao iniciar o programa no Rapsberry Pi, sera exibido no display LCD do mesmo a palavra START, o programa então começa a fazer o processo de verificação de interação do usuario com o sistema atráves do botão de inicio da contagem.  
	</p>
	<div align="center">
	<img src= https://user-images.githubusercontent.com/29680023/192542125-d63e99a4-9e55-4d8d-9168-3a3c53162683.jpeg width="300px" />
	</div>
	<p>
	<h3> Temporizador </h3>
	Após o botão de inicio de contagem ser acionado, o temporizador começara a decrementar no intervalo de 1 segundo, partindo de um valor pré definido em código que para a nossa implementação, terá como margem os números presentes entre 0 a 99.999.999. 
	</p>
	<p>
	<h3> Pause da contagem</h3>
	Outra interação esperada no nosso programa é a segunda interação com o botão de inicializar, como requerido no problema o mesmo botão de iniciar a contagem é o mesmo botão responsável por pausar, então após a contagem estar iniciada ao apertar o botão, será pausado o programa e o contador não decrementará mais. 
	</p>
	<div align="center">
	<img src=https://user-images.githubusercontent.com/29680023/192538169-8c3def50-d3b1-4fe7-8b95-d52f7186835d.jpeg width="300px" />
	</div>
	<p>
	<h3> Reinicialização </h3>
	Por fim, a ultima interação disponível pelo usuário, é a do segundo botão, responsável pela reinicialização do programa. Quando pressionado, este botão ira resetar o sistema, voltando para o seu estágio de inicialização. Como decisão do projeto, optamos fazer com que só seja possível a reinicialização do programa se o mesmo estiver em contagem, não reinicializando assim se o mesmo estiver pausado. 
	</p>
	<div align="center">
	<img src=https://user-images.githubusercontent.com/29680023/192541073-a17bc61a-d9f5-45d2-a51a-419236c1760c.jpeg width="300px" />
	</div>
 </div>

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
