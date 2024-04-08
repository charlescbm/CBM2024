#INCLUDE "MATR260.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MATR260  ³ Autor ³ Marcos V. Ferreira    ³ Data ³ 16/06/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Posicao dos Estoques                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

user Function RESTR10()

Local oReport
	RESTR10R3()
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MATR260R3 ³ Autor ³ Eveli Morasco         ³ Data ³ 01/03/93 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Posicao dos Estoques                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Marcelo Pim.³09/12/97³09827A³Ajuste da descricao p/ 30 caracteres.     ³±±
±±³Fernando J. ³25/09/98³17720A³ Corre‡„o no Salto de Linhas.             ³±±
±±³Fernando J. ³02/12/98³18752A³A fun‡„o PesqPictQT foi substituida pela  ³±±
±±³            ³        ³      ³PesqPict.                                 ³±±
±±³Fernando J. ³21/12/98³18920A³Possibilitar filtragem pelo usuario.      ³±±
±±³Rodrigo Sart³08/02/99³META  ³Avaliacao da qtd empenhada prevista.      ³±±
±±³Cesar       ³30/03/99³XXXXXX³Manutencao na SetPrint()                  ³±±
±±³Patricia Sal³28/01/00³002121³Aumento da picture dos campos.            ³±±
±±³Jeremias    ³09.02.00³Melhor³Validacao da comparacao dos valores e da  ³±±
±±³            ³        ³      ³qtde quando do calculo do custo medio.    ³±±
±±³RicardoBerti³12/09/05³086108³Se Moeda#1 p/Cust.St.e U.P.Cp:usa xMoeda()³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

STATIC Function RESTR10R3()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local Titulo   := STR0001	//"Relacao da Posicao do Estoque"
Local wnrel    := "MATR260"
Local cDesc1   := STR0002	//"Este relatorio emite a posicao dos saldos e empenhos de cada  produto"
Local cDesc2   := STR0003	//"em estoque. Ele tambem mostrara' o saldo disponivel ,ou seja ,o saldo"
Local cDesc3   := STR0004	//"subtraido dos empenhos."
Local cString  := "SB1"
Local aOrd     := {OemToAnsi(STR0005),OemToAnsi(STR0006),OemToAnsi(STR0007),OemToAnsi(STR0008),OemToAnsi(STR0009)}    //" Por Codigo         "###" Por Tipo           "###" Por Descricao     "###" Por Grupo        "###" Por Almoxarifado   "
Local lEnd     := .F.
Local Tamanho  := "M"
Local aHelpPor := {},aHelpEng:={},aHelpSpa:={}
Local aHelpP15 := {"Ao imprimir os itens sera considerado ","os saldos:","- Atual:       SB2->B2_VATU","- Fechamento:  SB2->B2_VFIM","- Movimento:   SD1,SD2,SD3,SB9","** O Empenho nao e retroativo, mesmo","quando selecionado por movimento sera","sempre baseado no saldo atual."}
Local aHelpS15 := {"Al imprimir los itemes seran considerados","los saldos:","- Actual:  SB2->B2_VATU","- Cierre:  SB2->B2_VFIM","- Movimiento: SD1,SD2,SD3,SB9","**La reserva no es retroactiva,","aun cuando se seleccione por algun movimiento,","siempre se basara en el saldo actual."}
Local aHelpE15 := {"At the moment the items are printed, it takes","in consideration the following balances:","- Current: SB2->B2_VATU","- Closing: SB2->B2_VFIM","- Movements: SD1,SD2,SD3,SB9","**Allocation is not retroactive,","even if the allocation is chosen by","movement, this will always be base on the","current balance."}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis tipo Local para SIGAVEI, SIGAPEC e SIGAOFI         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aArea1	:= Getarea() 
Local nTamSX1   := Len(SX1->X1_GRUPO)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis tipo Private para SIGAVEI, SIGAPEC e SIGAOFI       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private lVeic   := Upper(GetMV("MV_VEICULO"))=="S"
Private aSB1Cod := {}
Private aSB1Ite := {}
Private nCOL1	:= 0
Private XSB1	:= SB1->(XFILIAL("SB1"))
Private XSB2	:= SB2->(XFILIAL("SB2"))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis tipo Private padrao de todos os relatorios         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private aReturn  := {OemToAnsi(STR0010), 1,OemToAnsi(STR0011), 2, 2, 1, "",1 }   //"Zebrado"###"Administracao"
Private nLastKey := 0 
PRIVATE cPerg    := U_CriaPerg("MTR260")
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se utiliza custo unificado por Empresa/Filial       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private lCusUnif := IIf(FindFunction("A330CusFil"),A330CusFil(),SuperGetMV('MV_CUSFIL',.F.))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Funcao utilizada para verificar a ultima versao dos fontes      ³
//³ SIGACUS.PRW, SIGACUSA.PRX e SIGACUSB.PRX, aplicados no rpo do   |
//| cliente, assim verificando a necessidade de uma atualizacao     |
//| nestes fontes. NAO REMOVER !!!							        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !(FindFunction("SIGACUS_V") .and. SIGACUS_V() >= 20050512)
	Aviso("Atencao","Atualizar patch do programa SIGACUS.PRW !!!",{"Ok"})
	Return
EndIf
If !(FindFunction("SIGACUSA_V") .and. SIGACUSA_V() >= 20050512)
	Aviso("Atencao","Atualizar patch do programa SIGACUSA.PRX !!!",{"Ok"})
	Return
EndIf
If !(FindFunction("SIGACUSB_V") .and. SIGACUSB_V() >= 20050512)
	Aviso("Atencao","Atualizar patch do programa SIGACUSB.PRX !!!",{"Ok"})
	Return
EndIf

Ajustasx1()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                                ³
//³ mv_par01     // Aglutina por: Almoxarifado / Filial / Empresa       ³
//³ mv_par02     // Filial de       *                                   ³
//³ mv_par03     // Filial ate      *                                   ³
//³ mv_par04     // almoxarifado de *                                   ³
//³ mv_par05     // almoxarifado ate*                                   ³
//³ mv_par06     // codigo de       *                                   ³
//³ mv_par07     // codigo ate      *                                   ³
//³ mv_par08     // tipo de         *                                   ³
//³ mv_par09     // tipo ate        *                                   ³
//³ mv_par10     // grupo de        *                                   ³
//³ mv_par11     // grupo ate       *                                   ³
//³ mv_par12     // descricao de    *                                   ³
//³ mv_par13     // descricao ate   *                                   ³
//³ mv_par14     // imprime produtos: Todos /Positivos /Negativos       ³
//³ mv_par15     // Saldo a considerar : Atual / Fechamento / Movimento |
//³ mv_par16     // Qual Moeda (1 a 5)                                  ³
//³ mv_par17     // Aglutina por UM ?(S)im (N)ao                        ³
//³ mv_par18     // Lista itens zerados ? (S)im (N)ao                   ³
//³ mv_par19     // Imprimir o Valor ? Custo / Custo Std / Ult Prc Compr³
//³ mv_par20     // Data de Referencia                                  ³
//³ mv_par21     // Lista valores zerados ? (S)im (N)ao                 ³
//³ mv_par22     // QTDE na 2a. U.M. ? (S)im (N)ao                      ³
//³ mv_par23     // Imprime descricao do Armazem ? (S)im (N)ao          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Aadd(aHelpPor, "Data de referencia para calculo do saldo" )
Aadd(aHelpPor, "do produto quando utiliza saldo por     " )
Aadd(aHelpPor, "movimento.                              " )
Aadd(aHelpEng, "Reference date for product`s balances   " )
Aadd(aHelpEng, "calculation, when using balance per     " )
Aadd(aHelpEng, "transaction/movement.                   " )
Aadd(aHelpSpa, "Fecha de referencia para calculo del    " )
Aadd(aHelpSpa, "saldo del producto cuando usa saldo por " )
Aadd(aHelpSpa, "movimiento.                             " )
PutSx1("MTR260", "20","Data de Referencia  ","Data de Referencia  ","Reference Date           ","mv_chK","D",8,0,0,"G","","","","","mv_par20","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
PutSx1("MTR260","22","QTDE. na 2a. U.M. ?","CTD. EN 2a. U.M. ?","QTTY. in 2a. U.M. ?", "mv_chm", "N", 1, 0, 2,"C", "", "", "", "","mv_par22","Sim","Si","Yes", "","Nao","No","No", "", "", "", "", "", "", "", "", "", "", "", "", "")
PutSX1Help("P.MTR26015.",aHelpP15,aHelpE15,aHelpS15)
aHelpPor :={}
aHelpEng :={}
aHelpSpa :={} 
Aadd(aHelpPor,"Imprime descricao do Armazem. Sim ou Nao" )
Aadd(aHelpEng,"Print warehouse description. Yes or No  " )
Aadd(aHelpSpa,"Imprime descripcion del almacen. Si o No" ) 
PutSx1("MTR260","23","Imprime descricao do Armazem ?","Imprime descripc. del almacen?","Print warehouse description ?","mv_chn","N",1,0,2,"C","","","","","mv_par23","Sim","Si","Yes","","Nao","No","No","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ajustar o SX1 para SIGAVEI, SIGAPEC e SIGAOFI                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aSB1Cod	:= TAMSX3("B1_COD")
aSB1Ite	:= TAMSX3("B1_CODITE")

If lVEIC
	Tamanho := "G"
	nCol1	:= ABS(aSB1Cod[1] - aSB1Ite[1]) + 1 +  aSB1Cod[1]
	dbSelectArea("SX1")
	dbSetOrder(1)
	dbSeek(cPerg)
	Do While SX1->X1_GRUPO == cPerg .And. !SX1->(Eof())
		If "PRODU" $ Upper(SX1->X1_PERGUNT) .And. Upper(SX1->X1_TIPO) == "C" .And. (SX1->X1_TAMANHO <> aSB1Ite[1] .Or. Upper(SX1->X1_F3) <> "VR4")
			Reclock("SX1",.F.)
			SX1->X1_TAMANHO := aSB1Ite[1]
			SX1->X1_F3 := "VR4"
			dbCommit()
			MsUnlock()
		EndIf
		dbSkip()
	EndDo
	dbCommitAll()
	RestArea(aArea1)
Else
	dbSelectArea("SX1")
	dbSetOrder(1)
	dbSeek(cPerg)
	Do While SX1->X1_GRUPO == cPerg .And. !SX1->(Eof())
		If "PRODU" $ Upper(SX1->X1_PERGUNT) .And. Upper(SX1->X1_TIPO) == "C" .And. (SX1->X1_TAMANHO <> aSB1Cod[1] .OR. UPPER(SX1->X1_F3) <> "SB1")
			Reclock("SX1",.F.)
			SX1->X1_TAMANHO := aSB1Cod[1]
			SX1->X1_F3 := "SB1"
			dbCommit()
			MsUnlock()
		EndIf
		dbSkip()
	EndDo
	dbCommitAll()
	RestArea(aArea1)
EndIf

Pergunte(cPerg,.F.)

If mv_par23 == 1
	Tamanho := "G"
Else
	Tamanho := "M"
Endif

If lCusUnif //-- Ajusta as perguntas para Custo Unificado
	MA260PergU()
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,Tamanho)
If nLastKey = 27
	dbClearFilter()
	Return
Endif

If lCusUnif .And. ((mv_par01==1).Or.!(mv_par04=='**').Or.!(mv_par05=='**').Or.aReturn[8]==5) //-- Ajusta as perguntas para Custo Unificado
	If Aviso(STR0024, STR0025+CHR(10)+CHR(13)+STR0029+CHR(10)+CHR(13)+STR0026+CHR(10)+CHR(13)+STR0027+CHR(10)+CHR(13)+STR0028+CHR(10)+CHR(13)+STR0030, {STR0031,STR0032}) == 2
		dbClearFilter()
		Return Nil
	EndIf	
EndIf

If mv_par04 == '**'
	mv_par04 := '  '
EndIf
If mv_par05 == '**'
	mv_par05 := 'zz'
Endif

SetDefault(aReturn,cString)
If nLastKey = 27
	dbClearFilter()
	Return
Endif

mv_par16 := If( ((mv_par16 < 1) .Or. (mv_par16 > 5)),1,mv_par16 )
Tipo     := IIf(aReturn[4]==1,15,18)

If Type("NewHead")#"U"
	Titulo := (NewHead+" ("+AllTrim( aOrd[ aReturn[ 8 ] ] )+")")
Else
	Titulo += " ("+AllTrim( aOrd[ aReturn[ 8 ] ] )+")"
EndIf

cFileTRB := ""
RptStatus( { | lEnd | cFileTRB := r260Select( @lEnd ) },Titulo+STR0023 ) //": Preparacao..."

If !Empty( cFileTRB )
	RptStatus({|lEnd| R260Imprime( @lEnd,cFileTRB,Titulo,wNRel,Tamanho,Tipo,aReturn[ 8 ] )},titulo)
EndIf

Return NIL

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³R260SELECT³ Autor ³ Ben-Hur M. Castilho   ³ Data ³ 20/11/96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Preparacao do Arquivo de Trabalho p/ Relatorio             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR260                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function R260Select( lEnd )
Local cFileTRB	:= ""
Local cIndxKEY	:= ""
Local aSizeQT	:= TamSX3( "B2_QATU" )
Local aSizeVL	:= TamSX3( "B2_VATU1")
Local aSaldo	:= {}
Local nQuant	:= 0
Local nValor	:= 0
Local nQuantR	:= 0
Local nValorR	:= 0
Local cFilOK	:= cFilAnt
Local cAl1		:= "SB1"
Local cAl2		:= "SB2"
Local lExcl		:= .F.
Local cIndSB1	:= ""
Local nIndex	:= 0
Local cUM    	:= If(mv_par22 == 1,"SEGUM ","UM    ")
Local aCampos 	:= {	{ "FILIAL","C",02,00 },;
						{ "CODIGO","C",15,00 },;
						{ "LOCAL ","C",02,00 },;
						{ "TIPO  ","C",02,00 },;
						{ "GRUPO ","C",04,00 },;
						{ "DESCRI","C",21,00 },;
						{ cUM     ,"C",02,00 },;
						{ "VALORR","N",aSizeVL[ 1 ]+1, aSizeVL[ 2 ] },;
						{ "QUANTR","N",aSizeQT[ 1 ]+1, aSizeQT[ 2 ] },;
						{ "VALOR ","N",aSizeVL[ 1 ]+1, aSizeVL[ 2 ] },;
						{ "QUANT ","N",aSizeQT[ 1 ]+1, aSizeQT[ 2 ] },;
						{ "DESCARM","C",15,00 };
					 }
Local dDataRef
#IFDEF TOP
	Local aStruSB1	:= {}
	Local cName
	Local cQryAd	:= ""
	Local cQuery	:= ""
	Local nX
#ENDIF	

dDataRef := IIf(Empty(mv_par20),dDataBase,mv_par20)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Para SIGAVEI, SIGAPEC e SIGAOFI                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If !lVeic
	If (mv_par01 == 1)
		If (aReturn[ 8 ] == 5)
			cIndxKEY := "LOCAL"
		Else
			cIndxKEY := "FILIAL"
		EndIf
		Do Case
			Case (aReturn[ 8 ] == 1)
				If (mv_par17 == 1)
					cIndxKEY += "+" + cUM
				EndIf
				cIndxKEY += "+CODIGO+LOCAL"
			Case (aReturn[ 8 ] == 2)
				cIndxKEY += "+TIPO"
				If (mv_par17 == 1)
					cIndxKEY += "+" + cUM
				EndIf
				cIndxKEY += "+CODIGO+LOCAL"
			Case (aReturn[ 8 ] == 3)
				If (mv_par17 == 1)
					cIndxKEY += "+" + cUM
				EndIf
				cIndxKEY += "+DESCRI+CODIGO+LOCAL"
			Case (aReturn[ 8 ] == 4)
				cIndxKEY += "+GRUPO"
				If (mv_par17 == 1)
					cIndxKEY += "+" + cUM
				EndIf
				cIndxKEY += "+CODIGO+LOCAL"
			Case (aReturn[ 8 ] == 5)
				If (mv_par17 == 1)
					cIndxKEY += "+" + cUM
				EndIf
				cIndxKEY += "+CODIGO+FILIAL"
			OtherWise
				If (mv_par17 == 1)
					cIndxKEY += "+" + cUM
				EndIf
				cIndxKEY += "+CODIGO+LOCAL"
		EndCase
	Else // 	If (mv_par01 == 1)
		If (aReturn[ 8 ] == 5)
			cIndxKEY := "LOCAL"
		Else
			cIndxKEY := ""
		EndIf

		Do Case
			Case (aReturn[ 8 ] == 1)
				If (mv_par17 == 1)
					cIndxKEY += (iif(empty(cIndxKEY),"","+")+ cUM)
				EndIf
				cIndxKEY += (iif(empty(cIndxKEY),"","+") + "CODIGO+FILIAL+LOCAL")
			Case (aReturn[ 8 ] == 2)
				cIndxKEY += (iif(empty(cIndxKEY),"","+") + "TIPO")
				If (mv_par17 == 1)
					cIndxKEY += (iif(empty(cIndxKEY),"","+")+ cUM)
				EndIf
				cIndxKEY += "+CODIGO+FILIAL+LOCAL"
			Case (aReturn[ 8 ] == 3)
				If (mv_par17 == 1)
					cIndxKEY += (iif(empty(cIndxKEY),"","+")+ cUM)
				EndIf
				cIndxKEY += (iif(empty(cIndxKEY),"","+") + "DESCRI+CODIGO+FILIAL+LOCAL")
			Case (aReturn[ 8 ] == 4)
				cIndxKEY += (iif(empty(cIndxKEY),"","+") + "GRUPO")
				If (mv_par17 == 1)
					cIndxKEY += (iif(empty(cIndxKEY),"","+")+ cUM)
				EndIf
				cIndxKEY += "+CODIGO+FILIAL+LOCAL"
			Case (aReturn[ 8 ] == 5)
				If (mv_par17 == 1)
					cIndxKEY += (iif(empty(cIndxKEY),"","+")+ cUM)
				EndIf
				cIndxKEY += (iif(empty(cIndxKEY),"","+") + "CODIGO+FILIAL")
			OtherWise
				If (mv_par17 == 1)
					cIndxKEY += (iif(empty(cIndxKEY),"","+")+ cUM)
				EndIf
				cIndxKEY += (iif(empty(cIndxKEY),"","+") + "CODIGO+LOCAL")
		EndCase
	EndIf
Else
	aAdd(aCampos,{"CODITE","C",aSB1Ite[ 1 ],00})
	If (mv_par01 == 1) // ARMAZEN
		If (aReturn[ 8 ] == 5) // ALMOXARIFADO
			cIndxKEY := "LOCAL"
		Else
			cIndxKEY := "FILIAL"
		EndIf
		Do Case
			Case (aReturn[ 8 ] == 1)
				If (mv_par17 == 1)
					cIndxKEY += "+" + cUM
				EndIf
				cIndxKEY += "+CODITE+LOCAL"
			Case (aReturn[ 8 ] == 2)
				cIndxKEY += "+TIPO"
				If (mv_par17 == 1)
					cIndxKEY += "+" + cUM
				EndIf
				cIndxKEY += "+CODITE+LOCAL"
			Case (aReturn[ 8 ] == 3)
				If (mv_par17 == 1)
					cIndxKEY += "+" + cUM
				EndIf
 				cIndxKEY += "+DESCRI+CODITE+LOCAL"
			Case (aReturn[ 8 ] == 4)
				cIndxKEY += "+GRUPO"
				If (mv_par17 == 1)
					cIndxKEY += "+" + cUM
				EndIf
				cIndxKEY += "+CODITE+LOCAL"
			Case (aReturn[ 8 ] == 5)
				If (mv_par17 == 1)
					cIndxKEY += "+" + cUM
				EndIf
				cIndxKEY += "+CODITE+FILIAL"
			OtherWise
				If (mv_par17 == 1)
					cIndxKEY += "+" + cUM
				EndIf
				cIndxKEY += "+CODITE+LOCAL"
		EndCase
	Else // FILIAL / EMPRESA
		If (aReturn[ 8 ] == 5) // ALMOXARIFADO
			cIndxKEY := "LOCAL"
		Else
			cIndxKEY := ""
		EndIf
		Do Case
			Case (aReturn[ 8 ] == 1) // CODIGO
				If (mv_par17 == 1)
					cIndxKEY += (iif(empty(cIndxKEY),"","+")+ cUM)
				EndIf
				cIndxKEY += (iif(empty(cIndxKEY),"","+") + "CODITE+FILIAL+LOCAL")
			Case (aReturn[ 8 ] == 2)
				cIndxKEY += (iif(empty(cIndxKEY),"","+") + "TIPO")
				If (mv_par17 == 1)
					cIndxKEY += (iif(empty(cIndxKEY),"","+")+ cUM)
				EndIf
				cIndxKEY += (iif(empty(cIndxKEY),"","+") + "CODITE+FILIAL+LOCAL")
			Case (aReturn[ 8 ] == 3)
				If (mv_par17 == 1)
					cIndxKEY += (iif(empty(cIndxKEY),"","+") + cUM)
				EndIf
				cIndxKEY += (iif(empty(cIndxKEY),"","+") + "DESCRI+CODITE+FILIAL+LOCAL")
			Case (aReturn[ 8 ] == 4)
				cIndxKEY += (iif(empty(cIndxKEY),"","+") + "GRUPO")
				If (mv_par17 == 1)
					cIndxKEY += (iif(empty(cIndxKEY),"","+") + cUM)
				EndIf
				cIndxKEY += (iif(empty(cIndxKEY),"","+") + "CODITE+FILIAL+LOCAL")
			Case (aReturn[ 8 ] == 5)
				If (mv_par17 == 1)
					cIndxKEY += (iif(empty(cIndxKEY),"","+") + cUM)
				EndIf
				cIndxKEY += (iif(empty(cIndxKEY),"","+") + "CODITE+FILIAL")
			OtherWise
				If (mv_par17 == 1)
					cIndxKEY += (iif(empty(cIndxKEY),"","+")+ cUM)
				EndIf
				cIndxKEY += (iif(empty(cIndxKEY),"","+") + "CODITE+LOCAL")
		EndCase
	EndIf
EndIf
cFileTRB := CriaTrab( nil,.F. )

dbSelectArea(0)
DbCreate( cFileTRB,aCampos )

dbUseArea( .F.,,cFileTRB,cFileTRB,.F.,.F. )
IndRegua( cFileTRB,cFileTRB,cIndxKEY,,,OemToAnsi(STR0013))   //"Organizando Arquivo..."

dbSelectArea( "SB2" )
SetRegua(LastRec())

#IFDEF TOP
	cQuery := "SELECT B2_FILIAL, B2_LOCAL, B2_COD, B2_QATU, B2_QTSEGUM, B2_QFIM, B2_QFIM2, B2_VATU1, B2_VATU2"
	cQuery += ", B2_VATU3, B2_VATU4, B2_VATU5"
	cQuery += ", B2_VFIMFF1, B2_VFIMFF2, B2_VFIMFF3, B2_VFIMFF4, B2_VFIMFF5, B2_QEMP, B2_QEMP2"
	cQuery += ", B2_QEMPPRE, B2_RESERVA, B2_RESERV2, B2_QEMPSA, B2_QEMPPRJ, B2_VFIM1, B2_QEMPPR2"
	cQuery += ", B2_VFIM2, B2_VFIM3, B2_VFIM4, B2_VFIM5, B1_COD, B1_FILIAL, B1_TIPO"
	cQuery += ", B1_GRUPO, B1_DESC, B1_GRUPO, B1_CUSTD, B1_UPRC"
	If mv_par19 == 2
		cQuery += ", B1_MCUSTD" 	
	EndIf
	If mv_par22 == 1
		cQuery += ", B1_SEGUM" 	
	Else
		cQuery += ", B1_UM" 	
	Endif
	if lVEIC
		cQuery += ", B1_CODITE"
	endif
	If mv_par23 == 1
		cQuery += ", B2_LOCALIZ"
	Endif

	aStruSB1 := SB1->(dbStruct())

	If !Empty(aReturn[7])
		For nX := 1 To SB1->(FCount())
			cName := SB1->(FieldName(nX))
			If AllTrim( cName ) $ aReturn[7]
				If aStruSB1[nX,2] <> "M"
					If !cName $ cQuery .And. !cName $ cQryAd
						cQryAd += ", " + cName
					EndIf
				EndIf
			EndIf
		Next nX
	EndIf

	cQuery += cQryAd

	cQuery += (" FROM " + RetSqlName("SB2") + " B2, " + RetSqlName("SB1") + " B1")
	cQuery += (" WHERE B2_FILIAL BETWEEN '" + MV_PAR02 + "' AND '" + MV_PAR03 + "'")
	cQuery += ("   AND B2_LOCAL  BETWEEN '" + MV_PAR04 + "' AND '" + MV_PAR05 + "'")
	if lVEIC
		cQuery += ("   AND B1_CODITE   BETWEEN '" + MV_PAR06 + "' AND '" + MV_PAR07 + "'")
	ELSE
		cQuery += ("   AND B2_COD    BETWEEN '" + MV_PAR06 + "' AND '" + MV_PAR07 + "'")
	ENDIF
	cQuery +=  "   AND B2.D_E_L_E_T_ = ' '"
	cQuery +=  "   AND B2_COD = B1_COD"
	cQuery += ("   AND B1_FILIAL = '" + xSB1 + "'")
	cQuery +=  "   AND B1.D_E_L_E_T_ = ' '"
	cQuery += ("   AND B1_TIPO  between '" + MV_PAR08 + "' AND '" + MV_PAR09 + "'")
	cQuery += ("   AND B1_GRUPO between '" + MV_PAR10 + "' AND '" + MV_PAR11 + "'")
	cQuery += ("   AND B1_DESC  between '" + MV_PAR12 + "' AND '" + MV_PAR13 + "'")
	
	cAl1 := "xxSB2"
	cAl2 := "xxSB2"
	cQuery := ChangeQuery(cQuery)
	
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAl2, .F., .T.)

	aEval(SB2->(dbStruct()), {|x| If(x[2] <> "C" .And. FieldPos(x[1]) > 0, TcSetField(cAl2,x[1],x[2],x[3],x[4]),Nil)})
	aEval(SB1->(dbStruct()), {|x| If(x[2] <> "C" .And. FieldPos(x[1]) > 0, TcSetField(cAl2,x[1],x[2],x[3],x[4]),Nil)})
#ELSE
	dbSetOrder(1)
	If lVEIC
		dbSeek(MV_PAR02,.T.)
	Else
		dbSeek(MV_PAR02+MV_PAR06+MV_PAR04,.T.)
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Quando houver filtro do usuario sera aplicada a Indregua p/ otimizar performance em Ambiente CDX.|
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	If !Empty(aReturn[7])
		cIndSB1 := CriaTrab( Nil,.F. )
		dbSelectArea(cAl1)
		dbSetOrder(1)
	 	IndRegua(cAl1,cIndSB1,SB1->(IndexKey()),,aReturn[7])
		nIndex := RetIndex("SB1")
		dbSetIndex(cIndSB1+OrdBagExt())
		dbSetOrder(nIndex+1)
		dbGoTop()	
	EndIf

#ENDIF

If xSB2 != "  "
	lExcl := .T.
EndIf

dbSelectArea( cAl2 )

While !Eof()
	If lExcl
		cFilAnt := (cAl2)->B2_FILIAL
	EndIf

	IncRegua()
	
	If	( ( (cAl2)->B2_FILIAL >= MV_PAR02 ) .And. ( (cAl2)->B2_FILIAL <= MV_PAR03 ) )	.And. ;
		( ( (cAl2)->B2_Local  >= MV_PAR04 ) .And. ( (cAl2)->B2_Local  <= MV_PAR05 ) )	.And. ;
		(IIf( lVeic, .T. ,( (cAl2)->B2_COD >= mv_par06 ) .And. ( (cAl2)->B2_COD <= mv_par07 ) ) )
				
	#IFNDEF TOP
		dbSelectArea( cAl1 )
		dbSetOrder(nIndex+1)
		If (dbSeek( XSB1 + (cAl2)->B2_COD) )
			If (	(	((cAl1)->B1_TIPO  >= mv_par08 ) .And. ((cAl1)->B1_TIPO  <= mv_par09 )) .And. ;
					(	((cAl1)->B1_GRUPO >= mv_par10 ) .And. ((cAl1)->B1_GRUPO <= mv_par11 )) .And. ;
					(	((cAl1)->B1_DESC  >= mv_par12 ) .And. ((cAl1)->B1_DESC  <= mv_par13 )))
	#ELSE
			If (	(	((cAl1)->B1_TIPO  >= mv_par08 ) .And. ((cAl1)->B1_TIPO  <= mv_par09 )) .And. ;
					(	((cAl1)->B1_GRUPO >= mv_par10 ) .And. ((cAl1)->B1_GRUPO <= mv_par11 )) .And. ;
					(	((cAl1)->B1_DESC  >= mv_par12 ) .And. ((cAl1)->B1_DESC  <= mv_par13 )) .And. ;
					(	(!Empty(aReturn[7]) .And. &(aReturn[7]) ) .Or. Empty(aReturn[7]));
				)
	#ENDIF

				Do Case
					Case (mv_par15 == 1)
						nQuant := If( mv_par22==1, ConvUM( (cAl2)->B2_COD, (cAl2)->B2_QATU, (cAl2)->B2_QTSEGUM, 2 ), (cAl2)->B2_QATU )
					Case (mv_par15 == 2)
						nQuant := If( mv_par22==1, ConvUM( (cAl2)->B2_COD, (cAl2)->B2_QFIM, (cAl2)->B2_QFIM2, 2 ), (cAl2)->B2_QFIM )
					Case (mv_par15 == 3)
						nQuant := (aSaldo := CalcEst( (cAl2)->B2_COD,(cAl2)->B2_LOCAL,dDataRef+1,(cAl2)->B2_FILIAL ))[ If( mv_par22==1, 7, 1 ) ]
					Case (mv_par15 == 4)
						nQuant := If( mv_par22==1, ConvUM( (cAl2)->B2_COD, (cAl2)->B2_QFIM, (cAl2)->B2_QFIM2, 2 ), (cAl2)->B2_QFIM )
					Case (mv_par15 == 5)
						nQuant := (aSaldo := CalcEstFF( (cAl2)->B2_COD,(cAl2)->B2_LOCAL,dDataRef+1,(cAl2)->B2_FILIAL ))[ If( mv_par22==1, 7, 1 ) ]
				EndCase
				
				dbSelectArea( cAl1 )
				If ( (mv_par14 == 1)  .Or.;
					 ((mv_par14 == 2) .And.(nQuant >= 0)) .Or.;
	  				 ((mv_par14 == 3) .And.(nQuant  < 0))	)
					
					If (mv_par19 == 1)
						Do Case
							Case (mv_par15 == 1)
								nValor := (cAl2)->(FieldGet( FieldPos( "B2_VATU"+Str( mv_par16,1 ) ) ))
							Case (mv_par15 == 2)
								nValor := (cAl2)->(FieldGet( FieldPos( "B2_VFIM"+Str( mv_par16,1 ) ) ))
							Case (mv_par15 == 3)
								nValor := aSaldo[ 1+mv_par16 ]
 							Case (mv_par15 == 4)
								nValor := (cAl2)->(FieldGet( FieldPos( "B2_VFIMFF"+Str( mv_par16,1 ) ) ))
							Case (mv_par15 == 5)
								nValor := aSaldo[ 1+mv_par16 ]
						EndCase
					Elseif (mv_par19==4) 
                            cMF :=  StrZero(MONTH(GETMV("MV_ULMES")),2)
                            cMes := StrZero(MONTH(MV_PAR20),2)
					       if mv_par15 == 3
					       		
					       		if  cMF <> '02'
					         		_DTATU:=DTOS(LASTDAY(GETMV("MV_ULMES") - 30))
 					       		else                                  
 					         		_DTATU:=DTOS(LASTDAY(GETMV("MV_ULMES") - 20))
 					       		endif
 					       
					       else
					       		if cMes <> '02'
					         		_DTATU:=DTOS(LASTDAY(MV_PAR20 - 30))
 					       		else                                  
 					         		_DTATU:=DTOS(LASTDAY(MV_PAR20 - 20))
 					       		endif
 					       endif
 					       
 					            
 					       if cMes > cMF .and. mv_par15 <> 3
 					       
 					          SB2->(DBSEEK(XFILIAL("SB2")+(cAl2)->B2_COD+(cAl2)->B2_Local))
 					          IF SB2->B2_QFIM > 0 .AND. SB2->B2_VFIM1 > 0  
 					            _cValor:=SB2->B2_VFIM1/SB2->B2_QFIM  
					            nValor := nQuant * xMoeda(_cValor,1,mv_par16,dDataRef,4 )					
					          ELSE
					          SB3->(DBSEEK(XFILIAL("SB3")+(cAl2)->B2_COD))
					        
					          cMes:=MONTH(LASTDAY(MV_PAR20-30))
					          cMes:= StrZero(cMes, 2)
                              cCampo := "SB3->B3_CMD"+cMes
                              nValor := nQuant * xMoeda(&cCampo,1,mv_par16,dDataRef,4 )
                              ENDIF
                          ELSEIF cMes <= cMF .and. mv_par15 <> 3 
  					        SB9->(DBSEEK(XFILIAL("SB9")+(cAl2)->B2_COD+(cAl2)->B2_Local+_DTATU))
 					       IF SB9->B9_QINI> 0 .AND. SB9->B9_VINI1 > 0  
 					          _cValor:=SB9->B9_VINI1/SB9->B9_QINI  
					          nValor := nQuant * xMoeda(_cValor,1,mv_par16,dDataRef,4 )					
					       ELSE
					        SB3->(DBSEEK(XFILIAL("SB3")+(cAl2)->B2_COD))
					        
					        cMes:=MONTH(LASTDAY(MV_PAR20-30))
					        cMes:= StrZero(cMes, 2)
                            cCampo := "SB3->B3_CMD"+cMes
                            nValor := nQuant * xMoeda(&cCampo,1,mv_par16,dDataRef,4 )
                          ENDIF
                       elseif mv_par15 == 3
                   			SB9->(DBSEEK(XFILIAL("SB9")+(cAl2)->B2_COD+(cAl2)->B2_Local+_DTATU))
 					       IF SB9->B9_QINI> 0 .AND. SB9->B9_VINI1 > 0  
 					          _cValor:=SB9->B9_VINI1/SB9->B9_QINI  
					          nValor := nQuant * xMoeda(_cValor,1,mv_par16,dDataRef,4 )					
					       ELSE
					        SB3->(DBSEEK(XFILIAL("SB3")+(cAl2)->B2_COD))
					        
					        //cMes:=MONTH(LASTDAY(MV_PAR20-30))
					        //cMF:= StrZero(cMF, 2)
                            cCampo := "SB3->B3_CMD"+cMF
                            nValor := nQuant * xMoeda(&cCampo,1,mv_par16,dDataRef,4 )
                          ENDIF
                       
                       ENDIF
                   
                   
                   Else
										
					
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Converte valores para a moeda do relatorio (C.St. e U.Pr.Compra)³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						Do Case
							Case (mv_par19 == 2)
								nValor := nQuant * xMoeda( RetFldProd((cAL1)->B1_COD,"B1_CUSTD",cAL1),Val( (cAL1)->B1_MCUSTD ),mv_par16,dDataRef,4 )
							Case (mv_par19 == 3)  // Ult.Pr.Compra sempre na Moeda 1
								nValor := nQuant * xMoeda( RetFldProd((cAL1)->B1_COD,"B1_UPRC" ,cAL1),1,mv_par16,dDataRef,4 )
						EndCase
					EndIf
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Verifica se devera ser impresso itens zerados                ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If (mv_par18==2)  .And. (QtdComp(nQuant)==QtdComp(0))
						dbSelectArea( cAl2 )
						dbSkip()
						Loop
					EndIf					
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Verifica se devera ser impresso valores zerados              ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If (mv_par21==2) .And. (QtdComp(nValor)==QtdComp(0))
						dbSelectArea( cAl2 )
						dbSkip()
						Loop
					EndIf
					
    	           	If (mv_par22==1)
	                 	nQuantR := (cAl2)->B2_QEMP2 + AvalQtdPre("SB2",1,.T.,cAl2) + (cAl2)->B2_RESERV2  + ConvUM( (cAl2)->B2_COD, (cAl2)->B2_QEMPSA, 0, 2)+(cAl2)->B2_QEMPPR2
					Else
						nQuantR := (cAl2)->B2_QEMP + AvalQtdPre("SB2",1,NIL,cAl2) + (cAl2)->B2_RESERVA + (cAl2)->B2_QEMPSA + (cAl2)->B2_QEMPPRJ
					EndIf

					nValorR := (QtdComp(nValor) / QtdComp(nQuant)) * QtdComp(nQuantR)
					
					dbSelectArea( cFileTRB )
					dbAppend()
					
					FIELD->FILIAL := (cAl2)->B2_FILIAL
					FIELD->CODIGO := (cAl2)->B2_COD
					FIELD->LOCAL  := (cAl2)->B2_LOCAL
					FIELD->TIPO   := (cAl1)->B1_TIPO
					FIELD->GRUPO  := (cAl1)->B1_GRUPO
					FIELD->DESCRI := (cAl1)->B1_DESC
					If mv_par22 == 1
				 	  FIELD->SEGUM  := (cAl1)->B1_SEGUM
				 	Else
				 	  FIELD->UM     := (cAl1)->B1_UM
				 	EndIf  
					FIELD->QUANTR := nQuantR
					FIELD->VALORR := nValorR
					FIELD->QUANT  := nQuant
					FIELD->VALOR  := nValor
					If lVEIC
						FIELD->CODITE := (cAl1)->B1_CODITE
					EndIf
					If mv_par23 == 1
						FIELD->DESCARM := (cAl2)->B2_LOCALIZ
					EndIf
				EndIf
			EndIf
		#IFNDEF TOP
		EndIf
		#ENDIF
		dbSelectArea( cAl2 )
	EndIf
	
	dbSkip()
EndDo

cFilAnt := cFilOk

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Apaga os arquivos de trabalho, cancela os filtros e restabelece as ordens originais.|
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
#IFDEF TOP
	dbSelectArea(cAl2)
	dbCloseArea()
	ChkFIle("SB2",.F.)
#ELSE
  	dbSelectArea("SB1")
	RetIndex("SB1")
	Ferase(cIndSB1+OrdBagExt())
#ENDIF

dbSelectArea("SB1")
dbClearFilter()

Return( cFileTRB )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³R260IMPRIM³ Autor ³ Ben-Hur M. Castilho   ³ Data ³ 20/11/96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Preparacao do Arquivo de Trabalho p/ Relatorio             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR260                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function R260Imprime( lEnd,cFileTRB,cTitulo,wNRel,cTam,nTipo,nOrdem )

#define DET_SIZE  14

#define DET_CODE   1
#define DET_TIPO   2
#define DET_GRUP   3
#define DET_DESC   4
#define DET_UM     5
#define DET_FL     6
#define DET_ALMX   7
#define DET_SALD   8
#define DET_EMPN   9
#define DET_DISP  10
#define DET_VEST  11
#define DET_VEMP  12
#define DET_KEYV  13
#define DET_DEAL  14

#define ACM_SIZE   6

#define ACM_CODE   1
#define ACM_SALD   2
#define ACM_EMPN   3
#define ACM_DISP   4
#define ACM_VEST   5
#define ACM_VEMP   6

Local	aPrnDET   := Nil
Local	aTotORD   := Nil
Local	aTotUM    := Nil
Local	aTotUM1   := Nil
Local	aTotAMZ   := Nil

Local	cLPrnCd   := ""
Local   cProd     := ""
Local   cLocal	  := ""

Local	lPrintCAB := .F.
Local	lPrintDET := .F.
Local	lPrintTOT := .F.
Local	lPrintOUT := .F.
Local	lPrintLIN := .F.

Local	nTotValEst:=0
Local	nTotValEmp:=0
Local	nTotValSal:=0
Local	nTotValRPR:=0
Local	nTotValRes:=0

Local cPicture	:= PesqPict("SB2", If( (mv_par15 == 1),"B2_QATU","B2_QFIM" ),14 )
Local cPictureT	:= PesqPict("SB2", If( (mv_par15 == 1),"B2_QATU","B2_QFIM" ),15 )

Local cPicVal	:= PesqPict("SB2","B2_VATU"+Str(mv_par16,1),15)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis tipo Local para SIGAVEI, SIGAPEC e SIGAOFI         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local	lT		:= .F.
Local	lT1		:= .F.
Local	lT2		:= .F.
Local	cArm0	:= alltrim(OemToAnsi(STR0009))
Local	cArm1	:= ""
Local	cArm2	:= ""
Local	n2		:= Len(cArm0)
Local	n1

For	n1	:=	n2	To	1	Step	-1
	cArm2	:=	Substr(cArm0,n1,1)
	If cArm2 <> " "
		cArm1	:= cArm2 + cArm1
	Else
		Exit   
	EndIf
Next

n1	:= 0
If lVeic
	n1	:= 016
EndIf

Private	Li		:= 80
		M_Pag	:= 1

cCab01 := OemToAnsi(STR0014)        //"CODIGO          TP GRUP DESCRICAO             UM FL ALM   SALDO       EMPENHO PARA     ESTOQUE      ___________V A L O R___________"
cCab02 := OemToAnsi(STR0015)        //"                                                          EM ESTOQUE  REQ/PV/RESERVA   DISPONIVEL    EM ESTOQUE          EMPENHADO "
//  	                                   123456789012345 12 1234 123456789012345678901 12 12 12 999,999,999.99 999,999,999.99 9999,999,999.99 9999,999,999.99 9999,999,999.99
//      	                               0         1         2         3         4         5         6         7         8         9        10        11        12        13
//          	                           0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012

If lVeic
	cCab01 := Substr(cCab01,1,aSB1Cod[1]) + Space(nCOL1) + Substr(cCab01,aSB1Cod[1]+1)
	cCab02 := Substr(cCab02,1,aSB1Cod[1]) + Space(nCOL1) + Substr(cCab02,aSB1Cod[1]+1)
EndIf

If mv_par23 == 1
	cCab01 += "    DESCRICAO"
	cCab02 += "    DO ARMAZEM"
EndIf

dbSelectArea( cFileTRB )
dbGoTop()
While !Eof()
	
	If	(LastKey() == 286) .OR. If(lEND==Nil,.F.,lEND) .OR. lAbortPrint
		Exit
	EndIf
	
	If (aPrnDET == nil)
		
		If lVEIC
			aPrnDET := Array( DET_SIZE + 1)
			aPrnDET[ DET_CODE ] := FIELD->CODITE
			aPrnDET[ DET_SIZE + 1 ] := FIELD->CODIGO
		Else	
			aPrnDET := Array( DET_SIZE )
			aPrnDET[ DET_CODE ] := FIELD->CODIGO
		EndIf
		aPrnDET[ DET_TIPO ] := FIELD->TIPO
		aPrnDET[ DET_GRUP ] := FIELD->GRUPO
		aPrnDET[ DET_DESC ] := FIELD->DESCRI
		aPrnDET[ DET_UM   ] := If(mv_par22==1,FIELD->SEGUM,FIELD->UM)
		aPrnDET[ DET_FL   ] := ""
		aPrnDET[ DET_ALMX ] := ""
		aPrnDET[ DET_SALD ] := 0
		aPrnDET[ DET_EMPN ] := 0
		aPrnDET[ DET_DISP ] := 0
		aPrnDET[ DET_VEST ] := 0
		aPrnDET[ DET_VEMP ] := 0
		aPrnDET[ DET_DEAL ] := If(mv_par23==1,FIELD->DESCARM,"")
		aPrnDET[ DET_KEYV ] := ""
	EndIf
	
	If (mv_par17 == 1) .And. (aTotUM == Nil)
		aTotUM	:= { If(mv_par22==1,FIELD->SEGUM,FIELD->UM),0,0,0,0,0 }
	EndIf
	If (mv_par17 == 1) .And. (aTotUM1 == Nil)
		aTotUM1	:= { If(mv_par22==1,FIELD->SEGUM,FIELD->UM)+FIELD->LOCAL,0,0,0,0,0 }
	EndIf
	//SubTotal por Armazem
	If nOrdem == 5 .And. (mv_par01 == 1) .And. (aTotAMZ == Nil)
		aTotAMZ	:= { If(mv_par22==1,FIELD->SEGUM,FIELD->UM),0,0,0,0,0 }
	EndIf
	
	If (((nOrdem == 2) .Or. (nOrdem == 4)) .And. (aTotORD == Nil))
		aTotORD := { If( (nOrdem == 2),FIELD->TIPO,FIELD->GRUPO ),0,0,0,0,0 }
	EndIf
	
	Do Case
		Case (mv_par01 == 1)
			aPrnDET[ DET_FL   ] := FIELD->FILIAL
			aPrnDET[ DET_ALMX ] := FIELD->LOCAL
		Case ((mv_par01 == 2) .And. (aPrnDET[ DET_KEYV ] == ""))
			aPrnDET[ DET_FL   ] := FIELD->FILIAL
			aPrnDET[ DET_ALMX ] := If( (aReturn[ 8 ] == 5),FIELD->LOCAL,"**" )
		Case ((mv_par01 == 3) .And. (aPrnDET[ DET_KEYV ] == ""))
			aPrnDET[ DET_FL   ] := "**"
			aPrnDET[ DET_ALMX ] := If( (aReturn[ 8 ] == 5),FIELD->LOCAL,"**" )
	EndCase
	
	If	aPrnDET[ DET_KEYV ] == ""
		If lVeic
			Do Case
				Case (mv_par01 == 1)
					If (aReturn[ 8 ] == 5)
						If (mv_par17 == 1)
							aPrnDET[ DET_KEYV ] := FIELD->LOCAL+If(mv_par22==1,FIELD->SEGUM,FIELD->UM)+FIELD->CODITE+FIELD->FILIAL
						Else
							aPrnDET[ DET_KEYV ] := FIELD->LOCAL+FIELD->CODITE+FIELD->FILIAL
						EndIf
					Else
						If (mv_par17 == 1)
							aPrnDET[ DET_KEYV ] := If(mv_par22==1,FIELD->SEGUM,FIELD->UM)+FIELD->CODITE+FIELD->FILIAL+FIELD->LOCAL
						Else
							aPrnDET[ DET_KEYV ] := FIELD->CODITE+FIELD->FILIAL+FIELD->LOCAL
						EndIf	
					EndIf
				Case (mv_par01 == 2)
					If (aReturn[ 8 ] == 5)
						If (mv_par17 == 1)
							aPrnDET[ DET_KEYV ] := FIELD->LOCAL+If(mv_par22==1,FIELD->SEGUM,FIELD->UM)+FIELD->CODITE+FIELD->FILIAL
					   	Else
							aPrnDET[ DET_KEYV ] := FIELD->LOCAL+FIELD->CODITE+FIELD->FILIAL
						EndIf	
					Else
						If (mv_par17 == 1)
							aPrnDET[ DET_KEYV ] := If(mv_par22==1,FIELD->SEGUM,FIELD->UM)+FIELD->CODITE+FIELD->FILIAL
						Else
							aPrnDET[ DET_KEYV ] := FIELD->CODITE+FIELD->FILIAL
						EndIf
					EndIf
				Case (mv_par01 == 3)
					If (aReturn[ 8 ] == 5)
						If (mv_par17 == 1)
							aPrnDET[ DET_KEYV ] := FIELD->LOCAL+If(mv_par22==1,FIELD->SEGUM,FIELD->UM)+FIELD->CODITE
						Else
							aPrnDET[ DET_KEYV ] := FIELD->LOCAL+FIELD->CODITE
						EndIf	
					Else
						If (mv_par17 == 1)
							aPrnDET[ DET_KEYV ] := If(mv_par22==1,FIELD->SEGUM,FIELD->UM)+FIELD->CODITE
						Else
							aPrnDET[ DET_KEYV ] := FIELD->CODITE
						EndIf
					EndIf
			EndCase
      Else
			Do Case
				Case (mv_par01 == 1)
					If (aReturn[ 8 ] == 5)
						If (mv_par17 == 1)
							aPrnDET[ DET_KEYV ] := FIELD->Local+If(mv_par22==1,FIELD->SEGUM,FIELD->UM)+FIELD->CODIGO+FIELD->FILIAL
						Else
							aPrnDET[ DET_KEYV ] := FIELD->Local+FIELD->CODIGO+FIELD->FILIAL
						EndIf
					Else
						If (mv_par17 == 1)
							aPrnDET[ DET_KEYV ] := If(mv_par22==1,FIELD->SEGUM,FIELD->UM)+FIELD->CODIGO+FIELD->FILIAL+FIELD->Local
						Else
							aPrnDET[ DET_KEYV ] := FIELD->CODIGO+FIELD->FILIAL+FIELD->Local
						EndIf
					EndIf
				Case (mv_par01 == 2)
					If (aReturn[ 8 ] == 5)
						If (mv_par17 == 1)
							aPrnDET[ DET_KEYV ] := FIELD->Local+If(mv_par22==1,FIELD->SEGUM,FIELD->UM)+FIELD->CODIGO+FIELD->FILIAL
						Else
							aPrnDET[ DET_KEYV ] := FIELD->Local+FIELD->CODIGO+FIELD->FILIAL
						EndIf
					Else
						If (mv_par17 == 1)
							aPrnDET[ DET_KEYV ] := If(mv_par22==1,FIELD->SEGUM,FIELD->UM)+FIELD->CODIGO+FIELD->FILIAL
						Else
							aPrnDET[ DET_KEYV ] := FIELD->CODIGO+FIELD->FILIAL
						EndIf
					EndIf
				Case (mv_par01 == 3)
					If (aReturn[ 8 ] == 5)
						If (mv_par17 == 1)
							aPrnDET[ DET_KEYV ] := FIELD->Local+If(mv_par22==1,FIELD->SEGUM,FIELD->UM)+FIELD->CODIGO
						Else
							aPrnDET[ DET_KEYV ] := FIELD->Local+FIELD->CODIGO
						EndIf
					Else
						If (mv_par17 == 1)
							aPrnDET[ DET_KEYV ] := If(mv_par22==1,FIELD->SEGUM,FIELD->UM)+FIELD->CODIGO
						Else
							aPrnDET[ DET_KEYV ] := FIELD->CODIGO
						EndIf
					EndIf
			EndCase
		EndIf
	EndIf
	
    cProd:= FIELD->CODIGO
    cLocal:= FIELD->LOCAL
	aPrnDET[ DET_SALD ] += FIELD->QUANT
	aPrnDET[ DET_EMPN ] += FIELD->QUANTR
	aPrnDET[ DET_DISP ] += (FIELD->QUANT-FIELD->QUANTR)
	aPrnDET[ DET_VEST ] += FIELD->VALOR
	aPrnDET[ DET_VEMP ] += FIELD->VALORR
	
	If (mv_par17 == 1)
		
		aTotUM[ ACM_SALD ] += FIELD->QUANT
		aTotUM[ ACM_EMPN ] += FIELD->QUANTR
		aTotUM[ ACM_DISP ] += (FIELD->QUANT-FIELD->QUANTR)
		aTotUM[ ACM_VEST ] += FIELD->VALOR
		aTotUM[ ACM_VEMP ] += FIELD->VALORR
		
		aTotUM1[ ACM_SALD ] += FIELD->QUANT
		aTotUM1[ ACM_EMPN ] += FIELD->QUANTR
		aTotUM1[ ACM_DISP ] += (FIELD->QUANT-FIELD->QUANTR)
		aTotUM1[ ACM_VEST ] += FIELD->VALOR
		aTotUM1[ ACM_VEMP ] += FIELD->VALORR
	EndIf
	//SubTotal por Armazem
	If nOrdem == 5 .And. (mv_par01 == 1)
		aTotAMZ[ ACM_SALD ] += FIELD->QUANT
		aTotAMZ[ ACM_EMPN ] += FIELD->QUANTR
		aTotAMZ[ ACM_DISP ] += (FIELD->QUANT-FIELD->QUANTR)
		aTotAMZ[ ACM_VEST ] += FIELD->VALOR
		aTotAMZ[ ACM_VEMP ] += FIELD->VALORR
	EndIf
	
	If ((nOrdem == 2) .Or. (nOrdem == 4))
		aTotORD[ ACM_SALD ] += FIELD->QUANT
		aTotORD[ ACM_EMPN ] += FIELD->QUANTR
		aTotORD[ ACM_DISP ] += (FIELD->QUANT-FIELD->QUANTR)
		aTotORD[ ACM_VEST ] += FIELD->VALOR
		aTotORD[ ACM_VEMP ] += FIELD->VALORR
	EndIf
	
	dbSkip()
	
	If lVeic
		Do Case
			Case (mv_par01 == 1)
				If (aReturn[ 8 ] == 5)
					If (mv_par17 == 1)
						lPrintDET := !(aPrnDET[ DET_KEYV ] == FIELD->LOCAL+If(mv_par22==1,FIELD->SEGUM,FIELD->UM)+FIELD->CODITE+FIELD->FILIAL)
				  	Else
						lPrintDET := !(aPrnDET[ DET_KEYV ] == FIELD->LOCAL+FIELD->CODITE+FIELD->FILIAL)
					EndIf
				Else
					If (mv_par17 == 1)
						lPrintDET := !(aPrnDET[ DET_KEYV ] == If(mv_par22==1,FIELD->SEGUM,FIELD->UM)+FIELD->CODITE+FIELD->FILIAL+FIELD->LOCAL)
					Else
						lPrintDET := !(aPrnDET[ DET_KEYV ] == FIELD->CODITE+FIELD->FILIAL+FIELD->LOCAL)
					EndIf
				EndIf
			Case (mv_par01 == 2)
				If (aReturn[ 8 ] == 5)
					If (mv_par17 == 1)
						lPrintDET := !(aPrnDET[ DET_KEYV ] == FIELD->LOCAL+If(mv_par22==1,FIELD->SEGUM,FIELD->UM)+FIELD->CODITE+FIELD->FILIAL)
					Else
						lPrintDET := !(aPrnDET[ DET_KEYV ] == FIELD->LOCAL+FIELD->CODITE+FIELD->FILIAL)
					EndIf
				Else
					If (mv_par17 == 1)
						lPrintDET := !(aPrnDET[ DET_KEYV ] == If(mv_par22==1,FIELD->SEGUM,FIELD->UM)+FIELD->CODITE+FIELD->FILIAL)
					Else	
						lPrintDET := !(aPrnDET[ DET_KEYV ] == FIELD->CODITE+FIELD->FILIAL)
					EndIf
				EndIf
			Case (mv_par01 == 3)
				If (aReturn[ 8 ] == 5)
					If (mv_par17 == 1)
						lPrintDET := !(aPrnDET[ DET_KEYV ] == FIELD->LOCAL+If(mv_par22==1,FIELD->SEGUM,FIELD->UM)+FIELD->CODITE)
					Else	
						lPrintDET := !(aPrnDET[ DET_KEYV ] == FIELD->LOCAL+FIELD->CODITE)
					EndIf
				Else
					If (mv_par17 == 1)
						lPrintDET := !(aPrnDET[ DET_KEYV ] == If(mv_par22==1,FIELD->SEGUM,FIELD->UM)+FIELD->CODITE)
					Else			
						lPrintDET := !(aPrnDET[ DET_KEYV ] == FIELD->CODITE)
					EndIf
				EndIf
		EndCase
	Else
		Do Case
			Case (mv_par01 == 1)
				If (aReturn[ 8 ] == 5)
					If (mv_par17 == 1)
						lPrintDET := !(aPrnDET[ DET_KEYV ] == FIELD->Local+If(mv_par22==1,FIELD->SEGUM,FIELD->UM)+FIELD->CODIGO+FIELD->FILIAL)
					Else
						lPrintDET := !(aPrnDET[ DET_KEYV ] == FIELD->Local+FIELD->CODIGO+FIELD->FILIAL)
					EndIf
				Else
					If (mv_par17 == 1)
						lPrintDET := !(aPrnDET[ DET_KEYV ] == If(mv_par22==1,FIELD->SEGUM,FIELD->UM)+FIELD->CODIGO+FIELD->FILIAL+FIELD->Local)
					Else
						lPrintDET := !(aPrnDET[ DET_KEYV ] == FIELD->CODIGO+FIELD->FILIAL+FIELD->Local)
					EndIf
				EndIf
			Case (mv_par01 == 2)
				If (aReturn[ 8 ] == 5)
					If (mv_par17 == 1)
						lPrintDET := !(aPrnDET[ DET_KEYV ] == FIELD->Local+If(mv_par22==1,FIELD->SEGUM,FIELD->UM)+FIELD->CODIGO+FIELD->FILIAL)
					Else			
						lPrintDET := !(aPrnDET[ DET_KEYV ] == FIELD->Local+FIELD->CODIGO+FIELD->FILIAL)
					EndIf
				Else
					If (mv_par17 == 1)
						lPrintDET := !(aPrnDET[ DET_KEYV ] == If(mv_par22==1,FIELD->SEGUM,FIELD->UM)+FIELD->CODIGO+FIELD->FILIAL)
					Else
						lPrintDET := !(aPrnDET[ DET_KEYV ] == FIELD->CODIGO+FIELD->FILIAL)
					EndIf
				EndIf
			Case (mv_par01 == 3)
				If (aReturn[ 8 ] == 5)
					If (mv_par17 == 1)
						lPrintDET := !(aPrnDET[ DET_KEYV ] == FIELD->Local+If(mv_par22==1,FIELD->SEGUM,FIELD->UM)+FIELD->CODIGO)
					Else
						lPrintDET := !(aPrnDET[ DET_KEYV ] == FIELD->Local+FIELD->CODIGO)
					EndIf
				Else
					If (mv_par17 == 1)
						lPrintDET := !(aPrnDET[ DET_KEYV ] == If(mv_par22==1,FIELD->SEGUM,FIELD->UM)+FIELD->CODIGO)
					Else
						lPrintDET := !(aPrnDET[ DET_KEYV ] == FIELD->CODIGO)
					EndIf
				EndIf
		EndCase
	EndIf
	
	If lCusUnif .And. lPrintDET
		If (mv_par18==2) .And. (QtdComp(aPrnDET[DET_SALD])==QtdComp(0))
			aPrnDET := Nil
			Loop	
		EndIf	
	EndIf
	Do Case
		Case (nOrdem <> 5) .And. ( (mv_par17 == 1) .And. (aTotUM[ ACM_CODE ] <> If(mv_par22==1,FIELD->SEGUM,FIELD->UM)))
			lPrintTOT := .T.
		Case (nOrdem == 5) .And. ( (mv_par17 == 1) .And. ((aTotUM1[ ACM_CODE ] <> If(mv_par22==1,FIELD->SEGUM,FIELD->UM)+FIELD->Local) .Or.;
			 (aTotUM[ ACM_CODE ] <> If(mv_par22==1,FIELD->SEGUM,FIELD->UM)) ) )
			lPrintTOT := .T.
		Case (( (nOrdem == 2) .Or. (nOrdem == 4) ) .And. !(aTotORD[ ACM_CODE ] == If( (nOrdem == 2),FIELD->TIPO,FIELD->GRUPO )))
			lPrintTOT := .T.
	EndCase
	
	If lPrintDET .Or. lPrintTOT
		
		If (Li > 56)
			Cabec( cTitulo,cCab01,cCab02,wNRel,cTam,nTipo )
		EndIf
		
		Do Case
			Case !(aPrnDET[ DET_CODE ] == cLPrnCd)
				cLPrnCd := aPrnDET[ DET_CODE ] ; lPrintCAB := .T.
		EndCase
		
		If lPrintCAB .Or. lPrintOUT
			If lVeic
				@ Li,000 PSay aPrnDET[ DET_CODE ] + " "+ aPrnDET[ DET_SIZE + 1 ]
				//  := FIELD->CODIGO
			Else	
				@ Li,000 PSay aPrnDET[ DET_CODE ]
			EndIf	

			@ Li,016 + nCOL1 PSay aPrnDET[ DET_TIPO ]
			@ Li,019 + nCOL1 PSay aPrnDET[ DET_GRUP ]
			@ Li,024 + nCOL1 PSay aPrnDET[ DET_DESC ]
			@ Li,046 + nCOL1 PSay aPrnDET[ DET_UM   ]
			
			lPrintCAB := .F. ; lPrintOUT := .F.
		EndIf
		
		@ Li,049 + nCOL1 PSay aPrnDET[ DET_FL   ]
		@ Li,052 + nCOL1 PSay aPrnDET[ DET_ALMX ]

		@ Li,054 + nCOL1 PSay aPrnDET[ DET_SALD ] Picture cPicture
		@ Li,070 + nCOL1 PSay aPrnDET[ DET_EMPN ] Picture cPicture
		@ Li,085 + nCOL1 PSay aPrnDET[ DET_DISP ] Picture cPicture
		@ Li,100 + nCOL1 PSay aPrnDET[ DET_VEST ] Picture cPicVal
		@ Li,117 + nCOL1 PSay aPrnDET[ DET_VEMP ] Picture cPicVal
        If mv_par23 == 1
	        @ Li,136 + nCOL1 PSay aPrnDET[ DET_DEAL ]
        EndIf
		
		nTotValSal+=aPrnDET[ DET_SALD ]
		nTotValRpr+=aPrnDET[ DET_EMPN ]
		nTotValRes+=aPrnDET[ DET_DISP ]
		nTotValEst+=aPrnDET[ DET_VEST ]
		nTotValEmp+=aPrnDET[ DET_VEMP ]
		
		aPrnDET := Nil
		
		Li++
		
		lT		:= .F.	// IMPRIMIR E ZERAR aTotUM
		lT1		:= .F.	// IMPRIMIR E ZERAR aTotUM1
		
		If (mv_par17 == 1) 
			If nORDEM <> 5 .AND. (aTotUM[ ACM_CODE ] <> If(mv_par22==1,FIELD->SEGUM,FIELD->UM))
				lT	:= .T. // IMPRIMIR E ZERAR aTotUM
			Else
				If nORDEM == 5 
					// unidade diferente !
					If (aTotUM[ ACM_CODE ] <> If(mv_par22==1,FIELD->SEGUM,FIELD->UM))
						lT	:= .T. // IMPRIMIR E ZERAR aTotUM E aTotUM1.
						If lT2
							lT1	:= .T. // IMPRIMIR E ZERAR aTotUM1.
							lT2	:= .F. // SE TEM Q IMPRIMIR O aTotUM1.
						EndIf
					Else // unidade igual e local diferente !
						If (Substr(aTotUM1[ ACM_CODE ],LEN(aTotUM1[ ACM_CODE ])-1,2) <> FIELD->LOCAL)
							lT	:= .F. // NAO IMPRIMIR E ZERAR aTotUM.
							lT1	:= .T. // IMPRIMIR E ZERAR aTotUM1.
							If ! lT2
								lT2	:= .T. 
							EndIf	
						EndIf
					EndIf
				EndIf	
	      	EndIf
		EndIf

		If lT	 .OR. lT1
			Li++
			If nORDEM <> 5 
				@ Li,016 PSay OemToAnsi(STR0019)+aTotUM[ ACM_CODE ]   //"Total Unidade Medida : "
				@ Li,054 + nCOL1 PSay aTotUM[ ACM_SALD ] Picture cPicture
				@ Li,070 + nCOL1 PSay aTotUM[ ACM_EMPN ] Picture cPicture
				@ Li,085 + nCOL1 PSay aTotUM[ ACM_DISP ] Picture cPicture
				@ Li,100 + nCOL1 PSay aTotUM[ ACM_VEST ] Picture cPicVal
				@ Li,117 + nCOL1 PSay aTotUM[ ACM_VEMP ] Picture cPicVal
				
				aTotUM    := Nil
			Else
				If lT1  
					@ Li,n1 PSay "Sub" + OemToAnsi(STR0019) ; //"SubTotal Unidade Medida : "
					+ SUBSTR(aTotUM1[ ACM_CODE ],1,LEN(aTotUM1[ ACM_CODE ])-2) ;
					+ " - " + cArm1 + " : " ;
					+ SUBSTR(aTotUM1[ ACM_CODE ],LEN(aTotUM1[ ACM_CODE ])-1,2)
					@ Li,054 + nCOL1 PSay aTotUM1[ ACM_SALD ] Picture cPicture
					@ Li,070 + nCOL1 PSay aTotUM1[ ACM_EMPN ] Picture cPicture
					@ Li,085 + nCOL1 PSay aTotUM1[ ACM_DISP ] Picture cPicture
					@ Li,100 + nCOL1 PSay aTotUM1[ ACM_VEST ] Picture cPicVal
					@ Li,117 + nCOL1 PSay aTotUM1[ ACM_VEMP ] Picture cPicVal

					aTotUM1	:= nil
					lT2		:= .T.
				EndIf
				If lT
					If lT1
						Li	+=	2
					EndIf
					
					@ Li,016 PSay OemToAnsi(STR0019)+aTotUM[ ACM_CODE ]   //"Total Unidade Medida : "
					@ Li,054 + nCOL1 PSay aTotUM[ ACM_SALD ] Picture cPicture
					@ Li,070 + nCOL1 PSay aTotUM[ ACM_EMPN ] Picture cPicture
					@ Li,085 + nCOL1 PSay aTotUM[ ACM_DISP ] Picture cPicture
					@ Li,100 + nCOL1 PSay aTotUM[ ACM_VEST ] Picture cPicVal
					@ Li,117 + nCOL1 PSay aTotUM[ ACM_VEMP ] Picture cPicVal
					
					aTotUM1	:= Nil
					aTotUM	:= Nil
					lT2		:= .F.
				EndIf
			EndIf
			Li++
			
			lPrintLIN := .T.
			lPrintTOT := .F. ; lPrintOUT := .T.
		EndIf

		//SubTotal por Armazem
		If nOrdem == 5 .And. mv_par01 == 1 .And. cLocal != FIELD->LOCAL
			If nOrdem == 5
				@ Li,n1 PSay OemToAnsi("SubTotal por Armazem: ") ; //"SubTotal por Armazem: "
				+ SUBSTR(aTotAMZ[ ACM_CODE ],1,LEN(aTotAMZ[ ACM_CODE ])-2) + " - " + cArm1 + " : " ;
				+ cLocal
				@ Li,054 + nCOL1 PSay aTotAMZ[ ACM_SALD ] Picture cPicture
				@ Li,070 + nCOL1 PSay aTotAMZ[ ACM_EMPN ] Picture cPicture
				@ Li,085 + nCOL1 PSay aTotAMZ[ ACM_DISP ] Picture cPicture
				@ Li,100 + nCOL1 PSay aTotAMZ[ ACM_VEST ] Picture cPicVal
				@ Li,117 + nCOL1 PSay aTotAMZ[ ACM_VEMP ] Picture cPicVal
				Li++
			
				lPrintLIN := .T.
				lPrintTOT := .F.
				lPrintOUT := .T.
				lT2		  := .F.                     
				aTotAMZ   := Nil
			EndIf
		EndIf

		If (((nOrdem == 2) .Or. (nOrdem == 4)) .And. ;
				!(aTotORD[ ACM_CODE ] == If( (nOrdem == 2),FIELD->TIPO,FIELD->GRUPO )))
			
			Li++
			
			@ Li,016 PSay OemToAnsi(STR0016)+If( (nOrdem == 2),OemToAnsi(STR0017),OemToAnsi(STR0018))+" : "+aTotORD[ ACM_CODE ]   //"Total do "###"Tipo"###"Grupo"
	 	   	@ Li,054 + nCOL1 PSay aTotORD[ ACM_SALD ] Picture cPicture
		   	@ Li,070 + nCOL1 PSay aTotORD[ ACM_EMPN ] Picture cPicture
		   	@ Li,085 + nCOL1 PSay aTotORD[ ACM_DISP ] Picture cPicture
		   	@ Li,100 + nCOL1 PSay aTotORD[ ACM_VEST ] Picture cPicVal
		   	@ Li,117 + nCOL1 PSay aTotORD[ ACM_VEMP ] Picture cPicVal

			Li++
			
			aTotORD   := nil ; lPrintLIN := .T.
			lPrintTOT := .F. ; lPrintOUT := .T.
		EndIf
		
		If lPrintLIN
			Li++ ; lPrintLIN := .F.
		EndIf
	EndIf
EndDo

If nTotValSal + nTotValRPR + nTotValRes + nTotValEst + nTotValEmp # 0
	If Li > 56
		Cabec(cTitulo,cCab01,cCab02,wnRel,cTam,nTipo)
	EndIf
	Li += If(mv_par17#1,1,0)
	@ Li,016 PSay OemToAnsi(STR0020) // "Total Geral : "
	@ Li,054 + nCOL1 PSay nTotValSal Picture cPictureT
	@ Li,070 + nCOL1 PSay nTotValRPR Picture cPicture
	@ Li,085 + nCOL1 PSay nTotValRes Picture cPicture
	@ Li,100 + nCOL1 PSay nTotValEst Picture cPicVal
	@ Li,117 + nCOL1 PSay nTotValEmp Picture cPicVal
EndIf

If (LastKey() == 286) .Or. If(lEnd==Nil,.F.,lEnd) .Or. lAbortPrint
	@ pRow()+1,00 PSay OemToAnsi(STR0021)     //"CANCELADO PELO OPERADOR."
ElseIf !(RecCount()==0) //utilizado para nao Imprimir Pagina em Branco
	Roda( LastRec(), OemToAnsi(STR0022),cTam )    //"Registro(s) processado(s)"
EndIf

SET DEVICE TO SCREEN

MS_FLUSH()

If (aReturn[ 5 ] == 1)
	SET PRINTER TO
	OurSpool( wNRel )
Endif

dbSelectArea( cFileTRB )  ; DbCloseArea()
FErase( cFileTRB+GetDBExtension() ) 
FErase( cFileTRB+OrdBagExt() )

dbSelectArea( "SB1" )

Return( Nil )
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MA260PergUºAutor  ³Microsiga           º Data ³  01/28/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Altera as Perguntas no SX1 para utilizacao do MV_CUSFIL     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function MA260PergU()

Local aAreaAnt := GetArea()
Local nTamSX1  := Len(SX1->X1_GRUPO)

If lCusUnif //-- Ajusta as perguntas para Custo Unificado
	dbSelectArea('SX1')
	dbSetOrder(1)
	If dbSeek(PADR("MTR260",nTamSX1)+"01", .F.) .And. !(X1_PRESEL==2.Or.X1_PRESEL==3) //-- Aglutina por Filial
		RecLock('SX1', .F.)
		Replace X1_PRESEL With 2
		MsUnlock()
	EndIf
	If dbSeek(PADR("MTR260",nTamSX1)+"04", .F.) .And. !(X1_CNT01=='**') //-- Armazem De **
		RecLock('SX1', .F.)
		Replace X1_CNT01 With '**'
		MsUnlock()
	EndIf
	If dbSeek(PADR("MTR260",nTamSX1)+"05", .F.) .And. !(X1_CNT01=='**') //-- Armazem Ate **
		RecLock('SX1', .F.)
		Replace X1_CNT01 With '**'
		MsUnlock()
	EndIf
EndIf	

RestArea(aAreaAnt)

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³AjustaSX1 ºAutor  ³Fernando J. Siquini º Data ³  02/06/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Inclui a 21a pergunta do MTR260 no SX1 e inclui opcao de    º±±
±±º          ³custo FIFO no relatorio.                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MATR260                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function AjustaSX1()

Local nTamSX1 := Len(SX1->X1_GRUPO)

PutSx1('MTR260', '21' , 'Listar Prods C/ Valor Zerado ?', ;
	'Muestra Valores a Cero ?      ', ;
	'Show Zeroed Values ?          ', 'mv_chk', 'C', 1, 0, 2, 'C', '', '', '', '', 'mv_par21', ;
	'Sim' , ;
	'Si', ;
	'Yes', '', ;
	'Nao', ;
	'No', ;
	'No','','','','','','','','','', ;
	{'Determina se produtos que possuam o     ', ;
	'Custo apurado igual a ZERO devem ser    ', ;
	'impressos.                              '}, ;
	{'Defina si los productos con el coste   ', ;
	'calculado igual Cero tienen que ser    ', ;
	'impressos                              '}, ;
	{'Define if Products with Calculated Cost', ;
	'equal Zero have to be printed.         ', ;
	'                                       '})

// Inclui opcao para impressao do custo FIFO
dbSelectArea("SX1")
dbSetOrder(1)
If dbSeek(PADR("MTR260",nTamSX1)+"15")
	Reclock("SX1",.F.)
	Replace X1_DEFSPA1 With "Actual"	       // Espanhol
	Replace X1_DEFENG1 With "Actual"	       // Ingles
	Replace X1_DEF04   With "Fechamento FIFO"  // Portugues
	Replace X1_DEFSPA4 With "Cierre FIFO"      // Espanhol
	Replace X1_DEFENG4 With "FIFO Closing"     // Ingles
	Replace X1_DEF05   With "Movimento FIFO"	 // Portugues
	Replace X1_DEFSPA5 With "Movimiento FIFO"  // Espanhol
	Replace X1_DEFENG5 With "FIFO Movement"    // Ingles
	MsUnlock()
EndIf
Return Nil
