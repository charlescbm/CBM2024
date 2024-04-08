#INCLUDE "PROTHEUS.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Rdmake    ³ RFATC10  ³ Autor ³ Marcos Eduardo Rocha  ³ Data ³ 10/01/06  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Exibe para os Vendedores as vendas previstas e realizadas   ³±±
±±³          ³ do Mes na inicializacao do sistema.                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico Brascola                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Alteracao³ 0.06.06  Luciano Lorenzetti                                 ³±±
±±³          ³ Incluido tratamento para desconsiderar itens com eliminacao ³±±
±±³          ³ de residuos.                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RFATC10()          

Local cCodRep  := ''
Local cCodRepPr:= ''
Local lRepre   := .F.
Local cQuery   := ''
Local cEol     := Chr(13)+Chr(10)
Local nOpc     := 1
Local oDlg	   := {}
Local aArea    := GetArea()
Local cGrupo   := {}
Local cVend    := {}
Local nTotPrev := 0
Local nTotVDia := 0
Local nTotVMes := 0
Local nPercPrev:= 0
Local nPercReal:= 0
Local nQtdPed  := 0	
Local cAx_User := __cUserId

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se o usuario e' vendedor. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea('SA3')
DbSetOrder(7)

// Alterado em 300610
//If dbSeek(xFilial("SA3")+__cUserId)
//	cCodRep := SA3->A3_COD
//	lRepre  := .T.
//EndIf

If DbSeek( xFilial('SA3') + __cUserId, .f. )
	While !Eof() .And. ( cAx_User == A3_CODUSR )
		cCodRep  += SA3->A3_COD + "','"
		cCodRepPr+= SA3->A3_COD + "/"
		lRepre:= .t.
		DbSkip()
	EndDo
EndIf

cCodRep  := Subs( cCodRep  , 1, Len( cCodRep   ) - 3 )
cCodRepPr:= Subs( cCodRepPr, 1, Len( cCodRepPr ) - 1 )

DbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³        Executa a Consulta.         ³
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
If lRepre == .t. .And. GetMv('MV_CONSVND')
	
	mv_par01:= FirstDay(dDataBase)
	mv_par02:= LastDay(dDatabase)
	mv_par03:= dDataBase
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Define Query para buscar os Pedidos de Venda                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	// Vendas Previstas x Faturadas
	cQuery += " SELECT GRUPO, VEND, SUPER, SUM(TOTPREV) TOTPREV, SUM(TOTVDIA) TOTVDIA, SUM(TOTVMES) TOTVMES, SUM(QTDPED) QTDPED" + cEol
	cQuery += " FROM (" + cEol
	
	// Busca as Previsoes de Venda
	cQuery += " SELECT SA3.A3_GRPREP GRUPO, SA3.A3_COD VEND, SA3.A3_SUPER SUPER, SUM(SCT.CT_VALOR) TOTPREV, 0 TOTVDIA, 0 TOTVMES, 0 QTDPED " + cEol
	cQuery += " FROM " + RetSqlName("SCT") + " SCT, " + RetSqlName("SA3") + " SA3" + cEol
	cQuery += " WHERE SCT.CT_DATA BETWEEN '" + Dtos( MV_PAR01 ) + "' AND '" + DtoS( MV_PAR02 ) + "'" + cEol
	///// cQuery += " AND SCT.CT_VEND = '"+cCodRep+"'"+cEol // em 300610
	cQuery += " AND SCT.CT_VEND IN ('" + cCodRep + "')"           + cEol
	cQuery += " AND SCT.D_E_L_E_T_ <> '*'"                        + cEol
	cQuery += " AND SA3.A3_FILIAL  = '  '"                        + cEol
	cQuery += " AND SA3.A3_COD = SCT.CT_VEND"                     + cEol
	cQuery += " AND SA3.D_E_L_E_T_ <> '*'"                        + cEol
	cQuery += " GROUP BY SA3.A3_GRPREP, SA3.A3_COD, SA3.A3_SUPER" + cEol

	cQuery += " UNION ALL" + cEol
	
	// Busca as Vendas do Mes E QUANTIDADE DE PEDIDOS DO MES
	cQuery += " SELECT GRUPO, VEND, SUPER, 0 TOTPREV, 0 TOTVDIA, SUM(TOTVMES), SUM(QTDPED)" + cEol
	cQuery += " FROM (" + cEol
	cQuery += " SELECT SA3.A3_GRPREP GRUPO, SA3.A3_COD VEND, SA3.A3_SUPER SUPER, 0 TOTPREV, 0 TOTVDIA, SUM(C6_VALOR) TOTVMES, COUNT(DISTINCT(C6_NUM)) QTDPED" + cEol
	cQuery += " FROM " + RetSqlName("SC5") + " SC5, " + RetSqlName("SC6") + " SC6, " + RetSqlName("SA3") + " SA3, " + RetSqlName("SF4") + " SF4" + cEol
	cQuery += " WHERE SC5.C5_TIPO NOT IN ('D','B')" + cEol
	cQuery += " AND SC5.C5_EMISSAO BETWEEN '" + DtoS( MV_PAR01 ) + "' AND '" + DtoS( MV_PAR02 ) + "'" + cEol
	///// cQuery += " AND SC5.C5_VEND1 = '"+cCodRep+"'"+cEol EM 300610
	cQuery += " AND SC5.C5_VEND1 IN ('" + cCodRep + "')"          + cEol
	cQuery += " AND SC5.D_E_L_E_T_ <> '*'"                        + cEol
	cQuery += " AND SC6.C6_FILIAL = SC5.C5_FILIAL"                + cEol
	cQuery += " AND SC6.C6_NUM = SC5.C5_NUM"                      + cEol
	cQuery += " AND SC6.C6_BLQ <> 'R ' "                          + cEol
	cQuery += " AND SC6.D_E_L_E_T_ <> '*'"                        + cEol
	cQuery += " AND SA3.A3_FILIAL = '  '"                         + cEol
	cQuery += " AND SA3.A3_COD = SC5.C5_VEND1"                    + cEol
	cQuery += " AND SA3.D_E_L_E_T_ <> '*'"                        + cEol
	cQuery += " AND SF4.F4_FILIAL = '  '"                         + cEol
	cQuery += " AND SF4.F4_CODIGO = SC6.C6_TES"                   + cEol
	cQuery += " AND SF4.F4_DUPLIC = 'S'"                          + cEol
	cQuery += " AND SF4.D_E_L_E_T_ <> '*'"                        + cEol
	cQuery += " GROUP BY SA3.A3_GRPREP, SA3.A3_COD, SA3.A3_SUPER" + cEol

	cQuery += " UNION ALL" + cEol

	cQuery += " SELECT SA3.A3_GRPREP GRUPO, SA3.A3_COD VEND, SA3.A3_SUPER SUPER, 0 TOTPREV, 0 TOTVDIA, SUM(C6_VALOR) TOTVMES, COUNT(DISTINCT(C6_NUM)) QTDPED" + cEol
	cQuery += " FROM " + RetSqlName("SC5") + " SC5, " + RetSqlName("SC6") + " SC6, " + RetSqlName("SA3") + " SA3, " + RetSqlName("SF4") + " SF4" + cEol
	cQuery += " WHERE SC5.C5_TIPO NOT IN ('D','B')" + cEol
	cQuery += " AND SC5.C5_EMISSAO BETWEEN '" + DtoS( MV_PAR01 ) + "' AND '" + DtoS( MV_PAR02 ) + "'" + cEol
	///// cQuery += " AND SC5.C5_VEND1 = '"+cCodRep+"'"+cEol EM 300610
	cQuery += " AND SC5.C5_VEND1 IN ('" + cCodRep + "')"          + cEol
	cQuery += " AND SC5.D_E_L_E_T_ <> '*'"                        + cEol
	cQuery += " AND SC6.C6_FILIAL = SC5.C5_FILIAL"                + cEol
	cQuery += " AND SC6.C6_NUM = SC5.C5_NUM"                      + cEol
	cQuery += " AND SC6.C6_BLQ = 'R ' "                           + cEol
	cQuery += " AND SC6.C6_QTDENT >= SC6.C6_QTDVEN "              + cEol
	cQuery += " AND SC6.C6_NOTA  <> ' ' "                         + cEol
	cQuery += " AND SC6.D_E_L_E_T_ <> '*'"                        + cEol
	cQuery += " AND SA3.A3_FILIAL = '  '"                         + cEol
	cQuery += " AND SA3.A3_COD = SC5.C5_VEND1"                    + cEol
	cQuery += " AND SA3.D_E_L_E_T_ <> '*'"                        + cEol
	cQuery += " AND SF4.F4_FILIAL = '  '"                         + cEol
	cQuery += " AND SF4.F4_CODIGO = SC6.C6_TES"                   + cEol
	cQuery += " AND SF4.F4_DUPLIC = 'S'"                          + cEol
	cQuery += " AND SF4.D_E_L_E_T_ <> '*'"                        + cEol
	cQuery += " GROUP BY SA3.A3_GRPREP, SA3.A3_COD, SA3.A3_SUPER" + cEol
	cQuery += " ) AGRUPA1"                                        + cEol
	cQuery += " GROUP BY GRUPO, VEND, SUPER"                      + cEol
	
	cQuery += " UNION ALL" + cEol
	
	// Busca as Vendas do Dia
	cQuery += " SELECT SA3.A3_GRPREP GRUPO, SA3.A3_COD VEND, SA3.A3_SUPER SUPER, 0 TOTPREV, SUM(C6_VALOR) TOTVDIA, 0 TOTVMES, 0 QTDPED" + cEol
	cQuery += " FROM " + RetSqlName("SC5") + " SC5, " + RetSqlName("SC6") + " SC6, " + RetSqlName("SA3") + " SA3, " + RetSqlName("SF4") + " SF4" + cEol
	cQuery += " WHERE SC5.C5_TIPO NOT IN ('D','B')"               + cEol
	cQuery += " AND SC5.C5_EMISSAO = '" + DtoS(MV_PAR03) + "'"    + cEol
	///// cQuery += " AND SC5.C5_VEND1 = '"+cCodRep+"'"+cEol EM 300610
	cQuery += " AND SC5.C5_VEND1 IN ('" + cCodRep + "')"          + cEol
	cQuery += " AND SC5.D_E_L_E_T_ <> '*'"                        + cEol
	cQuery += " AND SC6.C6_FILIAL = SC5.C5_FILIAL"                + cEol
	cQuery += " AND SC6.C6_NUM = SC5.C5_NUM"                      + cEol
	cQuery += " AND SC6.C6_BLQ <> 'R ' "                          + cEol
	cQuery += " AND SC6.D_E_L_E_T_ <> '*'"                        + cEol
	cQuery += " AND SA3.A3_FILIAL = '  '"                         + cEol
	cQuery += " AND SA3.A3_COD = SC5.C5_VEND1"                    + cEol
	cQuery += " AND SA3.D_E_L_E_T_ <> '*'"                        + cEol
	cQuery += " AND SF4.F4_FILIAL = '  '"                         + cEol
	cQuery += " AND SF4.F4_CODIGO = SC6.C6_TES"                   + cEol
	cQuery += " AND SF4.F4_DUPLIC = 'S'"                          + cEol
	cQuery += " AND SF4.D_E_L_E_T_ <> '*'"                        + cEol
	cQuery += " GROUP BY SA3.A3_GRPREP, SA3.A3_COD, SA3.A3_SUPER" + cEol
	
	//	cQuery += " UNION ALL"+cEol
	
	// Busca a Quantidade de Pedidos
	/*
	cQuery += " SELECT SA3.A3_GRPREP GRUPO, SA3.A3_COD VEND, SA3.A3_SUPER SUPER, 0 TOTPREV, 0 TOTVDIA, 0 TOTVMES, COUNT(*) QTDPED" + cEol
	cQuery += " FROM "+RetSqlName("SC5") + " SC5, " + RetSqlName("SA3") + " SA3" + cEol
	///cQuery += " WHERE SC5.C5_FILIAL = '01'" + cEol
	cQuery += " WHERE SC5.C5_TIPO NOT IN ('D','B')" + cEol
	cQuery += " AND SC5.C5_EMISSAO BETWEEN '" + DtoS(MV_PAR01) + "' AND '" + DtoS(MV_PAR02) + "'" + cEol
	cQuery += " AND SC5.C5_VEND1 = '" + cCodRep + "'" + cEol
	cQuery += " AND SC5.D_E_L_E_T_ <> '*'" + cEol
	cQuery += " AND SA3.A3_FILIAL = '  '" + cEol
	// cQuery += " AND SA3.A3_GRPREP BETWEEN '" + MV_PAR04 + "' AND '" + MV_PAR05 + "' "  // Parametro de grupo de/ate - Daniel
	cQuery += " AND SA3.A3_COD = SC5.C5_VEND1" + cEol
	cQuery += " AND SA3.D_E_L_E_T_ <> '*'" + cEol
	cQuery += " AND ( SELECT COUNT(*) FROM SC6020 SC6, SF4020 SF4 WHERE SC6.C6_FILIAL = SC5.C5_FILIAL" + cEol
	cQuery += "	AND SC6.C6_NUM = SC5.C5_NUM" + cEol
	cQuery += " AND SC6.C6_BLQ <> 'R ' " + cEol
	cQuery += " AND SC6.D_E_L_E_T_ <> '*'" + cEol
	cQuery += " AND SF4.F4_FILIAL = '  '" + cEol
	cQuery += " AND SF4.F4_CODIGO = SC6.C6_TES" + cEol
	cQuery += " AND SF4.F4_DUPLIC = 'S'" + cEol
	cQuery += " AND SF4.D_E_L_E_T_ <> '*') > 0" + cEol
	cQuery += " GROUP BY SA3.A3_GRPREP, SA3.A3_COD, SA3.A3_SUPER" + cEol
	*/
	cQuery += " ) GERAL" + cEol
	cQuery += " GROUP BY GRUPO, VEND, SUPER" + cEol
	cQuery += " ORDER BY GRUPO, VEND, SUPER" + cEol
	
	//cQuery := ChangeQuery(cQuery)
	
	//MemoWrite( "\QUERYSYS\EFATC01.SQL", cQuery )
	
	DbUseArea( .t., "TOPCONN", TcGenQry(,,cQuery), "QUERY", .t., .f. )
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta uma matriz para tratar as informacoes pra se manter informado. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectArea('QUERY')
	DbGoTop()
	
   //	If Eof() //Fernando
	 //	msgStop ("Não tem registro....")
  //	EndIf
	
	
	If !Eof()
		cGrupo  := AllTrim( QUERY->GRUPO ) + " - " + AllTrim( Posicione("ACA", 1, xFilial("ACA") + QUERY->GRUPO,"ACA_DESCRI" ) )
		cVend   := AllTrim( cCodRepPr )    + " - " + AllTrim( Posicione("SA3", 1, xFilial("SA3") + QUERY->VEND ,"A3_NOME"    ) )

		While !Eof()
			nTotPrev+= QUERY->TOTPREV
			nTotVDia+= QUERY->TOTVDIA
			nTotVMes+= QUERY->TOTVMES
			nQtdPed += QUERY->QTDPED
			DbSkip()
		EndDo	
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Calcula o Total de dias uteis e ate a data. ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nQtdUteis:= 0
		nQtdUtAtu:= 0
		dDtProc  := MV_PAR01

 		// Dias uteis entre datas
		While dDtProc <= MV_PAR02
			dDtValid:= DataValida( dDtProc, .t. )
			If dDtValid == dDtProc
				nQtdUteis ++
				If dDtProc <= MV_PAR03
					nQtdUtAtu ++
				EndIf
			EndIf
			dDtProc ++
		EndDo
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Calcula a variação Prevista e Realizada. ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nPercPrev:= ( 100 / nQtdUteis ) * nQtdUtAtu
		
		If nTotPrev > 0
			nPercReal:= ( nTotVMes / nTotPrev ) * 100
		Else
			nPercReal:= 0
		EndIf
		
		DEFINE MSDIALOG oDlg TITLE OemToAnsi( "Posição de Vendas do mês - Potencial x Realizada" ) FROM 100,000 TO 350,600 PIXEL
		
		@ 002,002 TO 098,298 OF oDlg PIXEL
		
		@ 010,010 Say OemToAnsi("Grupo : "                       ) Size 050,07 Of oDlg Pixel
		@ 010,087 Say cGrupo 									   Size 200,10 Of oDlg Pixel
		
		@ 020,010 Say OemToAnsi("Representante : "               ) Size 050,07 Of oDlg Pixel
		@ 020,087 Say cVend 									   Size 200,10 Of oDlg Pixel
		
		@ 030,010 Say OemToAnsi("Potencial Mês / Dia : "         ) Size 050,07 Of oDlg Pixel
		@ 030,087 Say TransForm( nTotPrev,"@E 999,999,999") + " /" + TransForm( nTotPrev/nQtdUteis, "@E 999,999,999" )	Size 150,10 Of oDlg Pixel
		
		@ 040,010 Say OemToAnsi("Tot. Vendas Dia : "             ) Size 050,07 Of oDlg Pixel
		@ 040,087 Say nTotVDia  Picture "@E 999,999,999"	  	   Size 050,10 Of oDlg Pixel
		
		@ 050,010 Say OemToAnsi("Tot. Vendas Mês : "             ) Size 050,07 Of oDlg Pixel
		@ 050,087 Say nTotVMes Picture "@E 999,999,999"	      	   Size 050,10 Of oDlg Pixel
		
		@ 060,010 Say OemToAnsi("Prev. x Realiz. - até a data : ") Size 100,07 Of oDlg Pixel
		@ 060,087 Say TransForm( nPercPrev,"@E 99,999") + "% /" + TransForm( nPercReal, "@E 99,999"                  ) + "%" Size 150,10 Of oDlg Pixel
		
		@ 070,010 Say OemToAnsi("Qtd. Pedidos : "                ) Size 050,07 Of oDlg Pixel
		@ 070,087 Say nQtdPed Picture "@E 999,999,999"			   Size 050,10 Of oDlg Pixel
		
		@ 080,010 Say OemToAnsi("Dias Úteis - Mês / Até data : " ) Size 080,07 Of oDlg Pixel
		@ 080,087 Say TransForm( nQtdUteis, "@E 999"             ) + " /" + TransForm( nQtdUtAtu, "@E 999"           ) Size 150,10 Of oDlg Pixel
		
		DEFINE SBUTTON FROM 100,250 TYPE 1 ACTION( nOpc := 1, oDlg:End() ) ENABLE OF oDlg
		
		ACTIVATE MSDIALOG oDlg CENTERED
		
	EndIf
	
	DbSelectArea("QUERY")
	DbCloseArea()
	
EndIf

RestArea(aArea)

Return