#INCLUDE "protheus.CH"
#INCLUDE "TopConn.ch"
#INCLUDE "RwMake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³a410Cons  ºAutor  ³Evaldo V. Batista   º Data ³  11/06/2005 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cria Um Botao na EnchoiceBar para liberar o pedido para    º±±
±±º          ³ Faturamento                                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³   	                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function A410Cons()
Local aButton := {}     

U_BCFGA002("A410Cons")//Grava detalhes da rotina usada

/*Aadd( aButton, {"RELATORIO",{|| U_ExecLibPed()},"Liberacao","Liberacao" }) */
Aadd( aButton, { "RELATORIO",{|| U_PEDVEN()   }, "Imprime Pedido de Venda","Imp.P.V." })
Aadd( aButton, { "FORM"		,{|| U_A410VDESC()}, "Regras de Desconto","Descontos"	  })
aadd(aButton,  {"OPEN"		,{|| u_GDVHistMan("SC5")},"Hist.Cabec","Hist.Cabec"})
aadd(aButton,  {"OPEN"		,{|| u_GDVHistMan("SC6")},"Hist.Item","Hist.Item"})

// Vizualizacao
If Type("oListbox") == "O"
	// Daniel Pelegrinelli 17.11.05
	Aadd( aButton, { "PENDENTE"  , { || U_A410RES(oListbox:nat)}, "Relacao de Pedidos Reservado",	"Reserva"   })
Else
	// Daniel Pelegrinelli 17.11.05
	Aadd( aButton, { "PENDENTE"  , { || U_A410RES()}, "Relacao de Pedidos Reservado",	"Reserva"})
Endif

Return( aButton )
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A410VDESC ºAutor  ³ Jaime Wikanski     º Data ³  21/10/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Tela de visualizacao das regras de desconto do pedido de    º±±
±±º          ³venda                                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function A410VDESC(cPedido, cCliente, cLoja, cTipo, lExibe)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local nI       		:= 0
Local cTitulo  		:= OemToAnsi( "Regras de desconto do Pedido de Venda" )
Local nOpc     		:= 0
Local oVerde   		:= LoadBitMap(GetResources(),"BR_VERDE")
Local oVermelho		:= LoadBitMap(GetResources(),"BR_VERMELHO")
Local aTitulo  		:= {" ", "Item", "Codigo", "Produto", "Valor Total", "% Desc Praticado", "% Desc Classe", "% Desc Grupo", "% Desc Produto","% Desc Total X  Qde.Itens - PA5","% Desc Total - SZ8"}
Local oListBox
Local oSay
Local oDlg
Local bOk			:= { || nOpc := 1, oDlg:End()}
Local bNo			:= { || nOpc := 0, oDlg:End()}
Local aBotao		:= {}
Local aDados		:= {}
Local nPosItem		:= 0
Local nPosProd		:= 0
Local nPosDesc		:= 0
Local nPosValor		:= 0
Local nPosPDesc 	:= 0
Local nPosQtdEnt	:= 0
Local nPosQtdVen	:= 0
Local nPosPrUnit	:= 0
Local nMaxDesc		:= 0.00
Local nTotPed		:= 0.00
Local nDescClasse	:= 0.00
Local nDescGrupo 	:= 0.00
Local nDescProd		:= 0.00
Local nDescVlTot	:= 0.00
Local nDescQde		:= 0.00
Local nQdeItem		:= 0
Local cGrpVen		:= " "
Local nVlrPed		:= 0
Local cQry			:= ""
local aSuc          := {}
Default lExibe		:= .T.
Default cPedido		:= M->C5_NUM
Default cCliente	:= M->C5_CLIENTE
Default cLoja  		:= M->C5_LOJACLI
Default cTipo   	:= M->C5_TIPO

// Se a chamada for feita pela rotina de liberação de pedido não processa.
If AllTrim(FunName()) == "MATA440"
	Return(aDados)
EndIf

// Se a chamada for feita pela rotina de liberação de pedido schedulada, não processa
If AllTrim(FunName()) == "U_RFATM01"
	Return(aDados)
EndIf

// Pega as posições do header
nPosItem  := BuscaHeader(aHeader,"C6_ITEM")
nPosProd  := BuscaHeader(aHeader,"C6_PRODUTO")
nPosDesc  := BuscaHeader(aHeader,"C6_DESCRI")
nPosValor := BuscaHeader(aHeader,"C6_VALOR")
nPosPDesc := BuscaHeader(aHeader,"C6_DESCONT")
nPosQtdEnt:= BuscaHeader(aHeader,"C6_QTDENT")
nPosQtdVen:= BuscaHeader(aHeader,"C6_QTDVEN")
nPosPrUnit:= BuscaHeader(aHeader,"C6_PRUNIT")
nPosTES	  := BuscaHeader(aHeader,"C6_TES")

If cTipo $ "DB" .and. lExibe
	Aviso("Inconsistência", "Regras de desconto não permitida para esse tipo de pedido.",{"Ok"},,"Atenção:")
	Return(aDados)
Endif

if cCliente  $ GetMv("BR_000034")
	Return(aDados)
Endif

IF LEN(aCols) >= 1
	FOR I:= 1 TO LEN(aCols)
		IF aCols[I,nPosTES] $ '506*701*720*721*706'
			aAdd(aSuc, aCols[I,nPosTES])
		ENDIF
		
	NEXT
ENDIF

IF LEN(aSuc) >= 1
	Return(aDados)
Endif

//Criei uma funcao que chama este grande bloco de codigo abaixo comentado
aDados := RetSitBQL(cPedido, cCliente, cLoja, cTipo, lExibe)
/*
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Para visualizacao ou exclusao, recupera as informacoes gravada         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Inclui .and. !Altera
DbSelectArea("SC6")
DbSetOrder(1)
DbSeek(xFilial("SC6")+cPedido,.f.)
While !EOF() .and. SC6->C6_FILIAL+SC6->C6_NUM == xFilial("SC6")+cPedido
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Grava o array                                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Aadd(aDados, {	.F.,;							//[01] - Bloqueio?  .T. - Sim     .F. - N
SC6->C6_ITEM,;				//[02] - Item do Pedido
SC6->C6_PRODUTO,;			//[03] - Codigo do Produto
SC6->C6_DESCRI,;			//[04] - Descricao do produto
SC6->C6_VALOR,;			//[05] - Valor Total Item
SC6->C6_DESCONT,;			//[06] - Desconto concedido no item do pedido
SC6->C6_DSCCLAS,;			//[07] - Desconto da Classe
SC6->C6_DSCGRP,;			//[08] - Desconto do Grupo
SC6->C6_DSCPRD,;			//[09] - Desconto do produto
SC6->C6_DSCVLPV,;			//[10] - Desconto do Total do Pedido
0,;							//[11] -
SC6->C6_DSCQDE;			//[12] - Desconto por Total.Pedido x Nro Itens
})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza o flag de bloqueio                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nMaxDesc			:= aDados[Len(aDados),7]
nMaxDesc			:= Max(nMaxDesc,aDados[Len(aDados),8])
nMaxDesc			:= Max(nMaxDesc,aDados[Len(aDados),9])
nMaxDesc			:= Max(nMaxDesc,aDados[Len(aDados),10])
nMaxDesc			:= Max(nMaxDesc,aDados[Len(aDados),12])
If nMaxDesc < aDados[Len(aDados),6]
aDados[Len(aDados),1] := .T.
Endif

DbSelectArea("SC6")
DbSkip()
Enddo
Else

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Pesquisa o desconto do grupo                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nDescGrupo 		:= 0.00
DbSelectArea("SZD")
DbSetOrder(2)
If DbSeek(xFilial("SZD")+cCliente+cLoja,.F.)
DbSelectArea("SZC")
DbSetOrder(1)
If DbSeek(xfilial("SZC")+SZD->ZD_GRUPO,.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Pesquisa na tabela de faixas                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("SZ8")
DbSetOrder(1)
DbSeek(xFilial("SZ8"),.F.)
While !EOF() .and. SZ8->Z8_FILIAL == xFilial("SZ8")
If SZC->ZC_VALOR >= SZ8->Z8_FAIXA1 .and. SZC->ZC_VALOR <= SZ8->Z8_FAIXA2
nDescGrupo	:= SZ8->Z8_DESCONT
Exit
Endif
DbSelectArea("SZ8")
DbSkip()
Enddo

Endif
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Pesquisa a tabela de Regra por Quantidade de Itens do Pedido.          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SA1")
cGrpVen	:= GetAdvFVal( "SA1", "A1_GRPVEN", xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJAENT, 1, 0 )
aEval( aCols, { |x| nQdeItem += If(x[Len(aHeader)+1],0,1) } )
aEval( aCols, { |x| nVlrPed += Round(x[nPosQtdVen] * x[nPosPrUnit],2) } )
nVlrPed	:= Str(nVlrPed,14,2)
nQdeItem	:= Str(nQdeItem,6,0)
cQry	+= " SELECT *" 																						+ Chr(10)
cQry	+= " FROM "+RetSqlName("PA5")+" PA5" 											  				+ Chr(10)
cQry	+= " WHERE PA5.PA5_FILIAL = '"+xFilial("PA5")+"'" 											+ Chr(10)
cQry  += " AND (PA5.PA5_QDEINI <= "+nQdeItem+" AND PA5.PA5_QDEFIN >= "+nQdeItem+")" 	+ Chr(10)
cQry	+= " AND (PA5.PA5_GRPVEN = '*' OR PA5.PA5_GRPVEN = '"+cGrpVen+"')" 					+ Chr(10)
cQry	+= " AND (PA5.PA5_CODCLI = '*' OR PA5.PA5_CODCLI = '"+M->C5_CLIENTE+"')" 			+ Chr(10)
cQry	+= " AND (PA5.PA5_LOJCLI = '*' OR PA5.PA5_LOJCLI = '"+M->C5_LOJAENT+"')" 			+ Chr(10)
cQry  += " AND (PA5.PA5_VALINI <= "+nVlrPed+" AND PA5.PA5_VALOR >= "+nVlrPed+")	" 		+ Chr(10)
cQry	+= " AND PA5.D_E_L_E_T_ <> '*'" 																	+ Chr(10)
If Select("A410CONSA") > 0
dbSelectArea("A410CONSA")
dbCloseArea()
EndIf
MEMOWRITE("\QUERYSYS\A410CONSA.SQL",cQry)
TCQUERY cQry NEW ALIAS "A410CONSA"
dbSelectArea("A410CONSA")
While !Eof()
If A410CONSA->PA5_GRPVEN <> "*" .And. A410CONSA->PA5_GRPVEN <> cGrpVen
dbSkip()
Loop
EndIf
If A410CONSA->PA5_CODCLI <> "*" .And. A410CONSA->PA5_CODCLI <> M->C5_CLIENTE
dbSkip()
Loop
EndIf
If A410CONSA->PA5_LOJCLI <> "*" .And. A410CONSA->PA5_LOJCLI <> M->C5_LOJAENT
dbSkip()
Loop
EndIf
nDescQde	:= A410CONSA->PA5_PERDES
dbSkip()
EndDo
dbSelectArea("A410CONSA")
dbCloseArea()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gera o array com os dados a serem exibidos                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nI := 1 to Len(aCols)
If Len(aHeader) < Len(aCols[1])
If aCols[nI,Len(aHeader)+1] == .T.
Loop
Endif
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Calcula os descontos do item do pedido                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nTotPed			+= (aCols[nI,nPosQtdVen] * aCols[nI,nPosPrUnit])
nDescClasse		:= Iif(cTipo $ "DB", 0.00, Posicione("SA1",1,xFilial("SA1")+cCliente+cLoja,"A1_LIMDESC"))
nDescProd		:= Posicione("SB1",1,xFilial("SB1")+aCols[nI,nPosProd],"B1_MDESC")
nDescVlTot		:= 0.00

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Grava o array                                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Aadd(aDados, {	.F.,; 						//[01] - Bloqueio?  .T. - Sim     .F. - N
aCols[nI,nPosItem],;		//[02] - Item do Pedido
aCols[nI,nPosProd],;		//[03] - Codigo do Produto
aCols[nI,nPosDesc],;		//[04] - Descricao do produto
aCols[nI,nPosValor],;	//[05] - Valor Total Item
aCols[nI,nPosPDesc],; 	//[06] - Desconto concedido no item do pedido
nDescClasse,;				//[07] - Desconto da Classe
nDescGrupo,;				//[08] - Desconto do Grupo
nDescProd,;					//[09] - Desconto do produto
nDescVlTot,;				//[10] - Desconto do Total do Pedido
Iif(Inclui, aCols[nI,nPosQtdVen], aCols[nI,nPosQtdVen] - Posicione("SC6",1,xFilial("SC6")+cPedido+aCols[nI,nPosItem],"C6_QTDENT")),; //se for inclusao, retorna a quantidade vendida, senão, retorna a quantidade vendida MENOS  quantidade pendente
nDescQde;  					//[12] - Desconto por Total.Pedido x Nro Itens
})
Next nX

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Pesquisa o desconto pelo valor total do pedido                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nDescVlTot 		:= 0.00

DbSelectArea("SZ8")
DbSetOrder(1)
DbSeek(xFilial("SZ8"),.F.)
While !EOF() .and. SZ8->Z8_FILIAL == xFilial("SZ8")
If nTotPed >= SZ8->Z8_FAIXA1 .and. nTotPed <= SZ8->Z8_FAIXA2
nDescVlTot	:= SZ8->Z8_DESCONT
Exit
Endif
DbSelectArea("SZ8")
DbSkip()
Enddo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se o item esta bloqueado                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nI := 1 to Len(aDados)
aDados[nI,10] 	:= nDescVlTot
nMaxDesc			:= aDados[nI,7]
nMaxDesc			:= Max(nMaxDesc,aDados[nI,8])
nMaxDesc			:= Max(nMaxDesc,aDados[nI,9])
nMaxDesc			:= Max(nMaxDesc,aDados[nI,10])
//		nMaxDesc			:= Max(nMaxDesc,aDados[nI,12])

//Se não está bloquado pelas regras definidas anteriormente, verifica se o pedido nao ficara
//bloqueado por desconto superior `a regra "Total.Pedido x Nro.Itens"
If (nMaxDesc < aDados[nI,6] .and. aDados[nI,11] > 0) .Or.;
aDados[nI,6] > aDados[nI,12]
aDados[nI,1] := .T.
Endif
Next nX
Endif

*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a tela de selecao                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Len(aDados) > 0 .and. lExibe
	DEFINE MSDIALOG oDlg TITLE cTitulo From 000,000 To 300,700 OF oMainWnd  PIXEL
	@ 140,005 BITMAP oBmp RESNAME "BR_VERDE" SIZE 16,16 NOBORDER PIXEL
	@ 140,015 SAY "Item Sem Bloqueio"	OF oDlg PIXEL COLOR CLR_HBLUE
	@ 140,140 BITMAP oBmp RESNAME "BR_VERMELHO" SIZE 16,16 NOBORDER PIXEL
	@ 140,150 SAY "Item Com Desconto Superior" OF oDlg PIXEL COLOR CLR_HBLUE
	
	@ 015,005 LISTBOX oListBox VAR cListBox Fields ;
	HEADER  	          aTitulo[1],;		//" "
	OemtoAnsi(aTitulo[2]),;		//"Item"
	OemtoAnsi(aTitulo[3]),;		//"Codigo"
	OemtoAnsi(aTitulo[4]),;		//"Produto"
	OemtoAnsi(aTitulo[5]),;		//"Valor Total"
	OemtoAnsi(aTitulo[6]),;		//"% Desc Praticado"
	OemtoAnsi(aTitulo[7]),;		//"% Desc Classe"
	OemtoAnsi(aTitulo[8]),;		//"% Desc Grupo"
	OemtoAnsi(aTitulo[9]),;		//"% Desc Produto"
	OemtoAnsi(aTitulo[10]),;	//"% Desc Qde Itens"
	OemtoAnsi(aTitulo[11]) ;	//"% Desc Total x QdeItens"
	SIZE 343,119 NOSCROLL PIXEL
	
	oListBox:SetArray(aDados)
	oListBox:bLine := { || {	Iif(!aDados[oListBox:nAt,1],oVerde,oVermelho),;
	aDados[oListBox:nAt,2],;
	aDados[oListBox:nAt,3],;
	aDados[oListBox:nAt,4],;
	Transform(aDados[oListBox:nAt,5],"@E 999,999,999.99"),;
	Transform(aDados[oListBox:nAt,6],"@E 999.99"),;
	Transform(aDados[oListBox:nAt,7],"@E 999.99"),;
	Transform(aDados[oListBox:nAt,8],"@E 999.99"),;
	Transform(aDados[oListBox:nAt,9],"@E 999.99"),;
	Transform(aDados[oListBox:nAt,12],"@E 999.99"),;
	Transform(aDados[oListBox:nAt,10],"@E 999.99")}}
	
	ACTIVATE MSDIALOG oDlg CENTERED ON INIT Enchoicebar(oDlg, bOk, bNo,, aBotao)
Endif

If Len(aDados) <= 0 .and. lExibe
	Aviso("Inconsistência", "Regras de desconto não localizadas para esse pedido de venda.",{"Ok"},,"Atenção:")
EndIf

Return(aDados)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³BuscaHeader³ Autor ³Jaime Wikanski        ³ Data ³ 27/09/2004 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Pesquisa a posicao do campo no aheader                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function BuscaHeader(aArrayHeader,cCampo)

Return(AScan(aArrayHeader,{|aDados| AllTrim(Upper(aDados[2])) == Alltrim(Upper(cCampo))}))

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ExecLibPedºAutor  ³Evaldo V. Batista   º Data ³  11/06/2005 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cria Um Botao na EnchoiceBar para liberar o pedido para    º±±
±±º          ³ Faturamento                                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ExecLibPed()
Local aRegs := {}
Local cPerg	:= U_CriaPerg("LIBPED")
Local nPosAfat := aScan( aHeader, {|x| Upper(AllTrim(x[2])) == 'C6_APTOFAT'} )
Local lRepre := .F.
//Acerta Pergunte no SX1
Aadd( aRegs, {cPerg,"01","Tipo de Liberacao ?","Tipo de Liberacao ?","Tipo de Liberacao ?","MV_CH1","N",1,0,0,"C","","MV_PAR01","Libera Tudo","Libera Tudo","Libera Tudo","","","Bloqueia Tudo","Bloqueia Tudo","Bloqueia Tudo","","","Inverte Selecao","Inverte Selecao","Inverte Selecao","","","","","","","","","","","","","N","","","" } )
ValidPerg( aRegs, cPerg ) //Constroi o Pergunte se não existir

dbSelectArea("SA3")
dbSetOrder(7)
If DbSeek(xFilial("SA3")+__cUserId)
	IF A3_TIPO <> 'I'
		cCodRep := A3_COD
		lRepre  := .T.
	EndIf
ENDIF
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³C6_APTOFAT pode ser:         ³
//³1 = Liberado para Faturamento³
//³2 = Não Liberado             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF lRepre == .F.
	
	If Pergunte( cPerg, .T. )
		If Mv_Par01 == 1
			//Libera Tudo
			For _nA := 1 To Len( aCols )
				aCols[_nA, nPosAFat] := '1'
			Next _nA
		ElseIf Mv_Par01 == 2
			//Bloqueia Tudo
			For _nA := 1 To Len( aCols )
				aCols[_nA, nPosAFat] := '2'
			Next _nA
		ElseIf Mv_Par01 == 3
			//Inverte a Seleção
			For _nA := 1 To Len( aCols )
				aCols[_nA, nPosAFat] := If ( aCols[_nA, nPosAFat] == '1', '2', '1' )
			Next _nA
		EndIf
	EndIf
	//Tem de retornar o pergunte padrão do pedido senão vai dar erro na hora de gravar o pedido
	Pergunte( 'MTA410', .F. )
	
ELSE
	MSGBOX("Usuário sem Permissão !")
ENDIF

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A410RES   ºAutor  ³Daniel Pelegrinelli º Data ³  11/17/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relacao de Pedidos Liberados                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION A410RES()

LOCAL _aAreaAtu:= Getarea()
LOCAl _aAreaC6 := SC6->( Getarea() )
LOCAL nPosProd := aScan( aHeader, {|x| Upper(AllTrim(x[2])) == 'C6_PRODUTO'} )
LOCAL _cCod	   := ""
LOCAL _cList   := ""
LOCAL _nList   := 0
LOCAL _aList   := {}
LOCAL _nQuant  := 0
LOCAL _cQuant  := ""
LOCAL _cEntreg := ""
LOCAL oListBox1
LOCAL bLine
LOCAL _lReserv := .t.

If Type("olistbox") == "O"  // Vizualizacao
	_cCod:= aCols[oListBox:nat][nPosProd]
Else
	_cCod:= aCols[n,nPosProd]
Endif

cQryc9:= "SELECT * "
cQryc9+= "FROM "+RETSQLNAME("SC9")    + "  "
cQryc9+= "WHERE C9_PRODUTO = '"+_cCod + "' "
cQryc9+= "AND C9_FILIAL = '" + xFilial("SC6") + "' " //'"+SC6->C6_FILIAL+"' "
cQryc9+= "AND  SC9010.D_E_L_E_T_ <> '*' "
cQryc9+= "AND C9_NFISCAL = SPACE(9)     "
cQryc9+= "AND C9_BLCRED = SPACE(2)      "    
cQryc9+= "AND C9_BLEST = SPACE(2)       "
cQryc9+= "AND C9_LOTECTL <> SPACE(10)   "
cQryc9+= "ORDER BY C9_PEDIDO            "

cQryc9 := ChangeQuery(cQryc9)

DbUseArea( .T., 'TOPCONN', TcGenQry(,,cQryc9), "SC9X", .T., .T. )

SC9X->( DBGOTOP() )

IF SC9X->(EOF())
	
	Alert("Produto "+Alltrim(_cCod)+ " sem reserva na Filial "+xfilial("SC6")+" !!!", "Pedido sem Reserva")
	
	Restarea(_aAreaatu)
	Restarea(_aAreaC6)
	SC9X->(DBCLOSEAREA())
	
	Return
	
ELSE
	WHILE SC9X->( !EOF() )
		_cQuant := Transform(SC9X->C9_QTDLIB,"@E 999,999,999.99")
		///_cEntreg:= Substr(SC9X->C9_ENTREG,7,2)+"/"+substr(SC9X->C9_ENTREG,5,2)+"/"+substr(SC9X->C9_ENTREG,3,2)
		
		AADD( _aList, {SC9X->C9_PEDIDO, SC9X->C9_Cliente,  _cQuant } )
		
		_nQuant:= _nQuant + SC9X->C9_QTDLIB
		
		DBSKIP()
	ENDDO
ENDIF

SC9X->( DBCLOSEAREA() )

_cQuant := Transform(_nQuant,"@E 999,999,999.99")

DEFINE FONT oFont NAME "Arial" SIZE 0,-12 BOLD
DEFINE MSDIALOG oDlg FROM 096,042 TO 400,600 TITLE "Pedidos Empenhados " PIXEL
@ 11,3 To 113,264 Title OemToAnsi(" Produto "+ _cCod+"   ")
@ 130,11 Say OemToAnsi("Quantidade:  " + _cQuant) Size 300,8 OF oDlg PIXEL COLOR CLR_HBLUE
@ 020,005 LISTBOX oListBox1 VAR cListBox1 Fields HEADER ;
OEMTOANSI("PEDIDO"),;
OEMTOANSI("CLIENTE"),;
OEMTOANSI("QUANTIDADE"),;
OEMTOANSI("ENTREGA") ;
FIELDSIZES ;
GetTextWidth(0,"BBBBBBBB"),;
GetTextWidth(0,"BBBBBBBB"),;
GetTextWidth(0,"BBBBBBBB"),;
GetTextWidth(0,"BBBBBBBB");
SIZE 240,080 NOSCROLL PIXEL
oListBox1:SetArray(_aList)
oListBox1:bLine 		:= {|| {_aList[oListBox1:nAt,1],;
_aList[oListBox1:nAt,2],;
_aList[oListBox1:nAt,3]}}
//_aList[oListBox1:nAt,4] }}
//oListBox1:bChange 		:= {|| RESTC02b(_aList,@aList2,@aList3,oListBox1,@oListBox2,@oListbox3,lBloq,cLocal,@oDlgABro) }
//oListBox1:blDblClick 	:= {|| RESTC02c(_aList,oListBox1:nAt,@lRetorno,cChamada,oDlgABro)}
//oListBox1:cToolTip		:= "Duplo click para retornar o código do produto"
oListBox1:Refresh()
@ 128,229 BmpButton Type 1 Action  (oDlg:End())
ACTIVATE DIALOG oDlg CENTERED

Restarea(_aAreaatu)
Restarea(_aAreaC6)

RETURN()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RetSitBlq ºAutor  ³Microsiga           º Data ³  25/08/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Coloquei funcao de visualizar o status de bloqueio aqui     º±±
±±º          ³porque estava dando algumas diferencas quando o botao era   º±±
±±º          ³ativado na visualizacao ou na entrada do pedido para altera-º±±
±±º          ³cao. Tambem para maior facilidade na manutencao.            º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RetSitBQL( cPedido, cCliente, cLoja, cTipo, lExibe )
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local nI       		:= 0
Local aDados		:= {}
Local nPosItem		:= 0
Local nPosProd		:= 0
Local nPosDesc		:= 0
Local nPosValor		:= 0
Local nPosPDesc 	:= 0
Local nPosQtdEnt	:= 0
Local nPosQtdVen	:= 0
Local nPosPrUnit	:= 0
Local nMaxDesc		:= 0.00
Local nTotPed		:= 0.00
Local nDescClasse	:= 0.00
Local nDescGrupo 	:= 0.00
Local nDescProd		:= 0.00
Local nDescVlTot	:= 0.00
Local nDescQde		:= 0.00
Local nQdeItem		:= 0
Local cGrpVen		:= " "
Local nVlrPed		:= 0
Local cQry			:= ""

Local cTabela		:= GETMV('BR_000090') // tabela de preco praticada exportação
Local cGRPTRIB		:= CriaVar('A1_GRPTRIB', .T. )

Default lExibe		:= .T.
Default cPedido		:= M->C5_NUM
Default cCliente	:= M->C5_CLIENTE
Default cLoja  		:= M->C5_LOJACLI
Default cTipo   	:= M->C5_TIPO

// Pega as posições do header
nPosItem			:= BuscaHeader(aHeader,"C6_ITEM"   )
nPosProd			:= BuscaHeader(aHeader,"C6_PRODUTO")
nPosDesc			:= BuscaHeader(aHeader,"C6_DESCRI" )
nPosValor			:= BuscaHeader(aHeader,"C6_VALOR"  )
nPosPDesc 			:= BuscaHeader(aHeader,"C6_DESCONT")
nPosQtdEnt			:= BuscaHeader(aHeader,"C6_QTDENT" )
nPosQtdVen			:= BuscaHeader(aHeader,"C6_QTDVEN" )
nPosPrUnit			:= BuscaHeader(aHeader,"C6_PRUNIT" )
nResiduo 			:= BuscaHeader(aHeader,"C6_BLQ"    )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Pesquisa o desconto do grupo                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nDescGrupo			:= 0.00

DbSelectArea("SZD")
DbSetOrder(2)

If DbSeek( xFilial("SZD") + cCliente+cLoja, .F. )

	DbSelectArea("SZC")
	DbSetOrder(1)
	
	If DbSeek( xFilial("SZC") + SZD->ZD_GRUPO, .F. )
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Pesquisa na tabela de faixas                                           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DbSelectArea("SZ8")
		DbSetOrder(1)
		
		DbSeek( xFilial("SZ8"), .F. )
		
		While !EOF() .and. SZ8->Z8_FILIAL == xFilial("SZ8")
	
			If SZC->ZC_VALOR >= SZ8->Z8_FAIXA1 .and. SZC->ZC_VALOR <= SZ8->Z8_FAIXA2
				nDescGrupo	:= SZ8->Z8_DESCONT
				Exit
			Endif
			
			DbSelectArea("SZ8")
			DbSkip()
		Enddo
		
	Endif
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Pesquisa a tabela de Regra por Quantidade de Itens do Pedido.          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("SA1")

cGrpVen := GetAdvFVal( "SA1", "A1_GRPVEN", xFilial("SA1") + M->C5_CLIENTE + M->C5_LOJAENT, 1, 0 )
cGRPTRIB:= Posicione( "SA1", 1, xFilial("SA1") + M->C5_CLIENTE + M->C5_LOJAENT, "A1_GRPTRIB" )
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Obtem os valores resumidos da quantidade de itens, e o total de cada item, diretamente do aCols  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aResumo := {}
lInseriu:= .F.

For nx:=1 To len(aCols)
	//Somente verifica se a linha do Acols esta deletada quando
	If Inclui .Or. Altera
		If Len( aHeader ) < Len( aCols[1] )
			If aCols[ nx, Len( aHeader ) + 1 ] == .T.
				Loop
			Endif
		Endif
	EndIf
	
	For ny:= 1 To Len( aResumo )
		If aCols[ nx, nPosProd ] == aResumo[ ny, 01 ]
			aResumo[ ny, 02 ]    += aCols[ nx, nPosValor ]
			lInseriu:= .T.
			Exit
		EndIf
	Next
	
	If !lInseriu
		AADD( aResumo, { aCols[ nx, nPosProd ], aCols[ nx, nPosValor ] } )
	EndIf
	lInseriu:= .F.
Next

For nx:= 1 To Len( aResumo )
	nQdeItem++
	nVlrPed += aResumo[ nx, 02 ]
Next

nVlrPed	:= Str( nVlrPed , 14, 2 )
nQdeItem:= Str( nQdeItem,  6, 0 )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Obtem os valores de desconto por regra da tabela pa5, que poderiam ser concedidos                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQry+= " SELECT *" 																			+ Chr(10)
cQry+= " FROM " + RetSqlName("PA5") + " PA5" 											  	+ Chr(10)
cQry+= " WHERE PA5.PA5_FILIAL = '" + xFilial("PA5") + "'" 									+ Chr(10)
cQry+= " AND (PA5.PA5_QDEINI <=  " + nQdeItem + " AND PA5.PA5_QDEFIN >= " + nQdeItem+")" 	+ Chr(10)
cQry+= " AND (PA5.PA5_GRPVEN = '*' OR PA5.PA5_GRPVEN = '" + cGrpVen       + "')" 			+ Chr(10)
cQry+= " AND (PA5.PA5_CODCLI = '*' OR PA5.PA5_CODCLI = '" + M->C5_CLIENTE + "')" 			+ Chr(10)
cQry+= " AND (PA5.PA5_LOJCLI = '*' OR PA5.PA5_LOJCLI = '" + M->C5_LOJAENT + "')" 			+ Chr(10)
cQry+= " AND (PA5.PA5_VALINI <= " + nVlrPed + " AND PA5.PA5_VALOR >= " + nVlrPed +  ")	" 	+ Chr(10)
cQry+= " AND PA5.D_E_L_E_T_ <> '*'" 														+ Chr(10)

If Select( "A410CONSA" ) > 0
	DbSelectArea("A410CONSA")
	DbCloseArea()
EndIf

//MEMOWRITE( "\QUERYSYS\A410CONSA.SQL", cQry )
TCQUERY cQry NEW ALIAS "A410CONSA"

DbSelectArea("A410CONSA")

While !Eof()
	If A410CONSA->PA5_GRPVEN <> "*" .And. A410CONSA->PA5_GRPVEN <> cGrpVen
		dbSkip()
		Loop
	EndIf
	If A410CONSA->PA5_CODCLI <> "*" .And. A410CONSA->PA5_CODCLI <> M->C5_CLIENTE
		dbSkip()
		Loop
	EndIf
	If A410CONSA->PA5_LOJCLI <> "*" .And. A410CONSA->PA5_LOJCLI <> M->C5_LOJAENT
		dbSkip()
		Loop
	EndIf
	
	nDescQde:= A410CONSA->PA5_PERDES
	DbSkip()
EndDo

DbSelectArea("A410CONSA")
DbCloseArea()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gera o array com os dados a serem exibidos                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nI := 1 to Len(aCols)
	
	//Somente verifica se a linha do Acols esta deletada quando
	If Inclui .Or. Altera
		If Len(aHeader) < Len(aCols[1])
			If aCols[nI,Len(aHeader)+1] == .T.
				Loop
			Endif
		Endif
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Calcula os descontos do item do pedido                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nTotPed		+= ( aCols[nI, nPosQtdVen] * aCols[nI, nPosPrUnit] )
	nDescClasse	:= Iif( cTipo $ "DB", 0.00, Posicione("SA1", 1, xFilial("SA1") + cCliente+cLoja, "A1_LIMDESC") )
	nDescProd	:= Posicione( "SB1", 1, xFilial("SB1") + aCols[nI,nPosProd], "B1_MDESC" )
	nDescVlTot	:= 0.00
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Grava o array                                                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Aadd(aDados, {	.F.,; 				//[01] - Bloqueio?  .T. - Sim     .F. - N
				aCols[nI, nPosItem ],;	//[02] - Item do Pedido
				aCols[nI, nPosProd ],;	//[03] - Codigo do Produto
				aCols[nI, nPosDesc ],;	//[04] - Descricao do produto
				aCols[nI, nPosValor],;	//[05] - Valor Total Item
				aCols[nI, nPosPDesc],; 	//[06] - Desconto concedido no item do pedido
				nDescClasse,;			//[07] - Desconto da Classe
				nDescGrupo ,;			//[08] - Desconto do Grupo
				nDescProd  ,;			//[09] - Desconto do produto
				nDescVlTot ,;			//[10] - Desconto do Total do Pedido
				Iif(Inclui, aCols[nI,nPosQtdVen], aCols[nI,nPosQtdVen] - Posicione("SC6", 1, xFilial("SC6") + cPedido + aCols[nI,nPosItem], "C6_QTDENT" ) ),; //se for inclusao, retorna a quantidade vendida, senão, retorna a quantidade vendida MENOS  quantidade pendente
				nDescQde;  				//[12] - Desconto por Total.Pedido x Nro Itens
								})
Next nX

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Pesquisa o desconto pelo valor total do pedido                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nDescVlTot:= 0.00

DbSelectArea("SZ8")
DbSetOrder(1)

DbSeek(xFilial("SZ8"),.F.)

While !EOF() .And. SZ8->Z8_FILIAL == xFilial("SZ8")
	If nTotPed >= SZ8->Z8_FAIXA1 .and. nTotPed <= SZ8->Z8_FAIXA2
		nDescVlTot:= SZ8->Z8_DESCONT
		Exit
	Endif
	
	DbSelectArea("SZ8")
	DbSkip()
Enddo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se o item esta bloqueado                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nI := 1 to Len(aDados)
	aDados[nI,10]:= nDescVlTot
	nMaxDesc	 := aDados[ nI,7 ]
	nMaxDesc	 := Max(nMaxDesc,aDados[ nI, 08 ])
	nMaxDesc	 := Max(nMaxDesc,aDados[ nI, 09 ])
	nMaxDesc	 := Max(nMaxDesc,aDados[ nI, 10 ])
	nMaxDesc	 := max(nMaxDesc,aDados[ nI, 12 ])
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Nao considera itens que foram elimidados por residuo ou com saldo zerado          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//	If !AllTrim(aCols[nI,nResiduo]) == 'R' .And. aDados[nI,11] > 0
	
	If nResiduo = 0
		
		IF aDados[ nI, 11 ] > 0
			
			If nMaxDesc < aDados[ nI, 6 ]      			// Se o desconto concedido for maior que o maximo permitido
				aDados[ nI, 1 ] := .T.  				// item estara BLOQUEADO
			EndIf
			
			If M->C5_AMOSTRA $ '1/S'
				aDados[ nI, 1 ] := .T.  				// item estara BLOQUEADO
			EndIf
			
			If M->C5_AMOSTRA $ '5'
				aDados[ nI, 1 ] := .T.  				// item estara BLOQUEADO
			EndIf
			
			
			If !aDados[ nI, 1 ]              .And.; 	// Se ainda nao estiver bloqueado
				nTotPed < GetMV("BR_000008") .And.;		// E o total do pedido for menor que o minimo permitido
				M->C5_AMOSTRA$"2/N"          .And.;		// E não for pedido de amostra
				M->C5_TIPO=='N'							// E for pedido normal -> saidas para clientes
				aDados[ nI, 1 ] := .T.					// O pedido estara BLOQUEADO
			EndIf
			
		EndIf
		
	Else
		
		If ( If( !Inclui, !AllTrim( aCols[ nI, nResiduo ] ) == 'R', .T. )) .And. aDados[ nI, 11 ] > 0
			
			If nMaxDesc < aDados[ nI, 6 ]      			// se o desconto concedido for maior que o maximo permitido
				aDados[ nI, 1 ] := .T.  				// item estara BLOQUEADO
			EndIf
			
			If M->C5_AMOSTRA $ '1/S'
				aDados[ nI, 1 ] := .T.  				// item estara BLOQUEADO
			EndIf
			
			If M->C5_AMOSTRA $ '5'
				aDados[ nI, 1 ] := .T.  				// item estara BLOQUEADO
			EndIf
			
			If !aDados[nI,1] .And.; 					// Se ainda nao estiver bloqueado
				nTotPed < GetMV("BR_000008") .And.;		// E o total do pedido for menor que o minimo permitido
				M->C5_AMOSTRA$"2/N" .And.;				// E não for pedido de amostra
				M->C5_TIPO=='N'							// E for pedido normal -> saidas para clientes
				aDados[ nI, 1 ] := .T.					// o pedido estara BLOQUEADO
			EndIf
			
		EndIf
		
	EndIf
	
	// Pedidos de exportação
	If (( AllTrim( M->C5_TABELA ) $ AllTrim( cTABELA ) ) .And. ( M->C5_GRPVEN $ '000050-000051'  )) .Or. AllTrim( cGRPTRIB ) == '108'
		aDados[ nI, 1 ] := .T.							// o pedido estara BLOQUEADO
		C5_XBLQ:= '3'
	EndIf	
Next nX

Return( aDados )
