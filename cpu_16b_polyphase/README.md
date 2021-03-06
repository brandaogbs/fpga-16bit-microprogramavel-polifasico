# Microprocessador 16bits Microprogramável Polifásico em FPGA

## Resumo
O atual projeto propõe a sintese de microprocessador com arquitetura de 16 bits de instruções polifásicas e micro-programavel em FPGA  (Field Programmable Gate Array) utilizando o kit de desenvolvimento DE1-SoC da Terasic, que apresenta um chip FPGA da Altera. A descrição do hardware será feita utilizando VHDL (Hardware Description Language).


## Implementação

### Implementação do Microprocessador

A Figura 2 (não consta :x olhar pdf) apresenta o diagrama funcional do microprocessador implementado em FPGA. O diagrama RTL é um  modelo de abstração de circuitos digitais síncronos focado no fluxo dos sinais entre os registradores e as operações realizadas sobre eles. Portanto, observando o diagrama RTL e possível observar todos os sinais contidos no processador implementado e seu fluxo dentro dos componentes definidos no projeto.

Os blocos verdes da Figura 2 sao componentes que desempenham funções específicas no microprocessador. A lista a seguir apresenta a função de cada um deles: 

* **CLOCK DIV:** 
divide o clock base do microprocessador, permitindo ajustar a frequencia de execução das 
operações. O divisor de clock propicia a escolha de frequências suficientemente pequenas para a execução
de testes e busca por erros no projeto.

* **CONTROLADOR PRIN:**
este bloco representa os controladores (principal e microprogramado) do microprocessador, executando as fases reset e de 1 a 5 e gerenciando as memorias principal e de microprograma. 
Seu funcionamento baseia-se na atualizac¸ao das fases e na identificação da fase atual, realizando as operações
entre barramentos, registradores e memoria de acordo com os sinais de controle ativos.

* **DISPLAY SEGS:**
o bloco dos displays 7 segmentos foi criado como uma interface entre o usuario e os registradores e barramentos do processador. Foram configurados um total de 6 displays, que exibem os valores atuais dos barramentos de entrada e saída da ULA, a fase atual do controlador microprogramado e os registradores MPC e PC.

### Registradores e Barramentos

A primeira etapa do desenvolvimento do microcontrolador foi a definição dos registradores e barramentos internos e externos da maquina. Para a sua criação, foram utilizados sinais e variaveis, que são estruturas do VHDL que armazenam informações. Um exemplo de definição de sinal e a criação do sinal equivalente ao registrador MPC: 

`SIGNAL MPC: STD LOGIC VECTOR ( 9 DOWNTO 0 ) ;`

Na definição e fornecido um nome para o sinal, seu tipo e tamanho, já que o sinal em questão se trata de um vetor de 10 posições. Vale ressaltar que da maneira como foi definido, `MPC(9)` seria o bit mais significativo do vetor, enquanto
`MPC(0)` carrega o bit menos significativo.

A declaração de uma variável  é semelhante à de um sinal, seguindo a seguinte sintaxe para a definição do registrador 
R1:

`VARIABLE R1 : STD LOGIC VECTOR ( 1 5 DOWNTO 0 ) ;`

Os sinais e variaveis foram definidos como vetores de  bits, do tipo STD LOGIC, com o tamanho segundo o projeto da arquitetura da maquina. Além disto, os registradores que são necessários em diversas partes do código do processador foram definidos como globais. A Tabela I contem a lista completa dos registradores implementados, apresentando seu nome, seu tamanho e sua func¸ao no processador. 

![Fig Tab1](http://prntscr.com/etdwi4)

Para a criac¸ao dos barramentos também foi escolhida a utilização de sinais. Foram definidos sinais com a mesma dimensão dos barramentos no projeto do processador. A Tabela II apresenta os barramentos implementados, acompanhando seu nome, tamanho e função.

![Fig Tab2](http://prntscr.com/etdx2w)

### Fases do Controlador Microprogramável

Na arquitetura implementada, o controlador microprogramado possui 5 fases de operac¸ao. Cada fase está vinculada a sinais de controle específicos, que correspondem a movimentos e operações básicas nos registradores e barramentos de todo o processador. A Tabela III apresenta quais são as fases de operac¸ao do controlador microprogramado, trazendo também a função de cada fase e os sinais de controle vinculados a ela.

![Fig Tab3](http://prntscr.com/etdxoj)

As fases do controlador microprogramado foram implementadas em VHDL com uma maquina de estados. Foram efinidos 5 estados diferentes correspondentes as fases, controlados pelos sinais CURRENT FASE e NEXT FASE que indicam, respectivamente, a fase atual e a proxima fase. 

Projetou-se uma logica para que a fase seja atualizada após o teste de todos os sinais de controle, executando suas respectivas ações quando eles estiverem ativos. Para a implementação da máquina de estados, foi utilizada a estrutura de controle de fluxo CASE. O uso desta estrutura na definição na máquina de estados pode ser observado no seguinte trecho de codigo: 

```
CASE CURRENT_FASE IS
  WHEN F_RESET => NEXT_FASE <= F_1 ;
  WHEN F_1 => NEXT_FASE <= F_2 ;
  WHEN F_2 => NEXT_FASE <= F_3 ;
  WHEN F_3 => NEXT_FASE <= F_4 ;
  WHEN F_4 => NEXT_FASE <= F_5 ;
  WHEN F_5 =>
    IF ( SC ( 24) = ’ 1 ’ ) THEN
      NEXT_FASE <= F_4 ;
    ELSE
      NEXT_FASE <= F_1 ;
    END IF ;
END CASE;
```
Para a atualizac¸ao da fase, e atribuida ao sinal NEXT FASE o valor da proxima fase, definido como  F_x, em que x e o numero da fase. Uma rotina chamada de FASE_CHANGE é responsavel por atribuir o valor de NEXT_FASE para CURRENT_FASE, habilitando a sequencia de teste e execução dos sinais de controle da fase atual. O diagrama da Figura 1 apresenta a logica de mudança das fases do microprocessador.

![Fig 1](http://prntscr.com/etdziy)

Uma fase extra definida por F_RESET e responsável por configurar todos os registradores, barramentos e memorias após o início ou reset do microprocessador.

### Memórias

As memorias de microprograma e principal foram definidas como variaveis bidimensionais, chamadas respectivamente de MEM MICRO e MEM PRIN. Ao vetor MEM_MICRO foi atribuído o tamanho de 24 bits para os dados e 18 enderec¸os diferentes, totalizando 108 bytes para a micromemoria. Já para  MEMP_RIN foi atribuído o tamanho de 16 bits para os dados em 50 endereços diferentes, totalizando 200 bytes.
Para os testes inicias, a memoria de microprograma foi preenchida com o ciclo de busca, a tabela de jumps e os codigos para a instruções LOAD, STORE e ADD. A Tabela IV apresenta os enderec¸os da memoria de microprograma e o conteudo guardado em cada posição da memória.

![Fig Tab4](http://prntscr.com/ete0zc)

No caso da memoria principal, foram preenchidos apenas os 10 primeiros endereços, contendo uma rotina simples para teste das instruções implementadas. A Tabela V apresenta os endereços da memoria principal e o conteído guardado nas posições que foram preenchidas.

![Fig Tab4](http://prntscr.com/ete1gn)
