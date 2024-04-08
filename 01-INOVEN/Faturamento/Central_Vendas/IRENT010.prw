#INCLUDE "PROTHEUS.CH"
#INCLUDE 'FWMVCDEF.CH'
//---------------------------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc} IRENT020
@author SERGIO
@since 22/06/2015
@version 1.0
/*/
//---------------------------------------------------------------------------------------------------------------------------------
//DESENVOLVIDO POR INOVEN


User Function IRENT010(cNumOrc,nMargem)

	Local aCoors 	:= FWGetDialogSize( oMainWnd )

	Local nPos3   	:= 0
	Local nPos4   	:= 0


	Private aButtons	:=	{}

	Private oDlgPrinc,oFWLayer,oPanelUpLeft,oPanelUpRight,oPanelDnLeft
	Private oCbTipo,oPedido,oBjMargens,oBjLista3,oNumero,oPanel1,oCliente,oNomCli,oEmissao,oVend,oNomVed,oPgto,oNomPgto,oFrete,oDespesa,oTotPP,oTotPL
	Private oCidade, oTransp
	Private cCbTipo 	:= ""
	Private aCbTipo 	:= {}
	Private cCFrete     := ""
	Private aCFrete     := {}
	Private cCusto      := ""
	Private aCusto      := {}
	Private cPedido 	:= space(6)
	Private aMargens 	:= {}
	Private aVetPnl3	:= {}
	Private cNumero	:= ""
	Private cCliente	:= ""
	Private cNomCli	:= ""
	Private dEmissao	:= ctod("")
	Private cVend		:= ""
	Private cNomVed	:= ""
	Private cPgto		:= ""
	Private cNomPgto	:= ""
	Private nFrete		:= 0
	Private nFretePL	:= 0
	Private nDespesa	:= 0
	Private nDespesaPL	:= 0
	Private nTotPP		:= 0
	Private nTotPL		:= 0
	Private cTipCli	:= ""
	Private cLojaCli	:= ""
	Private cData       := ""
	Private cCodProd    := ""
	Private cProdQry    := ""
	Private aProdQry    := {}
	Private cFilQry     := "" 
	Private cPTDD4      := GetMV("LI_PCTTD7",.F.,0)  
	Private cPTDD7      := GetMV("LI_PCTTD4",.F.,0)
	Private cPTDD12     := GetMV("LI_PCTTD12",.F.,0)
	Private cPTPLO4     := GetMV("LI_PCPLO4",.F.,0)
	Private cPTPLO7     := GetMV("LI_PCPLO7",.F.,0)
	Private cPTPLO12    := GetMV("LI_PCPLO12",.F.,0)
	Private cCidade		:= ""
	Private cTransp		:= ""
	
	Default cNumOrc := ""
	Default nMargem	:= 0
	
	
	DEFINE FONT oFont01  NAME "Arial" SIZE 0,15  BOLD

	aadd(aCbTipo, "1 - Orçamentos " )
	aadd(aCbTipo, "2 - Pedidos    " )
	
	aadd(aCFrete, "1 - Sim" )
	aadd(aCFrete, "2 - Não" )
	
	aadd(aCusto, "1 - Médio" )
	aadd(aCusto, "2 - Reposição" )

	if Empty(cNumOrc)
		
		Carga(2) 
		Carga(3) 

		Define MsDialog oDlgPrinc Title 'Margens de Contribuição' From aCoors[1], aCoors[2] To aCoors[3], aCoors[4] Pixel

		oFWLayer := FWLayer():New()
		oFWLayer:Init( oDlgPrinc, .F., .T. )

	//
	// Define Painel Superior
	//
		oFWLayer:AddLine( 'UP', 50, .F. )
		oFWLayer:AddCollumn( 'LEFT' , 50, .T., 'UP' )
		oFWLayer:AddCollumn( 'RIGHT', 50, .T., 'UP' )
		oFWLayer:AddWindow( "LEFT" , "Win01", "Calcular Frete ?", 100, .F., .T., ,'UP',)
		oFWLayer:AddWindow( "RIGHT", "Win02", "Margens", 100, .F., .T., ,'UP',)
		oPanelUpLeft  := oFWLayer:GetColPanel( 'LEFT', 'UP' )
		oPanelUpRight := oFWLayer:GetColPanel( 'RIGHT', 'UP' )

		//Painel da pesquisa
		
		@ 05, 50 MSCOMBOBOX oCFrete VAR cCFrete ITEMS aCFrete SIZE 40, 40 PIXEL OF oPanelUpLeft
		
		@ 05, 130 MSCOMBOBOX oCusto VAR cCusto ITEMS aCusto SIZE 50, 50 PIXEL OF oPanelUpLeft
		@ 05, 100 SAY "Custo ?" SIZE 50,50 PIXEL OF oPanelUpLeft FONT oFont01
		
		@ 05, 245 MSCOMBOBOX oCbTipo VAR cCbTipo ITEMS aCbTipo SIZE 53, 53 OF oPanelUpLeft PIXEL ON CHANGE (fTrocaF3(cCbTipo))
		@ 05, 300 MSGET oPedido var cPedido		SIZE 040,7 WHEN .T. F3 "SUA" VALID( FWMsgRun(,{|| BuscaDados(cCbTipo,cPedido) }, "Aguarde...", "Localizando Orçamento..."))  PIXEL OF oPanelUpLeft
		
		//===================================================================================================================================================
		//PAINEL 1. Dados
		//===================================================================================================================================================
		
		nPos3 	:= (oPanelUpLeft:nHeight / 2)-25
		nPos4  	:= (oPanelUpLeft:nRight /2)-10
		oPanel1 := tPanel():New(20,05,"",oPanelUpLeft,,,,,,nPos4-1,nPos3-1,.t.,.t.)


		@ 11, 10 SAY "Número :"	SIZE 70,7 PIXEL OF oPanel1 FONT oFont01 
		@ 10, 50 MSGET oNumero var cPedido SIZE 040,7  WHEN .F.  PIXEL OF oPanel1

		@ 11, 180 SAY "Emissão :"	SIZE 70,7 PIXEL OF oPanel1 FONT oFont01 
		@ 10, 230 MSGET oEmissao var dEmissao SIZE 060,7  WHEN .F.  PIXEL OF oPanel1

		@ 26, 10  SAY "Cliente :" SIZE 70,7 PIXEL OF oPanel1 FONT oFont01 
		@ 25, 50  MSGET oCliente var cCliente SIZE 040,7  WHEN .F.  PIXEL OF oPanel1
		@ 25, 100 MSGET oNomCli var cNomCli SIZE 190,7  WHEN .F.  PIXEL OF oPanel1

		@ 41, 10  SAY "Vendedor :" SIZE 70,7 PIXEL OF oPanel1 FONT oFont01 
		@ 40, 50  MSGET oVend var cVend SIZE 040,7  WHEN .F.  PIXEL OF oPanel1
		@ 40, 100 MSGET oNomVed var cNomVed SIZE 190,7  WHEN .F.  PIXEL OF oPanel1

		@ 56, 10  SAY "Cond.Pgto :" SIZE 70,7 PIXEL OF oPanel1 FONT oFont01 
		@ 55, 50  MSGET oPgto var cPgto SIZE 040,7  WHEN .F.  PIXEL OF oPanel1
		@ 55, 100 MSGET oNomPgto var cNomPgto SIZE 190,7  WHEN .F.  PIXEL OF oPanel1

		@ 71, 10  SAY "Frete PP :" SIZE 70,7 PIXEL OF oPanel1 FONT oFont01 
		@ 70, 50  MSGET oFrete var nFrete picture "@E 999,999.99" SIZE 060,7  WHEN .F.  PIXEL OF oPanel1

		@ 86, 10  SAY "Frete PL :" SIZE 70,7 PIXEL OF oPanel1 FONT oFont01 
		@ 85, 50  MSGET oFrete var nFretePL picture "@E 999,999.99" SIZE 060,7  WHEN .F.  PIXEL OF oPanel1
		
		@ 71, 180  SAY "Despesas PP :" SIZE 70,7 PIXEL OF oPanel1 FONT oFont01 
		@ 70, 230  MSGET oDespesa var nDespesa picture "@E 999,999.99" SIZE 060,7  WHEN .F.  PIXEL OF oPanel1

		@ 86, 180  SAY "Despesas PL :" SIZE 70,7 PIXEL OF oPanel1 FONT oFont01 
		@ 85, 230  MSGET oDespesa var nDespesaPL picture "@E 999,999.99" SIZE 060,7  WHEN .F.  PIXEL OF oPanel1
		
		@ 101, 10  SAY "Total PP :" SIZE 70,7 PIXEL OF oPanel1 FONT oFont01 
		@ 100, 50  MSGET oTotPP var nTotPP picture "@E 999,999,999.99" SIZE 080,7  WHEN .F.  PIXEL OF oPanel1
	 
		@ 116, 10  SAY "Total PL :" SIZE 70,7 PIXEL OF oPanel1 FONT oFont01 
		@ 115, 50  MSGET oTotPl var nTotPL picture "@E 999,999,999.99" SIZE 080,7  WHEN .F.  PIXEL OF oPanel1
		
		@ 131, 10  SAY "Cidade/UF:" SIZE 70,7 PIXEL OF oPanel1 FONT oFont01 
		@ 130, 50  MSGET oCidade var cCidade SIZE 080,7  WHEN .F.  PIXEL OF oPanel1

		@ 131, 135  SAY "Transp:" SIZE 70,7 PIXEL OF oPanel1 FONT oFont01 
		@ 130, 165  MSGET oTransp var cTransp SIZE 190,7  WHEN .F.  PIXEL OF oPanel1

		
		//===================================================================================================================================================
		//PAINEL 2.Margens
		//===================================================================================================================================================
		oBjMargens := TCBrowse():New( 020,005,(oPanelUpRight:nRight / 2)-7,(oPanelUpRight:nHeight / 2)-20,,{},{},oPanelUpRight,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )
		
		oBjMargens:SetArray(aMargens)
		oBjMargens:AddColumn( TCColumn():New("Margem  " ,{ || aMargens[oBjMargens:nAt,1]},"@!"        ,,,"LEFT"  ,100,.F.,.T.,,,,.F.,) )
		oBjMargens:AddColumn( TCColumn():New("PL %    " ,{ || aMargens[oBjMargens:nAt,2]},"@# 999.99 %" ,,,"CENTER",035,.F.,.T.,,,,.F.,) )
		oBjMargens:AddColumn( TCColumn():New("PP %    " ,{ || aMargens[oBjMargens:nAt,3]},"@# 999.99 %" ,,,"CENTER",035,.F.,.T.,,,,.F.,) )
		//oBjMargens:AddColumn( TCColumn():New("PE %    " ,{ || aMargens[oBjMargens:nAt,4]},"@# 999.99 %" ,,,"CENTER",035,.F.,.T.,,,,.F.,) )

		//tela detalhes da margem
		oBjMargens:blDblClick := {|| fGoWinMar(cCbTipo,cPedido) } 

		oBjMargens:Refresh()


	// Painel Inferior
	//
		oFWLayer:AddLine( 'DOWN', 50, .F. )
		oFWLayer:AddCollumn( 'LEFT'   , 100, .T., 'DOWN' )
		oFWLayer:AddWindow( "LEFT" , "Win03", "Itens "   , 100, .F., .T., ,'DOWN',)
		oPanelDnLeft		:= oFWLayer:GetColPanel( 'LEFT'   , 'DOWN' )


		//===================================================================================================================================================
		//PAINEL 3.Itens do Pedido de venda(SC6) ou Orçamentos 																					|
		//===================================================================================================================================================

		oBjLista3 := TwBrowse():New(20,5,(oPanelDnLeft:nRight / 2)-7,(oPanelDnLeft:nHeight / 2)-35,,{},,oPanelDnLeft,,,,,,,,,,,,.T.,,.T.,,.F.,,,,.T.,.T.)
		oBjLista3:SetArray(aVetPnl3)
		oBjLista3:AddColumn( TCColumn():New("Item"        ,{ || aVetPnl3[oBjLista3:nAt,1]},"@!"                ,,,"LEFT"  ,20,.F.,.T.,,,,.F.,) )
		oBjLista3:AddColumn( TCColumn():New("Produto"     ,{ || aVetPnl3[oBjLista3:nAt,2]},"@!"                ,,,"LEFT"  ,40,.F.,.T.,,,,.F.,) )
		oBjLista3:AddColumn( TCColumn():New("Descrição"   ,{ || aVetPnl3[oBjLista3:nAt,3]},"@!"                ,,,"LEFT"  ,150,.F.,.T.,,,,.F.,) )
		oBjLista3:AddColumn( TCColumn():New("Quantidade"  ,{ || aVetPnl3[oBjLista3:nAt,4]},"@E 99,999,999.99"  ,,,"CENTER",60,.F.,.T.,,,,.F.,) )
		oBjLista3:AddColumn( TCColumn():New("Preço PL R$" ,{ || aVetPnl3[oBjLista3:nAt,5]},"@E 99,999,999.99"  ,,,"CENTER",60,.F.,.T.,,,,.F.,) )
		oBjLista3:AddColumn( TCColumn():New("Total PL R$" ,{ || aVetPnl3[oBjLista3:nAt,6]},"@E 99,999,999.99"  ,,,"CENTER",60,.F.,.T.,,,,.F.,) )
		oBjLista3:AddColumn( TCColumn():New("Margem PL %" ,{ || aVetPnl3[oBjLista3:nAt,7]},"@# 999.99 %"       ,,,"CENTER",60,.F.,.T.,,,,.F.,) )
		oBjLista3:AddColumn( TCColumn():New("Preço PP R$" ,{ || aVetPnl3[oBjLista3:nAt,8]},"@E 99,999,999.99"  ,,,"CENTER",60,.F.,.T.,,,,.F.,) )
		oBjLista3:AddColumn( TCColumn():New("Total PP R$" ,{ || aVetPnl3[oBjLista3:nAt,9]},"@E 99,999,999.99"  ,,,"CENTER",60,.F.,.T.,,,,.F.,) )
		oBjLista3:AddColumn( TCColumn():New("Margem PP %" ,{ || aVetPnl3[oBjLista3:nAt,10]},"@# 999.99 %"      ,,,"CENTER",60,.F.,.T.,,,,.F.,) )
		//oBjLista3:AddColumn( TCColumn():New("Preço PE R$" ,{ || aVetPnl3[oBjLista3:nAt,11]},"@E 99,999,999.99"  ,,,"CENTER",60,.F.,.T.,,,,.F.,) )
		//oBjLista3:AddColumn( TCColumn():New("Margem PE %" ,{ || aVetPnl3[oBjLista3:nAt,12]},"@# 999.99 %"      ,,,"CENTER",60,.F.,.T.,,,,.F.,) )
		oBjLista3:AddColumn( TCColumn():New("Custo R$"    ,{ || aVetPnl3[oBjLista3:nAt,13]},"@E 99,999,999.99" ,,,"CENTER",60,.F.,.T.,,,,.F.,) )
		oBjLista3:AddColumn( TCColumn():New("ImpPP R$" 	  ,{ || aVetPnl3[oBjLista3:nAt,14]},"@E 99,999,999.99" ,,,"CENTER",60,.F.,.T.,,,,.F.,) )
		oBjLista3:AddColumn( TCColumn():New("RegEspPP R$"   ,{ || aVetPnl3[oBjLista3:nAt,38]},"@E 99,999,999.99" ,,,"CENTER",60,.F.,.T.,,,,.F.,) )
		oBjLista3:AddColumn( TCColumn():New("ImpPL R$"    ,{ || aVetPnl3[oBjLista3:nAt,18]},"@E 99,999,999.99" ,,,"CENTER",60,.F.,.T.,,,,.F.,) )
		oBjLista3:AddColumn( TCColumn():New("RegEspPL R$"    ,{ || aVetPnl3[oBjLista3:nAt,39]},"@E 99,999,999.99" ,,,"CENTER",60,.F.,.T.,,,,.F.,) )
		oBjLista3:AddColumn( TCColumn():New("FretePP/DespesaPP R$" ,{ || aVetPnl3[oBjLista3:nAt,15]},"@E 99,999,999.99" ,,,"CENTER",60,.F.,.T.,,,,.F.,) )
		oBjLista3:AddColumn( TCColumn():New("FretePL/DespesaPL R$" ,{ || aVetPnl3[oBjLista3:nAt,32]},"@E 99,999,999.99" ,,,"CENTER",60,.F.,.T.,,,,.F.,) )
		oBjLista3:AddColumn( TCColumn():New("Desconto"   ,{ || aVetPnl3[oBjLista3:nAt,40]},"@E 999.99"                ,,,"CENTER"  ,30,.F.,.T.,,,,.F.,) )

		oBjLista3:blDblClick := {|| fEditCell() } 

		oBjLista3:Refresh()

		

		ACTIVATE MSDIALOG oDlgPrinc ON INIT EnchoiceBar(oDlgPrinc,{|| nOpca := 2, oDlgPrinc:End()}, {|| nOpca := 1,oDlgPrinc:End()},,aButtons)
	else
		//BuscaDados("1",cNumOrc,.T., @nMargem)
		BuscaDados("2",cNumOrc,.T., @nMargem)
	endif

Return


//===============================================|
//ROTINA PARA REINICIAR AS VARIAVES DO LISTBOX   |
//===============================================|
STATIC FUNCTION Carga(cPnl)
	
	If cPnl == 2


		aMargens := {}
		AADD( aMargens , {space(20),0,0,0,''} )


	ElseIf cPnl == 3

		aVetPnl3 := {}
		AADD( aVetPnl3 , {"",;
						  "",;
						  "",;
						  0,;
						  0,;	
						  0,;
						  0,;
						  0,;
						  0,;
						  0,;
						  0,;
						  0,;
						  0,;
						  0,;
						  0,;
						  "","",;
						  0,;
						  0,;
						  0,;
						  0,;
						  0,;
						  0,;
						  0,;
						  0,;
						  0,;
						  0,;
						  0,;
						  0,;
						  0,;
						  0,;
						  0,;
						  0,;
						  0,;
						  0,;
						  0,;
						  0,;
						  0,;
		                   0,;
						   0,;
							0})

	EndIf
	
	
Return


Static Function fTrocaF3(wTipo)

	Local cF3 := ""

	LimpaDados()
	
	If left(wTipo,1) = "1"
		cF3 := "SUA"
	Else
		cF3 := "SC5"
	EndIf

	oPedido:CF3 := cF3
	oPedido:Refresh()

Return


Static Function BuscaDados(cCbTipo,wPedido,lSilenc, nMargem)

	Local wTipo 	:= left(cCbTipo,1)
	Local lOk		:= .t.
	Local nCusto 	:= 0
	Local cCateg	:= ""
	Local nImpostos := 0
	Local nCustoRep := 0
	
	Default lSilenc := .F.
	Default nMargem	:= 0
	
	dEmissao 	:= ctod("")
	cCliente	:= ""
	cNomCli		:= ""
	cVend 		:= ""
	cNomVed		:= ""
	cPgto		:= ""
	cNomPgto	:= ""
	//aMargens	:= {}
	aVetPnl3	:= {}
	nFrete		:= 0
	nFretePL	:= 0
	nDespesa	:= 0
	nDespesaPL	:= 0
	nTotPP		:= 0
	nTotPL		:= 0
	nvaltot     := 0
	nPrecoPL	:= 0
	cTipCli		:= ""
	cLojaCli	:= ""
	cCidade		:= ""
	cTransp		:= ""
		
	If wTipo = "1" //Orçamento
		dbSelectArea("SUA")		
		dbsetorder(1)
		If dbseek(xFilial("SUA")+wPedido)
				dEmissao 	:= SUA->UA_EMISSAO
				cCliente	:= SUA->UA_CLIENTE
				cNomCli		:= posicione("SA1",1,xFilial("SA1")+SUA->UA_CLIENTE+SUA->UA_LOJA,"A1_NOME")
				cVend 		:= SUA->UA_VEND
				cNomVed		:= posicione("SA3",1,xFilial("SA3")+SUA->UA_VEND,"A3_NOME")
				cPgto		:= SUA->UA_CONDPG
				cNomPgto	:= posicione("SE4",1,xFilial("SE4")+SUA->UA_CONDPG,"E4_DESCRI") 
				//nFrete		:= IIF (cCFrete == "1 - Sim",SUA->UA_FRETE,0)
				nFrete		:= SUA->UA_ZPRVFRE
				nDespesa	:= SUA->UA_DESPESA
				cTipCli		:= SUA->UA_TIPOCLI
				cLojaCli	:= SUA->UA_LOJA
				cData       := SUBSTR(DTOS(dEmissao),1,6)//GILMAR
				nDescont    := SUA->UA_DESCONT
				cCidade		:= alltrim(posicione("SA1",1,xFilial("SA1")+SUA->UA_CLIENTE+SUA->UA_LOJA,"A1_MUN"))
				cCidade		+= "/" + posicione("SA1",1,xFilial("SA1")+SUA->UA_CLIENTE+SUA->UA_LOJA,"A1_EST")
				cTransp		:= alltrim(posicione("SA4",1,xFilial("SA4")+SUA->UA_TRANSP,"A4_NOME")) + " "
				cTransp		+= "(" + posicione("SA4",1,xFilial("SA4")+SUA->UA_TRANSP,"A4_COD") + ")"
				dbSelectArea("SUB")
				dbSetOrder(1)
				If dbseek(xFilial("SUB")+wPedido)
					While !EOF() .and. SUB->UB_FILIAL = xFilial("SUB") .and. SUB->UB_NUM = wPedido 
							
						//If Select("QRYCU") <> 0 //Gilmar 23/03/2016 - Tratativa dos Custos BLOG
						//	dbSelectArea("QRYCU")
						//	QRYCU->(dbCloseArea())
						//EndIf
							
						// Guilherme Muniz - 12/09/2016 - Desabilitar custo no Poder de terceiros 
						/*
						SELECT 
							ROUND(SUM(B6_CUSTO1) /SUM(B6_QUANT) * SUM(B6_SALDO) / SUM(B6_SALDO),2) CUSUNIF
						FROM
							%table:SB6% SB6
						WHERE
							SB6.%notDel%
							AND B6_PRODUTO = %exp:SUB->UB_PRODUTO%
							AND B6_SALDO > 0
							AND B6_FILIAL = '0401'
						GROUP BY
							B6_PRODUTO
	                    */  

	                    // Guilherme Muniz - 12/09/2016 - Tratativa para custo MV_CONTERC / MV_ALMTERC
						/*BeginSQL Alias "QRYCU"	                    
						
	                    SELECT
		                    B2_CM1 CUSUNIF
	                    FROM 
	                    	%Table:SB2% SB2
	                    WHERE
	                    	SB2.%NotDel%
	                    	AND B2_FILIAL = %Exp:cFilAnt%//'0401'
	                    	AND B2_COD    = %Exp:SUB->UB_PRODUTO%
	                    	AND B2_LOCAL  = %Exp:SUB->UB_LOCAL%
	                    
						EndSql
	
						nCusto := QRYCU->CUSUNIF
						*/
						nCusto := 0
						SB2->(dbSetOrder(1))
						if SB2->(msSeek(xFilial('SB2') + SUB->UB_PRODUTO + '01'))
							if !empty(SB2->B2_CM1)
								nCusto := SB2->B2_CM1
							endif
						endif
						if empty(nCusto)
							if SB2->(msSeek(xFilial('SB2') + SUB->UB_PRODUTO + '03'))
								if !empty(SB2->B2_CM1)
									nCusto := SB2->B2_CM1
								endif
							endif
						endif
							
							/*
							If cCusto == "2 - Reposição"
								nCustoRep   := posicione("SB1",1,xfilial("SB1")+SUB->UB_PRODUTO,"B1_CUSTD")
							EndIf
							*/
							nCustoRep   := posicione("SB1",1,xfilial("SB1")+SUB->UB_PRODUTO,"B1_CUSTD")
							//If nCustoRep > nCusto
								//nCusto := nCustoRep
							//EndIf
							
							cCateg 		:= ''//posicione("SB1",1,xfilial("SB1")+SUB->UB_PRODUTO,"B1_CATEG")
							nImpostos 	:= 0 //CalcImp(SUA->UA_CLIENTE,SUA->UA_LOJA,SUA->UA_TIPOCLI,SUB->UB_PRODUTO,SUB->UB_TES,SUB->UB_QUANT,SUB->UB_VRUNIT)
							nImpPL      := 0

							AADD(aVetPnl3,{SUB->UB_ITEM,;					//1 ITEM
										   SUB->UB_PRODUTO,;				//2 COD PROD
										   posicione("SB1",1,xFilial("SB1")+SUB->UB_PRODUTO,"B1_DESC"),;	//3 PRODUTO
										   SUB->UB_QUANT,;					//4 QTD
										   SUB->UB_PRCTAB,;					//5 PRECO PL
										   SUB->UB_QUANT*SUB->UB_PRCTAB,;	//6 TOTAL PL
										   0,;								//7 MARGEM PL
										   SUB->UB_VRUNIT,;					//8 PRECO PP
										   SUB->UB_VLRITEM,;				//9 TOTAL PP
										   0,;								//10 MARGEM PP
										   SUB->UB_VRUNIT,;					//11 PRECO PE
										   0,;								//12 MARGEM PE
										   nCusto,; 						//13 CUSTO
										   nImpostos,;						//14 IMPOSTOS
										   0,;								//15 FRETE/DESP 
										   cCateg,;							//16 CATEGORIA
										   SUB->UB_TES,;					//17 TES
										   nImpPL,;							//18 IMPOSTO PL
										   0,;								//19 ALIQ ICMS
										   0,;								//20 ALIQ IPI
										   0,;								//21 ALIQ PIS
										   0,;								//22 ALIQ COFINS
										   0,;								//23 VAL ICMS
										   0,;								//24 VAL IPI
										   0,;								//25 VAL PIS
										   0,;								//26 VAL COFINS
										   0,;								//27 IMPOSTOS PP	
										   0,;								//28 VAL ICMS ST PL
										   0,;								//29 ALIQ SOL PL
										   0,;								//30 ALIQ IVA PL
										   0,;								//31 BASE_ST	
										   0,;								//32 FRETE_PL
										   0,;								//33 Valor IPI PL	
										   0,;								//34 Valor Merc - IPI PP
										   0,;								//35 Valor Merc - IPI PL
										   0,;								//36 Valor ST PP
										   0,;								//37 Valor ST PP
										   0,;								//38 Valor ST PP
										   0,;								//39 Valor REGIME SC PL
										   0})								//40 desconto
										   
										   
							nTotPP   	+= SUB->UB_VLRITEM
							nTotPL   	+= SUB->UB_QUANT*SUB->UB_PRCTAB									   
							nPrecoPL 	+= SUB->UB_PRCTAB
							nFretePL 	:= IIF (nFrete == 0, 0, nTotPL*nFrete/nTotPP)
							nDespesaPL	:= nTotPL*nDespesa/nTotPP

							//alert(SUB->UB_PRODUTO + '- ' + str(SUB->UB_QUANT*nCusto) + ' - ' + str(nCusto))
						dbSelectArea("SUB")
						dbSkip()
					End
				EndIf
			Else		  
			  	Alert("Orcamento não encontrado !!!")	
			  	lok := .f.
		EndIf
	  Else
		dbSelectArea("SC5")		
		dbsetorder(1)
		If dbseek(xFilial("SC5")+wPedido)
				dEmissao 	:= SC5->C5_EMISSAO
				cCliente	:= SC5->C5_CLIENTE
				cNomCli		:= posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_NOME")
				cVend 		:= SC5->C5_VEND1
				cNomVed		:= posicione("SA3",1,xFilial("SA3")+SC5->C5_VEND1,"A3_NOME")
				cPgto		:= SC5->C5_CONDPAG
				cNomPgto	:= posicione("SE4",1,xFilial("SE4")+SC5->C5_CONDPAG,"E4_DESCRI")
				//nFrete		:= IIF (cCFrete == "1 - Sim",SC5->C5_FRETE,0)
				nFrete 		:= SC5->C5_ZPRVFRE
				nDespesa	:= SC5->C5_DESPESA
				cTipCli		:= SC5->C5_TIPOCLI
				cLojaCli	:= SC5->C5_LOJACLI
				cData       := SUBSTR(DTOS(dEmissao),1,6)//GILMAR  
				nDescont    := SC5->C5_DESCONT
				cCidade		:= alltrim(posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_MUN"))
				cCidade		+= "/" + posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_EST")
				cTransp		:= alltrim(posicione("SA4",1,xFilial("SA4")+SC5->C5_TRANSP,"A4_NOME")) + " "
				cTransp		+= "(" + posicione("SA4",1,xFilial("SA4")+SC5->C5_TRANSP,"A4_COD") + ")"
				
				dbSelectArea("SC6")
				dbSetOrder(1)
				If dbseek(xFilial("SC6")+wPedido)
					While !eof() .and. SC6->C6_FILIAL = xFilial("SC6") .and. SC6->C6_NUM = wPedido
							
						IF SELECT("QRYCU") <> 0 //Gilmar 23/03/2016 - Tratativa dos Custos BLOG
							DBSELECTAREA("QRYCU")
							QRYCU->(DBCLOSEAREA())
						ENDIF                                                                     
						
						// Guilherme Muniz - 12/09/2016 - Desabilitar custo no Poder de terceiros 						
						/*	
						BeginSQL Alias "QRYCU"
						SELECT 
							ROUND(SUM(B6_CUSTO1) /SUM(B6_QUANT) * SUM(B6_SALDO) / SUM(B6_SALDO),2) CUSUNIF
						FROM
							%table:SB6% SB6
						JOIN
							%table:SB2% SB2
						ON
							B2_FILIAL = B6_FILIAL
							AND B2_COD = B6_PRODUTO
							AND	SB6.%notDel%
							AND	SB2.%notDel%
							AND B6_PRODUTO = %exp:SC6->C6_PRODUTO%
							AND B6_SALDO > 0
							AND B6_FILIAL = '0401'
						GROUP BY
							B6_PRODUTO
	
						EndSql
						*/
						
	                    // Guilherme Muniz - 12/09/2016 - Tratativa para custo MV_CONTERC / MV_ALMTERC
						BeginSQL Alias "QRYCU"	                    
						
	                    SELECT
		                    B2_CM1 CUSUNIF
	                    FROM 
	                    	%Table:SB2% SB2
	                    WHERE
	                    	SB2.%NotDel%
	                    	AND B2_FILIAL = %Exp:cFilAnt%//'0401'
	                    	AND B2_COD    = %Exp:SC6->C6_PRODUTO%
	                    	AND B2_LOCAL  = %Exp:SC6->C6_LOCAL%
	                    
						EndSql						
	
						nCusto := QRYCU->CUSUNIF
							
							/*
							If cCusto == "2 - Reposição"
								nCustoRep   := posicione("SB1",1,xfilial("SB1")+SC6->C6_PRODUTO,"B1_CUSTD")
							EndIf
							*/
							nCustoRep   := posicione("SB1",1,xfilial("SB1")+SUB->UB_PRODUTO,"B1_CUSTD")
							//If nCustoRep > nCusto
								//nCusto := nCustoRep
							//EndIf
							
							//cCateg 		:= posicione("SB1",1,xfilial("SB1")+SC6->C6_PRODUTO,"B1_CATEG")
							cCateg		:= ''
							nImpostos 	:= 0 //CalcImp(SC5->C5_CLIENTE,SC5->C5_LOJACLI,SC5->C5_TIPOCLI,SC6->C6_PRODUTO,SC6->C6_TES,SC6->C6_QTDVEN,SC6->C6_PRCVEN)
							nImpPL      := 0
					
							AADD(aVetPnl3,{SC6->C6_ITEM,;					//1 ITEM
										   SC6->C6_PRODUTO,;				//2 COD PROD
										   posicione("SB1",1,xFilial("SB1")+SC6->C6_PRODUTO,"B1_DESC"),;	//3 PRODUTO
										   SC6->C6_QTDVEN,;					//4 QTD
										   SC6->C6_XTABPRC,;				//5 PRECO PL
										   SC6->C6_QTDVEN*SC6->C6_XTABPRC,; //6 TOTAL PL
										   0,;								//7 MARGEM PL
										   SC6->C6_PRCVEN,;					//8 PRECO PP
										   SC6->C6_VALOR,;  				//9 TOTAL PP
										   0,;								//10 MARGEM PP
										   SC6->C6_PRCVEN,;					//11 PRECO PE
										   0,;								//12 MARGEM PE
										   nCusto,;							//13 CUSTO
										   nImpostos,;						//14 IMPOSTOS
										   0,;								//15 FRETE/DESP
										   cCateg,;							//16 CATEGORIA
										   SC6->C6_TES,;					//17 TES
										   nImpPL,;							//18 IMPOSTO PL	
										   0,;								//19 ALIQ ICMS
										   0,;								//20 ALIQ IPI
										   0,;								//21 ALIQ PIS
										   0,;								//22 ALIQ COFINS
										   0,;								//23 VAL ICMS
										   0,;								//24 VAL IPI
										   0,;								//25 VAL PIS
										   0,;								//26 VAL COFINS
										   0,;								//27 IMPOSTOS PP
										   0,;								//28 VAL ICMS ST PL
										   0,;								//29 ALIQ SOL
										   0,;								//30 ALIQ IVA
										   0,;								//31 BASE_ST	
										   0,;								//32 FRETE_PL
										   0,;								//33 Valor IPI PL	
										   0,;								//34 Valor Merc - IPI PP
										   0,;								//35 Valor Merc - IPI PL
										   0,;								//36 Valor ST PP
										   0,;								//37 Valor ST PL
										   0,;								//38 Valor ST PP
										   0,;								//39 REGIME ESP SC PL
										   0})								//40 DESCONTO
										   
						   //	nvaltot     += SC6->C6_VALOR
						//	nDescit     := 	nvaltot*nDescont/nvaltot
							nTotPP   	+= SC6->C6_VALOR //- nDescit
							nTotPL 	 	+= SC6->C6_QTDVEN*SC6->C6_XTABPRC									   
							nPrecoPL 	+= SC6->C6_XTABPRC
							nFretePL 	:= IIF (nFrete == 0, 0, nTotPL*nFrete/nTotPP)
							nDespesaPL 	:= nTotPL*nDespesa/nTotPP
						
						dbSelectArea("SC6")
						dbSkip()
					End
				EndIf
			Else		  
			  	Alert("Pedido não encontrado !!!")	
			  	lok := .f.
		EndIf

	Endif
	if !lSilenc
		If !lOk .or. Empty(aVetPnl3)
			cPedido := space(6)
			oPedido:Refresh()
			Carga(2) 
			Carga(3) 
		EndIf		

		oNumero:Refresh()
		oEmissao:Refresh()
		oCliente:Refresh()
		oNomCli:Refresh()
		oVend:Refresh()
		oNomVed:Refresh()
		oPgto:Refresh()
		oNomPgto:Refresh()
		oFrete:Refresh()
		oDespesa:Refresh()
		oTotPP:Refresh()
		oTotPL:Refresh()
	endif
	If aVetPnl3[1][2] <> ''
	  nMargem := CalcMargens()
    EndIf	
	
	if !lSilenc
		oBjLista3:SetArray(aVetPnl3)
		oBjLista3:bLine := {|| aEval( aVetPnl3[oBjLista3:nAt],{|z,w| aVetPnl3[oBjLista3:nAt,w]})} 
		oBjLista3:Refresh()


		oBjMargens:SetArray(aMargens)
		oBjMargens:bLine := {|| aEval( aMargens[oBjMargens:nAt],{|z,w| aMargens[oBjMargens:nAt,w]})} 
		oBjMargens:Refresh()

		
		oCbTipo:SetFocus()
	endif
	
	
Return(lOk)



Static Function LimpaDados()

	cPedido 	:= space(6)
	dEmissao 	:= ctod("")
	cCliente	:= ""
	cNomCli		:= ""
	cVend 		:= ""
	cNomVed		:= ""
	cPgto		:= ""
	cNomPgto	:= ""
	aMargens	:= {}
	aVetPnl3	:= {}
	nFrete		:= 0
	nFretePL	:= 0
	nDespesa	:= 0
	nDespesaPL	:= 0
	nTotPP		:= 0
	nTotPL		:= 0
	
		
	Carga(2) 
    Carga(3) 
		
	oPedido:Refresh()
	oNumero:Refresh()
	oEmissao:Refresh()
	oCliente:Refresh()
	oNomCli:Refresh()
	oVend:Refresh()
	oNomVed:Refresh()
	oPgto:Refresh()
	oNomPgto:Refresh()
	oFrete:Refresh()
	oDespesa:Refresh()
	oTotPP:Refresh()
	oTotPL:Refresh()
	
	
	oBjMargens:SetArray(aMargens)
	oBjMargens:bLine := {|| aEval( aMargens[oBjMargens:nAt],{|z,w| aMargens[oBjMargens:nAt,w]})} 
	oBjMargens:Refresh()


	oBjLista3:SetArray(aVetPnl3)
	oBjLista3:bLine := {|| aEval( aVetPnl3[oBjLista3:nAt],{|z,w| aVetPnl3[oBjLista3:nAt,w]})} 
	oBjLista3:Refresh()
	

Return 


Static Function CalcImp(cod_cli,loja_cli,tip_cli,wProduto,wTes,nQtd,nPreco,wFrete,wDespesa,wDescon)

   Local aAreAtu  := GETAREA()	

   Local nValIcm  := 0
   Local nIcmsRet := 0
   Local nValIns  := 0
   Local nValCof  := 0
   Local nValCsl  := 0
   Local nValPis  := 0
   Local nTotItem := 0
   Local nIcmComp := 0
   Local nDifal   := 0
   Local nPDDES   := 0
   Local nVFCPDIF := 0
   Local nFECP    := 0 
   Public nTotImp  := 0
   Public nValIpi  := 0
   Public nTotItem := 0
   Public nAliqIpi := 0

   MaFisIni(cod_cli,;
            loja_cli,;      // 2-Loja do Cliente/Fornecedor
            "C",;         // 3-C:Cliente , F:Fornecedor
            'N',;         // 4-Tipo da NF
            tip_cli,;   // 5-Tipo do Cliente/Fornecedor
            Nil,;
            Nil,;
            Nil,;
            Nil,;
            "MATA461",;
            Nil,;
            Nil,;
            Nil,;
            Nil,;
            Nil,;
            Nil,;
            Nil,;
            Nil,,,Nil,Nil,Nil,Nil,,Nil)

      	
   MaFisAdd( wProduto,;
             wTes,;
             nQtd,;
             nPreco,;
             wDescon,;
             "",;
             "",;
             0,;
             wFrete,;
             wDespesa,;
             0,;
             0,;
             nQtd*nPreco,;
             0,;
             0,;
             0)
                                  
   nValIcm  := MaFisRet(1,"IT_VALICM")
   nIcmsRet := MaFisRet(1,"IT_VALSOL")
   nValIpi  := MaFisRet(1,"IT_VALIPI")
   nValIns  := MaFisRet(1,"IT_VALINS")
   nValCof  := MaFisRet(1,"IT_VALCF2")
   nValCsl  := MaFisRet(1,"IT_VALCSL")
   nValPis  := MaFisRet(1,"IT_VALPS2")
   nTotItem := MaFisRet(1,"IT_TOTAL")
   nValSol  := MaFisRet(1,"IT_VALSOL")
   nAliqIcm := MaFisRet(1,"IT_ALIQICM")
   nAliqIpi := MaFisRet(1,"IT_ALIQIPI")
   nAliqPis := MaFisRet(1,"IT_ALIQPIS")
   nAliqCof := MaFisRet(1,"IT_ALIQCOF")
   nAliqSol := MaFisRet(1,"IT_ALIQSOL")//ALIQ INTRAESTADUAL
   nAliqIVA := MaFisRet(1,"IT_MARGEM")
   nBaseST  := MaFisRet(1,"IT_BASESOL")
   nIcmComp := MaFisRet(1,"IT_VALCMP")
   nDifal   := MaFisRet(1,"IT_DIFAL")
   nPDDES   := MaFisRet(1,"IT_PDDES")
   nVFCPDIF := MaFisRet(1,"IT_PDORI")
   nFECP    := MaFisRet(1,"IT_VFCPDIF")
   
	cVerImpo += 'ICMS ' + str(nValIcm) + chr(13) + chr(10)
    
	nComis := 0
	if left(cCbTipo,1) == '1'

		SA1->(dbSetOrder(1))
		SA1->(msSeek(xFilial('SA1') + cod_cli + loja_cli))
		//somente se cliente nao for INOVEN
		if substr(SA1->A1_CGC,1,8) <> '07826504'
			//Definir o % de ICMS com beneficio
			nPIcms := 0
			Do Case
				//Fora do Estado
				Case SA1->A1_EST <> SM0->M0_ESTENT; nPIcms := 0.01
				//Dentro do Estado e Simples
				Case SA1->A1_EST == SM0->M0_ESTENT .and. SA1->A1_GRPTRIB == GetNewPar("IN_GRPSIMP", "SCA"); nPIcms := 0.036
				//Dentro do Estado e Consumidor Final
				Case SA1->A1_EST == SM0->M0_ESTENT .and. SA1->A1_GRPTRIB == GetNewPar("IN_GRPCFIN", "055"); nPIcms := 0.036
				//Dentro do Estado e Nao Simples
				Case SA1->A1_EST == SM0->M0_ESTENT .and. SA1->A1_GRPTRIB == GetNewPar("IN_GRPNSIM", "SCC"); nPIcms := 0.001
			EndCase

			nBasICM    := MaFisRet(1, "IT_BASEICM")

			nValIcm := Round(nBasICM * nPIcms, 2)
		endif

	else
		SC6->(dbSetOrder(1))
		if SC6->(msSeek(xFilial('SC6') + cPedido + aVetPnl3[ny][01] + aVetPnl3[ny][02]))
			if !empty(SC6->C6_ZVALICM)
				nValIcm := SC6->C6_ZVALICM
			endif
			nComis := SC6->C6_ZVCOMIS + SC6->C6_ZVCOMSS		//comissao do vendedor + supervisor
		endif
	endif
	cVerImpo += 'ICMS Cust.' + str(nValIcm) + chr(13) + chr(10)

	cVerImpo += 'PIS ' + str(nValPis) + chr(13) + chr(10)
	cVerImpo += 'Cofins ' + str(nValCof) + chr(13) + chr(10)
	cVerImpo += 'Val CMP ' + str(nIcmComp) + chr(13) + chr(10)
	cVerImpo += 'Difal ' + str(nDifal) + chr(13) + chr(10)
	cVerImpo += 'FECP ' + str(nFECP) + chr(13) + chr(10)
	cVerImpo += 'Comissao ' + str(nComis) + chr(13) + chr(10)

   MaFisEnd()

	nTotImp := (nValIcm+nValPis+nValCof+nIcmComp+nDifal+nFECP+nComis)
   //If nFrete > 0
   	aVetPnl3[ny][24] := nValIpi
   	aVetPnl3[ny][36] := nValSol
   //EndIf

	cVerImpo += 'Frete ' + str(nFrete) + chr(13) + chr(10)
	cVerImpo += 'IPI ' + str(nValIpi) + chr(13) + chr(10)
	cVerImpo += 'Icm Sol ' + str(nValSol) + chr(13) + chr(10)

   RestArea(aAreAtu)
      
Return(nTotImp)


//CALCULO IMPOSTOS PL


Static Function CalcImpPL(cod_cli,loja_cli,tip_cli,wProduto,wTes,nQtd,nPrecoPL,wFretePL,wDespesaPL,wDescon)

   Local aAreAtuPL  := GETAREA()	

   Local nValIcmPL  := 0
   Local nIcmsRetPL := 0
   Local nValInsPL  := 0
   Local nValCofPL  := 0
   Local nValCslPL  := 0
   Local nValPisPL  := 0
   Local nTotItemPL := 0
   Local nIcmCompPL := 0
   Local nDifalPL   := 0
   //Local nPDDESPL   := 0
   //Local nVFCPDIFPL := 0
   Local nFECPPL    := 0
   Public nTotImpPL  := 0
   Public nValIpiPL  := 0
   
   
   MaFisIni(cod_cli,;
            loja_cli,;      // 2-Loja do Cliente/Fornecedor
            "C",;         // 3-C:Cliente , F:Fornecedor
            'N',;         // 4-Tipo da NF
            tip_cli,;   // 5-Tipo do Cliente/Fornecedor
            Nil,;
            Nil,;
            Nil,;
            Nil,;
            "MATA461",;
            Nil,;
            Nil,;
            Nil,;
            Nil,;
            Nil,;
            Nil,;
            Nil,;
            Nil,,,Nil,Nil,Nil,Nil,,Nil)

   MaFisAdd( wProduto,;
             wTes,;
             nQtd,;
             nPrecoPL,;
             0,;
             "",;
             "",;
             0,;
             wFretePL,;
             wDespesaPL,;
             0,;
             0,;
             nQtd*nPrecoPL,;
             0,;
             0,;
             0)
                                  
   nValIcmPL  := MaFisRet(1,"IT_VALICM")
   nIcmsRetPL := MaFisRet(1,"IT_VALSOL")
   nValIpiPL  := MaFisRet(1,"IT_VALIPI")
   nValInsPL  := MaFisRet(1,"IT_VALINS")
   nValCofPL  := MaFisRet(1,"IT_VALCF2")
   nValCslPL  := MaFisRet(1,"IT_VALCSL")
   nValPisPL  := MaFisRet(1,"IT_VALPS2")
   nTotItemPL := MaFisRet(1,"IT_TOTAL")
   nValSolPL  := MaFisRet(1,"IT_VALSOL")
   nAliqIcmPL := MaFisRet(1,"IT_ALIQICM")
   nAliqIpiPL := MaFisRet(1,"IT_ALIQIPI")
   nAliqPisPL := MaFisRet(1,"IT_ALIQPIS")
   nAliqCofPL := MaFisRet(1,"IT_ALIQCOF")
   nAliqSolPL := MaFisRet(1,"IT_ALIQSOL")//ALIQ INTRAESTADUAL
   nAliqIVAPL := MaFisRet(1,"IT_MARGEM")
   nBaseSTPL  := MaFisRet(1,"IT_BASESOL")
   nIcmCompPL := MaFisRet(1,"IT_VALCMP")
   nDifalPL   := MaFisRet(1,"IT_DIFAL")
   nFECPPL    := MaFisRet(1,"IT_VFCPDIF")

	//if left(cCbTipo,1) == '1'

		SA1->(dbSetOrder(1))
		SA1->(msSeek(xFilial('SA1') + cod_cli + loja_cli))
		//somente se cliente nao for INOVEN
		if substr(SA1->A1_CGC,1,8) <> '07826504'
			//Definir o % de ICMS com beneficio
			nPIcms := 0
			Do Case
				//Fora do Estado
				Case SA1->A1_EST <> SM0->M0_ESTENT; nPIcms := 0.01
				//Dentro do Estado e Simples
				Case SA1->A1_EST == SM0->M0_ESTENT .and. SA1->A1_GRPTRIB == GetNewPar("IN_GRPSIMP", "SCA"); nPIcms := 0.036
				//Dentro do Estado e Consumidor Final
				Case SA1->A1_EST == SM0->M0_ESTENT .and. SA1->A1_GRPTRIB == GetNewPar("IN_GRPCFIN", "055"); nPIcms := 0.036
				//Dentro do Estado e Nao Simples
				Case SA1->A1_EST == SM0->M0_ESTENT .and. SA1->A1_GRPTRIB == GetNewPar("IN_GRPNSIM", "SCC"); nPIcms := 0.001
			EndCase
		endif
		nBasICM    := MaFisRet(1, "IT_BASEICM")
		
		nValIcmPL := Round(nBasICM * nPIcms, 2)

	/*else
   
		SC6->(dbSetOrder(1))
		if SC6->(msSeek(xFilial('SC6') + cPedido + aVetPnl3[ny][01] + aVetPnl3[ny][02]))
			if !empty(SC6->C6_ZVALICM)
				nValIcmPL := SC6->C6_ZVALICM
			endif
		endif
	
	ENDIF*/
	nComisPL := 0	//valor comissao customizado
	if left(cCbTipo,1) <> '1'
		SC6->(dbSetOrder(1))
		if SC6->(msSeek(xFilial('SC6') + cPedido + aVetPnl3[ny][01] + wProduto))
			nComisV := ((nQtd*nPrecoPL) * (SC6->C6_COMIS1 / 100))
			nComisS := ((nQtd*nPrecoPL) * (SC6->C6_COMIS2 / 100))
			nComisPL := nComisV + nComisS
			
		endif
	endif

   MaFisEnd()

   nTotImpPL := (nValIcmPL+nValPisPL+nValCofPL+nIcmCompPL+nDifalPL+nFECPPL+nComisPL)
   
   
   //If nFretePL > 0
   	aVetPnl3[ny][33] := nValIpiPL
   	aVetPnl3[ny][37] := nValSolPL
   //EndIf
   
   RestArea(aAreAtuPL)
   
Return(nTotImpPL)


Static Function CalcMargens()

	Local nReceita 	:= 0
	Local nCustot  	:= 0
	Local cCateg		:= ""
	Local aCateg		:= {}
	Local nPosCt		:= 0
	Local nFreteImp 	:= 0
	Local nDespImp  	:= 0
	Local nFreteImpPL 	:= 0
	Local nDespImpPL  	:= 0
	Local nImpPE		:= 0 
	local nDescp :=0
	//Local ny
	Private ny
	Private nAliqIcm  	:= 0
	Private nAliqIcmPL	:= 0
	
	Private cVerImpo := ''
	For ny := 1 To Len(aVetPnl3)
	   cVerImpo := aVetPnl3[ny][2] + chr(13) + chr(10)
		//Rateio Frete e Despesas
	    If (nFrete + nDespesa) <> 0
	       aVetPnl3[ny][15] := Round((nFrete + nDespesa) *  (aVetPnl3[ny][09] / nTotPP),2) //rateio frete e despesa
		EndIf

		
	    If (nFrete) <> 0
	       nFreteImp := Round((nFrete) *  (aVetPnl3[ny][09] / nTotPP),2) //rateio frete para impostos
		EndIf

	    If (nDespesa) <> 0
	       nDespImp := Round((nDespesa) *  (aVetPnl3[ny][09] / nTotPP),2) //rateio frete para impostos       
		EndIf
        
 		//If (nDescont) <> 0
	    //   nDescp := Round((nDescont) *  (aVetPnl3[ny][09] / nTotPP),2) //rateio frete para impostos
	    //   aVetPnl3[ny][40] := Round((nDescont) *  (aVetPnl3[ny][09] / nTotPP),2) //rateio desconto
		//EndIf

		cVerImpo += 'Frete ' + str(nFrete) + chr(13) + chr(10)
		cVerImpo += 'Despesa ' + str(nDespesa) + chr(13) + chr(10)
		cVerImpo += 'Desconto ' + str(nDescont) + chr(13) + chr(10)
		cVerImpo += 'Total PP ' + str(nTotPP) + chr(13) + chr(10)
				
		//RATEIO DO FRETE PL
		
		If (nFretePL + nDespesaPL) <> 0
	       aVetPnl3[ny][32] := Round((nFretePL + nDespesaPL) *  (aVetPnl3[ny][06] / nTotPL),2) //rateio frete e despesa
		EndIf

	    If (nFretePL) <> 0
	       nFreteImpPL := Round((nFretePL) *  (aVetPnl3[ny][06] / nTotPL),2) //rateio frete para impostos
		EndIf
		
	    If (nDespesaPL) <> 0
	       nDespImpPL := Round((nDespesaPL) *  (aVetPnl3[ny][06] / nTotPL),2) //rateio frete para impostos       
		EndIf

		//If (nDescont) <> 0
	    //   nDescp := Round((nDescont) *  (aVetPnl3[ny][09] / nTotPP),2) //rateio frete para impostos
		//EndIf

			
		
		//Calculo dos Impostos PP
        aVetPnl3[ny][14] := CalcImp(cCliente,cLojaCli,cTipCli,aVetPnl3[ny][02],aVetPnl3[ny][17],aVetPnl3[ny][04],aVetPnl3[ny][08],nFreteImp,nDespImp,nDescp)
		aVetPnl3[ny][14] += aVetPnl3[ny][24]+aVetPnl3[ny][36]//SOMA DOS IMPOSTOS
		
		//alert(cVerImpo)		//Mostra os valores usados para o produto no calculo
		/*IF cfilant == '0301'    
		
			//_TIPOBEN:=posicione("SB1",1,xfilial("SB1")+aVetPnl3[ny][02],"B1_XREGSC")
			_TIPOBEN:= '1'
    		IF ALLTRIM(_TIPOBEN) == '1' .AND. nAliqIcm = 4
    			aVetPnl3[ny][38] :=(aVetPnl3[ny][9]*(cPTPLO4/100))
    		ELSEIF ALLTRIM(_TIPOBEN) == '1' .AND. nAliqIcm = 7
    			aVetPnl3[ny][38] :=(aVetPnl3[ny][9]*(cPTPLO7/100))    
    		ELSEIF ALLTRIM(_TIPOBEN) == '1' .AND. nAliqIcm = 12
    			aVetPnl3[ny][38] :=(aVetPnl3[ny][9]*(cPTPLO12/100))    
    		ELSEIF ALLTRIM(_TIPOBEN) == '2' .AND. nAliqIcm == 4
				
				aVetPnl3[ny][38] :=(aVetPnl3[ny][9]*(cPTDD4/100))    
    		
    		ELSEIF ALLTRIM(_TIPOBEN) == '2' .AND. nAliqIcm == 7
				
				aVetPnl3[ny][38] :=(aVetPnl3[ny][9]*(cPTDD7/100))    
    		ELSEIF ALLTRIM(_TIPOBEN) == '2' .AND. nAliqIcm ==  12
				
				aVetPnl3[ny][38] :=(aVetPnl3[ny][9]*(cPTDD12/100))    
    		ENDIF
  		ENDIF*/  
  
	 
	 	//Calculo dos Impostos PL
		aVetPnl3[ny][18] :=  CalcImpPL(cCliente,cLojaCli,cTipCli,aVetPnl3[ny][02],aVetPnl3[ny][17],aVetPnl3[ny][04],aVetPnl3[ny][05],nFreteImpPL,nDespImpPL,nDescp)
		aVetPnl3[ny][18] += aVetPnl3[ny][33]+aVetPnl3[ny][37]//SOMA DOS IMPOSTOS

		/*IF cfilant == '0404'    
		
			_TIPOBEN:=posicione("SB1",1,xfilial("SB1")+aVetPnl3[ny][02],"B1_XREGSC")
    		
    		IF ALLTRIM(_TIPOBEN) == '1' .AND.  nAliqIcmPL == 4
    			aVetPnl3[ny][39] :=(aVetPnl3[ny][6]*(cPTPLO4/100))
    		
    		ELSEIF ALLTRIM(_TIPOBEN) == '1' .AND. nAliqIcmPL == 7
    			
    			aVetPnl3[ny][39] :=(aVetPnl3[ny][6]*(cPTPLO7/100))    
    		
    		ELSEIF ALLTRIM(_TIPOBEN) == '1' .AND.  nAliqIcmPL == 12
    			
    			aVetPnl3[ny][39] :=(aVetPnl3[ny][6]*(cPTPLO12/100))    
    		
    		ELSEIF ALLTRIM(_TIPOBEN) == '2' .AND.  nAliqIcmPL == 4
				
				aVetPnl3[ny][39] :=(aVetPnl3[ny][6]*(cPTDD4/100))    
    		
    		ELSEIF ALLTRIM(_TIPOBEN) == '2' .AND.  nAliqIcmPL == 7
				
				aVetPnl3[ny][39] :=(aVetPnl3[ny][6]*(cPTDD7/100))    
    		
    		ELSEIF ALLTRIM(_TIPOBEN) == '2' .AND.  nAliqIcmPL == 12
				
				aVetPnl3[ny][39] :=(aVetPnl3[ny][6]*(cPTDD12/100))    
    		ENDIF
  		ENDIF*/  
  
			
					
		//Calculo das margens por item
		
		//Margem PP
		
		aVetPnl3[ny][9]  += (aVetPnl3[ny][24]+aVetPnl3[ny][36]+aVetPnl3[ny][15]) - (aVetPnl3[ny][40])//SOMA DOS IMPOSTOS/FRETE DESPESAS NO TOTAL DO ITEM
		
		nReceita := aVetPnl3[ny][9]-aVetPnl3[ny][14] //- aVetPnl3[ny][40]
		nCustot  := aVetPnl3[ny][4]*aVetPnl3[ny][13]
		nbenFil  := aVetPnl3[ny][38]
		aVetPnl3[ny][10] := Round((((nReceita - nCusTot + nbenFil ) / nReceita ) * 100),2)
		
		//alert('Receita '+str(nReceita))
		//alert('Custo Total '+ str(nCustot))
		//Margem PL
		
		aVetPnl3[ny][6]  += aVetPnl3[ny][33]+aVetPnl3[ny][37]+aVetPnl3[ny][32]//SOMA DOS IMPOSTOS/FRETE DESPESAS NO TOTAL DO ITEM
		
		nReceita := aVetPnl3[ny][6]-aVetPnl3[ny][18]
		nCustot  := aVetPnl3[ny][4]*aVetPnl3[ny][13]
		nbenFil  := aVetPnl3[ny][39]
		aVetPnl3[ny][07] := Round((((nReceita - nCusTot + nbenFil ) / nReceita ) * 100),2)
		
		
		/*
		//Margem PE
				
		nImpPE	  := CalcImp(cCliente,cLojaCli,cTipCli,aVetPnl3[ny][02],aVetPnl3[ny][17],aVetPnl3[ny][04],aVetPnl3[ny][11],nFreteImp,nDespImp)

		nReceita := ((aVetPnl3[ny][4]*aVetPnl3[ny][11]) + aVetPnl3[ny][15]) - nImpPE
		nCustot  := aVetPnl3[ny][4]*aVetPnl3[ny][13]
		aVetPnl3[ny][12] := Round((((nReceita - nCusTot) / nReceita ) * 100),2)
		*/


	 	//calculos das margens por categoria 
	 	cCateg := aVetPnl3[ny][16]
	 	nPosCt := Ascan(aCateg , {|x| x[1] == cCateg })
	 
	 	If nPosct = 0		  
	 		aadd(aCateg,{cCateg,;  			  					//01 categoria
	 		             aVetPnl3[ny][6],;    					//02 TOTAL PL
	 		             aVetPnl3[ny][9],;    					//03 TOTAL PP
	 		             aVetPnl3[ny][14],;   					//04 IMPOSTOS
	 		             aVetPnl3[ny][15],;   					//05 FRETE DESPESAS
	 		             aVetPnl3[ny][4]*aVetPnl3[ny][13],; 	//06 CUSTO
	 		             aVetPnl3[ny][4]*aVetPnl3[ny][11],; 	//07 TOTAL PE
	 		             nImpPE,;								//08 IMPOSTOS PE
	 		             aVetPnl3[ny][18],;						//09 VALOR IMPOSTOS PL
	 		             aVetPnl3[ny][32],;						//10 FRETE PL				   				
	 		             aVetPnl3[ny][39],;						//11 REGESP PL				   				
	 		             aVetPnl3[ny][38]})						//12 REGESPPP
	  	Else		 		           
	        aCateg[nposct][2] += aVetPnl3[ny][6]	 	 	
	 		aCateg[nposct][3] += aVetPnl3[ny][9]
	 		aCateg[nposct][4] += aVetPnl3[ny][14]
	 		aCateg[nposct][5] += aVetPnl3[ny][15]
	 		aCateg[nposct][6] += aVetPnl3[ny][4]*aVetPnl3[ny][13]
	 		aCateg[nposct][7] += aVetPnl3[ny][4]*aVetPnl3[ny][11]
	 		aCateg[nposct][8] += nImpPE
	 		aCateg[nposct][9] += aVetPnl3[ny][18]
	 		aCateg[nPosCt][10] += aVetPnl3[ny][32]
	 		aCateg[nPosCt][11] += aVetPnl3[ny][39]
	 		aCateg[nPosCt][12] += aVetPnl3[ny][38]
	 		
	  	Endif	

	Next ny
	
	/*
	//GILMAR 22/03/2016
	
	
	aProdQry := StrToKarr( cCodProd , ',')
	
	For nF := 1 To Len(aProdQry)
		cProdQry :=  "('" + alltrim(aProdQry[nF])  + "'"
	Next nF
		
	cProdQry := cProdQry + ")"
	cFilQry  := "IN " + cProdQry
	MSGINFO(cFilQry)							 
	*/
		
	//If !Empty(aCateg)

		wTotPL     	:= 0
		wTotPP  	:= 0
		wTotPE  	:= 0
		wTotCus 	:= 0
		wTotImp 	:= 0
		wTotDes 	:= 0
		wTotImpPE 	:= 0
		wTotImpPL 	:= 0
		wTotFretePL := 0
		wTotBENPP   :=0
		wTotBENPL:= 0
		
		aMargens := {}

		//For ny := 1 to len(aCateg)
		For ny := 1 to 1
			dbSelectArea("ACU")
			dbSetOrder(1)
			//If dbseek(xFilial("ACU")+aCateg[ny][1])

				//If ACU->ACU_XTGV <> "2" //se deve aparecer no TGV

					/*Aadd(aMargens,{Alltrim(ACU->ACU_DESC) ,;   //categoria
			  		              Round((((aCateg[ny][2] - aCateg[ny][9]) - aCateg[ny][6]+ aCateg[ny][11])  / (aCateg[ny][2] - aCateg[ny][9]) * 100),2),; //margem PL
								  Round((((aCateg[ny][3] - aCateg[ny][4]) - aCateg[ny][6]+ aCateg[ny][12])  / (aCateg[ny][3] - aCateg[ny][4]) * 100),2)}) //MARGEM PP
			  		              //Round((((((aCateg[ny][7]+aCateg[ny][5])-aCateg[ny][8])-aCateg[ny][6])/((aCateg[ny][7]+aCateg[ny][5])-aCateg[ny][8]))*100),2)} ) //margem PE

					*/			  
								  
					wTotPL  	+= aCateg[ny][2]
					wTotPP  	+= aCateg[ny][3]
					wTotPE  	+= aCateg[ny][7]
					wTotImp 	+= aCateg[ny][4]
					wTotDes 	+= aCateg[ny][5]
					wTotCus 	+= aCateg[ny][6]
					wTotImpPE 	+= aCateg[ny][8]
					wTotImpPL 	+= aCateg[ny][9]
					wTotFretePL += aCateg[ny][10]
					wTotBENPL   += aCateg[ny][11]
					wTotBENPP   += aCateg[ny][12]
					
				///////////////////////////
				nTotPP := wTotPP
				///////////////////////////
				nTotPL := wTotPL
				///////////////////////////
				
				
				//EndIf

			//EndIf
		Next ny	

		//aadd(aMargens,{"","",""})
		//Retorna Margem Preço Praticado
		nRetMarg := Round((((wTotPP  - wTotImp)  - wTotCus + 	wTotBENPP)  / (wTotPP - wTotImp) * 100),2)
		
		Aadd(aMargens,{"RENTABILIDADE DO PEDIDO" ,;   //categoria
			  		   Round((((wTotPL  - wTotImpPL) - wTotCus + wTotBENPL) / (wTotPL - wTotImpPL) * 100),2) ,; //margem PL
			  		   nRetMarg}) //margem PP
			  		   //Round((((((aCateg[ny][7] + aCateg[ny][5]) - aCateg[ny][8]) - aCateg[ny][6]) / ((aCateg[ny][7] + aCateg[ny][5]) - aCateg[ny][8])) * 100),2)  }) //margem PE
			  		   
	//EndIf


Return nRetMarg


Static Function fEditCell()


	Local nPosCol 		:= oBjLista3:ColPos
	Local nLinha		:= oBjLista3:nAt
	//Local nReceita 	:= 0
	//Local nTotPE		:= 0
	//Local nImpPE		:= 0
	//Local nCustot		:= 0
	//Local nFreteImp 	:= 0
	//Local nDespImp  	:= 0
	
	If nPosCol = 11  //DIGITA PRECO PE PARA CALCULO DA MARGEM PE

    	lEditCell(aVetPnl3,oBjLista3,"@E 99,999,999.99",nPosCol) 
		
		If oBjLista3:aarray[nLinha][nPosCol] <> 0

		    //Margem PE

			/*/
	    	If (nFrete) <> 0
	       		nFreteImp := Round((nFrete) *  (oBjLista3:aarray[nLinha][09] / nTotPP),2) //rateio frete para impostos
			EndIf

	    	If (nDespesa) <> 0
	       		nDespImp := Round((nDespesa) *  (oBjLista3:aarray[nLinha][09] / nTotPP),2) //rateio frete para impostos
			EndIf

        	nImpPE 		:=  CalcImpostos(cCliente,cLojaCli,cTipCli,;
        	                        		oBjLista3:aarray[nLinha][02],; 		//produto
        	                        		oBjLista3:aarray[nLinha][17],; 		//TES
        	                        		oBjLista3:aarray[nLinha][04],; 		//QTD
        	                        		oBjLista3:aarray[nLinha][nPosCol],; //PRECO PE
        	                        		nFreteImp,nDespImp)

			nTotPE	  	:= oBjLista3:aarray[nLinha][4] * oBjLista3:aarray[nLinha][nPosCol] 
			nReceita 	:= (nTotPE + oBjLista3:aarray[nLinha][15]) - nImpPE
			nCustot  	:= oBjLista3:aarray[nLinha][4] * oBjLista3:aarray[nLinha][13] 

			oBjLista3:aarray[nLinha][12] := Round((((nReceita - nCusTot) / nReceita ) * 100),2)

			/*/
	
			aVetPnl3[nLinha][nPosCol] := oBjLista3:aarray[nLinha][nPosCol] 
			//aVetPnl3[nLinha][12] := oBjLista3:aarray[nLinha][12] 


			CalcMargens()

			oBjLista3:SetArray(aVetPnl3)
			oBjLista3:bLine := {|| aEval( aVetPnl3[oBjLista3:nAt],{|z,w| aVetPnl3[oBjLista3:nAt,w]})} 
			oBjLista3:Refresh()


			oBjMargens:SetArray(aMargens)
			oBjMargens:bLine := {|| aEval( aMargens[oBjMargens:nAt],{|z,w| aMargens[oBjMargens:nAt,w]})} 
			oBjMargens:Refresh()

	
			oCbTipo:SetFocus()

	
		EndIf

	EndIf

Return()


//RECEITA LIQUIDA = (MERCADORIA + FRETE + DESPESAS) - (ICMS+PIS+COFINS)

//MARGEM  =   (RECEITA LÍQUIDA – CUSTO) / RECEITA LÍQUIDA





//RECEITA BRUTA    =    ( MERCADORIA + FRETE + OUTRAS DESPESAS + IPI + ICMS-ST )
//RECEITA LiQUIDA =    RECEITA BRUTA  - (ICMS  + PIS + COFINS + ICMS-ST + IPI )
//MARGEM BRUTA =   (RECEITA LIQUIDA - CUSTO) / RECEITA LIQUIDA

/*
Static Function FilQry()


	Local cFilQry		:= ""    

	For nX := 1 to Len(aTabela)
		If Empty(cTabela)
			cTabela :=  "('" + alltrim(aTabela[nX])  + "'"
		else
			cTabela := cTabela + ",'" + alltrim(aTabela[nX]) + "'"
		EndIf
	Next nX
	
		If !Empty(cTabela)
			cTabela := cTabela + ")"
			cFilQry := "IN " + cTabela
		Else
			cFilQry := ""
		EndIf

	EndIf

	RestArea(aAreaSA3)
	RestArea(aArea)

Return(cFilQry)
*/

//Tela detalhe da margem
Static Function fGoWinMar( cwTipo,wPedido )

Local nPosCol 		:= oBjMargens:ColPos
Local nLinha		:= oBjMargens:nAt
Local cAlmox		:= ""
Local nTotProd		:= 0

Local nTotItem	:= 0
Local nImpTot		:= 0
Local nCustot		:= 0
Local nbenFil		:= 0


Private cSayHTML := ""

//            '<tbody><tr><th style="border: 1px solid #ddd;text-align: left;padding: 5px;background:#6495ED;color:white;">Itens</th>'+;
cSayHTML := '<table style="font-size:12px;font-family: "Trebuchet MS", Arial, Helvetica, sans-serif;border-collapse: collapse;border-spacing: 0;width: 100%;">'+;
            '<tbody><tr><th style="border: 1px solid #ddd;text-align: left;padding: 5px;background:#6495ED;color:white;">Itens</th>'+;
            '<th style="border: 1px solid #ddd;text-align: right;padding: 5px;background:#6495ED;color:white;">Valor</th>'+;
            '<th style="border: 1px solid #ddd;text-align: right;padding: 5px;background:#6495ED;color:white;">&nbsp;</th>'+;
            '<th style="border: 1px solid #ddd;text-align: left;padding: 5px;background:#6495ED;color:white;">Itens</th>'+;
            '<th style="border: 1px solid #ddd;text-align: right;padding: 5px;background:#6495ED;color:white;">Valor</th>'+;
            '<th style="border: 1px solid #ddd;text-align: right;padding: 5px;background:#6495ED;color:white;">&nbsp;</th></tr>'

nTotIcm  	:= 0
nTotIpi  	:= 0
nTotCof  	:= 0
nTotPis  	:= 0
nTotIRet 	:= 0
nTotICom 	:= 0
nTotDif  	:= 0
nTotFECP 	:= 0
nTotComi	:= 0

if Left(cwTipo,1) == '1'	//orçamento
	SUA->(dbsetorder(1))
	If SUA->(dbseek(xFilial("SUA")+wPedido))
		cCliente	:= SUA->UA_CLIENTE
		cTipCli		:= SUA->UA_TIPOCLI
		cLojaCli	:= SUA->UA_LOJA
		//nFrete		:= IIF (cCFrete == "1 - Sim",SUA->UA_FRETE,0)
		nFrete		:= SUA->UA_ZPRVFRE
		nDespesa	:= SUA->UA_DESPESA
		nDescont    := SUA->UA_DESCONT

		//TOTAL ITENS
		BeginSQL Alias "QRYIT"	                    
		SELECT
			SUM(UB_VLRITEM) TOTALPP, SUM(UB_QUANT * UB_PRCTAB) TOTALPL
		FROM 
			%Table:SUB% SUB
		WHERE
			SUB.%NotDel%
			AND UB_FILIAL = %Exp:cFilAnt%//'0401'
			AND UB_NUM    = %Exp:wPedido%
		EndSql	

		if nPosCol == 2	//Preço de Lista
			nTotProd := QRYIT->TOTALPL
			//frete
		elseif nPosCol == 3	//Preço aplicado
			nTotProd := QRYIT->TOTALPP
		ENDIF
		QRYIT->(dbCloseArea())

		MaFisIni(cCliente,;
					cLojaCli,;      // 2-Loja do Cliente/Fornecedor
					"C",;         // 3-C:Cliente , F:Fornecedor
					'N',;         // 4-Tipo da NF
					cTipCli,;   // 5-Tipo do Cliente/Fornecedor
					Nil,;
					Nil,;
					Nil,;
					Nil,;
					"MATA461",;
					Nil,;
					Nil,;
					Nil,;
					Nil,;
					Nil,;
					Nil,;
					Nil,;
					Nil,,,Nil,Nil,Nil,Nil,,Nil)

		SUB->(dbSetOrder(1))
		SUB->(dbseek(xFilial("SUB")+wPedido))
		While !SUB->(EOF()) .and. SUB->UB_FILIAL == xFilial("SUB") .and. SUB->UB_NUM == wPedido 
							
			nCusto := 0
			SB2->(dbSetOrder(1))
			if SB2->(msSeek(xFilial('SB2') + SUB->UB_PRODUTO + '01'))
				if !empty(SB2->B2_CM1)
					nCusto := SB2->B2_CM1
					cAlmox := "01"
				endif
			endif
			if empty(nCusto)
				if SB2->(msSeek(xFilial('SB2') + SUB->UB_PRODUTO + '03'))
					if !empty(SB2->B2_CM1)
						nCusto := SB2->B2_CM1
						cAlmox := "03"
					endif
				endif
			endif
							
			nPreco := 0
			nValor := 0
			if nPosCol == 2	//Preço de Lista
				nValor := SUB->UB_QUANT*SUB->UB_PRCTAB
				nPreco := SUB->UB_PRCTAB
			elseif nPosCol == 3	//Preço aplicado
				nValor := SUB->UB_VLRITEM
				nPreco := SUB->UB_VRUNIT
			ENDIF

			nFreteImp := 0
			nDespImp := 0
			nDescp := 0
			nFrtDsp := 0

			If (nFrete) <> 0
				nFreteImp := Round((nFrete) *  (nValor / nTotProd),2) //rateio frete para impostos
			EndIf

			If (nDespesa) <> 0
				nDespImp := Round((nDespesa) *  (nValor / nTotProd),2) //rateio frete para impostos       
			EndIf

			If (nDescont) <> 0
			   nDescp := Round((nDescont) *  (nValor / nTotProd),2) //rateio frete para impostos
			EndIf

			//Rateio Frete e Despesas
			If (nFrete + nDespesa) <> 0
				nFrtDsp := Round((nFrete + nDespesa) *  (nValor / nTotProd),2) //rateio frete e despesa
			EndIf

			//IMPOSTOS
			MaFisAdd( SUB->UB_PRODUTO,;
						SUB->UB_TES,;
						SUB->UB_QUANT,;
						nPreco,;
						nDescp,;
						"",;
						"",;
						0,;
						nFreteImp,;
						nDespImp,;
						0,;
						0,;
						nValor,;
						0,;
						0,;
						0)

   			nValIcm  := MaFisRet(val(SUB->UB_ITEM),"IT_VALICM")
			nValIpi  := MaFisRet(val(SUB->UB_ITEM),"IT_VALIPI")
			nValCof  := MaFisRet(val(SUB->UB_ITEM),"IT_VALCF2")
			nValPis  := MaFisRet(val(SUB->UB_ITEM),"IT_VALPS2")
			nIcmsRet := MaFisRet(val(SUB->UB_ITEM),"IT_VALSOL")
			nBaseICM := MaFisRet(val(SUB->UB_ITEM),"IT_BASEICM")
			nIcmComp := MaFisRet(val(SUB->UB_ITEM),"IT_VALCMP")
			nDifal   := MaFisRet(val(SUB->UB_ITEM),"IT_DIFAL")
			nFECP    := MaFisRet(val(SUB->UB_ITEM),"IT_VFCPDIF")

			SA1->(dbSetOrder(1))
			SA1->(msSeek(xFilial('SA1') + cCliente + cLojaCli))
			//somente se cliente nao for INOVEN
			if substr(SA1->A1_CGC,1,8) <> '07826504'
				//Definir o % de ICMS com beneficio
				nPIcms := 0
				Do Case
					//Fora do Estado
					Case SA1->A1_EST <> SM0->M0_ESTENT; nPIcms := 0.01
					//Dentro do Estado e Simples
					Case SA1->A1_EST == SM0->M0_ESTENT .and. SA1->A1_GRPTRIB == GetNewPar("IN_GRPSIMP", "SCA"); nPIcms := 0.036
					//Dentro do Estado e Consumidor Final
					Case SA1->A1_EST == SM0->M0_ESTENT .and. SA1->A1_GRPTRIB == GetNewPar("IN_GRPCFIN", "055"); nPIcms := 0.036
					//Dentro do Estado e Nao Simples
					Case SA1->A1_EST == SM0->M0_ESTENT .and. SA1->A1_GRPTRIB == GetNewPar("IN_GRPNSIM", "SCC"); nPIcms := 0.001
				EndCase

				nValIcm := Round(nBaseICM * nPIcms, 2)
			endif

			nImpTot += (nValIcm+nValPis+nValCof+nIcmComp+nDifal+nFECP)
			//if nFreteImp > 0
				nImpTot += nValIpi + nIcmsRet
			//else
			//	nValIpi := 0
			//	nIcmsRet := 0
			//endif
			//alert(nImpTot)

			nTotItem  += nValor
			nTotItem  += (nValIpi+nIcmsRet+nFrtDsp) - (nDescp)//SOMA DOS IMPOSTOS/FRETE DESPESAS NO TOTAL DO ITEM

			nCustot  += (SUB->UB_QUANT*nCusto)
			nbenFil  += 0	//aVetPnl3[ny][38]

			//TOTAIS
			nTotIcm  	+= nValIcm
			nTotIpi  	+= nValIpi
			nTotCof  	+= nValCof
			nTotPis  	+= nValPis
			nTotIRet 	+= nIcmsRet
			nTotICom 	+= nIcmComp
			nTotDif  	+= nDifal
			nTotFECP 	+= nFECP

			SUB->(dbSkip())
		End

		MaFisEnd()

	EndIf
else	//Pedidos
	SC5->(dbsetorder(1))
	If SC5->(dbseek(xFilial("SC5")+wPedido))
		cCliente	:= SC5->C5_CLIENTE
		cTipCli		:= SC5->C5_TIPOCLI
		cLojaCli	:= SC5->C5_LOJACLI
		//nFrete		:= IIF (cCFrete == "1 - Sim",SC5->C5_FRETE,0)
		nFrete		:= SC5->C5_ZPRVFRE
		nDespesa	:= SC5->C5_DESPESA
		nDescont    := SC5->C5_DESCONT

		//TOTAL ITENS
		BeginSQL Alias "QRYIT"	                    
		SELECT
			SUM(C6_VALOR) TOTALPP, SUM(C6_QTDVEN * C6_XTABPRC) TOTALPL
		FROM 
			%Table:SC6% SC6
		WHERE
			SC6.%NotDel%
			AND C6_FILIAL = %Exp:cFilAnt%//'0401'
			AND C6_NUM    = %Exp:wPedido%
		EndSql	

		if nPosCol == 2	//Preço de Lista
			nTotProd := QRYIT->TOTALPL
			nFrete 	 := IIF (nFrete == 0, 0, QRYIT->TOTALPL*nFrete/QRYIT->TOTALPP)
		elseif nPosCol == 3	//Preço aplicado
			nTotProd := QRYIT->TOTALPP
		ENDIF
		QRYIT->(dbCloseArea())

		MaFisIni(cCliente,;
					cLojaCli,;      // 2-Loja do Cliente/Fornecedor
					"C",;         // 3-C:Cliente , F:Fornecedor
					'N',;         // 4-Tipo da NF
					cTipCli,;   // 5-Tipo do Cliente/Fornecedor
					Nil,;
					Nil,;
					Nil,;
					Nil,;
					"MATA461",;
					Nil,;
					Nil,;
					Nil,;
					Nil,;
					Nil,;
					Nil,;
					Nil,;
					Nil,,,Nil,Nil,Nil,Nil,,Nil)


		SC6->(dbSetOrder(1))
		SC6->(dbseek(xFilial("SC6")+wPedido))
		While !SC6->(eof()) .and. SC6->C6_FILIAL = xFilial("SC6") .and. SC6->C6_NUM = wPedido
							
			IF SELECT("QRYCU") <> 0 //Gilmar 23/03/2016 - Tratativa dos Custos BLOG
				DBSELECTAREA("QRYCU")
				QRYCU->(DBCLOSEAREA())
			ENDIF                                                                     
			
			BeginSQL Alias "QRYCU"	                    
			
			SELECT
				B2_CM1 CUSUNIF
			FROM 
				%Table:SB2% SB2
			WHERE
				SB2.%NotDel%
				AND B2_FILIAL = %Exp:cFilAnt%//'0401'
				AND B2_COD    = %Exp:SC6->C6_PRODUTO%
				AND B2_LOCAL  = %Exp:SC6->C6_LOCAL%
			
			EndSql						
			nCusto := QRYCU->CUSUNIF
							
			nPreco := 0
			nValor := 0
			if nPosCol == 2	//Preço de Lista
				nValor := SC6->C6_QTDVEN*SC6->C6_XTABPRC
				nPreco := SC6->C6_XTABPRC
			elseif nPosCol == 3	//Preço aplicado
				nValor := SC6->C6_VALOR
				nPreco := SC6->C6_PRCVEN
			ENDIF

			nFreteImp := 0
			nDespImp := 0
			nDescp := 0
			nFrtDsp := 0

			If (nFrete) <> 0
				nFreteImp := Round((nFrete) *  (nValor / nTotProd),2) //rateio frete para impostos
			EndIf

			If (nDespesa) <> 0
				nDespImp := Round((nDespesa) *  (nValor / nTotProd),2) //rateio frete para impostos       
			EndIf

			If (nDescont) <> 0
			   nDescp := Round((nDescont) *  (nValor / nTotProd),2) //rateio frete para impostos
			EndIf

			//Rateio Frete e Despesas
			If (nFrete + nDespesa) <> 0
				nFrtDsp := Round((nFrete + nDespesa) *  (nValor / nTotProd),2) //rateio frete e despesa
			EndIf

			//IMPOSTOS
			MaFisAdd( SC6->C6_PRODUTO,;
						SC6->C6_TES,;
						SC6->C6_QTDVEN,;
						nPreco,;
						nDescp,;
						"",;
						"",;
						0,;
						nFreteImp,;
						nDespImp,;
						0,;
						0,;
						nValor,;
						0,;
						0,;
						0)

   			nValIcm  := MaFisRet(val(SC6->C6_ITEM),"IT_VALICM")
			nValIpi  := MaFisRet(val(SC6->C6_ITEM),"IT_VALIPI")
			nValCof  := MaFisRet(val(SC6->C6_ITEM),"IT_VALCF2")
			nValPis  := MaFisRet(val(SC6->C6_ITEM),"IT_VALPS2")
			nIcmsRet := MaFisRet(val(SC6->C6_ITEM),"IT_VALSOL")
			nBaseICM := MaFisRet(val(SC6->C6_ITEM),"IT_BASEICM")
			nIcmComp := MaFisRet(val(SC6->C6_ITEM),"IT_VALCMP")
			nDifal   := MaFisRet(val(SC6->C6_ITEM),"IT_DIFAL")
			nFECP    := MaFisRet(val(SC6->C6_ITEM),"IT_VFCPDIF")

			if !empty(SC6->C6_ZVALICM)
				nValIcm := SC6->C6_ZVALICM
			endif
			nComisV := (nValor * (SC6->C6_COMIS1 / 100))
			nComisS := (nValor * (SC6->C6_COMIS2 / 100))

			nComis := nComisV + nComisS		//comissao do vendedor + supervisor

			nImpTot += (nValIcm+nValPis+nValCof+nIcmComp+nDifal+nFECP+nComis)
			//if nFreteImp > 0
				nImpTot += nValIpi + nIcmsRet
			//else
			//	nValIpi := 0
			//	nIcmsRet := 0
			//endif
			//alert(nImpTot)

			nTotItem  += nValor
			nTotItem  += (nValIpi+nIcmsRet+nFrtDsp) - (nDescp)//SOMA DOS IMPOSTOS/FRETE DESPESAS NO TOTAL DO ITEM

			nCustot  += (SC6->C6_QTDVEN*nCusto)
			nbenFil  += 0	//aVetPnl3[ny][38]

			//TOTAIS
			nTotIcm  	+= nValIcm
			nTotIpi  	+= nValIpi
			nTotCof  	+= nValCof
			nTotPis  	+= nValPis
			nTotIRet 	+= nIcmsRet
			nTotICom 	+= nIcmComp
			nTotDif  	+= nDifal
			nTotFECP 	+= nFECP
			nTotComi	+= nComis

			SC6->(dbSkip())
		End

		MaFisEnd()

	endif
endif

nReceita := nTotItem-nImpTot
nMargem  := Round((((nReceita - nCusTot + nbenFil ) / nReceita ) * 100),2)

cSayHTML += '<tr><td style="border: 1px solid #ddd;text-align: left;padding: 5px;"><b>IMPOSTOS</b></td>'+;
			'<td style="border: 1px solid #ddd;text-align: right;padding: 5px;"><b>'+alltrim(transf(nImpTot,'@E 999,999,999.99'))+'</b></td>'+;
			'<td style="border: 1px solid #ddd;text-align: right;padding: 5px;">&nbsp;</td>'+;
			'<td style="border: 1px solid #ddd;text-align: left;padding: 5px;background:#6495ED;"><b>MARGEM</b></td>'+;
			'<td style="border: 1px solid #ddd;text-align: right;padding: 5px;background:#6495ED;"><b>'+alltrim(transf(nMargem,'@E 999,999,999.99'))+'%</b></td>'+;
			'<td style="border: 1px solid #ddd;text-align: right;padding: 5px;">&nbsp;</td></tr>'+;
			'<tr><td style="border: 1px solid #ddd;text-align: left;padding: 5px;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(+)Icms</td>'+;
			'<td style="border: 1px solid #ddd;text-align: right;padding: 5px;">'+alltrim(transf(nTotIcm,'@E 999,999,999.99'))+'</td>'+;
			'<td style="border: 1px solid #ddd;text-align: right;padding: 5px;">&nbsp;</td>'+;
			'<td style="border: 1px solid #ddd;text-align: left;padding: 5px;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Receita</td>'+;
			'<td style="border: 1px solid #ddd;text-align: right;padding: 5px;">'+alltrim(transf(nReceita,'@E 999,999,999.99'))+'</td>'+;
			'<td style="border: 1px solid #ddd;text-align: right;padding: 5px;">&nbsp;(Produtos - Impostos)</td></tr>'+;
			'<tr><td style="border: 1px solid #ddd;text-align: left;padding: 5px;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(+)PIS</td>'+;
			'<td style="border: 1px solid #ddd;text-align: right;padding: 5px;">'+alltrim(transf(nTotPis,'@E 999,999,999.99'))+'</td>'+;
			'<td style="border: 1px solid #ddd;text-align: right;padding: 5px;">&nbsp;</td>'+;
			'<td style="border: 1px solid #ddd;text-align: left;padding: 5px;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Custo Total</td>'+;
			'<td style="border: 1px solid #ddd;text-align: right;padding: 5px;">'+alltrim(transf(nCusTot,'@E 999,999,999.99'))+'</td>'+;
			'<td style="border: 1px solid #ddd;text-align: right;padding: 5px;">&nbsp;</td></tr>'+;
			'<tr><td style="border: 1px solid #ddd;text-align: left;padding: 5px;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(+)Cofins</td>'+;
			'<td style="border: 1px solid #ddd;text-align: right;padding: 5px;">'+alltrim(transf(nTotCof,'@E 999,999,999.99'))+'</td>'+;
			'<td style="border: 1px solid #ddd;text-align: right;padding: 5px;">&nbsp;</td>'+;
			'<td style="border: 1px solid #ddd;text-align: left;padding: 5px;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Subs.Trib.</td>'+;
			'<td style="border: 1px solid #ddd;text-align: right;padding: 5px;">'+alltrim(transf(nbenFil,'@E 999,999,999.99'))+'</td>'+;
			'<td style="border: 1px solid #ddd;text-align: right;padding: 5px;">&nbsp;</td></tr>'+;
			'<tr><td style="border: 1px solid #ddd;text-align: left;padding: 5px;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(+)Icms Compl.</td>'+;
			'<td style="border: 1px solid #ddd;text-align: right;padding: 5px;">'+alltrim(transf(nTotICom,'@E 999,999,999.99'))+'</td>'+;
			'<td style="border: 1px solid #ddd;text-align: right;padding: 5px;">&nbsp;</td>'+;
			'<td style="border: 1px solid #ddd;text-align: left;padding: 5px;">&nbsp;</td>'+;
			'<td style="border: 1px solid #ddd;text-align: right;padding: 5px;">&nbsp;</td>'+;
			'<td style="border: 1px solid #ddd;text-align: right;padding: 5px;">&nbsp;</td></tr>'+;
			'<tr><td style="border: 1px solid #ddd;text-align: left;padding: 5px;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(+)Difal</td>'+;
			'<td style="border: 1px solid #ddd;text-align: right;padding: 5px;">'+alltrim(transf(nTotDif,'@E 999,999,999.99'))+'</td>'+;
			'<td style="border: 1px solid #ddd;text-align: right;padding: 5px;">&nbsp;</td>'+;
			'<td style="border: 1px solid #ddd;text-align: left;padding: 5px;">&nbsp;</td>'+;
			'<td style="border: 1px solid #ddd;text-align: right;padding: 5px;">&nbsp;</td>'+;
			'<td style="border: 1px solid #ddd;text-align: right;padding: 5px;">&nbsp;</td></tr>'+;
			'<tr><td style="border: 1px solid #ddd;text-align: left;padding: 5px;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(+)FECP</td>'+;
			'<td style="border: 1px solid #ddd;text-align: right;padding: 5px;">'+alltrim(transf(nTotFECP,'@E 999,999,999.99'))+'</td>'+;
			'<td style="border: 1px solid #ddd;text-align: right;padding: 5px;">&nbsp;</td>'+;
			'<td style="border: 1px solid #ddd;text-align: left;padding: 5px;">&nbsp;</td>'+;
			'<td style="border: 1px solid #ddd;text-align: right;padding: 5px;">&nbsp;</td>'+;
			'<td style="border: 1px solid #ddd;text-align: right;padding: 5px;">&nbsp;</td></tr>'+;
			'<tr><td style="border: 1px solid #ddd;text-align: left;padding: 5px;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(+)Comissão</td>'+;
			'<td style="border: 1px solid #ddd;text-align: right;padding: 5px;">'+alltrim(transf(nTotComi,'@E 999,999,999.99'))+'</td>'+;
			'<td style="border: 1px solid #ddd;text-align: right;padding: 5px;">&nbsp;</td>'+;
			'<td style="border: 1px solid #ddd;text-align: left;padding: 5px;">&nbsp;</td>'+;
			'<td style="border: 1px solid #ddd;text-align: right;padding: 5px;">&nbsp;</td>'+;
			'<td style="border: 1px solid #ddd;text-align: right;padding: 5px;">&nbsp;</td></tr>'+;
			'<tr><td style="border: 1px solid #ddd;text-align: left;padding: 5px;"><b>PRODUTOS</b></td>'+;
			'<td style="border: 1px solid #ddd;text-align: right;padding: 5px;"><b>'+alltrim(transf(nTotItem,'@E 999,999,999.99'))+'</b></td>'+;
			'<td style="border: 1px solid #ddd;text-align: right;padding: 5px;">&nbsp;</td></tr>'+;
			'<tr><td style="border: 1px solid #ddd;text-align: left;padding: 5px;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(+)Vlr.Total</td>'+;
			'<td style="border: 1px solid #ddd;text-align: right;padding: 5px;">'+alltrim(transf(nTotProd,'@E 999,999,999.99'))+'</td>'+;
			'<td style="border: 1px solid #ddd;text-align: right;padding: 5px;">&nbsp;</td></tr>'+;
			'<tr><td style="border: 1px solid #ddd;text-align: left;padding: 5px;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(+)IPI</td>'+;
			'<td style="border: 1px solid #ddd;text-align: right;padding: 5px;">'+alltrim(transf(nTotIpi,'@E 999,999,999.99'))+'</td>'+;
			'<td style="border: 1px solid #ddd;text-align: right;padding: 5px;">&nbsp;</td></tr>'+;
			'<tr><td style="border: 1px solid #ddd;text-align: left;padding: 5px;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(+)Icms Sol.</td>'+;
			'<td style="border: 1px solid #ddd;text-align: right;padding: 5px;">'+alltrim(transf(nTotIRet,'@E 999,999,999.99'))+'</td>'+;
			'<td style="border: 1px solid #ddd;text-align: right;padding: 5px;">&nbsp;</td></tr>'+;
			'<tr><td style="border: 1px solid #ddd;text-align: left;padding: 5px;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(+)Prev.Frete</td>'+;
			'<td style="border: 1px solid #ddd;text-align: right;padding: 5px;">'+alltrim(transf(nFrete+nDespesa,'@E 999,999,999.99'))+'</td>'+;
			'<td style="border: 1px solid #ddd;text-align: right;padding: 5px;">&nbsp;</td></tr>'+;
			'<tr><td style="border: 1px solid #ddd;text-align: left;padding: 5px;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(-)Desconto</td>'+;
			'<td style="border: 1px solid #ddd;text-align: right;padding: 5px;">'+alltrim(transf(nDescont,'@E 999,999,999.99'))+'</td>'+;
			'<td style="border: 1px solid #ddd;text-align: right;padding: 5px;">&nbsp;</td></tr>'



cSayHTML += '</tbody></table>'

DEFINE FONT oFont NAME "Arial" SIZE 0, -8 //BOLD
oFont2 := TFont():New('Courier new',,-18,.T.)

DEFINE MSDIALOG oDlg FROM 00,00 TO 540,700 PIXEL TITLE "Mapa de Calculo Margem "

	if Left(cwTipo,1) == '1'	//orçamento
		cTitle := "ORÇAMENTO: " + wPedido
	else
		cTitle := "PEDIDO: " + wPedido
	endif
	if nPosCol == 2	//Preço de Lista
		cTitle += " - MARGEM PREÇO DE LISTA"
	elseif nPosCol == 3	//Preço aplicado
		cTitle += " - MARGEM PREÇO PRATICADO"
	ENDIF

	oSayData := tSay():New(010,010,{|| cTitle },oDlg,,oFont2,,,,.T.,CLR_BLACK,CLR_WHITE,540,9)
	/*oSayData := tSay():New(010,010,{|| "Data:" },oDlg,,,,,,.T.,CLR_BLACK,CLR_WHITE,50,9)
	oGetData := tGet():New(008,035,{|u| if(PCount()>0,dDatFil:=u,dDatFil)}, oDlg,50,9,,{ ||  },,,,,,.T.,,, {|| .T. } ,,,,.F.,,,'dDatFil')

	oSayData := tSay():New(010,090,{|| "Até" },oDlg,,,,,,.T.,CLR_BLACK,CLR_WHITE,20,9)
	oGetData := tGet():New(008,110,{|u| if(PCount()>0,dDatFilA:=u,dDatFilA)}, oDlg,50,9,,{ ||  },,,,,,.T.,,, {|| .T. } ,,,,.F.,,,'dDatFilA')

	oBtnAtu  := tButton():New(008, 220, "Atualizar" , oDlg, { || (goAtuWin(), oFicha:refresh()) },50,12,,,,.T.,,,,,,)*/
	//oBtnFim  := tButton():New(008, 280, "Sair" , oDlg, { || oDlg:End() },50,12,,,,.T.,,,,,,)

	//oScr:= TScrollBox():New(oDlg,5,5,165,345,.T.,.F.,.T.)
	oScr:= TScrollBox():New(oDlg,25,5,230,345,.T.,.F.,.T.)

	nW := ((2640 * len(cSayHTML)) / 14769) / 2

	//@ 5,5 SAY oFicha VAR cSayHTML OF oScr FONT oFont PIXEL SIZE 500,1000 HTML
	//@ 5,5 SAY oFicha VAR cSayHTML OF oScr FONT oFont PIXEL SIZE 500, (nW+20) HTML
	@ 3,5 SAY oFicha VAR cSayHTML OF oScr FONT oFont PIXEL SIZE 500, 400 HTML

ACTIVATE MSDIALOG oDlg CENTERED 

Return
