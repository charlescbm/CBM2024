#Include "topconn.CH"
#Include "Colors.ch"
#Include "Protheus.CH"  

/*/
----------------------------------------------------------------------------
PROGRAMA: BFATPE001         AUTOR: DÉBORA FRIEBE         DATA: 28/11/11
----------------------------------------------------------------------------

DESCRICAO: Ponto de entrada no pedido de venda do faturamento, onde cria uma rotina
no browser com a opção "posicao pedido". Alem disto, na visualizacao de pedido valida
os itens conforme entrega, criando uma legenda na tela, conforme segue:
Led verde - não atendido                                                
Led cinza - atendido parcial                                            
Led vermelho - totalmente atendido  

----------------------------------------------------------------------------
CONTROLE DE ALTERACOES

DATA:                     AUTOR:
OBJETIVO:
----------------------------------------------------------------------------
/*/





User Function MA410COR()

Local aRet	:= PARAMIXB
Local nElem	:= aScan(aRotina, {|x| "A410VISUAL"$Upper(AllTrim(x[2])) })


If SC5->(FieldPos("C5_BLQ")) == 0
	aRet := {{"Empty(C5_LIBEROK).And.Empty(C5_NOTA).And.C5_QTDPEN==0",'ENABLE' },;			//Pedido em Aberto
				{ "(!Empty(C5_NOTA) .And. Empty(C5_CANCELA)) .Or.C5_LIBEROK=='E'",'DISABLE'},;//Pedido Encerrado
				{ "!Empty(C5_LIBEROK).And.Empty(C5_NOTA).And.C5_QTDPEN==0",'BR_AMARELO'},;		//Pedido Liberado
				{"C5_QTDPEN<>0","BR_CINZA"},; 																//Pedido Parcial
				{"C5_NOTA == 'XXXXXX'","BR_PRETO"} }						//Pedido Excluido
Else
	aRet := {{"Empty(C5_LIBEROK).And.Empty(C5_NOTA) .And. Empty(C5_BLQ) .And. C5_QTDPEN==0",'ENABLE' },;		//Pedido em Aberto
				{ "!Empty(C5_NOTA).AND. Empty(C5_CANCELA).Or.C5_LIBEROK=='E' .And. Empty(C5_BLQ)" ,'DISABLE'},;	//Pedido Encerrado
				{ "!Empty(C5_LIBEROK).And.Empty(C5_NOTA).And. Empty(C5_BLQ) .And. C5_QTDPEN==0",'BR_AMARELO'},;
				{ "C5_BLQ == '1' .And. C5_QTDPEN==0",'BR_AZUL'},;	 //Pedido Bloquedo por regra
				{ "C5_BLQ == '2' .And. C5_QTDPEN==0",'BR_LARANJA'},; //Pedido Bloquedo por verba
				{"C5_QTDPEN<>0","BR_CINZA"} ,; //Pedido Parcial
				{" C5_NOTA == 'XXXXXX' .And. C5_CANCELA == 'S'","BR_PRETO"} }  //Pedido Excluido
Endif               

// Trocar a variável a rotina para chamar uma função específica no botão visualizar.


If nElem > 0
	aRotina[nElem,2]	:= "U_E410VISU('SC5',SC5->(RECNO()),2)"
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Adiciona o botão de situação no array aRotina                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Aadd(aRotina, { "Situação Pedido","U_A410Situa" ,2,0,0})
  
Return(aRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A410Situa ºAutor  ³Jaime Wikanski      º Data ³             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao especifica de visualizacao da situacao do pedido     º±±
±±º          ³de venda com relacao aos seus bloqueios                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function A410Situa(cAlias,nReg,nOpc)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local nI       		:= 0
Local cTitulo  		:= OemToAnsi("Situacao do Pedido de Venda "+SC5->C5_NUM+" - Filial "+SC5->C5_FILIAL)
Local nOpc     		:= 0
Local aTitulo  		:= {"Situacao", "Valor (R$)"}
Local oListBox
Local oSay
Local oDlg
Local aDados			:= {}
Local cPedido			:= SC5->C5_NUM
Local cQuery			:= ""
Local nValaLib			:= 0.00

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Alimenta o array com os status do pedido de venda                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Aadd(aDados, {Padr("Bloqueio por regra",60),0.00})
Aadd(aDados, {Padr("Bloqueio por crédito",60),0.00})
Aadd(aDados, {Padr("Sem estoque",60),0.00})
Aadd(aDados, {Padr("Liberados para faturamento",60),0.00})
Aadd(aDados, {Padr("Em aberto",60),0.00})
Aadd(aDados, {Padr("Faturados",60),0.00})
Aadd(aDados, {Padr("",60),0.00})
Aadd(aDados, {Padr("Total do Pedido",60),0.00})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Soma o total de pedidos bloqueados por regra                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery := " SELECT SUM((C6_QTDVEN-C6_QTDENT)*C6_PRCVEN) AS TOTAL"
cQuery += " FROM "+RetSqlName("SC6")+" SC6 (NOLOCK)"
cQuery += " WHERE C6_FILIAL = '"+xFilial("SC6")+"'"
cQuery += " AND C6_NUM = '"+cPedido+"'"
cQuery += " AND C6_BLOQUEI = '01'"
cQuery += " AND D_E_L_E_T_ <> '*'"
If Select("SC6TRB") > 0
	DbSelectArea("SC6TRB")
	DbCloseArea()
Endif
TcQuery cQuery New Alias "SC6TRB"
DbSelectArea("SC6TRB")
DbGoTop()
aDados[1,2] := Abs(SC6TRB->TOTAL)
If Select("SC6TRB") > 0
	DbSelectArea("SC6TRB")
	DbCloseArea()
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Soma o total de pedidos bloqueados por credito                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery := " SELECT SUM(C9_QTDLIB*C6_PRCVEN) AS TOTAL"
cQuery += " FROM "+RetSqlName("SC6")+" SC6 (NOLOCK),"
cQuery += "      "+RetSqlName("SC9")+" SC9 (NOLOCK)"
cQuery += " WHERE C6_FILIAL = '"+xFilial("SC6")+"'"
cQuery += " AND C6_NUM = '"+cPedido+"'"
cQuery += " AND C6_BLOQUEI = '  '"
cQuery += " AND SC6.D_E_L_E_T_ <> '*'"
cQuery += " AND C9_FILIAL = '"+xFilial("SC9")+"'"
cQuery += " AND C9_PEDIDO = C6_NUM"
cQuery += " AND C9_ITEM = C6_ITEM"
cQuery += " AND C9_BLCRED NOT IN('  ','10')"
cQuery += " AND SC9.D_E_L_E_T_ <> '*'"
If Select("SC6TRB") > 0
	DbSelectArea("SC6TRB")
	DbCloseArea()
Endif
TcQuery cQuery New Alias "SC6TRB"
DbSelectArea("SC6TRB")
DbGoTop()
aDados[2,2] := Abs(SC6TRB->TOTAL)
nValaLib		+= Abs(SC6TRB->TOTAL)
If Select("SC6TRB") > 0
	DbSelectArea("SC6TRB")
	DbCloseArea()
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Soma o total de pedidos bloqueados por estoque                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery := " SELECT SUM(C9_QTDLIB*C6_PRCVEN) AS TOTAL"
cQuery += " FROM "+RetSqlName("SC6")+" SC6 (NOLOCK),"
cQuery += "      "+RetSqlName("SC9")+" SC9 (NOLOCK)"
cQuery += " WHERE C6_FILIAL = '"+xFilial("SC6")+"'"
cQuery += " AND C6_NUM = '"+cPedido+"'"
cQuery += " AND SC6.D_E_L_E_T_ <> '*'"
cQuery += " AND C9_FILIAL = '"+xFilial("SC9")+"'"
cQuery += " AND C9_PEDIDO = C6_NUM"
cQuery += " AND C9_ITEM = C6_ITEM"
cQuery += " AND C9_BLCRED = '  '"
cQuery += " AND C9_BLEST NOT IN('  ','10')"
cQuery += " AND SC9.D_E_L_E_T_ <> '*'"
If Select("SC6TRB") > 0
	DbSelectArea("SC6TRB")
	DbCloseArea()
Endif
TcQuery cQuery New Alias "SC6TRB"
DbSelectArea("SC6TRB")
DbGoTop()
aDados[3,2]	:= Abs(SC6TRB->TOTAL)
nValaLib		+= Abs(SC6TRB->TOTAL)
If Select("SC6TRB") > 0
	DbSelectArea("SC6TRB")
	DbCloseArea()
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Soma o total de pedidos liberados para faturamento                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery := " SELECT SUM(C9_QTDLIB*C6_PRCVEN) AS TOTAL"
cQuery += " FROM "+RetSqlName("SC6")+" SC6 (NOLOCK),"
cQuery += "      "+RetSqlName("SC9")+" SC9 (NOLOCK)"
cQuery += " WHERE C6_FILIAL = '"+xFilial("SC6")+"'"
cQuery += " AND C6_NUM = '"+cPedido+"'"
cQuery += " AND SC6.D_E_L_E_T_ <> '*'"
cQuery += " AND C9_FILIAL = '"+xFilial("SC9")+"'"
cQuery += " AND C9_PEDIDO = C6_NUM"
cQuery += " AND C9_ITEM = C6_ITEM"
cQuery += " AND C9_BLCRED = '  '"
cQuery += " AND C9_BLEST = '  '"
cQuery += " AND SC9.D_E_L_E_T_ <> '*'"
If Select("SC6TRB") > 0
	DbSelectArea("SC6TRB")
	DbCloseArea()
Endif
TcQuery cQuery New Alias "SC6TRB"
DbSelectArea("SC6TRB")
DbGoTop()
aDados[4,2] := Abs(SC6TRB->TOTAL)
nValaLib		+= Abs(SC6TRB->TOTAL)
If Select("SC6TRB") > 0
	DbSelectArea("SC6TRB")
	DbCloseArea()
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Soma o total de pedidos faturados                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery := " SELECT SUM(C9_QTDLIB*C6_PRCVEN) AS TOTAL"
cQuery += " FROM "+RetSqlName("SC6")+" SC6 (NOLOCK),"
cQuery += "      "+RetSqlName("SC9")+" SC9 (NOLOCK)"
cQuery += " WHERE C6_FILIAL = '"+xFilial("SC6")+"'"
cQuery += " AND C6_NUM = '"+cPedido+"'"
cQuery += " AND SC6.D_E_L_E_T_ <> '*'"
cQuery += " AND C9_FILIAL = '"+xFilial("SC9")+"'"
cQuery += " AND C9_PEDIDO = C6_NUM"
cQuery += " AND C9_ITEM = C6_ITEM"
cQuery += " AND C9_BLCRED = '10'"
cQuery += " AND C9_BLEST = '10'"
cQuery += " AND SC9.D_E_L_E_T_ <> '*'"
If Select("SC6TRB") > 0
	DbSelectArea("SC6TRB")
	DbCloseArea()
Endif
TcQuery cQuery New Alias "SC6TRB"
DbSelectArea("SC6TRB")
DbGoTop()
aDados[6,2] := Abs(SC6TRB->TOTAL)
nValaLib		+= Abs(SC6TRB->TOTAL)
If Select("SC6TRB") > 0
	DbSelectArea("SC6TRB")
	DbCloseArea()
Endif


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Soma o total do pedido                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery := " SELECT SUM(C6_QTDVEN*C6_PRCVEN) AS TOTAL"
cQuery += " FROM "+RetSqlName("SC6")+" SC6 (NOLOCK)"
cQuery += " WHERE C6_FILIAL = '"+xFilial("SC6")+"'"
cQuery += " AND C6_NUM = '"+cPedido+"'"
cQuery += " AND SC6.D_E_L_E_T_ <> '*'"
If Select("SC6TRB") > 0
	DbSelectArea("SC6TRB")
	DbCloseArea()
Endif
TcQuery cQuery New Alias "SC6TRB"
DbSelectArea("SC6TRB")
DbGoTop()
aDados[8,2] := Abs(SC6TRB->TOTAL)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Total a liberar                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aDados[5,2] := Abs(SC6TRB->TOTAL) - nValaLib

If Select("SC6TRB") > 0
	DbSelectArea("SC6TRB")
	DbCloseArea()
Endif


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a tela de selecao                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Len(aDados) > 0
   DEFINE MSDIALOG oDlg TITLE cTitulo From 9,0 To 25,070 OF oMainWnd 
  
   @ .1,.1 LISTBOX oListBox VAR cListBox Fields ;
            HEADER  	OemtoAnsi(aTitulo[1]),;
	            		OemtoAnsi(aTitulo[2]) ;
            SIZE 240,119

   oListBox:SetArray(aDados)
   oListBox:bLine := { || {	aDados[oListBox:nAt,1],;
		   							Iif(oListBox:nAt <> 7, Transform(aDados[oListBox:nAt,2],"@E 999,999,999.99"),"")}}
		
   DEFINE SBUTTON FROM    4,245 	TYPE 1  ACTION (nOpc := 1,oDlg:End())       ENABLE OF oDlg 
   DEFINE SBUTTON FROM 18.5,245 	TYPE 2  ACTION (nOpc := 0,oDlg:End())       ENABLE OF oDlg

   ACTIVATE MSDIALOG oDlg CENTERED
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³E410VISU  ºAutor  ³Almir Bandina       º Data ³             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao especifica de visualizacao do pedido de venda        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function E410VISU(cAlias,nReg,nOpc)

// baseado na função padrão A410Visual
Local aArea    := GetArea()
Local aHeadSC6 := {}
Local aCpos1   := {"C6_QTDVEN ","C6_QTDLIB"}
Local aCpos2   := {}
Local aBackRot := aClone(aRotina)
Local aPosObj  := {}
Local aObjects := {}
Local aSize    := {}
Local aPosGet  := {}
Local aInfo    := {}

Local lContinua:= .T.
Local lGrade   := MaGrade()
Local lQuery   := .F.
Local lHeadSC6 := .F.   
Local lFreeze   := (SuperGetMv("MV_PEDFREZ",.F.,0) <> 0)

Local nGetLin  := 0
Local nOpcA    := 0
Local nUsado   := 0
Local nTotPed  := 0
Local nTotDes  := 0
Local nCntFor  := 0
Local nNumDec  := TamSX3("C6_VALOR")[2]
Local nColFreeze:= SuperGetMv("MV_PEDFREZ",.F.,0)

Local cArqQry  := ""
Local cCadastro:= OemToAnsi("Atualiza‡„o de Pedidos de Venda")
Local oGetd
Local oSAY1
Local oSAY2
Local oSAY3
Local oSAY4
Local oDlg                                        
Local aCpos		:= {}
Local aCampos	:= {}
Local aGrid  	:= {}
Local aHead   	:= {}
Local aHeadTip	:= {}
Local cLine		:= ""
Local oVerde   := LoadBitMap(GetResources(),"BR_VERDE")
Local oVermelho:= LoadBitMap(GetResources(),"BR_VERMELHO")
Local oCinza   := LoadBitMap(GetResources(),"BR_CINZA")
#IFDEF TOP
	Local aStruSC6 := {}       
	Local cQuery   := ""
#ENDIF 

Private __lHasWSSTART := FindFunction("WS_HEADSC6")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa a Variaveis Privates.                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE aTrocaF3  := {}
PRIVATE aTELA[0][0],aGETS[0]
PRIVATE aHeader	  := {}
PRIVATE aCols	  := {}
PRIVATE aColsGrade:= {}
PRIVATE aHeadGrade:= {}
PRIVATE aHeadFor  := {}
PRIVATE aColsFor  := {}
PRIVATE N         := 1
If Type("Inclui") == "U"
	Inclui := .F.
	Altera := .F.
EndIf
Pergunte("MTA410",.F.)
If ( lGrade )
	aRotina[nOpc][4] := 6
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa a Variaveis da Enchoice.                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RegToMemory( "SC5", .F., .F. )
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem do aHeader                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

lHeadSC6 := .f.
If __lHasWSSTART
	lHEADSC6 := WS_HEADSC6(.t.,cEmpAnt,@aHeadSC6)
EndIf

If !lHEADSC6
	dbSelectArea("SX3")
	dbSetOrder(1)    
	MsSeek("SC6")
	aAdd(aHead, "" )
//	Aadd(aHeadTip, {"","",""} )
	While ( !Eof() .And. (SX3->X3_ARQUIVO == "SC6") )
		If ( X3USO(SX3->X3_USADO) .And.;
				!(	Trim(SX3->X3_CAMPO) == "C6_NUM" ) 	.And.;
				Trim(SX3->X3_CAMPO) <> "C6_QTDEMP" 	.And.;
				cNivel >= SX3->X3_NIVEL )
			nUsado++
			Aadd(aHeader,{ TRIM(X3Titulo()),;
				SX3->X3_CAMPO,;
				SX3->X3_PICTURE,;
				SX3->X3_TAMANHO,;
				SX3->X3_DECIMAL,;
				SX3->X3_VALID,;
				SX3->X3_USADO,;
				SX3->X3_TIPO,;
				SX3->X3_ARQUIVO,;
				SX3->X3_CONTEXT } )                                            
			Aadd(aHead, TRIM(X3Titulo()) )
			Aadd(aHeadTip, {TRIM(X3Titulo()),SX3->X3_TIPO, SX3->X3_PICTURE} )
		EndIf
		If Trim(SX3->X3_CAMPO) == "C6_QTDENT"
			nUsado++
			Aadd(aHeader,{ TRIM("Saldo"),;
				"C6__SALDO",;
				SX3->X3_PICTURE,;
				SX3->X3_TAMANHO,;
				SX3->X3_DECIMAL,;
				SX3->X3_VALID,;
				SX3->X3_USADO,;
				SX3->X3_TIPO,;
				SX3->X3_ARQUIVO,;
				SX3->X3_CONTEXT } )
			Aadd(aHead, TRIM("Saldo") )
			Aadd(aHeadTip, {TRIM("Saldo"), SX3->X3_TIPO, SX3->X3_PICTURE} )
		Endif
		dbSelectArea("SX3")
		dbSkip()
	EndDo
	Aadd(aHeadTip, {"","",""} )
		
	If __lHasWSSTART
		WS_HEADSC6(.f.,cEmpAnt,aHeader)
	EndIf 	
Else
	aHeader := aClone( aHeadSC6 ) 	
	nUsado  := Len( aHeader ) 
EndIf 	
	
For nCntFor := 1 To Len(aHeader)
	If aHeader[nCntFor][8] == "M"
		aadd(aCpos1,aHeader[nCntFor][2])
	EndIf
Next nCntFor
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem do aCols                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SC6")
dbSetOrder(1)
#IFDEF TOP
	If Ascan(aHeader,{|x| x[8] == "M"}) == 0
		aStruSC6:= SC6->(dbStruct())
		cArqQry := "SC6_TRB"
		lQuery  := .T.
		cQuery := "SELECT * "
		cQuery += "FROM "+RetSqlName("SC6")+" SC6 "
		cQuery += "WHERE SC6.C6_FILIAL='"+xFilial("SC6")+"' AND "
		cQuery += "SC6.C6_NUM='"+SC5->C5_NUM+"' AND "
		cQuery += "SC6.D_E_L_E_T_<>'*' "
		cQuery += "ORDER BY "+SqlOrder(SC6->(IndexKey()))

		cQuery := ChangeQuery(cQuery)

//		dbSelectArea("SC6")
//		dbCloseArea()
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cArqQry,.T.,.T.)
		For nCntFor := 1 To Len(aStruSC6)
			If ( aStruSC6[nCntFor,2]<>"C" )
				TcSetField(cArqQry,aStruSC6[nCntFor,1],aStruSC6[nCntFor,2],aStruSC6[nCntFor,3],aStruSC6[nCntFor,4])
			EndIf
		Next nCntFor
	Else
#ENDIF
	cArqQry := "SC6"
	MsSeek(xFilial("SC6")+SC5->C5_NUM)
	#IFDEF TOP
	EndIf
	#ENDIF
While ( !Eof() .And. (cArqQry)->C6_FILIAL == xFilial("SC6") .And.;
		(cArqQry)->C6_NUM 	== SC5->C5_NUM )
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se este item foi digitada atraves de uma    ³
	//³ grade, se for junta todos os itens da grade em uma   ³
	//³ referencia , abrindo os itens so quando teclar enter ³
	//³ na quantidade                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ( (cArqQry)->C6_GRADE == "S" .And. lGrade )
		a410Grade(.F.,,cArqQry)
	Else
		AADD(aCols,Array(Len(aHeader)+1))
		For nCntFor:=1 To Len(aHeader)                        
			If Alltrim(aHeader[nCntFor,2]) == "C6__SALDO"
//				aCOLS[Len(aCols)][nCntFor] := (cArqQry)->C6_QTDVEN - (cArqQry)->C6_QTDENT
				aCOLS[Len(aCols)][nCntFor] := (cArqQry)->C6_QTDVEN - (cArqQry)->C6_QTDENT
			ElseIf ( aHeader[nCntFor,10] <>  "V" )
				aCOLS[Len(aCols)][nCntFor] := FieldGet(FieldPos(aHeader[nCntFor,2]))
			Else			
				aCOLS[Len(aCols)][nCntFor] := CriaVar(aHeader[nCntFor,2])
			EndIf
		Next nCntFor
		aCOLS[Len(aCols)][Len(aHeader)+1] := Iif((SC6->C6_QTDENT == SC6->C6_QTDVEN.Or.SC6->C6_BLQ=="R "),"1",Iif(SC6->C6_QTDENT == 0,"2","3"))
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Mesmo nao sendo um item digitado atraves de grade e' necessa-³
		//³ rio criar o Array referente a este item para controle da     ³
		//³ grade                                                        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		MatGrdMont(Len(aCols))
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Efetua a Somatoria do Rodape                                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nTotPed	+= (cArqQry)->C6_VALOR
	If ( (cArqQry)->C6_PRUNIT = 0 )
		nTotDes	+= (cArqQry)->C6_VALDESC
	Else
		nTotDes += A410Arred(((cArqQry)->C6_PRUNIT*(cArqQry)->C6_QTDVEN),"C6_VALOR")-A410Arred(((cArqQry)->C6_PRCVEN*(cArqQry)->C6_QTDVEN),"C6_VALOR")
	EndIf                 
	
	dbSelectArea(cArqQry)
	dbSkip()
EndDo
nTotPed  -= M->C5_DESCONT
nTotDes  += M->C5_DESCONT
nTotDes  += A410Arred(nTotPed*M->C5_PDESCAB/100,"C6_VALOR")
nTotPed  -= A410Arred(nTotPed*M->C5_PDESCAB/100,"C6_VALOR")
If ( lQuery )
	dbSelectArea(cArqQry)
	dbCloseArea()
	ChkFile("SC6",.F.)
	dbSelectArea("SC6")
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta o array com as formas de pagamento       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Ma410MtFor(@aHeadFor,@aColsFor)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Caso nao ache nenhum item , abandona rotina.         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( Len(aCols) == 0 )
	Help(" ",1,"A410SEMREG")
	lContinua := .F.
EndIf
If ( lContinua )
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Faz o calculo automatico de dimensoes de objetos     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aSize := MsAdvSize()
	aObjects := {}
	AAdd( aObjects, { 100, 100, .t., .t. } )
	AAdd( aObjects, { 100, 100, .t., .t. } )
	AAdd( aObjects, { 100, 015, .t., .f. } )

	aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
	aPosObj := MsObjSize( aInfo, aObjects )

	aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,;
		{{003,033,160,200,240,263}} )

	DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Estabelece a Troca de Clientes conforme o Tipo do Pedido de Venda      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ( M->C5_TIPO $ "DB" )
		aTrocaF3 := {{"C5_CLIENTE","SA2"}}
	Else
		aTrocaF3 := {}
	EndIf
	EnChoice( cAlias, nReg, nOpc, , , , , aPosObj[1],aCpos2,3,,,"A415VldTOk")
	nGetLin := aPosObj[3,1]
	@ nGetLin,aPosGet[1,1]  SAY OemToAnsi(IIF(M->C5_TIPO$"DB","Fornec.:","Cliente: ")) SIZE 020,09 PIXEL	
	@ nGetLin,aPosGet[1,2]  SAY oSAY1 VAR Space(40)						SIZE 120,09 PICTURE "@!" OF oDlg PIXEL
	@ nGetLin,aPosGet[1,3]  SAY OemToAnsi("Total :")						SIZE 020,09 OF oDlg PIXEL
	@ nGetLin,aPosGet[1,4]  SAY oSAY2 VAR 0 PICTURE TM(0,16,nNumDec)		SIZE 050,09 OF oDlg	PIXEL
	@ nGetLin,aPosGet[1,5]  SAY OemToAnsi("Desc. :")						SIZE 020,09 OF oDlg PIXEL
	@ nGetLin,aPosGet[1,6]  SAY oSAY3 VAR 0 PICTURE TM(0,16,nNumDec)		SIZE 050,09 OF oDlg	PIXEL RIGHT
	@ nGetLin+10,aPosGet[1,5] SAY OemToAnsi("=")							SIZE 020,09 OF oDlg PIXEL
	@ nGetLin+10,aPosGet[1,6] SAY oSAY4 VAR 0								SIZE 050,09 PICTURE TM(0,16,nNumDec) OF oDlg PIXEL RIGHT
	// Coloca a legenda para os led's
	@ nGetLin+20,aPosGet[1,1] BITMAP oBmp RESNAME "BR_VERDE"				SIZE 16,16 NOBORDER PIXEL
	@ nGetLin+20,aPosGet[1,1]+010 SAY "Item em Aberto"						OF oDlg PIXEL COLOR CLR_HBLUE
	@ nGetLin+20,aPosGet[1,1]+050 BITMAP oBmp RESNAME "BR_CINZA"				SIZE 16,16 NOBORDER PIXEL
	@ nGetLin+20,aPosGet[1,1]+060 SAY "Item Parcialmente Entregue"		OF oDlg PIXEL COLOR CLR_HBLUE
	@ nGetLin+20,aPosGet[1,1]+130 BITMAP oBmp RESNAME "BR_VERMELHO"			SIZE 16,16 NOBORDER PIXEL
	@ nGetLin+20,aPosGet[1,1]+140 SAY "Item Totalmente Entregue"			OF oDlg PIXEL COLOR CLR_HBLUE
	
	oDlg:Cargo	:= {|c1,n2,n3,n4| oSay1:SetText(c1),;
	oSay2:SetText(n2),;
	oSay3:SetText(n3),;
	oSay4:SetText(n4) }
	
	//oGetd   := MsGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpc,,,"",,aCpos1,nColFreeze,,"A410FldOk",,,,,,lFreeze)	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Monta o listbox de exibicao dos dados da tabela SC6          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek("SC6",.F.)
	While !Eof() .And. X3_ARQUIVO == Alltrim("SC6")
		If X3Uso(X3_USADO) .And. cNivel >= X3_NIVEL .And. AScan(aCpos,Alltrim(X3_CAMPO)) == 0
			AADD(aCpos  , X3_CAMPO)
			AADD(aCampos, {X3_CAMPO, X3_TIPO, X3_TAMANHO, X3_DECIMAL})		
		Endif
		dbSkip()
	Enddo        
	For nI:= 1 To Len(aHead)
		If nI == 1
			cLine += "Iif(aCols[oListBox:nAt][" + AllTrim(Str(Len(aHead))) + "] == '1', oVermelho, Iif(aCols[oListBox:nAt][" + AllTrim(Str(Len(aHead))) + "] == '2', oVerde, oCinza ))"
		Endif
		cLine += ","
		If aHeadTip[nI,2] == "N"
			cLine += "Transform(aCols[oListBox:nAt][" + AllTrim(Str(nI)) + "],'" + AllTrim(aHeadTip[nI,3]) + "')"
		Else
			cLine += "aCols[oListBox:nAt][" + AllTrim(Str(nI)) + "]"
		EndIf
	Next
	//cLine += "}"
	bLine := &( "{|| {" + cLine + "}}" )

	oListBox := TWBrowse():New( aPosObj[2,1],aPosObj[2,2],aPosObj[2][4]-aPosObj[2][2],aPosObj[2][3]-aPosObj[2][1],,aHead,,oDlg,,,,{||(N:=oListBox:nAt)},,,,,,,,.F.,,.T.,,.F.,,,)
	oListBox:SetArray(aCols)
	oListBox:bLine := bLine   
	oListBox:Refresh()
	
	Ma410Rodap(oGetd,nTotPed,nTotDes)
	ACTIVATE MSDIALOG oDlg ON INIT E410Bar(oDlg,{||nOpcA:=1,oDlg:End()},{||oDlg:End()},nOpc)
EndIf
aRotina := aClone(aBackRot)
RestArea(aArea)
Return( nOpcA )




******************************************************************************************************
Static Function E410Bar(oDlg,bOk,bCancel,nOpc)
******************************************************************************************************

Local aButtons  := {}
Local aButtonUsr := {}
Local nI        := 0

aadd(aButtons,{"RELATORIO",{||E410Impos()},"Planilha Financeira", "Planilha" })	//"Planilha Financeira"
If ( aRotina[ nOpc, 4 ] == 2 .Or. aRotina[ nOpc, 4 ] == 6 ) .And. !AtIsRotina("A410TRACK")
	AAdd(aButtons,{ "ORDEM", {|| E410Track() }, "System Tracker", "Tracker" } )  // "System Tracker"
EndIf 	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Pontos de Entrada 													   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistTemplate("A410CONS",,.T.)
	aButtonUsr := ExecTemplate("A410CONS",.F.,.F.)
	If ValType(aButtonUsr) == "A"
		For nI   := 1  To  Len(aButtonUsr)
			Aadd(aButtons,aClone(aButtonUsr[nI]))
		Next nI
	EndIf
EndIf
If ExistBlock("A410CONS",,.T.)
	aButtonUsr := ExecBlock("A410CONS",.F.,.F.)
	If ValType(aButtonUsr) == "A"
		For nI   := 1  To  Len(aButtonUsr)
			Aadd(aButtons,aClone(aButtonUsr[nI]))
		Next nI
	EndIf
EndIf


Return (EnchoiceBar(oDlg,bOK,bcancel,,aButtons))




******************************************************************************************************
Static Function E410Impos()
******************************************************************************************************

Local aArea		:= GetArea()
Local aAreaSA1	:= SA1->(GetArea())
Local aFisGet	:= {}
Local aFisGetSC5:= {}
Local aTitles   := {"Nota Fiscal","Duplicatas","Rentabilidade"}
Local aDupl     := {}
Local aVencto   := {}
Local aFlHead   := { "Vencimento","Valor","Dt. Entrega Ref." }
Local aEntr     := {}                
Local aDuplTmp  := {}
Local aRFHead   := { RetTitle("C6_PRODUTO"),RetTitle("C6_VALOR"),"C.M.V","Vlr.Presente","Lucro Bruto","Margem de Contribuição(%)"}
Local aRentab   := {}
Local nPLocal   := aScan(aHeader,{|x| AllTrim(x[2])=="C6_LOCAL"})
Local nPTotal   := aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALOR"})
Local nPValDesc := aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALDESC"})
Local nPPrUnit  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRUNIT"})
Local nPPrcVen  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRCVEN"})
Local nPQtdVen  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN"})
Local nPDtEntr  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_ENTREG"})
Local nPProduto := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO"})
Local nPTES     := aScan(aHeader,{|x| AllTrim(x[2])=="C6_TES"})
Local nPNfOri   := aScan(aHeader,{|x| AllTrim(x[2])=="C6_NFORI"})
Local nPSerOri  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_SERIORI"})
Local nPItemOri := aScan(aHeader,{|x| AllTrim(x[2])=="C6_ITEMORI"})
Local nUsado    := Len(aHeader)
Local nX        := 0
Local nAcerto   := 0
Local nPrcLista := 0
Local nValMerc  := 0
Local nDesconto := 0
Local nAcresFin := 0
Local nQtdPeso  := 0
Local nRecOri   := 0
Local nPosEntr  := 0
Local nItem     := 0
Local nY        := 0 
Local nPosCpo   := 0
Local lDtEmi    := SuperGetMv("MV_DPDTEMI",.F.,.T.)
Local dDataCnd  := M->C5_EMISSAO
Local oDlg
Local oDupl
Local oFolder
Local oRentab

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Busca referencias no SC6                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aFisGet	:= {}
dbSelectArea("SX3")
dbSetOrder(1)
MsSeek("SC6")
While !Eof().And.X3_ARQUIVO=="SC6"
	cValid := UPPER(X3_VALID+X3_VLDUSER)
	If 'MAFISGET("'$cValid
		nPosIni 	:= AT('MAFISGET("',cValid)+10
		nLen		:= AT('")',Substr(cValid,nPosIni,Len(cValid)-nPosIni))-1
		cReferencia := Substr(cValid,nPosIni,nLen)
		aAdd(aFisGet,{cReferencia,X3_CAMPO,MaFisOrdem(cReferencia)})
	EndIf
	If 'MAFISREF("'$cValid
		nPosIni		:= AT('MAFISREF("',cValid) + 10
		cReferencia	:=Substr(cValid,nPosIni,AT('","MT410",',cValid)-nPosIni)
		aAdd(aFisGet,{cReferencia,X3_CAMPO,MaFisOrdem(cReferencia)})
	EndIf
	dbSkip()
EndDo
aSort(aFisGet,,,{|x,y| x[3]<y[3]})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Busca referencias no SC5                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aFisGetSC5	:= {}
dbSelectArea("SX3")
dbSetOrder(1)
MsSeek("SC5")
While !Eof().And.X3_ARQUIVO=="SC5"
	cValid := UPPER(X3_VALID+X3_VLDUSER)
	If 'MAFISGET("'$cValid
		nPosIni 	:= AT('MAFISGET("',cValid)+10
		nLen		:= AT('")',Substr(cValid,nPosIni,Len(cValid)-nPosIni))-1
		cReferencia := Substr(cValid,nPosIni,nLen)
		aAdd(aFisGetSC5,{cReferencia,X3_CAMPO,MaFisOrdem(cReferencia)})
	EndIf
	If 'MAFISREF("'$cValid
		nPosIni		:= AT('MAFISREF("',cValid) + 10
		cReferencia	:=Substr(cValid,nPosIni,AT('","MT410",',cValid)-nPosIni)
		aAdd(aFisGetSC5,{cReferencia,X3_CAMPO,MaFisOrdem(cReferencia)})
	EndIf
	dbSkip()
EndDo
aSort(aFisGetSC5,,,{|x,y| x[3]<y[3]})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicializa a funcao fiscal                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MaFisSave()
MaFisEnd()
MaFisIni(M->C5_CLIENTE,;// 1-Codigo Cliente/Fornecedor
	M->C5_LOJAENT,;		// 2-Loja do Cliente/Fornecedor
	IIf(M->C5_TIPO$'DB',"F","C"),;				// 3-C:Cliente , F:Fornecedor
	M->C5_TIPO,;				// 4-Tipo da NF
	M->C5_TIPOCLI,;		// 5-Tipo do Cliente/Fornecedor
	Nil,;
	Nil,;
	Nil,;
	Nil,;
	"MATA461")

//Na argentina o calculo de impostos depende da serie.
If cPaisLoc == 'ARG'                         
	SA1->(DbSetOrder(1))
	SA1->(MsSeek(xFilial()+M->C5_CLIENTE+M->C5_LOJAENT))
	MaFisAlt('NF_SERIENF',LocXTipSer('SA1',MVNOTAFIS))
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Agrega os itens para a funcao fiscal         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nPTotal > 0 .And. nPValDesc > 0 .And. nPPrUnit > 0 .And. nPProduto > 0 .And. nPQtdVen > 0 .And. nPTes > 0
	For nX := 1 To Len(aCols)
		nQtdPeso := 0
		If Len(aCols[nX])==nUsado+1			// Como é só de visualização não precisa testar deletados .Or. !aCols[nX][nUsado+1]
			nItem++
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Posiciona Registros                          ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ			
			SB1->(dbSetOrder(1))
			If SB1->(MsSeek(xFilial("SB1")+aCols[nX][nPProduto]))
				nQtdPeso := aCols[nX][nPQtdVen]*SB1->B1_PESO
			EndIf
					
			If nPNfOri > 0 .And. nPSerOri > 0 .And. nPItemOri > 0
				If !Empty(aCols[nX][nPNfOri]) .And. !Empty(aCols[nX][nPItemOri])
					SD1->(dbSetOrder(1))
					If SD1->(MSSeek(xFilial("SD1")+aCols[nX][nPNfOri]+aCols[nX][nPSerOri]+M->C5_CLIENTE+M->C5_LOJACLI+aCols[nX][nPProduto]+aCols[nX][nPItemOri]))
						nRecOri := SD1->(Recno())
					Endif	
				Endif
			EndIf           
            SB2->(dbSetOrder(1))
            SB2->(MsSeek(xFilial("SB2")+SB1->B1_COD+aCols[nX][nPLocal]))
            SF4->(dbSetOrder(1))
            SF4->(MsSeek(xFilial("SF4")+aCols[nX][nPTES]))	            
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Calcula o preco de lista                     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nValMerc  := aCols[nX][nPTotal]
			nPrcLista := aCols[nX][nPPrUnit]
			If ( nPrcLista == 0 )
				nPrcLista := NoRound(nValMerc/aCols[nX][nPQtdVen],TamSX3("C6_PRCVEN")[2])
			EndIf
			nAcresFin := A410Arred(aCols[nX][nPPrcVen]*M->C5_ACRSFIN/100,"D2_PRCVEN")
			nValMerc  += A410Arred(aCols[nX][nPQtdVen]*nAcresFin,"D2_TOTAL")		
			nDesconto := a410Arred(nPrcLista*aCols[nX][nPQtdVen],"D2_DESCON")-nValMerc
			nDesconto := IIf(nDesconto==0,aCols[nX][nPValDesc],nDesconto)
			nDesconto := Max(0,nDesconto)		
			nPrcLista += nAcresFin			
			
			//Para os outros paises, este tratamento e feito no programas que calculam os impostos.
			If cPaisLoc=="BRA"
				nValMerc  += nDesconto
			Endif

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verifica a data de entrega para as duplicatas³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If ( nPDtEntr > 0 )
				If ( dDataCnd > aCols[nX][nPDtEntr] .And. !Empty(aCols[nX][nPDtEntr]) )
					dDataCnd := aCols[nX][nPDtEntr]
				EndIf
			Else
				dDataCnd  := M->C5_EMISSAO
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Agrega os itens para a funcao fiscal         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			MaFisAdd(aCols[nX][nPProduto],;   	// 1-Codigo do Produto ( Obrigatorio )
				aCols[nX][nPTES],;	   	// 2-Codigo do TES ( Opcional )
				aCols[nX][nPQtdVen],;  	// 3-Quantidade ( Obrigatorio )
				nPrcLista,;		  	// 4-Preco Unitario ( Obrigatorio )
				nDesconto,; 	// 5-Valor do Desconto ( Opcional )
				"",;	   			// 6-Numero da NF Original ( Devolucao/Benef )
				"",;				// 7-Serie da NF Original ( Devolucao/Benef )
				nRecOri,;					// 8-RecNo da NF Original no arq SD1/SD2
				0,;					// 9-Valor do Frete do Item ( Opcional )
				0,;					// 10-Valor da Despesa do item ( Opcional )
				0,;					// 11-Valor do Seguro do item ( Opcional )
				0,;					// 12-Valor do Frete Autonomo ( Opcional )
				nValMerc,;			// 13-Valor da Mercadoria ( Obrigatorio )
				0)					// 14-Valor da Embalagem ( Opiconal )	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Calculo do ISS                               ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			SF4->(dbSetOrder(1))
			SF4->(MsSeek(xFilial("SF4")+aCols[nX][nPTES]))			
			If ( M->C5_INCISS == "N" .And. M->C5_TIPO == "N")
				If ( SF4->F4_ISS=="S" )
					nPrcLista := a410Arred(nPrcLista/(1-(MaAliqISS(nItem)/100)),"D2_PRCVEN")
					nValMerc  := a410Arred(nValMerc/(1-(MaAliqISS(nItem)/100)),"D2_PRCVEN")
				EndIf
			EndIf	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Altera peso para calcular frete              ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			MaFisAlt("IT_VALMERC",nValMerc,nItem)
			MaFisAlt("IT_PRCUNI",nPrcLista,nItem)
			MaFisAlt("IT_PESO",nQtdPeso,nItem)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Analise da Rentabilidade                     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If SF4->F4_DUPLIC=="S"
				nY := aScan(aRentab,{|x| x[1] == aCols[nX][nPProduto]})
				If nY == 0
					aadd(aRenTab,{aCols[nX][nPProduto],0,0,0,0,0})
					nY := Len(aRenTab)
				EndIf
				If cPaisLoc=="BRA"
					aRentab[nY][2] += (nValMerc - nDesconto)
				Else
					aRentab[nY][2] += nValMerc
				Endif
				aRentab[nY][3] += aCols[nX][nPQtdVen]*SB2->B2_CM1
			EndIf
		EndIf
	Next nX
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Indica os valores do cabecalho               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MaFisAlt("NF_FRETE",M->C5_FRETE)
MaFisAlt("NF_SEGURO",M->C5_SEGURO)
MaFisAlt("NF_AUTONOMO",M->C5_FRETAUT)
MaFisAlt("NF_DESPESA",M->C5_DESPESA)
If M->C5_DESCONT > 0
	MaFisAlt("NF_DESCONTO",Min(MaFisRet(,"NF_VALMERC")-0.01,M->C5_DESCONT+MaFisRet(,"NF_DESCONTO")))
EndIf
If M->C5_PDESCAB > 0
	MaFisAlt("NF_DESCONTO",A410Arred(MaFisRet(,"NF_VALMERC")*M->C5_PDESCAB/100,"C6_VALOR")+MaFisRet(,"NF_DESCONTO"))
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Realiza alteracoes de referencias do SC6         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SC6")                     
If Len(aFisGet) > 0
	For nX := 1 to Len(aCols)                                    	
		If Len(aCols[nX])==nUsado+1			// Como é só de visualização não precisa ver deletados .Or. !aCols[nX][Len(aHeader)+1]			
			For nY := 1 to Len(aFisGet)
				nPosCpo := aScan(aHeader,{|x| AllTrim(x[2])==Alltrim(aFisGet[ny][2])})
				If nPosCpo > 0	
					If !Empty(aCols[nX][nPosCpo])
						MaFisAlt(aFisGet[ny][1],aCols[nX][nPosCpo],nX,.F.)
					Endif	
				EndIf
			Next nX	
		Endif	
	Next nY           
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Realiza alteracoes de referencias do SC5         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Len(aFisGetSC5) > 0	
	dbSelectArea("SC5")
	For nY := 1 to Len(aFisGetSC5)
		If !Empty(&("M->"+Alltrim(aFisGetSC5[ny][2])))
		
			If aFisGetSC5[ny][1] == "NF_SUFRAMA"
				MaFisAlt(aFisGetSC5[ny][1],Iif(&("M->"+Alltrim(aFisGetSC5[ny][2])) == "1",.T.,.F.),nItem,.F.)
			Else	
				MaFisAlt(aFisGetSC5[ny][1],&("M->"+Alltrim(aFisGetSC5[ny][2])),nItem,.F.)
			Endif	
		EndIf
	Next nY
Endif
If ExistBlock("M410PLNF")
	ExecBlock("M410PLNF",.F.,.F.)
EndIf
MaFisWrite(1)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Calcula os venctos conforme a condicao de pagto  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lDtEmi
	dbSelectarea("SE4")
	dbSetOrder(1)
	MsSeek(xFilial("SE4")+M->C5_CONDPAG)
	If !(SE4->E4_TIPO=="9")	
		aDupl := Condicao(MaFisRet(,"NF_BASEDUP"),M->C5_CONDPAG,MaFisRet(,"NF_VALIPI"),dDataCnd,MaFisRet(,"NF_VALSOL"))
		If Len(aDupl) > 0
			For nX := 1 To Len(aDupl)
				nAcerto += aDupl[nX][2]
			Next nX
			aDupl[Len(aDupl)][2] += MaFisRet(,"NF_BASEDUP") - nAcerto
			aVencto := aClone(aDupl)
			For nX := 1 To Len(aDupl)
				aDupl[nX][2] := TransForm(aDupl[nX][2],PesqPict("SE1","E1_VALOR"))
			Next nX			
		Endif	
	Else
		aDupl := {{Ctod(""),TransForm(MaFisRet(,"NF_BASEDUP"),PesqPict("SE1","E1_VALOR"))}}
		aVencto := {{dDataBase,MaFisRet(,"NF_BASEDUP")}}
	EndIf
Else
	For nX := 1 to Len(aCols)
		If Len(aCols[nX])==nUsado .Or. !aCols[nX][nUsado+1]	
			If nPDtEntr > 0				
				nPosEntr := Ascan(aEntr,{|x| x[1] == aCols[nX][nPDtEntr]})
 				If nPosEntr == 0
					Aadd(aEntr,{aCols[nX][nPDtEntr],MaFisRet(nX,"IT_BASEDUP"),MaFisRet(nX,"IT_VALIPI"),MaFisRet(nX,"IT_VALSOL")})
				Else    
					aEntr[nPosEntr][2]+= MaFisRet(nX,"IT_BASEDUP")
					aEntr[nPosEntr][2]+= MaFisRet(nX,"IT_VALIPI")
					aEntr[nPosEntr][2]+= MaFisRet(nX,"IT_VALSOL")
				EndIf				
			Endif	
		Endif	
    Next
	dbSelectarea("SE4")
	dbSetOrder(1)
	MsSeek(xFilial("SE4")+M->C5_CONDPAG)
	If !(SE4->E4_TIPO=="9")	
		For nY := 1 to Len(aEntr)
			nAcerto  := 0
			aDuplTmp := Condicao(aEntr[nY][2],M->C5_CONDPAG,aEntr[nY][3],aEntr[nY][1],aEntr[nY][4])			
			If Len(aDuplTmp) > 0			
				For nX := 1 To Len(aDuplTmp)
					nAcerto += aDuplTmp[nX][2]
				Next nX			
				aDuplTmp[Len(aDuplTmp)][2] += aEntr[nY][2] - nAcerto
				aVencto := aClone(aDuplTmp)
				For nX := 1 To Len(aDuplTmp)
					aDuplTmp[nX][2] := TransForm(aDuplTmp[nX][2],PesqPict("SE1","E1_VALOR"))
				Next nX			
				aEval(aDuplTmp,{|x| Aadd(aDupl,{aEntr[nY][1],x[1],x[2]})})
			EndIf			
		Next			
	Else
		aDupl := {{Ctod(""),TransForm(MaFisRet(,"NF_BASEDUP"),PesqPict("SE1","E1_VALOR"))}}
		aVencto := {{dDataBase,MaFisRet(,"NF_BASEDUP")}}
	EndIf
EndIf
If Len(aDupl) == 0
	aDupl := {{Ctod(""),TransForm(MaFisRet(,"NF_BASEDUP"),PesqPict("SE1","E1_VALOR"))}}
	aVencto := {{dDataBase,MaFisRet(,"NF_BASEDUP")}}
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Analise da Rentabilidade - Valor Presente    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nItem := 0
For nX := 1 To Len(aCols)
	If Len(aCols[nX])==nUsado+1		//  .Or. !aCols[nX][nUsado+1]
		nItem++
		nY := aScan(aRentab,{|x| x[1] == aCols[nX][nPProduto]})
		If nY <> 0
			aRentab[nY][4] += Max(Ma410Custo(nItem,aVencto,aCols[nX][nPTES],aCols[nX][nPProduto],aCols[nX][nPLocal],aCols[nX][nPQtdVen]),0)
			aRentab[nY][5] := Max(aRentab[nY][4]-aRentab[nY][3],0)
			aRentab[nY][6] := aRentab[nY][5]/aRentab[nY][4]*100
		EndIf
	EndIf
Next nX
aadd(aRentab,{"",0,0,0,0,0})
For nX := 1 To Len(aRentab)
	If nX <> Len(aRentab)
		aRentab[Len(aRentab)][2] += aRentab[nX][2]
		aRentab[Len(aRentab)][3] += aRentab[nX][3]
		aRentab[Len(aRentab)][4] += aRentab[nX][4]
		aRentab[Len(aRentab)][5] += aRentab[nX][5]
		aRentab[Len(aRentab)][6] := aRentab[Len(aRentab)][5]/aRentab[Len(aRentab)][4]*100
	EndIf	
	aRentab[nX][2] := TransForm(aRentab[nX][2],"@e 999,999,999.999999")
	aRentab[nX][3] := TransForm(aRentab[nX][3],"@e 999,999,999.999999")
	aRentab[nX][4] := TransForm(aRentab[nX][4],"@e 999,999,999.999999")
	aRentab[nX][5] := TransForm(aRentab[nX][5],"@e 999,999,999.999999")
	aRentab[nX][6] := TransForm(aRentab[nX][6],"@e 999,999,999.999999")
Next nX
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta a tela de exibicao dos valores fiscais ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE MSDIALOG oDlg TITLE OemToAnsi("Planilha Financeira") FROM 09,00 TO 28,80
oFolder := TFolder():New(001,001,aTitles,{"HEADER"},oDlg,,,, .T., .F.,315,140)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Folder 1                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MaFisRodape(1,oFolder:aDialogs[1],,{005,001,310,60},Nil,.T.)
@ 070,005 SAY RetTitle("F2_FRETE")		SIZE 40,10 PIXEL OF oFolder:aDialogs[1]
@ 070,105 SAY RetTitle("F2_SEGURO")		SIZE 40,10 PIXEL OF oFolder:aDialogs[1]
@ 070,205 SAY RetTitle("F2_DESCONT")	SIZE 40,10 PIXEL OF oFolder:aDialogs[1]
@ 085,005 SAY RetTitle("F2_FRETAUT")	SIZE 40,10 PIXEL OF oFolder:aDialogs[1]
@ 085,105 SAY RetTitle("F2_DESPESA")	SIZE 40,10 PIXEL OF oFolder:aDialogs[1]
@ 085,205 SAY RetTitle("F2_VALFAT")		SIZE 40,10 PIXEL OF oFolder:aDialogs[1]
@ 070,050 MSGET MaFisRet(,"NF_FRETE")		PICTURE PesqPict("SF2","F2_FRETE",16,2)		SIZE 50,07 PIXEL WHEN .F. OF oFolder:aDialogs[1]
@ 070,150 MSGET MaFisRet(,"NF_SEGURO")  	PICTURE PesqPict("SF2","F2_SEGURO",16,2)	SIZE 50,07 PIXEL WHEN .F. OF oFolder:aDialogs[1]
@ 070,250 MSGET MaFisRet(,"NF_DESCONTO")	PICTURE PesqPict("SF2","F2_DESCONTO",16,2)	SIZE 50,07 PIXEL WHEN .F. OF oFolder:aDialogs[1]
@ 085,050 MSGET MaFisRet(,"NF_AUTONOMO")	PICTURE PesqPict("SF2","F2_FRETAUT",16,2)	SIZE 50,07 PIXEL WHEN .F. OF oFolder:aDialogs[1]
@ 085,150 MSGET MaFisRet(,"NF_DESPESA")		PICTURE PesqPict("SF2","F2_DESPESA",16,2)	SIZE 50,07 PIXEL WHEN .F. OF oFolder:aDialogs[1]
@ 085,250 MSGET MaFisRet(,"NF_BASEDUP")		PICTURE PesqPict("SF2","F2_VALFAT",16,2)	SIZE 50,07 PIXEL WHEN .F. OF oFolder:aDialogs[1]
@ 105,005 TO 106,310 PIXEL OF oFolder:aDialogs[1]
@ 110,005 SAY OemToAnsi("Total da Nota")   SIZE 40,10 PIXEL OF oFolder:aDialogs[1]
@ 110,050 MSGET MaFisRet(,"NF_TOTAL")      PICTURE PesqPict("SF2","F2_VALBRUT",16,2) 	SIZE 50,07 PIXEL WHEN .F. OF oFolder:aDialogs[1]
@ 110,270 BUTTON OemToAnsi("Sair")			SIZE 040,11 FONT oFolder:aDialogs[1]:oFont ACTION oDlg:End() OF oFolder:aDialogs[1] PIXEL
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Folder 2                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ                                                                                                      
If lDtEmi
	@ 005,001 LISTBOX oDupl FIELDS TITLE aFlHead[1],aFlHead[2] SIZE 310,095 	OF oFolder:aDialogs[2] PIXEL
Else	
	@ 005,001 LISTBOX oDupl FIELDS TITLE aFlHead[3],aFlHead[1],aFlHead[2] SIZE 310,095 	OF oFolder:aDialogs[2] PIXEL
Endif	
oDupl:SetArray(aDupl)
oDupl:bLine := {|| aDupl[oDupl:nAt] }
@ 105,005 TO 106,310 PIXEL OF oFolder:aDialogs[2]
If cPaisLoc == "BRA"
	@ 110,005 SAY RetTitle("F2_VALFAT")		SIZE 40,10 PIXEL OF oFolder:aDialogs[2]
Else
	@ 110,005 SAY OemToAnsi("Vlr. Duplicatas")	    SIZE 40,10 PIXEL OF oFolder:aDialogs[2]
Endif	
@ 110,050 MSGET MaFisRet(,"NF_BASEDUP")		PICTURE PesqPict("SF2","F2_VALFAT",16,2)	SIZE 50,07 PIXEL WHEN .F. OF oFolder:aDialogs[2]
@ 110,270 BUTTON OemToAnsi("Sair")			SIZE 040,11 FONT oFolder:aDialogs[1]:oFont ACTION oDlg:End() OF oFolder:aDialogs[2] PIXEL
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Folder 3                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
@ 005,001 LISTBOX oRentab FIELDS TITLE aRFHead[1],aRFHead[2],aRFHead[3],aRFHead[4],aRFHead[5],aRFHead[6] SIZE 310,095 	OF oFolder:aDialogs[3] PIXEL
@ 110,270 BUTTON OemToAnsi("Sair")			SIZE 040,11 FONT oFolder:aDialogs[3]:oFont ACTION oDlg:End() OF oFolder:aDialogs[3] PIXEL		//"Sair"
If Empty(aRentab)
	aRentab   := {{"",0,0,0,0,0}}
EndIf
oRentab:SetArray(aRentab)
oRentab:bLine := {|| aRentab[oRentab:nAt] }
ACTIVATE MSDIALOG oDlg CENTERED
MaFisEnd()
MaFisRestore()

RestArea(aAreaSA1)
RestArea(aArea)
Return(.T.)



*******************************************************************************************************
Static Function E410Track()
*******************************************************************************************************

Local aEnt     := {}
Local cPedido  := M->C5_NUM
Local nPosItem := GDFieldPos( "C6_ITEM" )
Local nLoop    := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicializa a funcao fiscal                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nLoop := 1 To Len( aCols )
	AAdd( aEnt, { "SC6", cPedido + aCols[ nLoop, nPosItem ] } )
Next nLoop

MaTrkShow( aEnt )

Return( .T. )

