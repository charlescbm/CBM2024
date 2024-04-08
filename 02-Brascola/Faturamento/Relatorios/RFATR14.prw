#INCLUDE "RWMAKE.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RFATR14  ³ Autor ³ TI-2399 ARTUR DA COSTA   ³ Data ³ 24/11/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Pedidos em Faturados/Pendentes por vendedor                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico Brascola                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RFATR14()
********************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2       := "de acordo com os parametros informados pelo usuario."
Local cDesc3 	   := "Relatorio de Pedidos Faturados/Pendentes por Vendedor"
Local cPict  	   := ""
Local titulo 	   := "Pedidos Faturados/Pendentes por Vendedor"
Local imprime	   := .T.
Local aOrd   	   := {}
Local cQuery 	   := ""
Local aRegs        := {}
Local cPerg        := U_CRIAPERG("FATR14")
Local nOrdem
//Local Cabec1 	   := " VENDEDOR                              Num.Ped./Tipo                                            .............Quantidade..............                    .....................Total Valores...................."
//Local Cabec2 	   := " Cod./Loja/Nome Cnlinente  Data Emisao   Item / Cod / Descricao Produto                   UM      Vendido  Faturado  Pendente  Residuo                      Vendido        Faturado       Pendente       Residuo"
				 //     01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
				 //     0        10        20        30        40        50        60        70        80        90       100       110       120       130       140       150        160      170       180       190       200       210       220
Local Cabec1      := " VENDEDOR   Data Emissao Data Entrega  Num.Ped./Tipo                                            .............Quantidade..............                    .....................Total Valores...................."
Local Cabec2      := " Cod./Loja/Nome Cliente                Item / Cod / Descricao Produto                   UM      Vendido  Faturado  Pendente  Residuo                      Vendido        Faturado       Pendente       Residuo"
					// 01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
					// 0        10        20        30        40        50        60        70        80        90       100       110       120       130       140       150        160      170       180       190       200       210       220
Private lEnd       := .F.
Private lAbortPrint:= .F.
Private CbTxt      := ""
Private tamanho    := "G"
Private nomeprog   := "RFATR14"
Private nTipo      := 18
Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1 }
Private nLastKey   := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "RFATR14"
Private nlin	   := 80
Private cString    := ""
Private cCodRepr   := ''

AADD(aRegs,{ cPerg,"01","Do Produto                ?:", "Codigo Produto            ?:", "Codigo Produto            ?:", "mv_ch1", "C", 15, 0, 0, "G", "", "mv_par01", ""           , "", "", "", "", ""               ,"","","","","",""  ,"","","","","","","","","","","","","SB1","" ,"","","","" } )
AADD(aRegs,{ cPerg,"02","Ate o Produto             ?:", "Ate o Produto             ?:", "Ate o Produto             ?:", "mv_ch2", "C", 15, 0, 0, "G", "", "mv_par02", ""           , "", "", "", "", ""               ,"","","","","",""  ,"","","","","","","","","","","","","SB1","" ,"","","","" } )
AADD(aRegs,{ cPerg,"03","Do Vendedor               ?:", "Do Vendedor               ?:", "Do Vendedor               ?:", "mv_ch3", "C",  6, 0, 0, "G", "", "mv_par03", ""           , "", "", "", "", ""               ,"","","","","",""  ,"","","","","","","","","","","","","SA3","" ,"","","","" } )
AADD(aRegs,{ cPerg,"04","Ate o Vendedor            ?:", "Ate o Vendedor            ?:", "Ate o Vendedor            ?:", "mv_ch4", "C",  6, 0, 0, "G", "", "mv_par04", ""           , "", "", "", "", ""               ,"","","","","",""  ,"","","","","","","","","","","","","SA3","" ,"","","","" } )
AADD(aRegs,{ cPerg,"05","Do Cliente                ?:", "Do Cliente                ?:", "Do Cliente                ?:", "mv_ch5", "C",  6, 0, 0, "G", "", "mv_par05", ""           , "", "", "", "", ""               ,"","","","","",""  ,"","","","","","","","","","","","","SA1","" ,"","","","" } )
AADD(aRegs,{ cPerg,"06","Ate o Cliente             ?:", "Ate o Cliente             ?:", "Ate o Cliente             ?:", "mv_ch6", "C",  6, 0, 0, "G", "", "mv_par06", ""           , "", "", "", "", ""               ,"","","","","",""  ,"","","","","","","","","","","","","SA1","" ,"","","","" } )
AADD(aRegs,{ cPerg,"07","Do Doc.Numero             ?:", "Do Doc.Numero             ?:", "Do Doc.Numero             ?:", "mv_ch7", "C",  9, 0, 0, "G", "", "mv_par07", ""           , "", "", "", "", ""               ,"","","","","",""  ,"","","","","","","","","","","","","SC5","" ,"","","","" } )
AADD(aRegs,{ cPerg,"08","Ate Doc.Numero            ?:", "Ate Doc.Numero            ?:", "Ate Doc.Numero            ?:", "mv_ch8", "C",  9, 0, 0, "G", "", "mv_par08", ""           , "", "", "", "", ""               ,"","","","","",""  ,"","","","","","","","","","","","","SC5","" ,"","","","" } )
AADD(aRegs,{ cPerg,"09","Da Data de Emissao        ?:", "Da Data Emissao           ?:", "Da Data Emissao           ?:", "mv_ch9", "D",  8, 0, 0, "G", "", "mv_par09", ""           , "", "", "", "", ""               ,"","","","","",""  ,"","","","","","","","","","","","",""   ,"" ,"","","","" } )
AADD(aRegs,{ cPerg,"10","Ate Data de Emissao       ?:", "Ate Data Emissao          ?:", "Ate Data Emissao          ?:", "mv_cha", "D",  8, 0 ,0, "G", "", "mv_par10", ""           , "", "", "", "", ""               ,"","","","","",""  ,"","","","","","","","","","","","",""   ,"" ,"","","","" } )
AADD(aRegs,{ cPerg,"11","Da Data de Entrega        ?:", "Da Data de Entrega        ?:", "Da Data de Entrega        ?:", "mv_chb", "D",  8, 0, 0, "G", "", "mv_par11", ""           , "", "", "", "", ""               ,"","","","","",""  ,"","","","","","","","","","","","",""   ,"" ,"","","","" } )
AADD(aRegs,{ cPerg,"12","Ate Data de Entrega       ?:", "Ate Data de Entrega       ?:", "Ate Data de Entrega       ?:", "mv_chc", "D",  8, 0, 0, "G", "", "mv_par12", ""           , "", "", "", "", ""               ,"","","","","",""  ,"","","","","","","","","","","","",""   ,"" ,"","","","" } )
AADD(aRegs,{ cPerg,"13","Salta Pagina por Vendedor ?:", "Salta Pagina por Vendedor ?:", "Salta Pagina por Vendedor ?:", "mv_chd", "N",  1, 0, 0, "C", "", "mv_par13", "Sim"        , "", "", "", "", "Nao"            ,"","","","","",""  ,"","","","","","","","","","","","",""   ,"S","","","","" } )
AADD(aRegs,{ cPerg,"14","Tipo Relatorio            ?:", "Tipo Relatorio            ?:", "Tipo Relatorio            ?:", "mv_che", "N",  1, 0, 0, "C", "", "mv_par14", "Analitico"  , "", "", "", "", "Sintetico"      ,"","","","","",""  ,"","","","","","","","","","","","",""   ,"S","","","","" } )
AADD(aRegs,{ cPerg,"15","Quanto Duplicata          ?:", "Quanto Duplicata          ?:", "Quanto Duplicata          ?:", "mv_chf", "N",  1, 0, 0, "C", "", "mv_par15", "Gera Duplic", "", "", "", "", "Nao Gera Duplic","","","","","Ambos","","","","","","","","","","","","",""   ,"S","","","","" } )
//Aadd(aRegs,{ cPerg,"16","Do Grupo de Vend          ?:", "Do Grupo de Vend          ?:", "Do Grupo de Vend          ?:", "mv_chg", "C", 06, 0, 0, "G", "", "mv_par16", ""           , "", "", "", "", ""               ,"","","","",""     ,"","","","","","","","","","","","","ACA","" ,"","","","" } )

lValidPerg( aRegs )

Pergunte( cPerg, .f. )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := SetPrint( cString, NomeProg, cPerg, @titulo, cDesc1, cDesc2, cDesc3, .t., aOrd, .t., Tamanho,, .t. )
If nLastKey == 27
	Return
EndIf
SetDefault(aReturn,cString)
If nLastKey == 27
	Return
EndIf
nTipo := If(aReturn[4]==1,15,18)

//04/02/13 - Marcelo - Filtro dos Representantes
////////////////////////////////////////////////
If (u_BXRepAdm()) //Parametro/Presidente/Diretor
	cCodRepr := "" //Liberar para todos
Else
	cCodRepr := u_BXRepLst("SQL") //Lista dos Representantes
	If Empty(cCodRepr)
		Help("",1,"BRASCOLA",,OemToAnsi("Sem acesso ao cadastro de representantes! Favor verificar."),1,0) 
		Return
	Endif
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RptStatus( {|| RunReport( Cabec1, Cabec2, Titulo, nlin ) },Titulo )
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³                    º Data ³  29/09/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RunReport(Cabec1,Cabec2,Titulo,nlin)

Local nOrdem
Local nCount      := 0
Local nCountT     := 0
Local nVlrTot     := 0
Local nVlrNTot    := 0
Local nvalitem    := 0
Local nVendido    := 0
Local nFaturado   := 0
Local nPendente   := 0
Local nResiduo	  := 0
Local nTotVend    := 0
Local nTotFat     := 0
Local nTotPend    := 0
Local nTotRes     := 0
Local nTotGerVend := 0
Local nTotGerFat  := 0
Local nTotGerPend := 0
Local nTotGerRes  := 0
Local cProIni     := ""
Local cProFin     := ""
Local cVenIni     := ""
Local cVenFin     := ""
Local cCliIni     := ""
Local cCliFin     := ""
Local cDocIni     := ""
Local cDocFin     := ""
Local cDtemisIni  := ""
Local cDtemisFin  := ""
Local cDtentIni   := ""
Local cDtentFin   := ""

If Empty(mv_par01)
	cProIni:= Replicate( ' ', TAMSX3("C6_PRODUTO")[1] )
	cProFin:= Replicate( 'z', TAMSX3("C6_PRODUTO")[1] )
Else
	cProIni:= mv_par01
	cProFin:= mv_par02
EndIf

If Empty(mv_par03)
	cVenIni:= Replicate( ' ', TAMSX3("C5_VEND1")[1] )
	cVenFin:= Replicate( 'z', TAMSX3("C5_VEND1")[1] )
Else
	cVenIni:= mv_par03
	cVenFin:= mv_par04
EndIf

If Empty(mv_par05)
	cCliIni:= Replicate( ' ', TAMSX3("C5_CLIENTE")[1] )
	cCliFin:= Replicate( 'z', TAMSX3("C5_CLIENTE")[1] )
Else
	cCliIni:= mv_par05
	cCliFin:= mv_par06
EndIf

If Empty(mv_par07)
	cDocIni:= Replicate( ' ', TAMSX3("C6_NUM")[1] )
	cDocFin:= Replicate( 'z', TAMSX3("C6_NUM")[1] )
Else
	cDocIni	:= mv_par07
	cDocFin	:= mv_par08
EndIf

If Empty(mv_par09)
	cDtemisIni:= Replicate( ' ', TAMSX3("C5_EMISSAO")[1] )
	cDtemisFin:= Replicate( 'z', TAMSX3("C5_EMISSAO")[1] )
Else
	cDtemisIni	:= Dtos(mv_par09)
	cDtemisFin	:= Dtos(mv_par10)
EndIf

If Empty(mv_par11)
	cDtentIni:= Replicate( ' ', TAMSX3("C6_ENTREG")[1] )
	cDtentFin:= Replicate( 'z', TAMSX3("C6_ENTREG")[1] )
Else
	cDtentIni:= Dtos(mv_par11)
	cDtentFin:= Dtos(mv_par12)
EndIf

cQry := "SELECT A3_COD COD_VENDEDOR,A3_NOME NOME_VENDEDOR,C5_TIPO TIPO_PEDIDO,C5_EMISSAO DATA_EMISSAO,C6_ENTREG DATA_ENTREGA, C6_CLI COD_ClIENTE,C6_LOJA LOJA_CLIENTE,C6_PRCVEN PRECO_VEND, "
cQry += "CASE WHEN C5_TIPO IN ('B','D') THEN ISNULL((SELECT A2_NOME FROM " + RetSqlName("SA2")
cQry += " WHERE A2_FILIAL = ' ' AND A2_COD = C6_CLI AND A2_LOJA = C6_LOJA AND D_E_L_E_T_ <> '*'),' ') "
cQry += "ELSE ISNULL((SELECT A1_NOME FROM " + RetSqlName("SA1")
cQry += " WHERE A1_FILIAL = ' ' AND A1_COD = C6_CLI AND A1_LOJA = C6_LOJA AND D_E_L_E_T_ <> '*'),' ') END NOME_CLIENTE, "
cQry += "C6_NUM NUMERO_PEDIDO,C6_ITEM ITEM_PEDIDO,C6_PRODUTO PRODUTO,C6_DESCRI DESCRICAO,C6_UM UM,C6_QTDVEN VENDIDO,C6_QTDENT FATURADO, "
cQry += "CASE WHEN C6_BLQ <> 'R' THEN C6_QTDVEN-C6_QTDENT "
cQry += "ELSE 0 END PENDENTE, "
cQry += "CASE WHEN C6_BLQ = 'R' THEN C6_QTDVEN-C6_QTDENT "
cQry += "ELSE 0 END RESIDUO"
cQry += " FROM " + RetSqlName("SC6") + " SC6"
cQry += ", "     + RetSqlName("SC5") + " SC5"
cQry += ", "     + RetSqlName("SA3") + " SA3"
cQry += ", "     + RetSqlName("SF4") + " SF4"
cQry += " WHERE SC6.C6_FILIAL = '"      + xFilial("SC6")      + "'"
cQry += " AND SC6.C6_NUM BETWEEN '"     + cDocIni  + "' AND '" + cDocFin   + "'"
cQry += " AND SC6.C6_ENTREG BETWEEN '"  + cDtentIni+ "' AND '" + cDtentFin + "'"
cQry += " AND SC6.C6_PRODUTO BETWEEN '" + cProIni  + "' AND '" + cProFin   + "'"
cQry += " AND SC6.C6_CLI BETWEEN '"     + cCliIni  + "' AND '" + cCliFin   + "'"
If !Empty(cCodRepr)
	cQry += " AND SC5.C5_VEND1 IN (" + cCodRepr + ")"
	cQry += " AND SC5.C5_VEND1 BETWEEN '" + cVenIni + "' AND '" + cVenFin  + "'"
Else
	cQry += " AND SC5.C5_VEND1 BETWEEN '" + cVenIni + "' AND '" + cVenFin  + "'"
EndIf	
cQry += " AND SC6.D_E_L_E_T_ <> '*'"
cQry += " AND SC5.C5_FILIAL = SC6.C6_FILIAL "
cQry += " AND SC5.C5_NUM = SC6.C6_NUM "
cQry += " AND SC5.C5_EMISSAO BETWEEN '" + cDtemisIni + "' AND '" + cDtemisFin + "'"
cQry += " AND SC5.D_E_L_E_T_ <> '*'"
cQry += " AND SA3.A3_FILIAL = '"        + xFilial("SA3") + "'"
cQry += " AND SA3.A3_COD = SC5.C5_VEND1"
cQry += " AND SA3.D_E_L_E_T_ <> '*'"

/*If !Empty( AllTrim(mv_par16) )
	cQry += " AND SA3.A3_GRPREP = '" + AllTrim(mv_par16) + "' "
EndIf*/

cQry += " AND SF4.F4_FILIAL = '"     + xFilial("SF4")    + "'"
cQry += " AND SF4.F4_CODIGO = SC6.C6_TES"

If mv_par15 == 1
	cQry += " AND SF4.F4_DUPLIC = 'S'"
ElseIf mv_par15 == 2
	cQry += " AND SF4.F4_DUPLIC <> 'S'"
EndIf

cQry += " AND SF4.D_E_L_E_T_ <> '*'"
cQry += " ORDER BY COD_VENDEDOR,NUMERO_PEDIDO,ITEM_PEDIDO"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Grava query no diretorio             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQry := ChangeQuery(cQry)
//MemoWrite("\QUERYSYS\RFATR14.SQL",cQry)

If Select('RFATR14') > 0
	RFATR14->( DbCloseArea() )
EndIf	

DbUseArea( .t., "TOPCONN", TcGenQry(,,cQry),'RFATR14', .f., .t.)

DbSelectArea("RFATR14")
DbGotop()

SetRegua(RecCount())

While !Eof()
	
	IncRegua()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica o cancelamento pelo usuario...                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lAbortPrint
		@ nlin,000 Psay "*** CANCELADO PELO OPERADOR ***"
		Exit
	EndIf

	cCliente := RFATR14->COD_CLIENTE
	cVendedor:= RFATR14->COD_VENDEDOR
	nTotVend := 0
	nTotFat  := 0
	nTotPend := 0
	nTotRes  := 0
	nCount   := 0
	
	If nlin > 55
		Cabec( Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo,, .f.)
		nlin:= 8
	EndIf
	
	@ ++nlin, 000 Psay RFATR14->COD_VENDEDOR + "-" + RFATR14->NOME_VENDEDOR
	@ ++nlin, 000 PSAY __PrtThinline()
	
	While !Eof () .And. RFATR14->COD_VENDEDOR == cVendedor
		If nlin > 55
			Cabec( Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo,, .f. )
			nlin:= 8			
		EndIf
		
		cPedido  := RFATR14->NUMERO_PEDIDO
		nVendido := 0
		nFaturado:= 0
		nPendente:= 0
		nResiduo := 0
		
		@ ++nlin, 000 Psay RFATR14->COD_CLIENTE   + "-" + RFATR14->LOJA_ClIENTE + "-" + Left( RFATR14->NOME_CLIENTE, 25 )
		@   nlin, 040 Psay RFATR14->NUMERO_PEDIDO + "-" + RFATR14->TIPO_PEDIDO
		
		While !Eof () .And. RFATR14->NUMERO_PEDIDO == cPedido

			If nlin > 55
				Cabec( Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo, ,.f.)
				nlin:= 8
			EndIf
			
			If mv_par14 == 1
				@ ++nlin, 017 Psay StoD( RFATR14->DATA_EMISSAO )
				@   nlin, 027 Psay stod( RFATR14->DATA_ENTREGA )
				@   nlin, 040 Psay RFATR14->ITEM_PEDIDO
				@   nlin, 045 Psay Left( RFATR14->PRODUTO  ,  8 )
				@   nlin, 055 Psay Left( RFATR14->DESCRICAO, 30 )
				@   nlin, 089 Psay RFATR14->UM
				@   nlin, 099 Psay RFATR14->VENDIDO
				@   nlin, 109 Psay RFATR14->FATURADO
				@   nlin, 119 Psay RFATR14->PENDENTE
				@   nlin, 129 Psay RFATR14->RESIDUO
				@   nlin, 148 Psay RFATR14->PRECO_VEND * RFATR14->VENDIDO 	Picture "@E 999,999,999.99"
				@   nlin, 163 Psay RFATR14->PRECO_VEND * RFATR14->FATURADO	Picture "@E 999,999,999.99"
				@   nlin, 178 Psay RFATR14->PRECO_VEND * RFATR14->PENDENTE	Picture "@E 999,999,999.99"
				@   nlin, 193 Psay RFATR14->PRECO_VEND * RFATR14->RESIDUO	Picture "@E 999,999,999.99"
			EndIf
			
			nVendido   += RFATR14->PRECO_VEND * RFATR14->VENDIDO
			nFaturado  += RFATR14->PRECO_VEND * RFATR14->FATURADO
			nPendente  += RFATR14->PRECO_VEND * RFATR14->PENDENTE
			nResiduo   += RFATR14->PRECO_VEND * RFATR14->RESIDUO
			
			nTotVend   += RFATR14->PRECO_VEND * RFATR14->VENDIDO
			nTotFat    += RFATR14->PRECO_VEND * RFATR14->FATURADO
			nTotPend   += RFATR14->PRECO_VEND * RFATR14->PENDENTE
			nTotRes    += RFATR14->PRECO_VEND * RFATR14->RESIDUO
			
			nTotGerVend+= RFATR14->PRECO_VEND * RFATR14->VENDIDO
			nTotGerFat += RFATR14->PRECO_VEND * RFATR14->FATURADO
			nTotGerPend+= RFATR14->PRECO_VEND * RFATR14->PENDENTE
			nTotGerRes += RFATR14->PRECO_VEND * RFATR14->RESIDUO
			
			DbSelectArea("RFATR14")
			DbSkip()
			
		EndDo

		++nCount  // total de pedidos por vendedor
		++nCountT // total de pedidos

		If mv_par14 == 1
			@ ++nlin,125 PSAY "Total do Pedido"
			@   nlin,148 PSAY nVendido	Picture "@E 999,999,999.99"
			@   nlin,163 PSAY nFaturado	Picture "@E 999,999,999.99"
			@   nlin,178 PSAY nPendente	Picture "@E 999,999,999.99"
			@   nlin,193 PSAY nResiduo	Picture "@E 999,999,999.99"
			@ ++nlin,100 PSAY __PrtThinline()
		Else
			@ ++nlin,057 Psay StoD( RFATR14->DATA_EMISSAO )
			@   nlin,067 Psay StoD( RFATR14->DATA_ENTREGA ) 
			@   nlin,148 PSAY nVendido	Picture "@E 999,999,999.99"
			@   nlin,163 PSAY nFaturado	Picture "@E 999,999,999.99"
			@   nlin,178 PSAY nPendente	Picture "@E 999,999,999.99"
			@   nlin,193 PSAY nResiduo	Picture "@E 999,999,999.99"
		EndIf
		
		DbSelectArea("RFATR14")
		
	EndDo

	@ ++nlin,  17 PSAY "Total Pedidos :"
	@   nlin,  36 PSAY nCount	Picture '999999'
	@   nlin, 125 PSAY "Total Vendedor: " + AllTrim( cVendedor )
	@   nlin, 148 PSAY nTotVend	Picture "@E 999,999,999.99"
	@   nlin, 163 PSAY nTotFat	Picture "@E 999,999,999.99"
	@   nlin, 178 PSAY nTotPend	Picture "@E 999,999,999.99"
	@   nlin, 193 PSAY nTotRes	Picture "@E 999,999,999.99"
	@ ++nlin, 000 PSAY Replicate( '=', 207 )
	
	nlin+= 2
	
	IF MV_PAR13 == 1
		Cabec( Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo,, .f. )
		nlin:= 8
	Endif
	
EndDo

If nLin <> 80
	@ ++nlin,  17 PSAY "Total Pedidos :"
	@   nlin,  36 PSAY nCountT		Picture '999999'
	@   nlin, 125 PSAY "Total Geral"
	@   nlin, 148 PSAY nTotGerVend	Picture "@E 999,999,999.99"
	@   nlin, 163 PSAY nTotGerFat	Picture "@E 999,999,999.99"
	@   nlin, 178 PSAY nTotGerPend	Picture "@E 999,999,999.99"
	@   nlin, 193 PSAY nTotGerRes	Picture "@E 999,999,999.99"
	@ ++nlin, 100 PSAY __PrtThinline()
EndIf

If aReturn[5] == 1
	OurSpool(wnrel)
EndIf

MS_FLUSH()

DbSelectArea("RFATR14")
DbCloseArea()

Return