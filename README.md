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
        	<li><a href="#resultados-obtidos"> <b>Resultados Obtidos</b> </a> </li>
        	<li><a href="#limitacoes-solucao"> <b>Limitações e preferências da Solução Desenvolvida</b> </a> </li>
		<li><a href="#anexos"> <b>Anexos</b> </a></li>
	</ul>	
</div>

<div id="equipe">
    <h1>Equipe de Desenvolvimento</h1>
    <ul>
		<li><a href="https://github.com/VitorVA6"> Vitor Vaz Andrade </li>
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
	<h2>Ferramentas usadas no projeto.</h2>
        <li>Raspberry Pi Zero W: Ferramenta onde o sistema operacional em que o solução para o problema 1 foi feito e testado.</li>
	<ul>
	<li>Anexos ao Rapsberry também usamos os seguintes periféricos: Display LCD: HD44780U (LCD-II); Botão tipo push-button.</li>
	</ul>
	<li>Visual Studio Code: IDE utilizada para alteração, confecção e manuseio do código em Assembly.</li>
	<li>CPUlator: Software utilizado para fazer os testes do código fora do ambiente de laboratório.</li>
	</ul>
	<ul>
	<h3> Características da Raspberry PI Zero W utilizada:</h3>
	</ul>
	<ul>
	<p>
		Chip Broadcom BCM2835, com processador ARM1176JZF-S 1GHz single core;
		O processador conta com arquitetura ARMv6.
		512MB de memória LPDDR2 SDRAM;
	<p>
	</ul>
	<ul>
	 <h2>Descrição das instruções usadas para a resolução do problema.</h2>
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
		B = A instrução "B" faz com que uma ramificação seja .label.
		
		MOV = Copia o valor do operando fonte para o operando destino.
		MOVS = é usada para copiar um item de dados, podendo ser byte ou word, da string de origem para a string de destino.
		SVC = o modo do processador muda para Supervisor podendo, entre outras coisas, encerrar a chamada.
		STR = Armazena um valor de registro na memória.
		LDR = Carrega um valor de registro na memória.
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
 
<div id="resultados-obtidos">
<h1>Resultados Obtidos</h1>
	<p> 
	As requisições do projeto foram cumpridas com exito por nossa equipe, sendo realizadas de forma satisfatória e testadas com o devido rigor. Nesta seção iremos detalhar como funciona o nosso projeto e quais testes foram necessários para termos um resultado competente aos nossos estudos. 
	</p>
	<p>
	<h3> Inicialização </h3>
	Ao iniciar o programa no Rapsberry Pi, sera exibido no display LCD do mesmo a palavra START, o programa então começa a fazer o processo de verificação de interação do usuario com o sistema atráves do botão de inicio da contagem.  
	Como este problema 1 a solução foi feita por etapas, houveram distintos testes ao decorrer do problema para esse objetivo, o primeiro teste foi de garantir que o Display do LCD fosse realmente inicializado, ao nosso primeiro contato bem sucedido com o mesmo conseguiamos apenas faze-lo "piscar", após alguns períodos de testes e avanços no estudo conseguimos a inicialização onde avançamos inserindo letras soltas para o Display até que finalmente chegassemos no Start que usamos hoje e pudessemos avançar nos outros requisitos do problema.
	</p>
	<div align="center">
	<img src= https://user-images.githubusercontent.com/29680023/192542125-d63e99a4-9e55-4d8d-9168-3a3c53162683.jpeg width="300px" />
	</div>
	<p>
	<h3> Temporizador </h3>
	Após o botão de inicio de contagem ser acionado, o temporizador começara a decrementar no intervalo de 1 segundo, partindo de um valor pré definido em código que para a nossa implementação, terá como margem os números presentes entre 0 a 99.999.999. 
	Como teste deste complemento, colocamos diversos valores diferentes de 1 para decrementar o valor total, por usarmos um valor de 8 dígitos, preferimos testar todas as casas decímais para garantir a sua plena funcionalidade. Após checarmos que todas as casas e valores eram correspondentes as nossas expectatívas interpretamos como concluido esse objetivo. 
	</p>
	<div align="center">
	<img src= https://user-images.githubusercontent.com/29680023/192601339-2c9e4239-b419-4903-bfc2-d6dd2e122204.jpeg width="300px" />
	</div>	
	<p>
	<h3> Pause da contagem</h3>
	Outra interação esperada no nosso programa é a segunda interação com o botão de inicializar, como requerido no problema o mesmo botão de iniciar a contagem é o mesmo botão responsável por pausar, então após a contagem estar iniciada ao apertar o botão, será pausado o programa e o contador não decrementará mais. 
	Para a interação com o pause do sistema, primeiro decidimos usar um botão isolado para termos mais segurança no teste, após a confirmação de que o pause estava funcionando perfeitamente, ou seja parando o tempo da contagem até que o botão de inicio fosse pressionado, então finalmente juntamos a pausa da contagem ao mesmo botão de iniciar o contador. Apesar de termos escrito mensagens de que o sistema estava pausado ou despausado para nos auxiliar em testes, optamos por tira-los para melhorar nossa visualização na entrega final do produto. 
	</p>
	<div align="center">
	<img src=https://user-images.githubusercontent.com/29680023/192538169-8c3def50-d3b1-4fe7-8b95-d52f7186835d.jpeg width="300px" />
	</div>
	<p>
	<h3> Reinicialização </h3>
	Por fim, a ultima interação disponível pelo usuário, é a do segundo botão, responsável pela reinicialização do programa. Quando pressionado, este botão ira resetar o sistema, voltando para o seu estágio de inicialização. Como decisão do projeto, optamos fazer com que só seja possível a reinicialização do programa se o mesmo estiver em contagem, não reinicializando assim se o mesmo estiver pausado. 
	Os testes com o botão responsável pela reinicialização foram mais simples, apenas nos certificamos de que ao ser apertado, a contagem voltaria ao valor definido no código junto a mensagem de Start presente na inicialização da solução.
	</p>
	<div align="center">
	<img src=https://user-images.githubusercontent.com/29680023/192541073-a17bc61a-d9f5-45d2-a51a-419236c1760c.jpeg width="300px" />
	</div>
 </div>

<div id="limitacoes-solucao">
    <h1>Limitações e preferências da Solução Desenvolvida</h1> 
    <h3>Contador limitado a apenas 8 digitos</h3>
    Uma das estrátegias em nossa solução para realizar a contagem de 8 digitos foi usarmos o BCD, que é uma forma de conseguirmos realizar a contagem de números maiores que 99. Porém o BCD utiliza 4 bits para representar 1 dígito, já que a arquitetura usada foi de 32 bits, conseguimos apenas utilizar 8 dígitos em um registrador. Uma solução para este problema seria utilizar de outro registrador para armazenar outros 8 dígitos, fazendo assim com que esse contador tivesse 16 dígitos, porém, isso não foi possível pois já tinhamos usado todos os registradores disponíveis, o que acabou atrapalhando uma implementação mais poderosa da nossa solução. 
    <h3>Botões mudam de estado se pressionados por muito tempo</h3>
    
    <h3>Ação dos botões só funciona após 1 segundo</h3>
    
    <h3>O programa não reinicia se estiver pausadao.</h3>
    
</div>


<div id="anexos">
<h1> Materiais utilizados no desenvolvimento</h1> 

&nbsp;&nbsp;&nbsp;[Stephen Smith - Raspberry Pi Assembly Language
&nbsp;&nbsp;&nbsp;Programming
](https://link.springer.com/book/10.1007/978-1-4842-5287-1)

&nbsp;&nbsp;&nbsp;[HD44780U (LCD-16x2)](https://www.sparkfun.com/datasheets/LCD/HD44780.pdf)

&nbsp;&nbsp;&nbsp;[BCM2835 ARM Peripherals](https://www.raspberrypi.org/app/uploads/2012/02/BCM2835-ARM-Peripherals.pdf)

&nbsp;&nbsp;&nbsp;[ARM1176JZF-S Technical Reference Manual](https://developer.arm.com/documentation/ddi0301/h?lang=en)

&nbsp;&nbsp;&nbsp;[Linux system Calls - ARM 32bit EABI](https://chromium.googlesource.com/chromiumos/docs/+/master/constants/syscalls.md#arm-32_bit_EABI)
</div>


<hr/>
</div>




















