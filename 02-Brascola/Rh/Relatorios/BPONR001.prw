#INCLUDE "PONR010.CH"
#INCLUDE "RWMAKE.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � PONR010  � Autor � Equipe Advanded RH    � Data � 07.04.96 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Espelho do Ponto                                           ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � PONR010(void)                                              ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
���Marinaldo   �27/09/01�Melhor�Tratamento para o Terminal de Consulta    ���
���Marinaldo   �15/10/01�Melhor�Imprimir Resultado Acumulado			   ���
���Marinaldo   �16/10/01�Melhor�Utilizar a Funcao GetMarcacoes() para  car���
���            �--------�------�regar o Calendario de Marcacoes e as marca���
���            �--------�------�coes dos Funcionarios. Se houver a  sequen���
���            �--------�------�cia na Tabela de Troca de Turnos   conside���
���            �--------�------�rar esse sequencia como inicial da  Tabela���
���            �--------�------�Caso Contrario, utilizar as Funcoes RetSeq���
���            �--------�------�ou fQualSeq() para tentar retornar a    se���
���            �--------�------�quencia para o Inicio do Calendario.      ���
���Marinaldo   �17/10/01�Melhor�Quando houver Troca de Turno no Inicio  do���
���            �--------�------�periodo Considerar o Turno da Troca.      ���
���Marinaldo   �06/11/01�Acerto�Buscar a Descricao dos Resultados no Cadas���
���            �--------�------�tro de Verbas							        ���
���Marinaldo   �06/11/01�010922�Tratamento de Troca de Regra de  Apontamen���
���            �--------�------�to.    									        ���
���Marinaldo   �19/11/01�Melhor�A funcao GetMarcacoes passara a utilizar a���
���            �--------�------�Funcao fDiasFolga() para Verificar as  Fol���
���            �--------�------�gas Automaticas.						        ���
���Marinaldo   �22/11/01�Acerto�Quando Dia For Feriado e Regra Estiver  De���
���            �--------�------�Definida que Funcionario Trabalha em Feria���
���            �--------�------�do e nao possuir Marcacoes. Imprimir a Men���
���            �--------�------�sagem de Ausente						        ���
���Mauricio MR �10/12/01�Acerto�A)Complementacao Parametros em fAbonos:   ���
���            �--------�------�TpMarca e C.C.					              ���
���            �--------�------�B)Criacao das Funcoes LoadX3Box (Generica)���
���            �--------�------�e DescTpMarca(Especifica).                ���
���            �--------�------�C)Descrimina o Tipo de Marcacao	        ���
���Marinaldo   �12/11/01�Melhor�Redefinicao do Codigo HTML para o Terminal���
���            �--------�------�de Consultar (RH OnLine)                  ��� 
���Mauricio MR �22/01/02�Acerto�  Acerto Quebra de Pagina.                ���
���            �        �      �  Implementacao da ImprEsp para verificar ���
���            �        �      �  a necessidade de imprimir o cabec a cada��� 
���            �        �      �  impressao de linha detalhe na ImpFun.   ���
���            �        �      �  Inicializada Li:=1 no Cabec.            ���
���Marinaldo   �21/02/02�Acerto�Retirada da ValidPerg() que alterava e car���
���            �        �      �regava novos Perguntes					     ��� 
���Mauricio MR �26/03/02�14291 �  Melhoria.Impressao da descricao dos tur-���
���            �        �      �  nos trabalhados no periodo.             ��� 
���Mauricio MR �15/04/02�Acerto�  Correcao do Grupo de Perguntas. Ocorria ���
���            �        �      �  sobreposicao da Ultima Pergunta         ��� 
���Mauricio MR �23/05/02�Melhor�A)Possibilidade do usuario digitar o perio���
���            �        �      �  do desejado de modo que o programa se en��� 
���            �        �      �  carrega de subdivi-lo em periodos de a- ���
���            �        �      �  pontamentos apropriados. Tambem torna-se���
���            �        �      �  possivel digitar periodos parciais.     ���
���            �        �      �B)Alteracao no Layout de modo a permitir  ���
���            �        �      �  a impressao do centro de custo com 20 po���
���            �        �      �  sicoes. Para MV_COLMARC superior a 5, al���
���            �        �      �  teramos o tamanho do Relatorio para con-��� 
���            �        �      �  ter o cabecalho integralmente.          ���
���            �        �      �C)Os valores iniciais do periodo quando   ���
���            �        �      �  nao corresponderem a um periodo de apon-���
���            �        �      �  tamento correto assumirao o periodo em  ���
���            �        �      �  aberto.                                 ��� 
���            �        �Acerto�D)Recuperacao de Tabela de HE vigente con-���
���            �        �      �  forme turno definido pelas trocas de tur���
���            �        �      �  nos do funcionario no periodo solicitado��� 
���            �        �      �E)Alteracao Na Verificacao de Horas que   ���
���            �        �      �  farao parte dos totais conforme o tipo  ���
���            �        �      �  Autorizados/Nao Autor. ou Ambos.        ���
���Mauricio MR �13/06/02�Acerto�A)Verificacao correta da data de admissao ���
���            �        �      �  para selecionar periodos do funcionario.���
���Mauricio MR �03/09/02�Acerto�A)Padronizacao do Tipo de Impressao.      ���
���            �        �      �  - 6 PARES de marcacoes: impressao compri���
���            �        �      �  mida e retrato. Para + que 5 pares:     ��� 
���            �        �      �  impressao comprimida e paisagem.        ���
���Mauricio MR �01/10/02�Acerto�A)Nao utilizar a funcao __TimeSum para e- ���
���            �        �      �  ventos de Resultados.                   ���
���Mauricio MR �28/10/02�060626�A)Atualizamos a variavel lAfasta para que,���
���            �        �      �  quando funcionario demitido/transferido,��� 
���            �        �      �  seja impresso o tipo de afastamento a   ���
���            �        �      �  partir da data de demissao.             ��� 
���Mauricio MR �04/12/02�------�Retirada a restricao de existencia de cra-��� 
���            �--------�------�cha para a emissao do relatorio.	        ��� 
���Mauricio MR �12/12/02�061160�A)Alteracao na verificacao das ocorrencias���
���            �--------�------�de marcacao e ausencia da mesma para o dia��� 
���            �--------�------�considerando feriado e excecoes.          ��� 
���Mauricio MR �07/02/03�QNC   �A)Alteramos a rotina de obtencao de abonos���
���            �--------�00169 �de modo a ser fazer uma unica leitura tan-��� 
���            �--------�200300�to para acumulados qto para apontamentos. ��� 
���            �--------�      �B)Imprimir Cabec de Totais de Eventos com ��� 
���            �--------�      �titulos de Calc e Inf para impressao de ho��� 
���            �--------�      �ras calculadas visto que podem ter abonos.���
���            �--------�      �e nesse caso as horas correspondentes sao ���
���            �--------�      �informadas.								        ���
���            �--------�      �C)Nao imprimimos informacoes de abonos nos��� 
���            �--------�      �totais se a impressao for de eventos do   ��� 
���            �--------�      �resultado.								        ���
���            �--------�      �D)Verificamos se o motivo abona efetivamen��� 
���            �--------�      �te o apontamento e para motivos sem evento��� 
���            �--------�      �deduzimos a qtde efetivamente abonada.	  ���
���Mauricio MR �26/02/03�Acerto�A) Calculamos o acumulado de horas Efeti- ���
���            �--------�      �vamente abonadas por evento.			     ���
���Mauricio MR �14/04/03�Acerto�A) Consideramos a existencia dos parame - ���
���            �--------�      �tros MV_ABOSEVE e MV_SUBABAP.			     ���
���Mauricio MR �08/05/03�Melhor�A) Ajuste para permitir ate 99.999,99 hs  ���
���            �--------�      �para lancamentos vindos de resultados.    ���
���Mauricio MR �27/05/03�64292 �A) Imprime funcionario demitido somente   ���
���            �--------�      �qdo a data for superior a data de demissao���
���Mauricio MR �26/06/03�Acerto�A) Imprime a descricao dos abonos tambem  ���
���            �--------�      �na emissao de resultados.				     ���
���Mauricio MR �18/08/03�Acerto�A) Alterada a Monta_Per() para verificar o���
���            �--------�      �o compartilhamento do SPO e alteracao da  ���
���            �--------�      �verificacao de periodos a serem considera ���
���            �--------�      �dos.									           ���
���Mauricio MR �16/09/03�Acerto�A) Verificada a escolha da base de horas  ���
���            �--------�      �e se for centesimal somente sera calculada���
���            �--------�      �para eventos oriundos do apontamento.     ���
���Mauricio MR �20/10/03�Acerto�A) Para funcionarios que trabalham em fe- ���
���            �--------�      �riado e for feriado apontar o dia conforme���
���            �--------�      �o tipo de dia da tabela padrao. 		     ���
���Mauricio MR �29/10/03�Melhor�A) Para funcionarios afastados com excecao���
���            �--------�      �prioriza a excecao.						     ��� 
���Mauricio MR �04/10/03�Acerto�A) Converte para Sexagesimal o total das  ���
���            �--------�      �horas abonadas qdo exisitir evento asso-  ���
���            �--------�      �ciado.									           ���
���Mauricio MR �26/02/04�Acerto�A) Permite Escolher se Imprime Motivo da  ���
���            �--------�      �Excecao ao inves do de Afastamento.       ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function BPONR001(lTerminal,cFilTerminal,cMatTerminal,cPerAponta)
*************************************************************
/*
��������������������������������������������������������������Ŀ
� Define Variaveis Locais (Basicas)                            �
����������������������������������������������������������������*/
Local aArea		 := GetArea()
Local cDesc1    := STR0001  // 'Espelho do Ponto'
Local cDesc2    := STR0002  // 'Ser� impresso de acordo com os parametros solicitados pelo'
Local cDesc3    := STR0003  // 'usuario.'
Local cString   := 'SRA' //-- Alias do arquivo principal (Base)
Local aOrd      := {STR0004 , STR0005 , STR0006 , STR0007, STR0038 } // 'Matricula'###'Centro de Custo'###'Nome'###'Turno'###'C.Custo + Nome'
Local wnRel		 := ""
Local cHtml		 := ""

/*
��������������������������������������������������������������Ŀ
� Define Variaveis Private(Basicas)                            �
����������������������������������������������������������������*/
Private aReturn  := {STR0008 , 1, STR0009 , 2, 2, 1, '',1 } // 'Zebrado'###'Administra��o'
Private nomeprog := 'PONR010'
Private aLinha   := {}
Private nLastKey := 0
Private cPerg    := 'PNR010'

/*
��������������������������������������������������������������Ŀ
� Define variaveis Private utilizadas no programa RDMAKE ImpEsp�
����������������������������������������������������������������*/
Private aImp      := {}
Private aTotais   := {}
Private aBanco    := {}
Private aAbonados := {}
Private nImpHrs   := 0

/*
��������������������������������������������������������������Ŀ
� Variaveis Utilizadas na funcao IMPR                          �
����������������������������������������������������������������*/
Private Titulo   := OemToAnsi(STR0001 ) // 'Espelho do Ponto'
Private cCabec   := ''
Private AT_PRG   := 'PONR010'
Private wCabec0  := 1
Private wCabec1  := ''
Private CONTFL   := 1
Private LI       := 0
Private nTamanho := 'P'

/*
��������������������������������������������������������������Ŀ
� Define Variaveis Private(Programa)                           �
����������������������������������������������������������������*/
Private dPerIni  := Ctod("//")
Private dPerFim  := Ctod("//")
Private cMenPad1 := Space(30)
Private cMenPad2 := Space(19)
Private cIndCond := ''
Private cFilSPA  := IF(Empty(xFilial("SPA")),Space(02),SRA->RA_FILIAL)
Private cFor     := ''
Private nOrdem   := 0
Private cAponFer := ''	
Private aInfo    := {}
Private aTurnos  := {}
Private aPrtTurn := {}
Private nColunas := 0
         
If (lTerminal == Nil)
	lTerminal := .F.
Endif

/*
��������������������������������������������������������������Ŀ
�Par�metro MV_COLMARC										            �
����������������������������������������������������������������*/
nColunas := SuperGetmv("MV_COLMARC")
IF ( nColunas == NIL )
	Help("", 1, "MVCOLNCAD")
	Return( .F. )
EndIF

/*
��������������������������������������������������������������Ŀ
�Calcula Tamanho e Tipo de Impressao de modo a conter  integral�
�mente o cabecalho. 										               �
����������������������������������������������������������������*/
IF ( nColunas < 5 )
   nTamanho		:= "M"
   aReturn[4]	:= 1     
Else
   nTamanho		:= "G" 
   aReturn[4]	:= 1   
EndIF
   
/*
��������������������������������������������������������������Ŀ
�O numero de colunas eh sempre aos pares					         �
����������������������������������������������������������������*/
nColunas *= 2

/*
��������������������������������������������������������������Ŀ
� Envia controle para a funcao SETPRINT                        �
����������������������������������������������������������������*/
IF !( lTerminal )
	/*
	��������������������������������������������������������������Ŀ
	�Nome Default do relatorio em Disco							         �
	����������������������������������������������������������������*/
	wnrel := "BPONR001"
	/*
	��������������������������������������������������������������Ŀ
	�Inicializa a SetPrint										   �
	����������������������������������������������������������������*/
	wnrel := SetPrint(cString, wnrel, cPerg, Titulo, cDesc1, cDesc2, cDesc3, .F., aOrd, ,nTamanho)
EndIF	

/*
��������������������������������������������������������������Ŀ
� Define a Ordem do Arquivo Principal SRA                      �
����������������������������������������������������������������*/
nOrdem := IF( !lTerminal , aReturn[8] , 1 )

/*
��������������������������������������������������������������Ŀ
� Verifica as perguntas selecionadas                           �
����������������������������������������������������������������*/
Pergunte( "PNR010" , .F. )

/*
��������������������������������������������������������������Ŀ
� Carregando variaveis mv_par?? para Variaveis do Sistema.     �
����������������������������������������������������������������*/
FilialDe	:= IF( !lTerminal , mv_par01, cFilTerminal )			//Filial  De
FilialAte:= IF( !lTerminal , mv_par02, cFilTerminal )			//Filial  Ate
CcDe		:= IF( !lTerminal , mv_par03, SRA->RA_CC   )			//Centro de Custo De
CcAte		:= IF( !lTerminal , mv_par04, SRA->RA_CC   )			//Centro de Custo Ate
TurDe		:= IF( !lTerminal , mv_par05, SRA->RA_TNOTRAB)			//Turno De
TurAte	:= IF( !lTerminal , mv_par06, SRA->RA_TNOTRAB)			//Turno Ate
MatDe		:= IF( !lTerminal , mv_par07, cMatTerminal)				//Matricula De
MatAte	:= IF( !lTerminal , mv_par08, cMatTerminal)				//Matricula Ate
NomDe		:= IF( !lTerminal , mv_par09, SRA->RA_NOME)				//Nome De
NomAte	:= IF( !lTerminal , mv_par10, SRA->RA_NOME)				//Nome Ate
cSit		:= IF( !lTerminal , mv_par11, fSituacao( NIL , .F. ))	//Situacao
cCat		:= IF( !lTerminal , mv_par12, fCategoria( NIL , .F. ))	//Categoria
nImpHrs	:= IF( !lTerminal , mv_par13, 3 )						//Imprimir horas Calculadas/Inform/Ambas/NA
nImpAut	:= IF( !lTerminal , mv_par14, 1 )						//Demonstrar horas Autoriz/Nao Autorizadas
nCopias	:= IF( !lTerminal , If(mv_par15>0,mv_par15,1),1)		//N�mero de C�pias
lSemMarc	:= IF( !lTerminal , (mv_par16==1)	, .F. )				//Imprime para Funcion�rios sem Marca�oes
cMenPad1	:= IF( !lTerminal , mv_par17, "" )						//Mensagem padr�o anterior a Assinatura
cMenPad2	:= IF( !lTerminal , mv_par18, "" )						//Mens. padr�o anterior a Assinatura(Cont.)
dPerIni  := IF( !lTerminal , mv_par19,Stod( Subst( cPerAponta , 1 , 8 ) ))	//Data Contendo o Inicio do Periodo de Apontamento
dPerFim  := IF( !lTerminal , mv_par20,Stod( Subst( cPerAponta , 9 , 8 ) ))	//Data Contendo o Fim  do Periodo de Apontamento
lSexagenal:= IF( !lTerminal , (mv_par21==1), .T.  )				//Horas em  (Sexagenal/Centesimal)
lImpRes	:= IF( !lTerminal , (mv_par22==1), .F.	)				//Imprime eventos a partir do resultado ?
lImpTroca:= IF( !lTerminal , (mv_par23==1), .F.	)				//Imprime Descricao Troca de Turnos ou o Atual 
lImpExcecao:= IF( !lTerminal , (mv_par24==1), .F.	)				//Imprime Descricao da Excecao no Lugar da do Afastamento 

/*
��������������������������������������������������������������Ŀ
� Redefine o Tamanho das Mensagens Padroes					   �
����������������������������������������������������������������*/
cMenpad1 := IF(Empty( cMenPad1 ) , Space( 30 ) , cMenPad1 )
cMenpad2 := IF(Empty( cMenPad2 ) , Space( 19 ) , cMenPad2 )

Begin Sequence
	IF ( lTerminal )
		cHtml := Pnr010Imp( NIL , NIL , NIL , lTerminal )
	ElseIF !( nLastKey == 27 )
		SetDefault( aReturn , cString )
		IF Empty( dPerIni ) .or. Empty( dPerFim )
			Help(" ",1,"PONFORAPER" , , OemToAnsi( STR0039 ) , 5 , 0  )	//'Periodo de Apontamento Invalido.'
			Break
		EndIF
		IF !( nLastKey == 27 )
		    RptStatus( { |lEnd| Pnr010Imp(@lEnd, wNRel, cString , lTerminal ) } , Titulo )
		EndIF
	EndIF
End Sequence

Return( cHtml )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � POR010Imp� Autor � EQUIPE DE RH          � Data � 07.04.96 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Espelho do Ponto                                           ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � Pnr010Imp(lEnd,wnRel,cString)                              ���
�������������������������������������������������������������������������Ĵ��
���Parametros� lEnd        - A��o do Codelock                             ���
���          � wnRel       - T�tulo do relat�rio                          ���
���          � cString     - Mensagem                                     ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function Pnr010Imp( lEnd , WnRel ,cString , lTerminal )

Local aComplPer		:= {}
Local aAbonosPer	:= {}
Local cFil			:= ""
Local cMat			:= ""
Local cTno			:= ""
Local cLastFil		:= "__cLastFil__"
Local cAcessaSRA	:= &("{ || " + ChkRH("PONR010","SRA","2") + "}")
Local cSeq			:= ""
Local cTurno		:= ""
Local cHtml			:= ""
Local lSPJExclu	:= !Empty( xFilial("SPJ") )
Local lSP9Exclu	:= !Empty( xFilial("SP9") )
Local nCount		:= 0.00
Local nX			   := 0.00
Local nY			   := 0.00
Local lMvAbosEve	:= .F.
Local lMvSubAbAp	:= .F.

Private aMarcacoes := {}
Private aTabPadrao := {}
Private aTabCalend := {}
Private aPeriodos  := {}
Private aId		    := {}
Private aBoxSPC	 := LoadX3Box("PC_TPMARCA") 
Private aBoxSPH	 := LoadX3Box("PH_TPMARCA")
Private cHeader    := ""
Private dIniCale   := Ctod("//")	//-- Data Inicial a considerar para o Calendario
Private dFimCale   := Ctod("//")	//-- Data Final a considerar para o calendario
Private dMarcIni   := Ctod("//")	//-- Data Inicial a Considerar para Recuperar as Marcacoes
Private dMarcFim   := Ctod("//")	//-- Data Final a Considerar para Recuperar as Marcacoes
Private dIniPonMes := Ctod("//")	//-- Data Inicial do Periodo em Aberto 
Private dFimPonMes := Ctod("//")	//-- Data Final do Periodo em Aberto 
Private lImpAcum   := .F.
Private nSaldoAnt  := 0

/*
��������������������������������������������������������������Ŀ
�Como a Cada Periodo Lido reinicializamos as Datas Inicial e Fi�
�nal preservamos-as nas variaveis: dCaleIni e dCaleFim.		   �
����������������������������������������������������������������*/
dIniCale   := dPerIni   //-- Data Inicial a considerar para o Calendario
dFimCale   := dPerFim   //-- Data Final a considerar para o calendario

/*
��������������������������������������������������������������Ŀ
�Inicializa Variaveis Static								            �
����������������������������������������������������������������*/
(CarExtAut(),RstGetTabExtra())

/*
��������������������������������������������������������������Ŀ
�Seleciona a Ordem do Funcionario e Monta chave para  posiciona�
�namento													                  �
����������������������������������������������������������������*/
dbSelectArea("SRA")
SRA->(dbSetOrder(nOrdem))
IF ((nOrdem == 1).or.(lTerminal))
	cInicio  := 'RA_FILIAL + RA_MAT'
	IF !( lTerminal )
		SRA->( MsSeek( FilialDe + MatDe , .T. ) )
		cFim := FilialAte + MatAte
	Else
		cFim := SRA->( &(cInicio) )
	EndIF	
ElseIF ( nOrdem == 2 )
	SRA->( MsSeek( FilialDe + CcDe + MatDe , .T. ) )
	cInicio  := 'RA_FILIAL + RA_CC + RA_MAT'
	cFim     := FilialAte + CcAte + MatAte
ElseIF ( nOrdem == 3 )
	SRA->( MsSeek( FilialDe + NomDe + MatDe , .T. ) )
	cInicio  := 'RA_FILIAL + RA_NOME + RA_MAT'
	cFim     := FilialAte + NomAte + MatAte
ElseIF ( nOrdem == 4 )
   SRA->( MsSeek( FilialDe + TurDe , .T. ) )
   cInicio  := 'RA_FILIAL + RA_TNOTRAB'
   cFim     := FilialAte + TurAte
ElseIF ( nOrdem == 5 )
	SRA->( dbSetOrder(8) )
	SRA->( MsSeek( FilialDe + CcDe + NomDe , .T. ) )
	cInicio  := 'RA_FILIAL + RA_CC + RA_NOME'
	cFim     := FilialAte + CcAte + NomAte
EndIF

/*
��������������������������������������������������������������Ŀ
�Inicializa R�gua de Impress�o								         �
����������������������������������������������������������������*/
IF !( lTerminal )
	SetRegua( SRA->( RecCount() ) )
EndIF	

/*
��������������������������������������������������������������Ŀ
�Processa o Cadastro de Funcionarios						         �
����������������������������������������������������������������*/
While SRA->( !Eof() .and. &(cInicio) <= cFim )

	/*
	��������������������������������������������������������������Ŀ
	�So Faz Validacoes Quando nao for Terminal					      �
	����������������������������������������������������������������*/
	IF !( lTerminal ) 
	
		/*
		��������������������������������������������������������������Ŀ
		�Incrementa a R�gua de Impress�o							            �
		����������������������������������������������������������������*/
		IncRegua()

		/*
		��������������������������������������������������������������Ŀ
		�Cancela a Impress�o 										            �
		����������������������������������������������������������������*/
		IF ( lEnd )
			Impr( cCancela , 'C' )
			Exit
		EndIF

		/*
		��������������������������������������������������������������Ŀ
		� Consiste controle de acessos e filiais validas               �
		����������������������������������������������������������������*/
		IF SRA->( !( RA_FILIAL $ fValidFil() ) .or. !Eval( cAcessaSRA ) )
			SRA->( dbSkip() )
			Loop
		EndIF

		/*
		��������������������������������������������������������������Ŀ
		� Consiste Parametrizacao do Intervalo de Impressao            �
		����������������������������������������������������������������*/
		IF SRA->(;
					(  RA_TNOTRAB	< Turde ) .or. ( 	RA_TNOTRAB	> TurAte ) .or. ;
					(  RA_NOME 		< NomDe ) .or. ( 	RA_NOME 	> NomAte ) .or. ;
					(  RA_MAT 		< MatDe ) .or. ( 	RA_MAT 		> MatAte ) .or. ;
					(  RA_CC 		< CCDe  ) .or. ( 	RA_CC 		> CCAte	 ) .or. ;
					!( RA_SITFOLH	$ cSit	) .or. !(	RA_CATFUNC	$ cCat	 );
				)
			SRA->( dbSkip() )
			Loop
		EndIF

		/*
		��������������������������������������������������������������Ŀ
		�Consiste a data de Demiss�o								            �
		�Se o Funcionario Foi Demitido Anteriormente ao Inicio do Perio�
		�do Solicitado Desconsidera-o								            �
		����������������������������������������������������������������*/
		IF !Empty(SRA->RA_DEMISSA) .and. ( SRA->RA_DEMISSA < dIniCale )
			SRA->( dbSkip() )
			Loop
		EndIF

	EndIF

    /*
	�������������������������������������������������������������Ŀ
	� Verifica a Troca de Filial           						     �
	���������������������������������������������������������������*/
	IF !( SRA->RA_FILIAL == cLastFil )

		/*
		��������������������������������������������������������������Ŀ
		� Alimenta as variaveis com o conteudo dos MV_'S correspondetes�
		����������������������������������������������������������������*/		
		lMvAbosEve	:= ( Upper(AllTrim(SuperGetMv("MV_ABOSEVE",NIL,"N",cLastFil))) == "S" )	//--Verifica se Deduz as horas abonadas das horas do evento Sem a necessidade de informa o Codigo do Evento no motivo de abono que abona horas
		lMvSubAbAp	:= ( Upper(AllTrim(SuperGetMv("MV_SUBABAP",NIL,"N",cLastFil))) == "S" )	//--Verifica se Quando Abono nao Abonar Horas e Possuir codigo de Evento, se devera Gera-lo em outro evento e abater suas horas das Horas Calculadas
	    
	    /*
		�������������������������������������������������������������Ŀ
		� Atualiza a Filial Corrente           						     �
		���������������������������������������������������������������*/
		cLastFil := SRA->RA_FILIAL
		
	    /*
		�������������������������������������������������������������Ŀ
		� Carrega periodo de Apontamento Aberto						     �
		���������������������������������������������������������������*/
		IF !CheckPonMes( @dPerIni , @dPerFim , .F. , .T. , .F. , cLastFil )
			Exit
		EndIF

    	/*
		�������������������������������������������������������������Ŀ
		� Obtem datas do Periodo em Aberto							        �
		���������������������������������������������������������������*/
		GetPonMesDat( @dIniPonMes , @dFimPonMes , cLastFil )
		
    	/*
		�������������������������������������������������������������Ŀ
		�Atualiza o Array de Informa��es sobre a Empresa.			     �
		���������������������������������������������������������������*/
		aInfo := {}
		fInfo( @aInfo , cLastFil )
	
	    /*
		�������������������������������������������������������������Ŀ
		� Carrega as Tabelas de Horario Padrao						        �
		���������������������������������������������������������������*/
		IF ( lSPJExclu .or. Empty( aTabPadrao ) )
			aTabPadrao := {}
			fTabTurno( @aTabPadrao , IF( lSPJExclu , cLastFil , NIL ) )
		EndIF

    	/*
		�������������������������������������������������������������Ŀ
		� Carrega TODOS os Eventos da Filial						        �
		���������������������������������������������������������������*/
		IF ( Empty( aId ) .or. ( lSP9Exclu ) )
			aId := {}
			CarId( fFilFunc("SP9") , @aId , "*" )
		EndIF

	EndIF

   	/*
	�������������������������������������������������������������Ŀ
	�Retorna Periodos de Apontamentos Selecionados				     �
	���������������������������������������������������������������*/
	IF ( lTerminal )
		dPerIni	:= dIniCale
		dPerFim := dFimCale
	EndIF
	aPeriodos := Monta_per( dIniCale , dFimCale , cLastFil , SRA->RA_MAT , dPerIni , dPerFim )

   	/*
	�������������������������������������������������������������Ŀ
	�Corre Todos os Periodos 									  �
	���������������������������������������������������������������*/
	naPeriodos := Len( aPeriodos )
	For nX := 1 To naPeriodos

   		/*
		�������������������������������������������������������������Ŀ
		�Reinicializa as Datas Inicial e Final a cada Periodo Lido.	  �
		�Os Valores de dPerIni e dPerFim foram preservados nas   varia�
		�veis: dCaleIni e dCaleFim.									  �
		���������������������������������������������������������������*/
        dPerIni := aPeriodos[nX,1]
        dPerFim := aPeriodos[nX,2] 

   		/*
		�������������������������������������������������������������Ŀ
		�Obtem as Datas para Recuperacao das Marcacoes				     �
		���������������������������������������������������������������*/
        dMarcIni := aPeriodos[nX,3]
        dMarcFim := aPeriodos[nX,4]

   		/*
		�������������������������������������������������������������Ŀ
		�Verifica se Impressao eh de Acumulado						        �
		���������������������������������������������������������������*/
		lImpAcum := ( dPerFim < dIniPonMes )
		   
	    /*
		�������������������������������������������������������������Ŀ
		� Retorna Turno/Sequencia das Marca��es Acumuladas			     �
		���������������������������������������������������������������*/
		IF ( lImpAcum )
			IF SPF->( dbSeek( SRA->( RA_FILIAL + RA_MAT ) + Dtos( dPerIni) ) ) .and. !Empty(SPF->PF_SEQUEPA)
				cTurno:= SPF->PF_TURNOPA
				cSeq	:= SPF->PF_SEQUEPA
			Else
	    		/*
				�������������������������������������������������������������Ŀ
				� Tenta Achar a Sequencia Inicial utilizando RetSeq()         �
				���������������������������������������������������������������*/
				IF !RetSeq(cSeq,@cTurno,dPerIni,dPerFim,dDataBase,aTabPadrao,@cSeq) .or. Empty( cSeq )
	    			/*
					�������������������������������������������������������������Ŀ
					�Tenta Achar a Sequencia Inicial utilizando fQualSeq()		  �
					���������������������������������������������������������������*/
					cSeq := fQualSeq( NIL , aTabPadrao , dPerIni , @cTurno )
				EndIF
			EndIF
		Else
   			/*
			�������������������������������������������������������������Ŀ
			�Considera a Sequencia e Turno do Cadastro            		  �
			���������������������������������������������������������������*/
			cTurno	:= SRA->RA_TNOTRAB
			cSeq	:= SRA->RA_SEQTURN
		EndIF
	
	    /*
		�������������������������������������������������������������Ŀ
		� Carrega Arrays com as Marca��es do Periodo (aMarcacoes), com�
		�o Calendario de Marca��es do Periodo (aTabCalend) e com    as�	
		�Trocas de Turno do Funcionario (aTurnos)					  �	
		���������������������������������������������������������������*/
		( aMarcacoes := {} , aTabCalend := {} , aTurnos := {} )   
	    /*
		�������������������������������������������������������������Ŀ
		� Importante: 												  �
		� O periodo fornecido abaixo para recuperar as marcacoes   cor�
		� respondente ao periodo de apontamentoo Calendario de 	 Marca�	
		� ��es do Periodo ( aTabCalend ) e com  as Trocas de Turno  do�	
		� Funcionario ( aTurnos ) integral afim de criar o  calendario�	
		� com as ordens correspondentes as gravadas nas marcacoes	  �	
		���������������������������������������������������������������*/
		IF !GetMarcacoes(	@aMarcacoes					,;	//Marcacoes dos Funcionarios
							@aTabCalend					,;	//Calendario de Marcacoes
							@aTabPadrao					,;	//Tabela Padrao
							@aTurnos					,;	//Turnos de Trabalho
							dPerIni 					,;	//Periodo Inicial
							dPerFim						,;	//Periodo Final
							SRA->RA_FILIAL				,;	//Filial
							SRA->RA_MAT					,;	//Matricula
							cTurno						,;	//Turno
							cSeq						,;	//Sequencia de Turno
							SRA->RA_CC					,;	//Centro de Custo
							IF(lImpAcum,"SPG","SP8")	,;	//Alias para Carga das Marcacoes
							NIL							,;	//Se carrega Recno em aMarcacoes
							.T.							,;	//Se considera Apenas Ordenadas
						    .T.    						,;	//Se Verifica as Folgas Automaticas
						  	.F.    			 			 ;	//Se Grava Evento de Folga Automatica Periodo Anterior
					 )
			Loop
		EndIF					 
	   
	    aPrtTurn:={}
	    Aeval(aTurnos, {|x| If( x[2] >= dPerIni .AND. x[2]<= dPerFim, Aadd(aPrtTurn, x),Nil )} ) 
	   
	    /*
		�������������������������������������������������������������Ŀ
		�Reinicializa os Arrays                              			  �
		���������������������������������������������������������������*/
		( aTotais := {} , aAbonados := {} , aBanco := {} )

	    /*
		�������������������������������������������������������������Ŀ
		�Carrega os Abonos Conforme Periodo       			   		  �
		���������������������������������������������������������������*/
		fAbonosPer( @aAbonosPer , dPerIni , dPerFim , cLastFil , SRA->RA_MAT )

	    /*
		�������������������������������������������������������������Ŀ
		�Carrega os Totais de Horas e Abonos.						        �
		���������������������������������������������������������������*/
		CarAboTot( @aTotais , @aAbonados , aAbonosPer, lMvAbosEve, lMvSubAbAp )

	    /*
		�������������������������������������������������������������Ŀ
		�Carrega os Dados de Banco de Dados. 						        �
		���������������������������������������������������������������*/
		fBuscoBanco(@aBanco)
	
	    /*
		�������������������������������������������������������������Ŀ
		�Carrega o Array a ser utilizado na Impress�o.				     �
		�aPeriodos[nX,3] --> Inicio do Periodo para considerar as  mar�
		�                    cacoes e tabela						        �
		�aPeriodos[nX,4] --> Fim do Periodo para considerar as   marca�
		�                    coes e tabela							        �
		���������������������������������������������������������������*/
		If (!fMontaAimp(aTabCalend,aMarcacoes,@aImp,dMarcIni,dMarcFim).and.!(lSemMarc))
			Loop
		Endif

	    /*
		�������������������������������������������������������������Ŀ
		�Imprime o Espelho para um Funcionario.						     �
		���������������������������������������������������������������*/
		For nCount := 1 To nCopias
			IF !( lTerminal )
				fImpFun( aImp , nColunas , , @aBanco)
			Else
				cHtml := fImpFun( aImp , nColunas , lTerminal , @aBanco)
		    EndIF
		Next nCount
		
	    /*
		�������������������������������������������������������������Ŀ
		�Reinicializa Variaveis										           �
		���������������������������������������������������������������*/
		aImp      := {}
		aTotais   := {}
		aAbonados := {}
		aBanco    := {}
		
	Next nX

    SRA->( dbSkip() )

End While

/*
��������������������������������������������������������������Ŀ
� Termino do relatorio                                         �
����������������������������������������������������������������*/
IF !( lTerminal )
	dbSelectArea('SRA')
	dbSetOrder(1)
	Set Device To Screen
	IF (aReturn[5] == 1)
		Set Printer To
		dbCommit()
		OurSpool(wnrel)
	EndIF
	Ms_Flush()
EndIF

Return(cHtml)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �FImpFun   � Autor � J.Ricardo             � Data � 09/04/96 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Imprime o espelho do ponto do funcionario                  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   �                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � POR010IMP                                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function fImpFun( aImp , nColunas , lTerminal , aBanco)

Local cDet      	:= ""
Local cHtml			:= ""
Local lZebrado		:= .F.
Local nX        	:= 0.00
Local nY        	:= 0.00
Local nFor      	:= 0.00
Local nCol      	:= 0.00
Local nColMarc  	:= 0.00
Local nTamLin   	:= 0.00
Local nMin			:= 0.00
Local nLenImp		:= 0.00
Local nLenImpnX	:= 0.00
Local nTamAuxlin	:= 0.00

//-- Define o tamanho da linha com base no MV_ColMarc.
aEval(aImp, { |x| nColMarc := If(Len(x)-3>nColMarc, Len(x)-3, nColMarc) } )
nColMarc += If(nColMarc%2 == 0, 0, 1)
//-- Calcula Tamanho e Tipo de Impressao de modo a conter integralmente o cabecalho. 
IF ( nColunas < 10 )
   nTamanho		:='M'
   aReturn[4]	:= 1    
Else
   nTamanho		:='G' 
   aReturn[4]	:= 1   
EndIF
 
//-- Calcula a Maior das Qtdes de Colunas existentes
nColunas := Max(nColunas, nColMarc)

//-- Define configura��es da impress�o
nTamAuxLin	:= 19+(nColunas*6)+50
nTamLin    	:= If(nTamAuxLin <= 80,80,If(nTamAuxLin<=132,132,220))

IF ( lTerminal )
	/*
	��������������������������������������������������������������Ŀ
	� Inicio da Estrutura do Codigo HTML						   �
	����������������������������������������������������������������*/
	cHtml += HtmlProcId() + CRLF
	cHtml += '<html>'  + CRLF
	cHtml += 	'<head>'  + CRLF
	cHtml += 		'<title>RH Online</title>'  + CRLF
	cHtml +=		'<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">'  + CRLF
	cHtml +=		'<link rel="stylesheet" href="css/rhonline.css" type="text/css">'  + CRLF
	cHtml +=	'</head>'  + CRLF
	cHtml +=	'<body bgcolor="#FFFFFF" text="#000000">' + CRLF
	cHtml +=		'<table width="515" border="0" cellspacing="0" cellpadding="0">'  + CRLF
  	cHtml +=			'<tr>'  + CRLF
    cHtml +=				'<td class="titulo">'  + CRLF
    cHtml +=					'<p>' + CRLF
    cHtml +=						'<img src="'+TcfRetDirImg()+'/icone_titulo.gif" width="7" height="9">' + CRLF
    cHtml +=							'<span class="titulo_opcao">' + CRLF
    cHtml +=								STR0040 + CRLF	//'Consultar Marca&ccedil;&otilde;es'
    cHtml +=							'</span>' + CRLF
    cHtml +=							'<br><br>' + CRLF
	cHtml +=					'</p>' + CRLF
	cHtml +=				'</td>' + CRLF
  	cHtml +=			'</tr>' + CRLF
  	cHtml +=			'<tr>' + CRLF
    cHtml +=				'<td>' + CRLF
    cHtml +=					'<table width="515" border="0" cellspacing="0" cellpadding="0">' + CRLF
    cHtml +=						'<tr>' + CRLF
    cHtml +=							'<td background="'+TcfRetDirImg()+'/tabela_conteudo_1.gif" width="10">&nbsp;</td>' + CRLF
    cHtml +=							'<td class="titulo" width="498">' + CRLF
    cHtml +=								'<table width="498" border="0" cellspacing="2" cellpadding="1">' + CRLF
	cHtml += Imp_Cabec( nTamLin , nColunas , nTamanho , lTerminal )
Else
	//-- Inicializa Li com 1 para n�o imprimir cabecalho padrao
	Li := 01
	//-- Imprime Cabecalho Especifico.
	Imp_Cabec( nTamLin , nColunas ,  nTamanho , lTerminal, 1 )
EndIF

//-- Imprime Marca��es
nLenImp := Len(aImp)
For nX := 1 To nLenImp
	IF !( lTerminal )
		cDet := PADR(DtoC(aImp[nX,1]),10) + Space(1) + DiaSemana(aImp[nX,1],8)
		nMin := Min(nColunas+4,Len(aImp[nX]))
		If Len(aImp[nX]) >= 4
			For nY := 4 To nMin                              
			    //-- Imprime Marcacoes. Ao imprimir, verificar se as marcacoes passam de 9E/9S
			    //-- a partir dai acrescenta 2 espacoes apos imprimir a marcacao para disponibiliza-la
			    //-- corretamente abaixo do cabecalho correspondente. 
				cDet += aImp[nX,nY] + Space(If(nY<21,1,2))
			Next nY 
			//-- Imprime a ocorrencia (Ex.Excecao, DSR, Nao Trabalhado...)
			cDet += AllTrim( aImp[nX,2] )
		Else
			cDet += aImp[nX,2]
		Endif                                                                   
		//-- Qdo for "1a E. 2a S."  acrescenta mais 12 Brancos para que na eventual existencia de
		//-- ocorrencias como Excecoes e DSr e Compensado, as descricoes das mesmas saem integras,
		//-- sem cortes.                                    
	    //-- If(nColunas<3, SPACE(12),''), VEJA ABAIXO
		//-- Imprime o motivo de Abono....
		cDet := Left(cDet+Space(19+(nColunas*6))+If(nColunas<3, SPACE(12),'') , 19+(nColunas*6)+ If(nColunas<3, 12,0) ) + aImp[nX,3]
		cDet := Left(Alltrim(cDet)+Space(nTamLin),nTamLin)
		ImprEsp(cDet, 'C',,nTamLin , nColunas ,  nTamanho , lTerminal,1 )
	Else
		/*
		��������������������������������������������������������������Ŀ
		� Detalhes do Codigo HTML          							   �
		����������������������������������������������������������������*/
		IF ( lZebrado := ( nX%2 == 0.00 ) )
			cHtml += '<tr bgcolor="#FAFBFC">' + CRLF
			cHtml += 	'<td class="dados_2" bgcolor="#FAFBFC" nowrap><div align="center">' + CRLF
			cHtml += 		Dtoc(aImp[nX,1]) + CRLF
			cHtml += 	'</td>' + CRLF
			cHtml += 	'<td class="dados_2" bgcolor="#FAFBFC" nowrap><div align="left">' + CRLF
			cHtml +=		DiaSemana(aImp[nX,1]) + CRLF
			cHtml += 	'</td>' + CRLF
		Else
			cHtml += '<tr>' + CRLF
			cHtml += 	'<td class="dados_2" nowrap><div align="center">' + CRLF
			cHtml += 		Dtoc(aImp[nX,1]) + CRLF
			cHtml += 	'</td>' + CRLF
			cHtml += 	'<td class="dados_2" nowrap><div align="left">' + CRLF
			cHtml +=		DiaSemana(aImp[nX,1]) + CRLF
			cHtml += 	'</td>' + CRLF
		EndIF
		IF ( nLenImpnX := Len(aImp[nX]) ) < ( ( nColunas + nLenImpnX ) - 1 )
			For nY := Len(aImp[nX]) To ( ( nColunas + 3 ) - 1 )
				aAdd(aImp[nX] , Space(05) )
			Next nY
		EndIF
		nLenImpnX := Len(aImp[nX])
		For nY := 4 To nLenImpnX
			IF ( lZebrado )
				cHtml += 	'<td class="dados_2" bgcolor="#FAFBFC" nowrap><div align="center">' + CRLF
				cHtml += 		aImp[nX,nY] + CRLF
				cHtml += 	'</td>' + CRLF
			Else
				cHtml += 	'<td class="dados_2" nowrap><div align="center">' + CRLF
				cHtml += 		aImp[nX,nY] + CRLF
				cHtml += 	'</td>' + CRLF
			EndIF	
		Next nY
		IF ( lZebrado )
			cHtml += 		'<td class="dados_2" bgcolor="#FAFBFC" nowrap><div align="center">' + CRLF
			cHtml +=			Capital( AllTrim( aImp[nX,2] ) )
			cHtml += 		'</td>' + CRLF
			cHtml += 		'<td class="dados_2" bgcolor="#FAFBFC" nowrap><div align="left">' + CRLF
			cHtml +=			Capital( SubStr( aImp[nX,3] , 1 , At( ":" , aImp[nX,3] ) - 3 ) )
			cHtml += 		'</td>' + CRLF
			cHtml += 		'<td class="dados_2" bgcolor="#FAFBFC" nowrap><div align="center">' + CRLF
			cHtml +=			Capital( SubStr( aImp[nX,3] , At( ":" , aImp[nX,3] ) - 3 ) )
			cHtml += 		'</td>' + CRLF
		Else
			cHtml += 		'<td class="dados_2" nowrap><div align="center">' + CRLF
			cHtml +=			Capital( AllTrim( aImp[nX,2] ) )
			cHtml += 		'</td>' + CRLF
			cHtml += 		'<td class="dados_2" nowrap><div align="left">' + CRLF
			cHtml +=			Capital( SubStr( aImp[nX,3] , 1 , At( ":" , aImp[nX,3] ) - 3 ) )
			cHtml += 		'</td>' + CRLF
			cHtml += 		'<td class="dados_2" nowrap><div align="center">' + CRLF
			cHtml +=			Capital( SubStr( aImp[nX,3] , At( ":" , aImp[nX,3] ) - 3 ) )
			cHtml += 		'</td>' + CRLF
		EndIF	
	EndIF
Next nX

IF !( lTerminal )

	ImprEsp(Replicate('-',nTamLin), 'C',,nTamLin , nColunas ,  nTamanho , lTerminal )
	ImprEsp(' ','C',,nTamLin , nColunas ,  nTamanho , lTerminal )
	ImprEsp(cMenPad1 + cMenPad2 + Replicate('_',31), 'C',,nTamLin , nColunas ,  nTamanho , lTerminal )
	ImprEsp(Space(52) + STR0013 , 'C',,nTamLin , nColunas ,  nTamanho , lTerminal ) // 'Assinatura do Funcionario'
	
	//-- Se existirem totais, e se for selecionada sua impress�o, ser�o impressos.
	If Len(aTotais) > 0 .and. nImpHrs # 4
		ImprEsp(Replicate('-',nTamLin),'C',,nTamLin , nColunas ,  nTamanho , lTerminal )
		cDet := STR0014  // 'T O T A I S'
		ImprEsp(cDet,'C',,nTamLin , nColunas ,  nTamanho , lTerminal )
		ImprEsp(' ','C',,nTamLin , nColunas ,  nTamanho , lTerminal, 2 )
		If Len(aTotais) % 2 # 0
			aAdd (aTotais, Space(Len(aTotais[1])))
		Endif
		If nImpHrs == 1 .or. nImpHrs == 3
			cDet := STR0017  // 'Cod Descricao                Calc.    Infor.  Cod Descricao                Calc.    Infor.'
		ElseIf nImpHrs == 2
			cDet := STR0016  // 'Cod Descricao                         Infor.  Cod Descricao                         Infor.'
		Endif	
		ImprEsp(cDet,'C',,nTamLin , nColunas ,  nTamanho , lTerminal ,2)
		ImprEsp(Replicate('=',44)+Space(2)+Replicate('=',44),'C',,nTamLin , nColunas ,  nTamanho , lTerminal, 2 )
		nMetade := Len(aTotais) / 2
		For nX := 1 To Len(aTotais)/2
			cDet := aTotais[nX]+Space(2)+aTotais[nX+nMetade]
			ImprEsp(cDet,'C',,nTamLin , nColunas ,  nTamanho , lTerminal,2 )
		Next nX
	Endif	

   /*
	�������������������������������������������������������������Ŀ
	�Imprime o Banco de Horas do Funcionario.						     �
	���������������������������������������������������������������*/
	ImprEsp(Replicate('-',nTamLin),'C',,nTamLin , nColunas ,  nTamanho , lTerminal )
	ImprEsp("B A N C O   D E   H O R A S",'C',,nTamLin , nColunas ,  nTamanho , lTerminal )
	cDet := "                               Saldo Anterior: "+Transform(nSaldoAnt,"9999999.99")//Fernando: +Transform(14.14,"9999999.99")
	ImprEsp(cDet,'C',,nTamLin , nColunas ,  nTamanho , lTerminal )
	ImprEsp(' ','C',,nTamLin , nColunas ,  nTamanho , lTerminal, 2 )
	If (Len(aBanco) > 0)
		cDet := "Cod Descricao            "
		cDet += "    Debito"
		cDet += "    Credito"
		cDet += "      Saldo"
		ImprEsp(cDet,'C',,nTamLin , nColunas ,  nTamanho , lTerminal, 2 )
		ImprEsp(Replicate('=',57),'C',,nTamLin , nColunas ,  nTamanho , lTerminal, 2 )
	Endif
	nSaldoAtual := 0
	For nY := 1 To Len(aBanco)
		If Li > 57
			Li := 01
			Imp_Cabec( nTamLin , nColunas ,  nTamanho , lTerminal, 1 )
		EndIF                                                                        
		cDet := aBanco[nY,1] + "-"
		cDet += aBanco[nY,2] + " "
		cDet += Transform(aBanco[nY,3],"9999999.99") + " "
		cDet += Transform(aBanco[nY,4],"9999999.99") + " "
		cDet += Transform(aBanco[nY,5],"9999999.99") + " "
		Impr(cDet,"C")  
		nSaldoAtual:= aBanco[nY,5]
   Next nY 
    //cDet:= "902-CREDITO BH 50%             0.00       3.65       3.65" //fernando
    //Impr(cDet,"C") //Fernnado 
    //cDet:= "901-DEBITO BH                  0.30       0.00       3.35" //fernando
    //Impr(cDet,"C") //Fernnado   
   	ImprEsp(' ','C',,nTamLin , nColunas ,  nTamanho , lTerminal, 2 )    
	cDet := "                               Saldo Atual   : "+Transform(nSaldoAtual,"9999999.99") //Fernando:Transform(3.35,"9999999.99")
	ImprEsp(cDet,'C',,nTamLin , nColunas ,  nTamanho , lTerminal )
Else
	/*
	��������������������������������������������������������������Ŀ
	� Final da Estrutura do Codigo HTML							   �
	����������������������������������������������������������������*/
    cHtml +=									'<tr>' + CRLF
    cHtml +=										'<td colspan="' + AllTrim( Str( nColunas + 5 ) ) + '" class="etiquetas_1" bgcolor="#FAFBFC"><hr size="1"></td>' + CRLF 
    cHtml +=									'</tr>' + CRLF
	cHtml +=								'</table>' + CRLF
	cHtml +=							'</td>' + CRLF
    cHtml +=							'<td background="'+TcfRetDirImg()+'/tabela_conteudo_2.gif" width="7">&nbsp;</td>' + CRLF
    cHtml +=						'</tr>' + CRLF
    cHtml +=					'</table>' + CRLF
    cHtml +=				'</td>' + CRLF
  	cHtml +=			'</tr>' + CRLF
	cHtml +=		'</table>' + CRLF
	cHtml +=		'<p align="right"><a href="javascript:self.print()"><img src="'+TcfRetDirImg()+'/imprimir.gif" width="90" height="28" hspace="20" border="0"></a></p>' + CRLF
	cHtml +=	'</body>' + CRLF
	cHtml += '</html>' + CRLF
EndIF
	
Return( cHtml )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �FMontaaIMP� aUTOR � EQUIPE DE RH          � dATA � 09/04/96 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Monta o Vetor aImp , utilizado na impressao do espelho     ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   �                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � POR010IMP                                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function FMontaAimp(aTabCalend, aMarcacoes, aImp,dInicio,dFim)

Local aDescAbono := {}
Local cTipAfas   := ""
Local cDescAfas  := ""
Local cOcorr     := ""
Local cOrdem     := ""
Local cTipDia    := ""
Local dData      := Ctod("//")
Local dDtBase    := dFim
Local lRet       := .T.
Local lFeriado   := .T.
Local lTrabaFer  := .F.
Local lAfasta    := .T.
Local nX         := 0
Local nDia       := 0
Local nMarc      := 0
Local nLenMarc	 := Len( aMarcacoes )
Local nLenDescAb := Len( aDescAbono )
Local nTab       := 0
Local nContMarc  := 0
Local nDias		 := 0 

//-- Variaveis ja inicializadas.
aImp := {}

nDias := ( dDtBase - dInicio )
For nDia := 0 To nDias

	//-- Reinicializa Variaveis.
	dData      := dInicio + nDia
	aDescAbono := {}
	cOcorr     := ""
	cTipAfas   := ""
	cDescAfas  := ""
	cOcorr	   := ""

	//-- o Array aTabcalend � setado para a 1a Entrada do dia em quest�o.
	IF ( nTab := aScan(aTabCalend, {|x| x[1] == dData .and. x[4] == '1E' }) ) == 0.00
		Loop
	EndIF

	//-- o Array aMarcacoes � setado para a 1a Marca��o do dia em quest�o.
	nMarc := aScan(aMarcacoes, { |x| x[3] == aTabCalend[nTab, 2] })

	//-- Consiste Afastamentos, Demissoes ou Transferencias.
	IF ( ( lAfasta := aTabCalend[ nTab , 24 ] ) .or. SRA->( RA_SITFOLH $ 'D�T' .and. dData > RA_DEMISSA ) )
		lAfasta		:= .T.
		cTipAfas	:= IF(!Empty(aTabCalend[ nTab , 25 ]),aTabCalend[ nTab , 25 ],fDemissao(SRA->RA_SITFOLH, SRA->RA_RESCRAI) )
		cDescAfas	:= fDescAfast( cTipAfas )
	EndIF

	//-- Consiste Feriados.
	IF ( lFeriado := aTabCalend[ nTab , 19 ] )
		cOcorr := aTabCalend[ nTab , 22 ]
	EndIF

	//Verifica Regra de Apontamento ( Trabalha Feriado ? )
	lTrabaFer := ( PosSPA( aTabCalend[ nTab , 23 ] , cFilSPA , "PA_FERIADO" , 01 ) == "S" )

	//-- Carrega Array aDescAbono com os Abonos ocorridos no Dia
	nLenDescAb := Len(aAbonados)
	For nX := 1 To nLenDescAb
		If aAbonados[nX,1] == dData
			aAdd(aDescAbono, aAbonados[nX,2] + Space(1) + aAbonados[nX,3]+ Space(2) + aAbonados[nX,4])
		EndIf
	Next nX

	//-- Ordem e Tipo do dia em quest�o.
	cOrdem  := aTabCalend[nTab,2]
	cTipDia := aTabCalend[nTab,6]

    //-- Se a Data da marcacao for Posterior a Admissao
	IF dData >= SRA->RA_ADMISSA
		//-- Se Afastado
		If ( lAfasta  .AND. aTabCalend[nTab,10] <> 'E' ) .OR. ( lAfasta  .AND. aTabCalend[nTab,10] == 'E' .AND. !lImpExcecao )
			cOcorr := cDescAfas
		//-- Se nao for Afastado
		Else                    

		    //-- Se tiver EXCECAO para o Dia  ------------------------------------------------
			If aTabCalend[nTab,10] == 'E'			
		       //-- Se excecao trabalhada
		       If cTipDia == 'S'  
		          //-- Se nao fez Marcacao
		          If Empty(nMarc)
					 cOcorr := STR0020  // '** Ausente **'					     
				  //-- Se fez marcacao	 
		          Else
		          	 //-- Motivo da Marcacao
	          		 If !Empty(aTabCalend[nTab,11])
					 	cOcorr := Left(AllTrim(aTabCalend[nTab,11]), Min(Len(AllTrim(aTabCalend[nTab,11])),23))
					 Else
					 	cOcorr := STR0018  // '** Excecao nao Trabalhada **'
					 EndIf
		          Endif	 
		       //-- Se excecao outros dias (DSR/Compensado/Nao Trabalhado)
		       Else
 					//-- Motivo da Marcacao
		       		If !Empty(aTabCalend[nTab,11])
						cOcorr := Left(AllTrim(aTabCalend[nTab,11]), Min(Len(AllTrim(aTabCalend[nTab,11])),23))
					Else
						cOcorr := STR0018  // '** Excecao nao Trabalhada **'
					EndIf
			   Endif	

		    //-- Se nao Tiver Excecao  no Dia ---------------------------------------------------
		    Else    
		        //-- Se feriado 
		       	If lFeriado 
		       	    //-- Se nao trabalha no Feriado
		       	    If !lTrabaFer 
						cOcorr := If(!Empty(cOcorr),cOcorr,STR0019 ) // '** Feriado **'                       
					//-- Se trabalha no Feriado
					Else                  
					    //-- Se Dia Trabalhado e Nao fez Marcacao
				    	If cTipDia == 'S' .and. Empty(nMarc)
							cOcorr := STR0020  // '** Ausente **'
				    	ElseIf cTipDia == 'D'
							cOcorr := STR0021  // '** D.S.R. **'
						ElseIf cTipDia == 'C'
							cOcorr := STR0022  // '** Compensado **'
						ElseIf cTipDia == 'N'
							cOcorr := STR0023  // '** Nao Trabalhado **'
						EndIf
					Endif	
		    	Else                                    
		    	    //-- Se Dia Trabalhado e Nao fez Marcacao
			    	If cTipDia == 'S' .and. Empty(nMarc)
						cOcorr := STR0020  // '** Ausente **'
			    	ElseIf cTipDia == 'D'
						cOcorr := STR0021  // '** D.S.R. **'
					ElseIf cTipDia == 'C'
						cOcorr := STR0022  // '** Compensado **'
					ElseIf cTipDia == 'N'
						cOcorr := STR0023  // '** Nao Trabalhado **'
					EndIf
				Endif	
		    Endif
		Endif
	Endif	    
		
	cOcorr := If(!Empty(cOcorr),Space( Int((23-Len(cOcorr))/2) ) + cOcorr,'')

	//-- Adiciona Nova Data a ser impressa.
	aAdd(aImp,{})
	aAdd(aImp[Len(aImp)], aTabCalend[nTab,1])

	//-- Ocorrencia na Data.
	aAdd( aImp[Len(aImp)], cOcorr)

	//-- Abono na Data.
	If ( nLenDescAb := Len(aDescAbono) ) > 0
		For nX := 1 To nLenDescAb
			If nX == 1
				aAdd( aImp[Len(aImp)], aDescAbono[nX])
			Else
				aAdd(aImp, {})
				aAdd(aImp[Len(aImp)], aTabCalend[nTab,1])
				aAdd(aImp[Len(aImp)], Space(Len(cOcorr)-13)+Replicate('.',13))
				aAdd(aImp[Len(aImp)], aDescAbono[nX])
			Endif
		Next nX
	Else
		aAdd( aImp[Len(aImp)], '' )
	Endif

	//-- Marca�oes ocorridas na data.
	If nMarc > 0
		While nMarc <= nLenMarc .and. cOrdem == aMarcacoes[nMarc,3]
			nContMarc ++
			aAdd( aImp[Len(aImp)], StrTran(StrZero(aMarcacoes[nMarc,2],5,2),'.',':'))
			nMarc ++
		End While
	EndIf

Next nDia

lRet := If(nContMarc>=1,.T.,.F.)

Return( lRet )

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �Imp_Cabec � Autor � EQUIPE DE RH          � Data � 09/04/96 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Imprime o cabecalho do espelho do ponto                    ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   �                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � POR010IMP                                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������/*/
Static Function Imp_Cabec(nTamLin ,nColunas, nTamanho , lTerminal,nTipoCab )

Local cDet			:= ""
Local cHtml			:= ""
Local lImpTurnos	:=.F.
Local nVezes		:= ( nColunas / 2 )
Local nQtdeTurno	:= 0.00
Local nX			:= 0.00
Local nTamTno		:= ( Min(TamSx3("R6_DESC")[1], nTamLin) )
                        
If (lTerminal == Nil)
	lTerminal := .F.
Endif
If (nTipoCab == Nil)
	nTipoCab  := 3 // 1 - Cab para as Marcacoes / 2 - Totais / 3 - Sem Cab Auxiliar
Endif

lImpTurnos := If(Li==1,.T.,.F.) //-- Somente imprime as trocas de turnos na 1 pagina de cada funcionario

IF !( lTerminal )

	//-- Inicializa a impress�o

    @ 0,0 PSAY AvalImp(nTamLin )
	
	//-- Inicializa Li com 1 para n�o imprimir cabecalho padrao
	Li := 01

	//-- Linha 01
	//-- Emp...: XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX Matr..: 99-999999  Chapa : 9999999999
	cDet := STR0024  + PADR( If(Len(aInfo)>0,aInfo[03],SM0->M0_NomeCom) , 50)  // 'Emp...: '
	cDet += SPACE(2)+ STR0025  + SRA->RA_Filial + '-' + SRA->RA_Mat  // ' Matr..: '
	cDet += STR0026  + SRA->RA_Chapa // '  Chapa : '
	Impr(cDet,'C')
	
	//-- Linha 02
	//-- End...: XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX Nome..: XXXXXXXXXXXXXXXXXXXXXXXXXXXXX
	cDet := STR0027  + PADR( If(Len(aInfo)>0,aInfo[04],SM0->M0_EndCob) , 50) // 'End...: '
	cDet += SPACE(2)+ STR0028  + SRA->RA_Nome  // ' Nome..: '
	Impr(cDet,'C')
	
	//-- Linha 03
	//-- CGC...: 99.999.999/9999-99                Categ.: XXXXXXXXXXXXXXX 
	cDet := STR0029  + PADR(Transform( If(Len(aInfo)>0,aInfo[08],SM0->M0_CGC),'@R ##.###.###/####-##'),50)   // 'CGC...: '
	cDet += SPACE(2) + STR0032  + DescCateg(SRA->RA_CatFunc,25) // ' Categ.: '
	Impr(cDet,'C')
	
	//-- Linha 04
	//-- C.C...: 99999999-XXXXXXXXXXXXXXXXXXXXXXX  Funcao: 9999-XXXXXXXXXXXXXXXXXXXX
	cDet := STR0031  + PADR(AllTrim(SRA->RA_CC) + '-' + DescCc(SRA->RA_CC, SRA->RA_FILIAL,25) , 50) // 'C.C...: '
	cDet += SPACE(2) + STR0030  + SRA->RA_CodFunc + '-' + DescFun(SRA->RA_CodFunc , SRA->RA_Filial)  // 'Funcao: '
	Impr(cDet,'C')
	
	//-- Linha 06
	//-- Turno.: 999-XXXXXXXXXXXXXXXXXXXXX
	//-- Imprime Trocas de turnos
	nQtdeTurno:=Len(aPrtTurn)
	
	If !lImpTroca .OR. nQtdeTurno<2   //-- Imprime Somente a descricao do turno atual
	   If !lImpTroca .OR. nQtdeTurno == 0 //-- Periodo Atual ou Superior
	   	  cDet := STR0033  + AllTrim(SRA->RA_TnoTrab) + ' ' + fDescTno(SRA->RA_Filial,SRA->RA_TnoTrab, nTamTno) // 'Turno.: '
	   Else	 //Periodo Anterior 
		  cDet := STR0033  + AllTrim(Alltrim(aPrtTurn[1,1])) + ' ' + fDescTno(SRA->RA_Filial,aPrtTurn[1,1], nTamTno) // 'Turno.: '
	   Endif
	   Impr(cDet,'C')
	Else
        If lImpTurnos // Se for o mesmo funcionario nao imprime trocas de turnos a partir da 2 pagina
        	//-- Imprime Trocas de Turnos no Periodo
			For nX := 1 To nQtdeTurno
				cDet:= If(nX==1,STR0049,SPACE(Len(STR0049)))
		    	cDet:= cDet+DTOC(aPrtTurn[nX,2])+" "+STR0048+Alltrim(aPrtTurn[nX,1])+": "+Alltrim(fDescTno( SRA->RA_FILIAL, aPrtTurn[nX,1], nTamTno))
				Impr(cDet,'C')
			Next nX 
		
		Endif	
	Endif
	
	If nTipoCab==1
		//-- Monta e Imprime Cabecalho das Marcacoes
		cHeader := STR0034  // '   DATA    DIA     '
		
		//								99/99/9999 Segunda
		For nX := 1 To nVezes
			cHeader += StrZero(nX,If(nX<10,1,2)) + STR0035  + StrZero(nX,If(nX<10,1,2)) + STR0036  // 'a E. '###'a S. '
		Next nX
		//-- Qdo for "1a E. 2a S."  acrescenta mais 20 Brancos para que na eventual existencia de
		//-- ocorrencias como Excecoes e DSr e Compensado, as descricoes das mesmas saem integras,
		//-- sem cortes. 
		cHeader+=If(nVezes==1,SPACE(12),'') 
		cHeader += STR0037  // 'Motivo de Abono           Horas'
		Impr(Replicate('-',nTamLin), 'C')
		Impr(cHeader, 'C')
		Impr(Replicate('-',nTamLin), 'C')
	
	Elseif nTipoCab==2                   
		Impr(Replicate('-',nTamLin), 'C')
		Impr(' ' ,'C')
		If Len(aTotais) % 2 # 0
			aAdd (aTotais, Space(Len(aTotais[1])))
		Endif
		If nImpHrs == 1 .or. nImpHrs == 3
			cDet := STR0017  // 'Cod Descricao             Calc. Infor.    Cod Descricao             Calc. Infor.'
		ElseIf nImpHrs == 2
			cDet := STR0016  // 'Cod Descricao                   Infor.    Cod Descricao                   Infor.'
		Endif
	
		Impr(cDet,'C')
		Impr(Replicate('=',38)+Space(4)+Replicate('=',38),'C')
	Endif
Else
	/*
	��������������������������������������������������������������Ŀ
	� Monta o Cabecalho das Marcacoes							   �
	����������������������������������������������������������������*/
    cHtml +=									'<tr>' + CRLF
    cHtml +=										'<td colspan="' + AllTrim( Str( nColunas + 5 ) ) + '" class="etiquetas_1" bgcolor="#FAFBFC"><hr size="1"></td>' + CRLF
    cHtml +=									'</tr>' + CRLF
	cHtml +=									'<tr>' + CRLF
	cHtml +=											'<td class="etiquetas_1" bgcolor="#FAFBFC" nowrap>' + CRLF
    cHtml +=												'<div align="left">' + CRLF
	cHtml +=													STR0042 + CRLF	//'Data'
    cHtml +=												'</div>' + CRLF
	cHtml +=											'</td>' + CRLF
	cHtml +=											'<td class="etiquetas_1" bgcolor="#FAFBFC" nowrap>' + CRLF
    cHtml +=												'<div align="left">' + CRLF
	cHtml +=													STR0043 + CRLF	//'Dia'
    cHtml +=												'</div>' + CRLF
	cHtml +=											'</td>' + CRLF
	For nX := 1 To nVezes
		cHtml +=										'<td class="etiquetas_1" bgcolor="#FAFBFC" nowrap>' + CRLF
   		cHtml +=											'<div align="center">' + CRLF
    	cHtml +=												StrZero(nX,If(nX<10,1,2)) + STR0044 + CRLF	// '&#170;E.'
   		cHtml +=											'</div>' + CRLF
    	cHtml +=										'</td>' + CRLF
		cHtml +=										'<td class="etiquetas_1" bgcolor="#FAFBFC" nowrap>' + CRLF
   		cHtml +=											'<div align="center">' + CRLF
    	cHtml +=												StrZero(nX,If(nX<10,1,2)) + STR0045 + CRLF	//'&#170;S.'
   		cHtml +=											'</div>' + CRLF
    	cHtml +=										'</td>' + CRLF
	Next nX
	cHtml +=											'<td class="etiquetas_1" bgcolor="#FAFBFC" nowrap>' + CRLF
    cHtml +=												'<div align="left">' + CRLF
	cHtml +=													STR0046 + CRLF //'Observa&ccedil;&otilde;s
    cHtml +=												'</div>' + CRLF
	cHtml +=											'</td>' + CRLF
	cHtml +=											'<td class="etiquetas_1" bgcolor="#FAFBFC" nowrap>' + CRLF
    cHtml +=												'<div align="left">' + CRLF
	cHtml +=													STR0041 + CRLF	//'Motivo de Abono           Horas  Tipo da Marca&ccedil;&atilde;o'
    cHtml +=												'</div>' + CRLF
	cHtml +=											'</td>' + CRLF
	cHtml +=											'<td class="etiquetas_1" bgcolor="#FAFBFC" nowrap>' + CRLF
    cHtml +=												'<div align="left">' + CRLF
	cHtml +=													STR0047 + CRLF	//'Horas  Tipo da Marca&ccedil;&atilde;o'
    cHtml +=												'</div>' + CRLF
	cHtml +=											'</td>' + CRLF
    cHtml +=									'</tr>' + CRLF
    cHtml +=									'<tr>' + CRLF
    cHtml +=										'<td colspan="' + AllTrim( Str( nColunas + 5 ) ) + '" class="etiquetas_1" bgcolor="#FAFBFC"><hr size="1"></td>' + CRLF
    cHtml +=									'</tr>' + CRLF
EndIF
	
Return( cHtml )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �CarAboTot � Autor � EQUIPE DE RH          � Data � 08/08/96 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Carrega os totais do SPC e os abonos                       ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   �                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � POR010IMP                                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function CarAboTot( aTotais , aAbonados , aAbonosPer, lMvAbosEve, lMvSubAbAp ) 

Local aTotSpc		:= {} //-- 1-SPC->PC_PD/2-SPC->PC_QUANTC/3-SPC->PC_QUANTI/4-SPC->PC_QTABONO
Local aCodAbono		:= {}
Local aJustifica	:= {} //-- Retorno fAbonos() c/Cod abono e horas abonadas.
Local cString   	:= ""
Local cFilSP9   	:= xFilial( "SP9" , SRA->RA_FILIAL )
Local cFilSRV		:= xFilial( "SRV" , SRA->RA_FILIAL )
Local cFilSPC   	:= xFilial( "SPC" , SRA->RA_FILIAL )
Local cFilSPH   	:= xFilial( "SPH" , SRA->RA_FILIAL )
Local cImpHoras 	:= If(nImpHrs==1,"C",If(nImpHrs==2,"I","*")) //-- Calc/Info/Ambas
Local cAutoriza 	:= If(nImpAut==1,"A",If(nImpAut==2,"N","*")) //-- Aut./N.Aut./Ambas
Local cAliasRes		:= IF( lImpAcum , "SPL" , "SPB" )
Local cAliasApo		:= IF( lImpAcum , "SPH" , "SPC" )
Local bAcessaSPC 	:= &("{ || " + ChkRH("PONR010","SPC","2") + "}")
Local bAcessaSPH 	:= &("{ || " + ChkRH("PONR010","SPH","2") + "}")
Local bAcessaSPB 	:= &("{ || " + ChkRH("PONR010","SPB","2") + "}")
Local bAcessaSPL 	:= &("{ || " + ChkRH("PONR010","SPL","2") + "}")
Local bAcessRes		:= IF( lImpAcum , bAcessaSPH , bAcessaSPC )
Local bAcessApo		:= IF( lImpAcum , bAcessaSPL , bAcessaSPB )
Local lCalcula	 	:= .F.
Local lExtra	 	:= .F.
Local nColSpc   	:= 0.00
Local nCtSpc    	:= 0.00
Local nQuaSpc		:= 0.00
Local nPass     	:= 0.00
Local nHorasCal 	:= 0.00
Local nHorasInf 	:= 0.00
Local nX        	:= 0.00

If ( lImpRes )
	//Totaliza Codigos a partir do Resultado	
	fTotalSPB(;
				@aTotSpc		,;
				SRA->RA_Filial	,;
				SRA->RA_Mat		,;
				dMarcIni		,;
				dMarcFim		,;
				bAcessRes		,;
				cAliasRes		,;
				cAutoriza		 ;
			  )
	//-- Converte as horas para sexagenal quando impressao for a partir do resultado
	If ( lSexagenal )	// Sexagenal
		For nCtSpc := 1 To Len(aTotSpc)
			For nColSpc := 2 To 4
				aTotSpc[nCtSpc,nColSpc]:=fConvHr(aTotSpc[nCtSpc,nColSpc],'H')
			Next nColSpc
		Next nCtSpc
	Endif
Endif

//Totaliza Codigos a partir do Movimento
fTotaliza(;
			@aTotSpc,;
			SRA->RA_FILIAL,;
			SRA->RA_MAT,;
			bAcessApo,;
			cAliasApo,;
			cAutoriza,;
			@aCodAbono,;
			aAbonosPer,;
			lMvAbosEve,;
			lMvSubAbAp;
	 	)
//-- Converte as horas para Centesimal quando impressao for a partir do apontamento
If !( lImpRes ) .and. !( lSexagenal ) // Centesimal
	For nCtSpc :=1 To Len(aTotSpc)
		For nColSpc :=2 To 4
			aTotSpc[nCtSpc,nColSpc]:=fConvHr(aTotSpc[nCtSpc,nColSpc],'D')
		Next nColSpc
	Next nCtSpc
Endif


//-- Monta Array com Totais de Horas
If nImpHrs # 4  //-- Se solicitado para Listar Totais de Horas
	For nPass := 1 To Len(aTotSpc)
		IF ( lImpRes ) //Impressao dos Resultados
			//-- Se encontrar o Codigo da Verba ou For um codigo de hora extra valido de acordo com o solicitado  
			If PosSrv( aTotSpc[nPass,1] , cFilSRV , NIL , 01 )
		   	   nHorasCal 	:= aTotSpc[nPass,2] //-- Calculado - Abonado
			   nHorasInf 	:= aTotSpc[nPass,3] //-- Informado
			   If nHorasCal > 0 .and. cImpHoras $ 'C�*' .or. nHorasInf > 0 .and. cImpHoras $ 'I�*'
			  	  cString := If(cImpHoras$'C�*',Transform(nHorasCal, '@E 99,999.99'),Space(9)) + Space(1)
				  cString += If(cImpHoras$'I�*',Transform(nHorasInf, '@E 99,999.99'),Space(9))
				  aAdd(aTotais, aTotSpc[nPass,1] + Space(1) + SRV->RV_DESC + Space(1) + cString )
		  	   EndIf	
	        Endif
		ElseIf PosSP9( aTotSpc[nPass,1] , cFilSP9 , NIL , 01 )
			//-- Impressao a Partir do Movimento
			nHorasCal 	:= aTotSpc[nPass,2] //-- Calculado - Abonado
			nHorasInf 	:= aTotSpc[nPass,3] //-- Informado
			If nHorasCal > 0 .and. cImpHoras $ 'C�*' .or. nHorasInf > 0 .and. cImpHoras $ 'I�*'
				cString := If(cImpHoras$'C�*',Transform(nHorasCal, '@E 99,999.99'),Space(9)) + Space(1)
				cString += If(cImpHoras$'I�*',Transform(nHorasInf, '@E 99,999.99'),Space(9))
				aAdd(aTotais, aTotSpc[nPass,1] + Space(1) + DescPDPon(aTotSpc[nPass,1], cFilSP9 ) + Space(1) + cString )
			EndIf  
		EndIF
	Next nPass
	
	//-- Acrescenta as informacoes referentes aos eventos associados aos motivos de abono
	//-- Condicoes: Se nao For Impressao de Resultados 
	//-- 			e Se For para Imprimir Horas Calculadas ou Ambas
	If !( lImpRes ) .and. (nImpHrs == 1 .or. nImpHrs == 3) 
		For nX := 1 To Len(aCodAbono) 
			// Converte as horas para Centesimal
			If !( lSexagenal ) // Centesimal
				aCodAbono[nX,2]:=fConvHr(aCodAbono[nX,2],'D')
			Endif
			aAdd(aTotais, aCodAbono[nX,1] + Space(1) + DescPDPon(aCodAbono[nX,1], cFilSP9) + '      0,00 '  + Transform(aCodAbono[nX,2],'@E 99,999.99') )
		Next nX
	Endif
EndIf

Return( NIL )

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �fTotaliza � Autor � Mauricio MR           � Data � 27/05/02 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Totalizar as Verbas do SPC (Apontamentos) /SPH (Acumulado) ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � Generico 												  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������/*/
Static Function fTotaliza(	aTotais		,;
							cFil		,;
							cMat		,;
							bAcessa 	,;
							cAlias		,;
							cAutoriza	,;
							aCodAbono	,;
							aAbonosPer	,;
							lMvAbosEve	,;
							lMvSubAbAp 	 ;
						 )

Local aJustifica	:= {}
Local cCodigo		:= ""
Local cPrefix		:= SubStr(cAlias,-2)
Local cTno			:= ""
Local cCodExtras	:= ""
Local cEvento		:= ""
Local cPD			:= ""
Local cPDI			:= ""
Local cCC			:= ""
Local cTPMARCA		:= ""
Local dPD			:= Ctod("//")
Local lExtra		:= .T.
Local lAbHoras		:= .T.
Local nQuaSpc		:= 0.00
Local nX			:= 0.00 
Local nEfetAbono	:= 0.00
Local nQUANTC		:= 0.00
Local nQuanti		:= 0.00
Local nQTABONO		:= 0.00

If ( cAlias )->(dbSeek( cFil + cMat ) )
	While (cAlias)->( !Eof() .and. cFil+cMat == &(cPrefix+"_FILIAL")+&(cPrefix+"_MAT") )
        
        dData	:= (cAlias)->(&(cPrefix+"_DATA"))  	//-- Data do Apontamento
        cPD		:= (cAlias)->(&(cPrefix+"_PD"))    	//-- Codigo do Evento
        cPDI	:= (cAlias)->(&(cPrefix+"_PDI"))     	//-- Codigo do Evento Informado
        nQUANTC	:= (cAlias)->(&(cPrefix+"_QUANTC"))  	//-- Quantidade Calculada pelo Apontamento
        nQuanti	:= (cAlias)->(&(cPrefix+"_QUANTI"))  	//-- Quantidade Informada
        nQTABONO:= (cAlias)->(&(cPrefix+"_QTABONO")) 	//-- Quantidade Abonada
		cTPMARCA:= (cAlias)->(&(cPrefix+"_TPMARCA")) 	//-- Tipo da Marcacao
		cCC		:= (cAlias)->(&(cPrefix+"_CC")) 		//-- Centro de Custos
		
		If (cAlias)->( !Eval(bAcessa) )
			(cAlias)->( dbSkip() )
			Loop
		EndIf
		
		If dData < dMarcIni .or. dDATA > dMarcFim 
			(cAlias)->( dbSkip() )
			Loop
		Endif
        
		 /*
		��������������������������������������������������������������Ŀ
		� Obtem TODOS os ABONOS do Evento							   �
		����������������������������������������������������������������*/
        //-- Trata a Qtde de Abonos
        aJustifica 	:= {} //-- Reinicializa aJustifica
        nEfetAbono	:=	0.00
		If nQuanti == 0 .and. fAbonos( dData , cPD , NIL , @aJustifica , cTPMARCA , cCC , aAbonosPer ) > 0
            
            //-- Corre Todos os Abonos
			For nX := 1 To Len(aJustifica)
			    
			   /*
				��������������������������������������������������������������Ŀ
				� Cria Array Analitico de Abonos com horas Convertidas.		   �
				����������������������������������������������������������������*/
				//-- Obtem a Quantidade de Horas Abonadas
				nQuaSpc := aJustifica[nX,2] //_QtAbono
				
				//-- Converte as horas Abonadas para Centesimal
				If !( lSexagenal ) // Centesimal
					nQuaSpc:= fConvHr(nQuaSpc,'D')
				Endif
                
                //-- Cria Novo Elemento no array ANALITICO de Abonos 
				aAdd( aAbonados, {} )
				aAdd( aAbonados[Len(aAbonados)], dData )
				aAdd( aAbonados[Len(aAbonados)], DescAbono(aJustifica[nX,1],'C') )
				
				aAdd( aAbonados[Len(aAbonados)], StrTran(StrZero(nQuaSpc,5,2),'.',':') )
				aAdd( aAbonados[Len(aAbonados)], DescTpMarca(aBoxSPC,cTPMARCA))
				
				If !( lImpres )
					/*
					�������������������������������������������������������������������Ŀ
					� Trata das Informacoes sobre o Evento Associado ao Motivo corrente �
					���������������������������������������������������������������������*/ 
					//-- Obtem Evento Associado
					cEvento := PosSP6( aJustifica[nX,1] , SRA->RA_FILIAL , "P6_EVENTO" , 01 )
					If ( lAbHoras := ( PosSP6( aJustifica[nX,1] , SRA->RA_FILIAL , "P6_ABHORAS" , 01 ) $ " S" ) )
					    //-- Se o motivo abona Horas
						If ( lAbHoras )
							If !Empty( cEvento )
								If ( nPos := aScan( aCodAbono, { |x| x[1] == cEvento } ) ) > 0
									aCodAbono[nPos,2] := __TimeSum(aCodAbono[nPos,2], aJustifica[nX,2] ) //_QtAbono
								Else
									aAdd(aCodAbono, {cEvento,  aJustifica[nX,2] }) // Codigo do Evento e Qtde Abonada
								EndIf
							Else 
								/*
								�����������������������������������������������������������������������Ŀ
								� A T E N C A O: Neste Ponto deveriamos tratar o paramentro MV_ABOSEVE  �
								�                no entanto, como ja havia a deducao abaixo e caso al-  �
								�                guem migra-se da versao 609 com o cadastro de motivo   �
								�                de abonos abonando horas mas sem o codigo, deixariamos �
								�                de tratar como antes e o cliente argumentaria alteracao�
								�                de conceito.											�
								�������������������������������������������������������������������������*/ 
							    //-- Se o motivo  nao possui abono associado
							    //-- Calcula o total de horas a abonar efetivamente
							    nEfetAbono:= __TimeSum(nEfetAbono, aJustifica[nX,2] ) //_QtAbono
							EndIf
						Endif
					Else	
						/*
						��������������������������������������������������������������Ŀ
						�Se Motivo de Abono Nao Abona Horas e o Codigo do Evento Relaci�
						�onado ao Abono nao Estiver Vazio, Eh como se fosse uma  altera�
						�racao do Codigo de Evento. Ou seja, Vai para os Totais      as�
						�Horas do Abono que serao subtraidas das Horas Calculadas (  Po�
						�deriamos Chamar esta operacao de "Informados via Abono" ).	   �
						�Para que esse processo seja feito o Parametro MV_SUBABAP  deve�
						�ra ter o Conteudo igual a "S"								   �
						����������������������������������������������������������������*/
						IF ( ( lMvSubAbAp ) .and. !Empty( cEvento ) )
						   //-- Se o motivo  nao possui abono associado
						   //-- Calcula o total de horas a abonar efetivamente 
						   If ( nPos := aScan( aCodAbono, { |x| x[1] == cEvento } ) ) > 0
								aCodAbono[nPos,2] := __TimeSum(aCodAbono[nPos,2], aJustifica[nX,2] ) //_QtAbono
						   Else
								aAdd(aCodAbono, {cEvento,  aJustifica[nX,2] }) // Codigo do Evento e Qtde Abonada
						   EndIf
						   //-- O total de horas acumulado em nEfetAbono sera deduzido do 
						   //-- total de horas apontadas.
						   nEfetAbono:= __TimeSum(nEfetAbono, aJustifica[nX,2] ) //_QtAbono
						Endif
					EndIf
				Endif	
			Next nX 
		Endif
        
        If !( lImpres )
	        //-- Obtem o Codigo do Evento  (Informado ou Calculado)
	        cCodigo:= If(!Empty(cPDI), cPDI, cPD )
	         
	        //-- Obtem a posicao no Calendario para a Data
	        
	        If ( nPos 	:= aScan(aTabCalend, {|x| x[1] ==dDATA .and. x[4] == '1E' }) ) > 0 
			    //-- Obtem o Turno vigente na Data
			    cTno	:=	aTabCalend[nPos,14]  
			    //-- Carrega ou recupera os codigos correspondentes a horas extras na Data
			    cCodExtras	:= ''
			    CarExtAut( @cCodExtras , cTno , cAutoriza )
			    lExtra:=.F.
			    If cCodigo$cCodExtras 
			       lExtra:=.T.
			    Endif   
			Endif      
	                 
	        //-- Se o Evento for Alguma HE Solicitada (Autorizada ou Nao Autorizada) 
	        //-- Ou  Valido Qquer Evento (Autorizado e Nao Autorizado)
	        //-- OU  Evento possui um identificador correspondente a Evento Autorizado ou Nao Autorizado.
	        If lExtra .or. cAutoriza == '*' .or. (aScan(aId,{|aEvento| aEvento[1] == cCodigo .and. Right(aEvento[2],1) == cAutoriza }) > 0.00)		
	           
		        //-- Procura em aTotais pelo acumulado do Evento Lido
				If ( nPos := aScan(aTotais,{|x| x[1] = cCodigo  }) ) > 0    
				   //-- Subtrai do evento a qtde de horas que efetivamente abona horas conforme motivo de abono
			       aTotais[nPos,2] := __TimeSum(aTotais[nPos,2],If(nQuanti>0, 0, __TimeSub(nQUANTC,nEfetAbono)))
				   aTotais[nPos,3] := __TimeSum(aTotais[nPos,3],nQuanti)
				   aTotais[nPos,4] := __TimeSum(aTotais[nPos,4],nQTABONO)
			    
				Else 
				   //-- Adiciona Evento em Acumulados
				   //-- Subtrai do evento a qtde de horas que efetivamente abona horas conforme motivo de abono
	           	   aAdd(aTotais,{cCodigo,If(nQuanti > 0, 0, __TimeSub(nQUANTC,nEfetAbono)), nQuanti,nQTABONO,lExtra })
	            Endif
	        Endif
         Endif
		(cAlias)->( dbSkip() )
	End While
Endif

Return( NIL )

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �fTotalSPB � Autor � EQUIPE DE RH		    � Data � 05/06/00 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Totaliza eventos a partir do SPB.                          ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � Generico 												  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������/*/
Static Function fTotalSPB(aTotais,cFil,cMat,dDataIni,dDataFim,bAcessa,cAlias)

Local cPrefix := ""

cPrefix		:= SubStr(cAlias,-2)

If ( cAlias )->( dbSeek( cFil + cMat ) )
	While (cAlias)->( !Eof() .and. cFil+cMat == &(cPrefix+"_FILIAL")+&(cPrefix+"_MAT") )

		If (cAlias)->( &(cPrefix+"_DATA") < dDataIni .or. &(cPrefix+"_DATA") > dDataFim )
			(cAlias)->( dbSkip() )
			Loop
		Endif

		If (cAlias)->( !Eval(bAcessa) )
			(cAlias)->( dbSkip() )
			Loop
		EndIf

		If ( nPos := aScan(aTotais,{|x| x[1] == (cAlias)->( &(cPrefix+"_PD") ) }) ) > 0
			aTotais[nPos,2] := aTotais[nPos,2] + (cAlias)->( &(cPrefix+"_HORAS") ) 
		Else
			aAdd(aTotais,{(cAlias)->( &(cPrefix+"_PD") ),(cAlias)->( &(cPrefix+"_HORAS") ),0,0 })
		Endif
		(cAlias)->( dbSkip() )
	End While
Endif

Return( NIL )


/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �LoadX3Box � Autor � Mauricio MR           � Data � 10.12.01 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Retorna array da ComboBox                                  ���
�������������������������������������������������������������������������Ĵ��
���Parametros� cCampo - Nome do Campo                                     ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������/*/
Static Function LoadX3Box(cCampo)

Local aRet:={},nCont,nIgual
Local cCbox,cString
Local aSvArea := SX3->(GetArea())

SX3->(DbSetOrder(2))
SX3->(DbSeek(cCampo))

cCbox := SX3->(X3Cbox())
//-- Opcao 1   |Opcao 2 |Opcao 3|Opcao 4
//-- 01=Amarelo;02=Preto;03=Azul;04=Vermelho  
//   | �->nIgual        �->nCont
//   �->cString: 01=Amarelo
//aRet:={{01,Amarelo},{02.Preto},...}

While !Empty(cCbox) 
   nCont:=AT(";",cCbox) 
   nIgual:=AT("=",cCbox)
   cString:=AllTrim(SubStr(cCbox,1,nCont-1)) //Opcao
   IF nCont == 0
       aAdd(aRet,{SubStr(cString,1,nigual-1),SubStr(cString,nigual+1)})
      Exit
   Else
       aAdd(aRet,{SubStr(cString,1,nigual-1),SubStr(cString,nigual+1)})
   Endif 
   cCbox:=SubStr(cCbox,nCont+1)
Enddo
   
RestArea(aSvArea)

Return( aRet )

/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �DescTPMarc� Autor � Mauricio MR           � Data � 10.12.01 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Retorna Descricao do Tipo da Marcacao                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros� aBox     - Array Contendo as Opcoes do Combox Ja Carregadas���
���          � cTpMarca - Tipo da Marcacao                                ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Ponr010                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������/*/
Static Function DescTpMarca(aBox,cTpMarca)

Local aTpMarca:={},cRet:='',nTpMarca:=0
//-- SE Existirem Opcoes Realiza a Busca da Marcacao
If Len(aBox)>0
   nTpmarca:=aScan(aBox,{|xtp| xTp[1] == cTpMarca})
   cRet:=If(nTpMarca>0,aBox[nTpmarca,2],"")
Endif

Return( cRet )

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �ImprEsp   � Autor � Mauricio MR           � Data � 22/01/02 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Verifica se Deve Imprimir Cabec Especifico                 ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   �ImprEsp(Detalhe,FimFolha,Pos_cabec,nTamLin,nColunas,        ���
���          �        nTamanho,lTerminal)                                 ���
���          �A) Parametros de Acordo com a Impr:                         ���
���          �  Detalhe   => Linha detalhe a ser Impressa                 ���
���          �  FimFolha  => "C"(impressao continua)ou "P"(Pula Pagina)   ���
���          �  Pos_cabec => Posicionamento do Cabecalho                  ���
���          �B) Parametros de Acordo com a Imp_Cabec                     ���
���          �  nTamLin   => Tamanho da Linha                             ���
���          �  nColunas  => Qtde de Colunas a Imprimir                   ���
���          �  nTamanho  => Tamanho do Relatorio                         ���
���          �  lTerminal => Indica se Impressao de Destina a Web         ���
���          �  nTipoCab  => Tipo de Cabec Auxiliar                       ��� 
���          �               01 - Para Marcacoes : Data Dia 1aE 1aS 2aE...��� 
���          �               02 - Para Totais    : Cod. Descricao ....    ��� 
���          �               03 - Somente : Empresa,Funcionario ....      ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � POR010IMP  e ImpEsp                                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������/*/
Static Function ImprEsp(	Detalhe		,;
							FimFolha	,;
							Pos_cabec	,;
							nTamLin		,;
							nColunas	,;
							nTamanho	,;
							lTerminal	,;
							nTipoCab	 ;
						 )

IF ( LI > 57 )
   Imp_Cabec( nTamLin , nColunas , nTamanho , lTerminal , nTipoCab )
EndIF
Impr( Detalhe , FimFolha , Pos_cabec )

Return( NIL )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � Monta_Per� Autor �Equipe Advanced RH     � Data �          ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Gen�rico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������*/
Static Function Monta_Per( dDataIni , dDataFim , cFil , cMat , dIniAtu , dFimAtu )

Local aPeriodos := {}
Local cFilSPO	:= xFilial( "SPO" , cFil )
Local dAdmissa	:= SRA->RA_ADMISSA
Local dPerIni   := Ctod("//")
Local dPerFim   := Ctod("//")

SPO->( dbSetOrder( 1 ) )
SPO->( dbSeek( cFilSPO , .F. ) )
While SPO->( !Eof() .and. PO_FILIAL == cFilSPO )
                       
    dPerIni := SPO->PO_DATAINI
    dPerFim := SPO->PO_DATAFIM  

    //-- Filtra Periodos de Apontamento a Serem considerados em funcao do Periodo Solicitado
    IF dPerFim < dDataIni .OR. dPerIni > dDataFim                                                      
		SPO->( dbSkip() )  
		Loop  
    Endif

    //-- Somente Considera Periodos de Apontamentos com Data Final Superior a Data de Admissao
    IF ( dPerFim >= dAdmissa )
       aAdd( aPeriodos , { dPerIni , dPerFim , Max( dPerIni , dDataIni ) , Min( dPerFim , dDataFim ) } )
	Else
		Exit
	EndIF

	SPO->( dbSkip() )

End While

IF ( aScan( aPeriodos , { |x| x[1] == dIniAtu .and. x[2] == dFimAtu } ) == 0.00 )
	dPerIni := dIniAtu
	dPerFim	:= dFimAtu 
	IF !(dPerFim < dDataIni .OR. dPerIni > dDataFim)
		IF ( dPerFim >= dAdmissa )
			aAdd(aPeriodos, { dPerIni, dPerFim, Max(dPerIni,dDataIni), Min(dPerFim,dDataFim) } )
		EndIF
    Endif
EndIF

Return( aPeriodos )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � CarExtAut� Autor � Mauricio MR           � Data � 24/05/02 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Retorna Relacao de Horas Extras por Filial/Turno           ���
�������������������������������������������������������������������������Ĵ��
���Parametros� cCodExtras --> String que Contem ou Contera os Codigos     ���
���          � cTnoCad    --> Turno conforme o Dia                        ���
���          � cAutoriza  --> "*" Horas Autorizadas/Nao Autorizadas       ��� 
���          �                "A" Horas Autorizadas                       ��� 
���          �                "N" Horas Nao Autorizadas                   ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � PONM010                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function CarExtAut( cCodExtras , cTnoCad , cAutoriza )

Local aTabExtra		:= {}
Local cFilSP4		:= fFilFunc("SP4")
Local cTno			:= ""
Local lFound		:= .F.
Local lRet			:= .T.
Local nX			:= 0
Local naTabExtra	:= 0    
Local ncTurno	    := 0.00

Static aExtrasTno

If ( PCount() == 0.00 )

	aExtrasTno	:= NIL              

Else

	If (aExtrasTno == Nil)
		aExtrasTno := {} 
	Endif
		
	//-- Procura Tabela (Filial + Turno corrente)
	If (lFound	:= (SP4->(dbSeek(cFilSP4+cTnoCad,.F.))))
	   cTno		:=	cTnoCad
	   lFound	:=	.T.
	Else      
	    //-- Procura Tabela (Filial)    
	    cTno	:= Space(Len(SP4->P4_TURNO))
		lFound	:= SP4->( dbSeek(  cFilSP4 + cTno , .F.) )
	Endif    
	
	//-- Se Existe Tabela de HE
	If ( lFound )
	   //-- Verifica se a Tabela de HE para o Turno ainda nao foi carregada
	   If (ncTurno:=aScan(aExtrasTno,{|aTurno| aTurno[1]  == cFilSP4 .and. aTurno[2] == cTno} )) == 0.00
	      //-- Se nao Encontrou Carrega Tabela para Filial e Turno especificos
	      GetTabExtra( @aTabExtra , cFilSP4 , cTno , .F. , .F. )     
	      //-- Posiciona no inicio da Tabela de HE da Filial Solicitada
		  If !Empty(aTabExtra)
			  naTabExtra:=	Len(aTabExtra)
			  //-- Corre C�digos de Hora Extra da Filial
			  For nX:=1 To naTabExtra
					//-- Se Ambos os Tipos de Eventos ou Autorizados
					If cAutoriza == '*' .or. (cAutoriza == 'A' .and. !Empty(aTabExtra[nX,4]))
						cCodExtras += aTabExtra[nX,4]+'A' //-- Cod Autorizado                
					Endif
					//-- Se Ambos os Tipos de Eventos ou Nao Autorizados					
					If cAutoriza == '*' .or. (cAutoriza == 'N' .and. !Empty(aTabExtra[nX,5]))
						cCodExtras += aTabExtra[nX,5]+'N' //-- Cod Nao Autorizado                
					EndIf
			  Next nX
		  Endif	  
		  //-- Cria Nova Relacao de Codigos Extras para o Turno Lido
		  aAdd(aExtrasTno,{cFilSP4,cTno,cCodExtras})
	    Else
	        //-- Recupera Tabela Anteriormente Lida
	        cCodExtras:=aExtrasTno[ncTurno,3] 
	    Endif                    
	    
	Endif	

Endif

Return( lRet )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � CarId    � Autor � Mauricio MR           � Data � 24/05/02 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Retorna Relacao de Eventos da Filial						  ���
�������������������������������������������������������������������������Ĵ��
���Parametros� cFil       --> Codigo da Filial desejada					  ���
���          � aId    	  --> Array com a Relacao	                      ���
���          � cAutoriza  --> "*" Horas Autorizadas/Nao Autorizadas       ��� 
���          �                "A" Horas Autorizadas                       ��� 
���          �                "N" Horas Nao Autorizadas                   ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � PONM010                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/	
Static Function CarId( cFil , aId , cAutoriza )

Local nPos	:= 0.00

//-- Preenche o Array aCodAut com os Eventos (Menos DSR Mes Ant.)
SP9->( dbSeek( cFil , .T. ) )
While SP9->( !Eof() .and. cFil == P9_FILIAL )
	IF ( ( Right(SP9->P9_IDPON,1) == cAutoriza ) .or. ( cAutoriza == "*" ) )
		aAdd( aId , Array( 04 ) )
		nPos := Len( aId )
		aId[ nPos , 01 ] := SP9->P9_CODIGO	//-- Codigo do Evento 
		aId[ nPos , 02 ] := SP9->P9_IDPON 	//-- Identificador do Ponto 
		aId[ nPos , 03 ] := SP9->P9_CODFOL	//-- Codigo do da Verba Folha
		aId[ nPos , 04 ] := SP9->P9_BHORAS	//-- Evento para B.Horas
	EndIF
	SP9->( dbSkip() )
EndDo

Return

Static Function fBuscoBanco(aBanco)
*******************************
LOCAL nSaldo := 0, nPos := 0
LOCAL dDtIni := dPerIni //SRA->RA_admissa 	//Data Inicial
LOCAL dDtFim := dPerFim //dDataBase        //Data Final

//��������������������������������������������������������������Ŀ
//� Verifica lancamentos no Banco de Horas                       �
//����������������������������������������������������������������
nSaldoAnt:= 0
dbSelectArea("SPI")
dbSetOrder(2)
dbSeek(SRA->RA_FILIAL+SRA->RA_MAT,.T.)
While !Eof().and.(SPI->PI_FILIAL+SPI->PI_MAT == SRA->RA_FILIAL+SRA->RA_MAT)
	// Totaliza Saldo Anterior
	//////////////////////////
   If SPI->PI_STATUS == " " .And. SPI->PI_DATA < dDtIni
   	If PosSP9( SPI->PI_PD , SRA->RA_FILIAL, "P9_TIPOCOD") $ "1*3" 
      	nSaldoAnt:=SomaHoras(nSaldoAnt,SPI->PI_QUANT)
		Else
	   	nSaldoAnt:=SubHoras(nSaldoAnt,SPI->PI_QUANT)
	  Endif
		nSaldo := nSaldoAnt
	Endif
	//Verifica os Lancamentos a imprimir
	////////////////////////////////////
	If	SPI->PI_DATA < dDtIni .Or. SPI->PI_DATA > dDtFim
		dbSelectArea("SPI")
		SPI->(dbSkip())
		Loop
	Endif
	//Posiciono no SP9
	//////////////////
	PosSP9( SPI->PI_PD ,SRA->RA_FILIAL )
	//Acumula os lancamentos de Proventos/Desconto em Array
	///////////////////////////////////////////////////////
	If SP9->P9_TIPOCOD $ "1*3"
		nSaldo:=SomaHoras(nSaldo,If(SPI->PI_STATUS=="B",0,SPI->PI_QUANT))
	Else
		nSaldo:=SubHoras(nSaldo,If(SPI->PI_STATUS=="B",0,SPI->PI_QUANT))
	Endif
	    
	nPos := aScan(aBanco,{|x|x[1]==SPI->PI_PD})
	If Empty(nPos)
		aAdd(aBanco,{SPI->PI_PD,;
					  Left(DescPdPon(SPI->PI_PD,SPI->PI_FILIAL),20),;
					  If(SP9->P9_TIPOCOD $ "1*3",0,SPI->PI_QUANT),;
					  If(SP9->P9_TIPOCOD $ "1*3",SPI->PI_QUANT,0),;
					  nSaldo})
	Else
		aBanco[nPos,3] := SomaHoras(aBanco[nPos,3],(If(SP9->P9_TIPOCOD $ "1*3",0,SPI->PI_QUANT)))
		aBanco[nPos,4] := SomaHoras(aBanco[nPos,4],(If(SP9->P9_TIPOCOD $ "1*3",SPI->PI_QUANT,0)))
		aBanco[nPos,5] := nSaldo
	Endif
	
	dbSelectArea("SPI")
	SPI->(dbSkip())
Enddo
For nPos := 1 to Len(aBanco)
	If (nPos == 1)
		aBanco[nPos,5] := SomaHoras(nSaldoAnt,aBanco[nPos,4])
		aBanco[nPos,5] := SubHoras(aBanco[nPos,5],aBanco[nPos,3])
	Else
		aBanco[nPos,5] := SomaHoras(aBanco[nPos-1,5],aBanco[nPos,4])
		aBanco[nPos,5] := SubHoras(aBanco[nPos,5],aBanco[nPos,3])
	Endif
Next nPos
Return