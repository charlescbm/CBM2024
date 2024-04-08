/*
Diretiva: #INCLUDE  

A diretiva #INCLUDE indica em que arquivo de extensao *.CH (padrao ADVPL) estao os UDCs
a serem utilizados pelo pre-processador.
A aplicacao ERP possui diversos includes, os quais devem ser utilizados segundo a aplicacao
que sera desenvolvida, o que permitira a utilizacao de recursos adicionais definidos para a
linguagem, implementados pela area de Tecnologia da Microsiga.
Os includes mais utilizados nas aplicacoes ADVPL desenvolvidas para o ERP sao:
 
PROTHEUS.CH: diretivas de compilacao padroes para a linguagem. Contem a
especificacao da maioria das sintaxes utilizadas nos fontes, inclusive permitindo a
compatibilidade da sintaxe tradicional do Clipper para os novos recursos implementados
no ADVPL.

O include PROTHEUS.CH ainda contem a referencia a outros includes utilizadas pela
linguagem ADVPL que complementam esta funcionalidade de compatibilidade com a
sintaxe Clipper, tais como:
o DIALOG.CH
o FONT.CH
o INI.CH
o PTMENU.CH
o PRINT.CH    

A utilizacao do include protheus.ch nos fontes desenvolvidos para a
aplicacao ERP Protheus e obrigatoria e necessaria ao correto funcionamento das aplicacoes.
 
AP5MAIL.CH: Permite a utilizacao da sintaxe tradicional na definicao das seguintes
funcoes de envio e recebimento de e-mail:
o CONNECT SMTP SERVER
o CONNECT POP SERVER
o DISCONNECT SMTP SERVER
o DISCONNECT POP SERVER
o POP MESSAGE COUNT
o SEND MAIL FROM
o GET MAIL ERROR
o RECEIVE MAIL MESSAGE
 
TOPCONN.CH: Permite a utilizaco da sintaxe tradicional na definido das seguintes
funcoes de integracao com a ferramenta TOPCONNECT (MP10 Totvs DbAcess):
o TCQUERY  

TBICONN.CH: Permite a utilizacao da sintaxe tradicional na definicao de conexoes com
a aplicacao Server do ambiente ERP, atraves da seguintes sintaxes:
o CREATE RPCCONN
o CLOSE RPCCONN
o PREPARE ENVIRONMENT
o RESET ENVIRONMENT
o OPEN REMOTE TRANSACTION
o CLOSE REMOTE TRANSACTION
o CALLPROC IN
o OPEN REMOTE TABLES

XMLXFUN.CH: Permite a utilizacao da sintaxe tradicional na manipulacao de arquivos e
strings no padrao XML, atraves das seguintes sintaxes:
o CREATE XMLSTRING
o CREATE XMLFILE
o SAVE XMLSTRING
o SAVE XMLFILE
o ADDITEM TAG
o ADDNODE NODE
o DELETENODE
*/  

#include "rwmake.ch" //biblioteca mais antiga que permite compatibilidade com programas mais antigos
#include "totvs.ch"//biblioteca rerente a diversa funcoes de relatorio e telas
#include "protheus.ch" //biblioteca rerente a diversa funcoes de relatorio e telas
#include "topconn.ch" //biblioteca refente a funcoes de banco de dados
       


/*Nessa area colocasse uma Documentacao de Cabecalho
Isso venha a ser uma boa pratica de programacao onde devemos inserir informacoes basicas do programa
como autor, data de criacao, nome do programa, descricao breve do que sera o programa, qual o modulo, etc...  */

/*
+----------------------------------------------------------------------------+
!                         FICHA TECNICA DO PROGRAMA                          !
+----------------------------------------------------------------------------+
!   DADOS DO PROGRAMA                                                        !
+------------------+---------------------------------------------------------+
!Tipo              ! Relat�rio                                               !
+------------------+---------------------------------------------------------+
!Modulo            ! GPE - Gest�o de Pessoal                                 !
+------------------+---------------------------------------------------------+
!Nome              ! BGPER008                                                !
+------------------+---------------------------------------------------------+
!Descricao         ! Relat�rio Funcion�rios                                  !
+------------------+---------------------------------------------------------+
!Autor             ! FERNANDO SIMOES DA MAIA                                 !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 15/10/2013                                              !
+------------------+---------------------------------------------------------+
*/

/*
 Funcao principal do Programa
*/
User Function BGPER008()

/*Declaracao de variaveis, podem ser:
 Local : Variaveis de escopo local s�o pertencentes apenas ao escopo da funcao onde foram declaradas
         e devem ser explicitamente declaradas com o identificador LOCAL
 
 Static: Variaveis de escopo static funcionam basicamente como as variaveis de escopo local, mas
         mantem seu valor atraves da execucao e devem ser declaradas explicitamente no codigo com o identificador STATIC

 Private: Uma vez criada, uma variavel privada continua a existir e mantem seu valor ate que o programa ou funcao onde foi criada termine (ou seja,
          ate que a funcao onde foi criada retorne para o codigo que a executou)
          
 Public: As variaveis deste escopo continuam a existir e mantem seu valor ate o fim da execucao da thread (conexao)
*/
Private oReport  // declaracao de variavel do tipo objeto que recebera a instancia da classe TREPORT     
Private cPerg   := PADR("BGPER008",10)   //Recebe o nome da pergunta que sera colocada no SX1 no campo X1_GRUPO, onde este indica o grupo de perguntas que sera usado no programa
                                       //Funcao PADR(): http://tdn.totvs.com/pages/viewpage.action?pageId=24347023
                                       
Private aOrd:= {"Matricula" , "Nome" } //Array contendo as opcoes de ordenacao
Private cAlias := GetNextAlias() //o cAlias recebe um nome de uma tabela temporaria sequencial sem precisar especificar por exemplo uma TRB, evitando assim a possibilidade de ter um erro de alias em uso. 
                                 //entao toda a vez que rodar essa rotina o nome da tabela temporaria que sera armazenado a query sera diferente.  

Private cOrdem := "" //variavel do tipo string que recebera o conteudo do ORDER BY no SQL para realizar a ordenacao. 
 
oReport := ReportDef(cPerg) //ReportDef, funcao que implementa o layout, estrutura do relatorio.


U_BCFGA002("BGPER008")//Grava detalhes da rotina usada, o programa BCFGA002 e um programa customizado

BGPER08B(cPerg) //executa a funcao BGPER08B, onde esta faz a criacao do grupo de perguntas no SX1.
         

/*
PERGUNTE()

A funcao PERGUNTE() inicializa as variaveis de pergunta (mv_par01,�) baseada na pergunta cadastrado no Dicionario de Dados (SX1). Se o parametro lAsk nao for especificado ou for verdadeiro sera exibida a tela para edicao da pergunta e se o usuario confirmar as variaveis serao atualizadas e a pergunta no SX1 tambem sera atualizada.

Sintaxe: Pergunte( cPergunta , [lAsk] , [cTitle] )

Parametros:

cPergunta: Pergunta cadastrada no dicionario de dados ( SX1) a ser utilizada.

Ask:       Indica se exibira a tela para edicao.

cTitle:    Titulo do dialogo.

Retorno: Logico Indica se a tela de visualizacao das perguntas foi confirmada (.T.) ou cancelada (.F.)
*/
If Pergunte(cPerg,.T.)
	oReport:PrintDialog()
EndIf

Return  


//Funcao que ira fazer a montagem do Layout/Estrutura do Relatorio 
Static Function ReportDef(cPerg)
//Local oReport
Local oSection1 //declaracao de variavel do tipo objeto que sera instanciada da classe TSECTION para criacao de uma secao no relatorio.
Local cTitulo := "Relatorio de Funcionarios" //declaracao e inicializacao da variavel string que recebera o titulo do relatorio
Local aTabelas:= {"SRA", "SRJ", "CTT"}//declaracao e inicializacao da variavel do tipo array que recebera as tabelas que serao utilizadas neste relatorio



//Nesta area esta sendo efetuado a inicializacao da variavel do tipo objeto oReport que esta sendo instanciado da classe TREPORT
oReport:= TReport():New("BGPER008",cTitulo,cPerg,{|oReport| PrintReport(oReport)},cTitulo)//New: metodo construtor da classe TReport
                                                                                         //Documentacao: http://tdn.totvs.com/display/public/mp/New 

oReport:SetLandscape()//Metodo SetLandScape: usuado para definir um padrao na inicializacao da propriedade Retrato/Paisagem do relatorio
                      //Documentacao: http://tdn.totvs.com/display/public/mp/SetLandscape
                       
oReport:SetTotalInLine(.F.) //Metodo SettotalInLine: define se serao impressos os totalizadores em linha ou coluna
                            //Documentacao: http://tdn.totvs.com/display/public/mp/SetTotalInLine
                   

/*
Propriedades da Classe TReport:

aBreak	Array com todas as quebras totalizadoras do relat�rio. Elemento: 1-Objeto TRBreak.
aCollection		Array com todos totalizadores do tipo TRCollection do relat�rio. 
Elemento: 1-Objeto TRCollection.
aCustomText		Array contendo a customiza��o para impress�o do cabe�alho padr�o. 
Elementos: 1=Texto a ser impresso, no qual, um elemento por linha. Existem algumas strings que pode auxiliar na cria��o do cabe�alho:
	__NOLINEBREAK__ - N�o quebra linha
	__NOTRANSFORM__ - Imprime sem nenhum tratamento
	__LOGOEMP__ - Imprime o logo da empresa
	__FATLINE__ - Imprime um linha grossa
	__THINLINE__ - Imprime uma linha fina
aBmps	Array com as imagens dos gr�ficos enviadas por email. Elemento: 1- Caminho da imagem.
aFontSize	Array com as fontes do sistema. Elementos: 1-Fonte, 2-Tamanho, 3- Tamanho em pixel.
aFunction		Array com todos totalizadores do tipo TRFunction do relat�rio. 
Elemento: 1-Objeto TRFunction.
aHeaderPage		Array com todas as se��es que imprimem cabe�alho no topo da p�gina.
aSection		Array com todas as se��es do relat�rio. Elemento: 1-Objeto TRSection.
bAction		            Bloco de c�digo executado quando o usu�rio confirmar a impress�o do relat�rio.
bCustomText		Bloco de c�digo para atualiza��o da propriedade aCustomText.
bOnNumberPage	Bloco de c�digo para atualiza��o do n�mero da p�gina atual.
bOnPageBreak	Bloco de c�digo para tratamentos na inicializa��o de cada p�gina.
bTotal			Compatibilidade - N�o utilizado.
bTotalCanPrint 	Bloco de c�digo utilizado para validar a impress�o dos totalizadores.
bTotalPos		Bloco de c�digo utilizado para localizar a posi��o do totalizador a ser impresso.
bTotalPrint		Bloco de c�digo utilizado para imprimir os totalizadores.
bTotalReset		Bloco de c�digo utilizado para limpar os totalizadores.
bTotalRSize		Bloco de c�digo utilizado para definir o tamanho das Collections.
bTotalText		Bloco de c�digo utilizado na impress�o do texto do totalizador.
cClassName		Nome da classe. Exemplo: TREPORT.
cDate			Data da impress�o do relat�rio.
cDescription		Descri��o do relat�rio.
cDir			Diret�rio selecionado para gera��o do relat�rio.
cEmail			E-mail utilizado na gera��o do relat�rio via e-mail.
cFontBody		Fonte definida para impress�o do relat�rio.
cFile			Nome do arquivo que ser� gerado.
cID			ID do component. Exemplo: TREPORT.
cLogo			Logo da empresa/filial.
cMsgPrint		Mensagem apresentada durante a gera��o do relat�rio.
cPrinterName		Nome da impressora selecionada para impress�o.
cReport		Nome do relat�rio. Exemplo: MATR010.
cTime			Hora da impress�o do relat�rio.
cTitle			T�tulo do relat�rio.
cRealTitle		T�tulo padr�o do relat�rio definido pelo criador do relat�rio.
cUserObs		Observa��o do usu�rio.
cXlsTHStyle		Estilo do cabe�alho padr�o utilizado na gera��o da planilha.
cXlsSHStyle		Estilo do cabe�alho utilizado na gera��o da planilha.
cXmlDefault		Arquivo XML contendo Informa��es do relat�rio padr�o.
cXlsFile		Nome do arquivo que ser� gerado em planilha.
lBold			Aponta que as Informa��es ser�o impressas em negrito.
lCanceled		Aponta que o relat�rio foi cancelado.
lClrBack		Define que a cor de fundo dever� ser atualizada.
lClrFore		Define que a cor da fonte dever� ser atualizada.
lDisableOrientation	Orienta��o (Retrato/Paisagem) n�o poder� ser modificada.
lDynamic	Aponta que o relat�rio � din�mico, permitindo imprimir as se��es conforme a ordem de impress�o selecionada.
lEdit			Relat�rio n�o poder� ser configurado pelo usu�rio.
lEnabled		Impress�o do relat�rio foi desabilitada.
lEmptyLineExcel	Suprime as linhas em branco e os totais na gera��o em planilha.
lFooterVisible		Habilita a impress�o do rodap�.
lFunctionBefore	Imprime os totalizadores do tipo TRFunction antes dos totalizadores do tipo TRCollecions.
lHeaderVisible		Habilita a impress�o do cabe�alho.
lItalic			Aponta que as informa��es ser�o impressas em it�lico.
lOnPageBreak		Cabe�alho das se��es impressas ap�s a quebra de p�gina.
lPageBreak		Quebra p�gina antes da impress�o dos totalizadores.
lParamPage		Existe par�metros para impress�o.
lParamReadOnly	Par�metros n�o poder�o ser alterados pelo usu�rio.
lPixColSpace		Espa�amento das colunas ser�o calculadas em pixel.
lPreview		Visualiza��o do relat�rio antes da impress�o f�sica.
lPrinting		Relat�rio esta em processo de impress�o.
lPrtParamPage		Aponta que ser�o impressos os par�metros do relat�rio.
lStartPage		Aponta que uma nova p�gina dever� se inicializada.
lTotalInLine		Imprime as c�lulas no formato linha.
lTPageBreak		Quebra p�gina ap�s a impress�o do totalizador.
lUnderline		Aponta que as Informa��es ser�o impressas sublinhadas.
lUserAccess		Valida permiss�o para gera��o dos gr�ficos do relat�rio.
lUserInfo		Imprime Informa��es do usu�rio na p�gina de par�metros.
lUserFilter		Permite a utiliza��o de filtros na personaliza��o do relat�rio.
lXlsHeader		Imprime informa��es do cabe�alho padr�o na gera��o em planilha.
lNoPrint		Aponta que nenhuma informa��o foi impressa.
lXmlEndRow		Aponta fim de linha na gera��o em planilha.
lXlsParam		Aponta a exist�ncia de par�metros na gera��o em planilha.
lEndReport		Imprime total geral do relat�rio.
nBorderDiff		Tamanho da borda utilizado para c�lculo da altura de uma linha.
nClrBack		Cor de fundo.
nClrFore		Cor da fonte.
nCol			Coluna posiciona na impress�o.
nColSpace		Espa�amento entre as colunas.
nDevice	Tipo de impress�o selecionado. Op��es: 1-Arquivo,2-Impressora,3-email,4-Planilha e 5-Html.
nEnvironment		Ambiente selecionado. Op��es: 1-Server e 2-Cliente.
nFontBody		Tamanho da fonte definida para impress�o do relat�rio.
nHeaderDiff		Tamanho do cabe�alho utilizado para c�lculo do altura da p�gina.
nLeftMargin		Tamanho da margem a esquerda.
nLineHeight		Altura da linha.
nLogPxYDiff		Utilizado no c�lculo para gera��o da visualiza��o do relat�rio.
nLogPxXDiff		Utilizado no c�lculo para gera��o da visualiza��o do relat�rio.
nMeter			Posi��o da r�gua de progress�o.
nOrder			Ordem de impress�o selecionada.
nPageWidth		Largura da p�gina.
nPxColSpace		Espa�amento da coluna em pixel.
nPxBase		Tamanho da  base em pixel.
nPxDate		Tamanho da  sistema operacional em pixel.
nPxLeftMargin		Tamanho da margem a esquerda em pixel.
nPxPage		Tamanho da numera��o da p�gina em pixel.
nPxTitle		Tamanho do t�tulo em pixel.
nRemoteType	Aponta de que forma o Server est� gerando o relat�rio. Op��es:  1-Sem Remote, 2-Remote Delphi,3-Remote Windows e 4-Remote Linux.
nRow			Linha posicionada na impress�o.
nXlsCol		Coluna posicionada na gera��o em planilha.
nXlsRow		Linha posicionada na gera��o em planilha.
nXlsStyle		Estilo utilizado na gera��o em planilha.
nExcel			N�mero do arquivo na gera��o em planilha.
nColumnPos		Posicionamento no arquivo gerado em planilha.
oBrdBottom		Objeto TRBorder com a borda Inferior .
oBrdLeft		Objeto TRBorder com a borda � esquerda.
oBrdRight		Objeto TRBorder com a borda � direita.
oBrdTop		Objeto TRBorder com a borda superior.
oHBrdBottom		Objeto TRBorder com a borda Inferior no cabe�alho.
oHBrdLeft		Objeto TRBorder com a borda � esquerda no cabe�alho.
oHBrdRight		Objeto TRBorder com a borda � direita no cabe�alho.
oHBrdTop		Objeto TRBorder com a borda superior no cabe�alho.
oClrBack		Objeto TBrush com a cor de Fundo.
oFontBody		Objeto TFont com a fonte do relat�rio.
oFontHeader		Objeto TFont com a fonte do cabe�alho.
oMeter			Objeto TMeter com a r�gua de progress�o.
oMsg			Objeto TSAY com a mensagem apresentada durante a impress�o do relat�rio.
oPage			Objeto TRPage com a configura��o da p�gina de impress�o.
oParamPage		Objeto TRParamPage com a configura��o da p�gina de par�metros.
oPrint			Objeto TMSPrinter.
oReport		Componente de impress�o.
oXlsCell		Compatibilidade - N�o utilizado.
oXlsRow		Compatibilidade - N�o utilizado.
oXlsStyles		Compatibilidade - N�o utilizado.
oXlsWorksheet	Compatibilidade - N�o utilizado.
uParam		Par�metros do relat�rio cadastrado no Dicion�rio de Perguntas (SX1).
Tamb�m pode ser utilizado bloco de c�digo para par�metros customizados.

*/
oReport:nFontBody := 8 //Propriedade nFontBody: define o tamanho da fonte utilizado no relatorio
oReport:ShowHeader() //Metodo que define que sera impresso o cabe�aalho do relatorio.
      
      
 /*Definicao da Sessao do relatorio
 Propriedades:

aCell			Array contendo as c�lulas da se��o. Elemento: 1-Objeto TRCell.
aCellPos		Array contendo as c�lulas reposicionadas da se��o. Elemento: 1-Objeto 
TRCell.
aFilter			Array  contendo os filtros da se��o: Elementos: 1-Tabela, 2-Filtro, 3-
 Chave de �ndice, 4-Ordem.
aOrder			Array contendo as ordens do relat�rio: Elementos: 1-Objeto TROrder.
aPosCell		Array com as c�lulas da se��o na ordem de impress�o.
aTable			Array com as tabelas utilizadas na se��o.
aTCFields	Array com os campos que possuem o tipo de dados diferente de caracter e que devem ser tratados para apresentar os resultados na query. Elementos: 1-Campo, 2-Tipo, 3- Tamanho e 4-Decimal.
aTCMemo		Array com os campos do tipo de dados Memo a serem desconsiderados na query.
aTCTables		Array com as tabelas utilizadas na query.
aLoadCells	Array com as tabelas que executaram o carregamento de Informa��es das c�lulas atrav�s do Dicion�rio de Dados (SX3).
aUserFilter	Array  com os filtros de usu�rios: Elementos: 1-Tabela, 2-Express�o ADVPL, 3-Express�o SQL e 4-Filtro adicionado na query principal.
aNoFilter		Array com as tabelas que n�o poder�o aplicar filtros de usu�rio. Elemento: 1-Tabela.
aSection		Array com as se��es filhas. Elemento: 1-Objeto TRSection.
bCompQuery	Bloco de c�digo utilizado na montagem  da query atrav�s de compila��o em tempo real.
bLineCondition	Bloco de c�digo utilizado na valida��o do registro.
bOnPrintLine	Bloco de c�digo com os tratamentos a serem realizados antes da impress�o do registro da se��o.
bParentFilter		Bloco de c�digo com a regra para sa�da do loop.
bParentParam	Bloco de c�digo com a express�o que retorna o valor que � enviado como par�metro para a regra de sa�da do loop da se��o.
bRealQuery		Bloco de c�digo utilizado para montar a query da se��o.
cAlias			Tabela principal da se��o.
cAdvplExp		Filtro do usu�rio em forma de express�o ADVPL.
cDynamicKey		Chave que identifica a se��o na impress�o din�mica.
cFilter			Filtro da tabela principal da se��o.
cIdxFile		Indice tempor�rio utilizado na filtro da tabela principal.
cName			Nome da se��o.
cQuery			Query da se��o com os tratamentos de adi��o de campos e filtros.
cRealFilter		Filtro da tabela principal da se��o.
cRealQuery		Query sem os tratamentos de adi��o de campos e filtros.
cCharSeparator	Caracter que separa as Informa��es na impress�o em linha.
cSqlExp		Filtro do usu�rio em forma de express�o SQL.
lAutoSize		Ajusta o tamanho das c�lulas para que caiba em uma p�gina.
lCellPos		Ajusta o cabe�alho das c�lulas.
lChangeQuery		Tratamento para utilizar a query em diversos Banco de Dados.
lChkFilters		Compatibilidade - N�o utilizado.
lEdit			Aponta se a se��o poder� ser personalizada pelo usu�rio.
lEditCell		Aponta se o usu�rio poder� personalizar as c�lulas da se��o.
lForceLineStyle	For�a a impress�o em linha.
lHeaderBreak		Imprime cabe�alho da se��o na quebra de impress�o (TRBreak).
lHeaderPage		Imprime cabe�alho da se��o no topo da p�gina.
lHeaderSection	Imprime cabe�alho da se��o na quebra de se��o.
lIdxOrder		Utiliza ordem do Dicion�rio de �ndices (SIX) na impress�o da se��o.
lInit			Aponta que a impress�o da se��o n�o foi iniciada.
lInitFilter		Aponta que os filtros da se��o n�o foram iniciados.
lLineBreak	Aponta que a impress�o da se��o quebra linhas no caso das colunas n�o couberem em uma linha.
lLineStyle		Impress�o em linhas.
lSkipped		Aponta que a se��o saltou o registro da se��o pai.
lParentQuery		Utiliza Informa��es da query da se��o pai para impress�o dos registros.
lParentRecno		Utiliza Informa��es do registro da se��o pai.
lPrintHeader		Aponta impress�o do cabe�alho da se��o.
lPrintLayout		Aponta que � impress�o de visualiza��o do layout.
lReadOnly		Define se o usu�rio pode personalizar informa��es da se��o.
lTCFields	Define que dever� ser efetuado tratamento na query de campos com tipo de dado diferente de caracter.
lVisible			Aponta que a se��o ser� impressa.
lUserVisible		Aponta que a se��o ser� impressa na personaliza��o do usu�rio.
lCellUseQuery		Utiliza query na impress�o de c�lulas da se��o.
nCols			Quantidade de colunas a serem impressas.
nIdxOrder		Indice utilizado na impress�o da se��o.
nLineCount		Quantidade de linhas a serem impressas para o registro.
nLinesBefore		Quantidade de linhas a serem saltadas antes da impress�o da se��o.
nOrder			Ordem de impress�o da se��o.
nPercentage		Percentual da largura da p�gina a ser considerada.
nRow			Linha posicionada na impress�o da se��o.
nWidth			Largura da se��o.
oCBrdBottom		Objeto TRBorder com a borda Inferior.
oCBrdLeft		Objeto TRBorder com a borda � esquerda.
oCBrdRight		Objeto TRBorder com a borda � direita.
oCBrdTop		Objeto TRBorder com a borda superior.
oParent		Se��o pai.
oRelation		Objeto TRRelation com informa��es do relacionamento entre as se��es.

 */        
 
 /* 
Metodo construtor da classe TRSection.

New(oParent,cTitle,uTable,aOrder,lLoadCells,lLoadOrder,uTotalText,lTotalInLine,lHeaderPage,lHeaderBreak,lPageBreak,lLineBreak,nLeftMargin,lLineStyle,nColSpace,lAutoSize,cCharSeparator,nLinesBefore,nCols,nClrBack,nClrFore,nPercentage)

oParent	        Objeto da classe TReport ou TRSection que ser� o pai da classe TRSection
cTitle		    T�tulo da se��o
uTable		    Tipo Caracter: Tabela que ser� utilizada pela se��o
Tipo Array:     Lista de tabelas que ser�o utilizadas pela se��o
aOrder	        Array contendo a descri��o das ordens. Elemento: 1-Descri��o, como por exemplo, Filial+C�digo
lLoadCells	    Carrega os campos do Dicion�rio de Campos (SX3) das tabelas da se��o como c�lulas
lLoadOrder	    Carrega os �ndices do Dicion�rio de �ndices (SIX)
uTotalText	    Texto do totalizador da se��o, podendo ser caracter ou bloco de c�digo
lTotalInLine	Imprime as c�lulas em linha
lHeaderPage	    Cabe�alho da se��o no topo da p�gina
lHeaderBreak	Imprime cabe�alho na quebra da se��o
lPageBreak	    Imprime cabe�alho da se��o na quebra de p�gina
lLineBreak	    Quebra a linha na impress�o quando as Informa��es n�o caber na p�gina
nLeftMargin	    Tamanho da margem � esquerda da se��o
lLineStyle	    Imprime a se��o em linha
nColSpace	    Espa�amento entre as colunas
lAutoSize	    Ajusta o tamanho das c�lulas para que caiba em uma p�gina
cCharSeparator	Define o caracter que separa as Informa��es na impress�o em linha
nLinesBefore	Aponta a quantidade de linhas a serem saltadas antes da impress�o da se��o
nCols		    Quantidade de  colunas a serem impressas
nClrBack	    Cor de fundo das c�lulas da se��o
nClrFore	    Cor da fonte das c�lulas da se��o
nPercentage	    Tamanho da p�gina a ser considerada na impress�o em percentual


 */
           //TRSection():New( < oParent > , [ cTitle ] , [ uTable ] , [ aOrder ] , [ lLoadCells ] , [ lLoadOrder ] ) 
oSection1 := TRSection():New(   oReport   ,   cTitulo  ,  aTabelas  ,     aOrd   ,       .F.      ,        .F.     )  
oSection1:SetTotalInLine(.F.)//Metodo SettotalInLine: define se serao impressos os totalizadores em linha ou coluna
                            //Documentacao: http://tdn.totvs.com/display/public/mp/SetTotalInLine


    
/*
Celula de impressao de uma secao (TRSection) de um relatorio que utiliza a classe TReport.

Esta classe herda as propriedades e metodos da classe TRSECTION.

Propriedades:

aCBox     	 Array com os poss�veis textos a serem impressos na c�lula. Elemento: 1- Conte�do. Exemplo: 1=Sim.
aFormatCond	 Array com as condi��es do usu�rio para impress�o de forma vari�vel da cor da c�lula: Elementos: 1-Condi��o, 2-Cor de fundo e 3-Cor da fonte.
bCanPrint 	 Bloco de c�digo que valida a impress�o da c�lula.
bCellBlock	 Bloco de c�digo que retornar� o conte�do de impress�o da c�lula.
cFormula	 F�rmula para impress�o da c�lula.
cOrder		 Ordem de impress�o da c�lula.
cPicture	 M�scara da c�lula.
cRealFormula F�rmula em forma de express�o ADVPL.
cType		 Tipo de dado da c�lula.
cUserFunctionTipo de acumulador: "MIN" - Menor valor, "MAX" - Maior valor, "SUM" - Soma, "COUNT" - Contador ou "AVERAGE" - M�dia.
cXlsHStyle	 Estilo do cabe�alho padr�o utilizado na gera��o da planilha.
cXlsStyle	 Estilo utilizado na gera��o da planilha.
lBold		 Aponta que a c�lula ser� impressa em negrito.
lHeaderSize	 Aponta que o tamanho a ser considerado na impress�o � do cabe�alho.
lPixelSize	 Aponta que o tamanho da c�lula est� calculada em pixel.
lPrintCell	 Aponta que a c�lula est� habilitada para impress�o.
lCellBreak	 Compatibilidade - N�o utilizado.
lUserEnabled Aponta que a c�lula foi habilitada para impress�o pelo usu�rio.
lUserField	 Aponta que a c�lula foi personalizada pelo usu�rio.
lUserAccess	 Aponta que o usu�rio tem acesso a impress�o desta c�lula, no caso de falso, o usu�rio n�o possui o n�vel de campo ou acesso definido no cadastro de usu�rios.
nAlign		 Alinhamento da c�lula. 1-Esquerda, 2-Center ou 3-Direita.
nAutoWidth	 Largura gerada automaticamente quando excedida a largura da p�gina.
nCellPixel	 Largura da c�lula em pixel.
nHeaderAlign Alinhamento do cabe�alho 1-Esquerda, 2-Center ou 3-Direita.
nHeaderPixel Tamanho do cabe�alho da c�lula em pixel.
nHeaderSize	 Tamanho do cabe�alho da c�lula.
nLineStart	 Aponta a primeira linha da c�lula a ser impressa no caso de quebra de linha.
nNegative	 N�mero do item de sinal negativo no array aNegative.
nPixelSize	 Tamanho da c�lula em pixel.
nRowDiff	 Quantidade de linhas a serem consideradas na impress�o das bordas.
nSize		 Tamanho da c�lula.
nType		 Tipo da c�lula. 1-Celula, 2-Formula, 3-Acumulador ou 4-C�lula de usu�rio.
nUserValue	 Auxilia no controle do totalizador do tipo MAX e MIN.
nUserCount	 Contador de itens impressos quando utilizado totalizadores.
nLevel		 N�vel de campo da c�lula.
uValue		 Valor da c�lula a ser impresso.
uPrint		 Conte�do da c�lula a ser impresso.
oFontBody	 Objeto TFont com Informa��es da fonte da c�lula.
     

Metodo construtor da classe TRCell:
New(oParent,cName,cAlias,cTitle,cPicture,nSize,lPixel,bBlock,cAlign,lLineBreak,cHeaderAlign,lCellBreak,nColSpace,lAutoSize,nClrBack,nClrFore,lBold)

oParent	Objeto da classe TRSection que a c�lula pertence
cName		Nome da c�lula
cAlias		Tabela utilizada pela c�lula
cTitle		T�tulo da c�lula
cPicture	M�scara da c�lula
nSize		Tamanho da c�lula
lPixel		Aponta se o tamanho foi informado em pixel
bBlock		Bloco de c�digo com o retorno do campo
cAlign		Alinhamento da c�lula. "LEFT", "RIGHT" e "CENTER"
lLineBreak	Quebra linha se o conte�do estourar o tamanho do campo
cHeaderAlignAlinhamento do cabe�alho da c�lula. "LEFT", "RIGHT" e "CENTER"
lCellBreak	Compatibilidade - N�o utilizado
nColSpace	Espa�amento entre as c�lulas
lAutoSize	Ajusta o tamanho da c�lula com base no tamanho da p�gina e as Informa��es impressas
nClrBack	Cor de fundo da c�lula
nClrFore	Cor da fonte da c�lula
lBold		Imprime a fonte em negrito


*/
  
//Definicao das colunas que serao impressas no relatorio:
//TRCell():New(oSection1,cName          ,cAlias, cTitle      ,cPicture        ,nSize ,lPixel,bBlock,cAlign  ,lLineBreak,cHeaderAlign,lCellBreak,nColSpace,lAutoSize,nClrBack,nClrFore,lBold)
TRCell():New(oSection1,"FILIAL"         ,"SRA" , "Filial"    ,                ,  10  ,.F.   ,      ,"CENTER",  .F.     , "CENTER"   ,          ,   1     ,    .F.  ,        ,        ,     )
TRCell():New(oSection1,"MATRICULA"      ,"SRA" , "Mat"       ,                ,  20  ,.F.   ,      ,"CENTER",  .F.     , "CENTER"   ,          ,   1     ,    .F.  ,        ,        ,     )
TRCell():New(oSection1,"NOME"           ,"SRA" , "Nome"      ,                ,  60  ,.F.   ,      ,"LEFT"  ,  .F.     , "LEFT"     ,          ,   1     ,    .F.  ,        ,        ,     )
TRCell():New(oSection1,"NASC"           ,"SRA" , "Nasc"      ,                ,  30  ,.F.   ,      ,"CENTER",  .F.     , "CENTER"   ,          ,   1     ,    .F.  ,        ,        ,     )
TRCell():New(oSection1,"RG"             ,"SRA" , "RG"        ,                ,  20  ,.F.   ,      ,"LEFT"  ,  .F.     , "LEFT"     ,          ,   1     ,    .F.  ,        ,        ,     )
TRCell():New(oSection1,"CPF"            ,"SRA" , "CPF"       ,                ,  30  ,.F.   ,      ,"LEFT"  ,  .F.     , "LEFT"     ,          ,   1     ,    .F.  ,        ,        ,     )
TRCell():New(oSection1,"CODFUNC"        ,"SRA" , "CodFunc"   ,                ,  13  ,.F.   ,      ,"CENTER",  .F.     , "CENTER"   ,          ,   1     ,    .F.  ,        ,        ,     )
TRCell():New(oSection1,"FUNCAO"         ,"SRJ" , "Funcao"    ,                ,  60  ,.F.   ,      ,"LEFT"  ,  .F.     , "LEFT"     ,          ,   1     ,    .F.  ,        ,        ,     )
TRCell():New(oSection1,"CC"             ,"SRA" , "CC"        ,                ,  13  ,.F.   ,      ,"CENTER",  .F.     , "CENTER"   ,          ,   1     ,    .F.  ,        ,        ,     )
TRCell():New(oSection1,"DESCR"          ,"CTT" , "Desc"      ,                ,  40  ,.F.   ,      ,"LEFT"  ,  .F.     , "LEFT"     ,          ,   1     ,    .F.  ,        ,        ,     )
TRCell():New(oSection1,"FONE"           ,"SRA" , "Fone"      ,                ,  40  ,.F.   ,      ,"CENTER",  .F.     , "CENTER"   ,          ,   1     ,    .F.  ,        ,        ,     )
TRCell():New(oSection1,"FATOR"          ,"SRA" , "Fator"     ,                ,  10  ,.F.   ,      ,"CENTER",  .F.     , "CENTER"   ,          ,   1     ,    .F.  ,        ,        ,     )


             
   
/*
SetBorder(uBorder,nWeight,nColor,lHeader)
Define as bordas da celula.

uBorder	Tipo Caracter: "TOP","BOTTOM","LEFT","RIGHT","ALL"
        Tipo Numerico: 1-Superior,2-Inferior,3-Esquerda,4-Direita,5-Todas
nWeight	Largura da borda
nColor 	Cor da borda
lHeader	Aponta se e borda de cabecalho

Retorno	Objeto do tipo TRBorder

*/   
//Definicao das bordas, nesse caso sera impressa uma borda na cor preta
//SetBorder(uBorder,nWeight,nColor,lHeader)
oSection1:Cell("FILIAL"   ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("MATRICULA"):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("NOME"     ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("NASC"     ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("RG"       ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("CPF"      ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("CODFUNC"  ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("FUNCAO"   ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)  
oSection1:Cell("CC"       ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("DESCR"    ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)   
oSection1:Cell("FONE"     ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("FATOR"    ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)


//Definicao das bordas, nesse caso NAO sera impressa a borda, ou seja, a borda vai ser ocultada.
//SetBorder(uBorder,nWeight,nColor,lHeader)
oSection1:Cell("FILIAL"   ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("MATRICULA"):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("NOME"     ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("NASC"     ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("RG"       ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("CPF"      ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("CODFUNC"  ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("FUNCAO"   ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)  
oSection1:Cell("CC"       ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("DESCR"    ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)   
oSection1:Cell("FONE"     ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("FATOR"    ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
  


/*
TRFUNCTION:

Totalizador de uma quebra, se��o ou relat�rio que utiliza a classe TReport.

Um totalizador pode executar uma das seguintes fun��es abaixo, utilizando como refer�ncia uma c�lula da se��o ou o retorno de uma f�rmula definida para ele:

SUM 		Somar
COUNT   	Contar
MAX 		Valor m�ximo
MIN	     	Valor m�nimo 
AVERAGE 	Valor m�dio
ONPRINT	    Valor atual
TIMESUM 	Somar horas
TIMEAVERAGE Valor medio de horas
TIMESUB 	Subtrai horas

Propriedades:

bCondition  	Bloco de c�digo com a condi��o de atualiza��o dos valores do totalizador.
bOnPrint    	Bloco de c�digo para tratamentos antes da impress�o do totalizador.
cFunction   	Fun��o que ser� utilizada pelo totalizador. Exemplo: SUM, COUNT, MAX, MIN.
lCollection 	Se verdadeiro, aponta que o totalizador � do tipo Collection.
lEndPage    	Se verdadeiro, aponta que o totalizador ser� impresso no final da p�gina.
lEndReport  	Se verdadeiro, aponta que o totalizador ser� impresso no final do relat�rio.
lEndSection 	Se verdadeiro, aponta que o totalizador ser� impresso no final da se��o.
lPageValue  	Se verdadeiro, aponta que � impress�o do total da p�gina.
lPrintLayout	Se verdadeiro, aponta que � visualiza��o do layout.
lReportValue	Se verdadeiro, aponta que � impress�o do total geral.
lSectionValue	Se verdadeiro, aponta que � impress�o do total da se��o.
lPrintCollection	Se verdadeiro, aponta que � impress�o de totalizador do tipo Collection.
nCount	    	Contador de registros impressos.
nCountPage  	Contador de registros impressos para a p�gina.
nCountReport	Contador geral de registros impressos.
nCountSection 	Contador de registros impressos para a se��o.
oCell	    	Objeto da classe TRCell que o totalizador se refere.
oTotal	    	Objeto da classe TRFunction ou TRCollection.
uFormula    	Tipo Caracter: Express�o ADVPL para macro execu��o.
                Tipo Bloco de codigo: Bloco de C�digo com a express�o ADVPL para execu��o.
uLastValue  	Ultimo valor atualizado no totalizador.
uPage	    	Total acumulado por p�gina.
uReport     	Total acumulado geral do relat�rio.
uSection    	Total acumulado por se��o.

     
Metodo construtor da classe TRFunction:

New(oCell,cName,cFunction,oBreak,cTitle,cPicture,uFormula,lEndSection,lEndReport,lEndPage,oParent,bCondition,lDisable,bCanPrint)

oCell		Objeto da classe TRCell que o totalizador se refere
cName		Identifica��o do totalizador
cFunction	Funcao que sera utilizada pelo totalizador. Exemplo: SUM, COUNT, MAX, MIN
oBreak		Objeto da classe TRBreak que define em qual quebra o totalizador ser� impresso
cTitle  	T�tulo do totalizador. Se n�o informado ser� utilizado o t�tulo da c�lula que o totalizador se refere
cPicture	Mascara de impress�o do totalizador. Se n�o informado ser� utilizado a m�scara da c�lula que o totalizador se refere
uFormula	Tipo Caracter: Express�o ADVPL para macro execu��o
            Tipo Bloco de c�digo: Bloco de C�digo com a express�o ADVPL para execu��o
lEndSection	Se verdadeiro. Indica se totalizador ser� impresso na quebra de se��o
lEndReport	Se verdadeiro. Indica se totalizador ser� impresso no final do relat�rio
lEndPage	Se verdadeiro. Indica se totalizador ser� impresso no final de cada p�gina
            oParent	Objeto da classe TRSection que o totalizador se refere
bCondition	Bloco de c�digo com a condi��o de atualiza��o dos valores do totalizador
lDisable	Se verdadeiro. Define que n�o ir� atualizar os valores do totalizador
bCanPrint	Bloco de c�digo com a condi��o de impress�o dos valores do totalizador

*/

//TRFunction():New(         oCell               ,cName,cFunction,oBreak,cTitle,       cPicture      ,uFormula,lEndSection,lEndReport,lEndPage,oParent   ,bCondition,lDisable,bCanPrint)
//TRFunction():New(oSection1:Cell("VALBRUTO")     , NIL ,  "SUM"  ,  NIL ,  ""  ,"@E 999,999,999.99"  ,   NIL  ,   .F.     ,     .T.  ,   .F.  , oSection1,          ,        ,         )

dbSelectArea("SRA") //selecionando a Tabela SRA010, ou seja abrindo a mesma para ser utilizada.

dbSetOrder(oReport:GetOrder())//Retorna a ordem de impress�o selecionada) //Documentacao da funcao dbSetOrder: http://tdn.totvs.com/pages/viewpage.action?pageId=23889283

Return oReport //retorna o objeto oReport com todas as definicaoes implementadas acima.
             

/*
  Funcao que vai fazer o relatorio ser impresso
*/

Static Function PrintReport(oReport/*objeto oReport retornado com todas as definicoes ja setadas na funcao ReportDef*/)

Local oSection1 := oReport:Section(1) //declaracao de variavel do tipo objeto que recebe as definicoes da primeira Secao definida no objeto oReport 
Private nOrdem  := oSection1:GetOrder() //declaracao de variavel do tipo numerico que recebe a ordem definida na primeira Secao no objeto oReport 

 
//Definicao das ordens disponiveis no relatorio, esta sera utilizada na Query:
If (nOrdem == 1  .And. MV_PAR05 = 1) //Ordem por: Matricula Crescente
	cOrdem:= "% ORDER BY RA_MAT, RA_NOME%"  
ElseIf (nOrdem == 1  .And. MV_PAR05 = 2)//Ordem por: Matricula Decrescente
	cOrdem:= "% ORDER BY RA_MAT, RA_NOME DESC%" 
ElseIf (nOrdem = 2  .And. MV_PAR05 = 1)//Ordem por: Nome Crescente
	cOrdem:= "% ORDER BY RA_NOME%" 
Else
	cOrdem:= "% ORDER BY RA_NOME DESC%" //Ordem por: Nome Decrescente
EndIf
     

//Metodo BeginQuery():Indica que sera utilizado o Embedded SQL(metodo novo da Totvs, ou seja, facilitador de queries) para criacao de uma query para a secao.
oSection1:BeginQuery()


/*Inicio, desenvolvimento e finalizacao da Query no modo Embedded SQL:
  Documentacao completa desse formato: http://tdn.totvs.com/display/tec/Embedded+SQL+-+Facilitador+de+queries         
*/
BeginSql alias "cAlias"
	SELECT RA_FILIAL FILIAL,RA_MAT MATRICULA, RA_NOME NOME, RA_NASC NASC, RA_RG RG, RA_CIC CPF, RA_CODFUNC CODFUNC,
	RJ_DESC FUNCAO, RA_CC CC, CTT_DESC01 DESCR, RA_TELEFON FONE, RA_FATORRH FATOR 
	FROM %table:SRA% SRA, %table:SRJ% SRJ, %table:CTT% CTT
	WHERE RA_MAT BETWEEN %exp:MV_PAR01% AND %exp:MV_PAR02%  
	AND RA_CC BETWEEN %exp:MV_PAR03% AND %exp:MV_PAR04%  
	AND RA_SITFOLH <> 'D'
	AND RA_CODFUNC = RJ_FUNCAO
	AND RA_FILIAL = '01'
	AND RJ_FILIAL = RA_FILIAL
	AND RA_CC = CTT_CUSTO
	AND SRA.%notDel% 
	AND SRJ.%notDel% 
	AND CTT.%notDel% 
	%exp:cOrdem% 
EndSql
               

/*
Funcao auxiliar - GetLastQuery()

Apos a abertura do cursor, no alias especificado, a fun��o GetLastQuery() retorna um array, com 5 elementos, onde est�o dispon�veis as seguintes informa��es sobre a query executada.

 [1] cAlias - Alias usado para abrir o cursor.
 [2] cQuery - Query executada.
 [3] aCampos - Array de campos com crit�rio de convers�o especificados.
 [4] lNoParser - Caso verdadeiro (.T.), n�o foi utilizada a fun��o ChangeQuery() na string original.
 [5] nTimeSpend - Tempo, em segundos, utilizado para abertura do cursor.
*/
aQuery:= GetLastQuery()//funcao que mostra todas as informacoes da query, util para visualizar na aba Comandos


oSection1:EndQuery()//finalizacao do Embedded SQL
                
/*
Init()
Executa as quebras de secoes, imprime cabecalhos entre outras configuracoes do relatorio.
Nao e necessario executar o metodo Init se for utilizar o metodo Print, ja que estes fazem o controle de inicializa��o e finaliza��o da impress�o.

*/
oSection1:Init()


/*
SetHeaderSection(lHeaderSection):

Define que imprime cabe�alho das c�lulas na quebra de se��o.
lHeaderSection:	Se verdadeiro, aponta que imprime cabe�alho na quebra da se��o
*/
oSection1:SetHeaderSection(.T.)

DbSelectArea('cAlias')//seleciona/abre a tabela setada na variavel cAlias definida na query
dbGoTop() //aponta para o primeiro registro


/*
SetMeter(nTotal)
Define o limite da regua de progressao do relatorio.
nTotal: Limite da r�gua

*/
oReport:SetMeter(cAlias->(RecCount()))//conta o numero de registros retornados da query
 
//faz um loop para impressao dos dados nas celulas/colunas ja definidas no objeto oSection
While cAlias->(!Eof())
    
	/*
	Cancel()
    Retorna se o usuario cancelou a impressao do relatorio.
	*/  
	If oReport:Cancel()//se usuario clicou em cancelar o sistema abandona a impressao
		Exit
	EndIf
	        
	
/*
IncMeter(nInc)
Incrementa a regua de progressao do relatorio.
nInc: Quantidade a incrementar na regua. Padrao: 1

*/	
	oReport:IncMeter() //como nao foi definido o sistema incrementa pelo valor padrao 



	//seta os conteudos nos campos
	oSection1:Cell("FILIAL"):SetValue(cAlias->FILIAL)//Metodo SetValue: define o valor para a celula
	oSection1:Cell("FILIAL"):SetAlign("CENTER")//Metodo SetAlign: define o alinhamento da celula
	
	oSection1:Cell("MATRICULA"):SetValue(cAlias->MATRICULA)
	oSection1:Cell("MATRICULA"):SetAlign("CENTER")
	
	oSection1:Cell("NOME"):SetValue(cAlias->NOME)
	oSection1:Cell("NOME"):SetAlign("LEFT")
	  
	oSection1:Cell("NASC"):SetValue(STOD(cAlias->NASC))
	oSection1:Cell("NASC"):SetAlign("CENTER") 
	
	oSection1:Cell("RG"):SetValue(cAlias->RG)
	oSection1:Cell("RG"):SetAlign("LEFT") 
	
	oSection1:Cell("CPF"):SetValue(cAlias->CPF)
	oSection1:Cell("CPF"):SetAlign("LEFT")
	
	oSection1:Cell("CODFUNC"):SetValue(cAlias->CODFUNC)
	oSection1:Cell("CODFUNC"):SetAlign("CENTER")
	
	oSection1:Cell("FUNCAO"):SetValue(cAlias->FUNCAO)
	oSection1:Cell("FUNCAO"):SetAlign("LEFT")   

	oSection1:Cell("CC"):SetValue(cAlias->CC)
	oSection1:Cell("CC"):SetAlign("CENTER")
	
	oSection1:Cell("DESCR"):SetValue(cAlias->DESCR)
	oSection1:Cell("DESCR"):SetAlign("LEFT")      
	
	oSection1:Cell("FONE"):SetValue(cAlias->FONE)
	oSection1:Cell("FONE"):SetAlign("LEFT")     
	
	oSection1:Cell("FATOR"):SetValue(cAlias->FATOR)
	oSection1:Cell("FATOR"):SetAlign("CENTER")
	         
	/*
	PrintLine(lEvalPosition,lParamPage,lExcel)
	Imprime a linha baseado nas c�lulas existentes.
	lEvalPosition: Forca a atualizacao do conteudo das celulas 
	lParamPage:	Aponta que e a impressao da pagina de parametros

	*/
	
	oSection1:PrintLine()//como nao foi usado os parametro o sistema considera o padrao
	
	dbSelectArea("cAlias") //seleciona novamente o resultado da query  
   
	//Desloca para outro registro na tabela corrente
	cAlias->(dbSkip())//Documentacao do metodo dbSkip: http://tdn.totvs.com/display/tec/DBSkip 

EndDo //finaliza o loop do while
                  

/*
Finish()
Finaliza a impressao da secao, imprime os totalizadores, tratamentos de quebras das secoes, entre outros tratamentos do componente.
Nao e necessario executar o metodo Finish se for utilizar o metodo Print, ja que este faz o controle de inicializacao e finalizacao da impressao.
*/
oSection1:Finish()

dbSelectArea('SRA')//seleciona novamente a tabela SRA010 - Funcionarios 
dbSetOrder(1) //Seta a Ordem dos registros da tabela para o indice 1 (ver no configurador qual a ordem do indice 1 na Base de Dados para a tabela SRA

Return


//Funcao responsavel pela criacao do grupo de perguntas
Static Function BGPER08B(cPerg)
//PutSx1(cGrupo,cOrdem,  cPergunt         ,cPerSpa,cPerEng,cVar      ,cTipo,      nTam               ,nDec,nPres,cGSC,cValid,cF3	,cGrpSxg,cPyme,cVar01	  ,cDef01       ,cDefSpa1,cDefEng1,cCnt01, cDef02      ,cDefSpa2,cDefEng2,cDef03         ,cDefSpa3,cDefEng3,cDef04            ,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5, aHelpPor,aHelpEng,aHelpSpa,cHelp)
PutSX1(cPerg , "01" , "Matricula de"      , ""    , ""    , "mv_ch1" , "C" , TAMSX3("RA_MAT")[1]     , 0  , 0   , "G", ""   ,"SRA" , ""    , ""  , "mv_par01", ""            ,""      ,""      ,""    ,""           ,""      ,""      ,""             ,""      ,""      ,""                ,""      ,""      ,""     ,""      ,"")
PutSX1(cPerg , "02" , "Matricula ate"     , ""    , ""    , "mv_ch2" , "C" , TAMSX3("RA_MAT")[1]     , 0  , 0   , "G", ""   ,"SRA" , ""    , ""  , "mv_par02", ""            ,""      ,""      ,""    ,""           ,""      ,""      ,""             ,""      ,""      ,""                ,""      ,""      ,""     ,""      ,"")
PutSX1(cPerg , "03" , "CC de"             , ""    , ""    , "mv_ch3" , "C" , TAMSX3("RA_CC")[1]      , 0  , 0   , "G", ""   ,"CTT" , ""    , ""  , "mv_par03", ""            ,""      ,""      ,""    ,""           ,""      ,""      ,""             ,""      ,""      ,""                ,""      ,""      ,""     ,""      ,"")
PutSX1(cPerg , "04" , "CC ate"            , ""    , ""    , "mv_ch4" , "C" , TAMSX3("RA_CC")[1]      , 0  , 0   , "G", ""   ,"CTT" , ""    , ""  , "mv_par04", ""            ,""      ,""      ,""    ,""           ,""      ,""      ,""             ,""      ,""      ,""                ,""      ,""      ,""     ,""      ,"")
PutSX1(cPerg , "05" , "Tipo Ordem?"       , ""    , ""    , "mv_ch5" , "C" , 1                       , 0  , 0   , "C", ""   ,      , ""    , ""  , "mv_par03", "Crescente"   ,"      ","      ","    ","Decrecente" ,"      ","      ",""             ,""      ,""      ,""                ,""      ,""      ,""     ,""      ,"")
Return

