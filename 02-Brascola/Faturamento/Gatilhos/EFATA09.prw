/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Rdmake    ³ EFATA09  ³ Autor ³ Evaldo V. Batista     ³ Data ³ 11/06/2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Validador do campo C6_QTDLIB, nao permitir liberacao de     ³±±
±±³          ³ quantidade superior a quantidade disponivel                 ³±±
±±³          ³ Saldo Atual - Reserva                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico Brascola                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Alteracao 15.09.05 para nao controlar B8 quando o produto³
//³nao possui lote -Daniel Pelegrinelli                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function EFATA09()

Local lRet 			:= .T. //Retorno da Funcao
Local nPosQtdLib 	:= aScan( aHeader, {|x| Upper(AllTrim(x[2])) == 'C6_QTDLIB' } ) // Quantidade Liberada
Local nPosCodPro 	:= aScan( aHeader, {|x| Upper(AllTrim(x[2])) == 'C6_PRODUTO' } ) // Codigo do Produto
Local nPosLocPro 	:= aScan( aHeader, {|x| Upper(AllTrim(x[2])) == 'C6_LOCAL' } )  //Local / Armazem
Local nPosQtdVen 	:= aScan( aHeader, {|x| Upper(AllTrim(x[2])) == 'C6_QTDVEN' } )  //Quantidade Vendida
Local nQtdLib		:= M->C6_QTDLIB
Local cQuery 		:= ""
Local cAliasTmp		:= "TMPSB8"
Local cAliasAtu		:= Alias()
Local cLote         := .F.      //Daniel Neves - Verifica apenas b8 quando possui controle de lote

If nPosQtdLib > 0 .and. nPosCodPro > 0 .and. nPosLocPro > 0 .and. nPosQtdVen > 0 .and. nQtdLib > 0
	//Posiciona o Produto
	SB1->( dbSetOrder( 1 ) )
	If SB1->B1_COD <> aCols[n,nPosCodPro] //Verifica se precisa posicionar no produto
		SB1->( dbSeek( xFilial('SB1') + aCols[n,nPosCodPro], .T. ) )
		IF SB1->B1_RASTRO <> "N" // Daniel
			cLote := .T.
		ENDIF
	ELSE
		IF SB1->B1_RASTRO <> "N"
			cLote := .T.
		ENDIF
	EndIf
	//Posiciona no Produto e Armazem
	SB2->( dbSetOrder( 1 ) )
	//Testa se o Armazem informado existe
	If SB2->( dbSeek( xFilial('SB2') + aCols[n, nPosCodPro] + aCols[n, nPosLocPro], .T. ) )
		//Verifica Saldo Disponível
		If ((SB2->B2_QATU - SB2->B2_RESERVA) - SB2->B2_QEMP) < nQtdLib
			MsgAlert( "O Produto ("+AllTrim(aCols[n,nPosCodPro])+") não tem saldo suficiente para a Reserva informada: "+;
			Chr(13)+Chr(10)+"Quantidade Disponível.: " + TransForm( ((SB2->B2_QATU - SB2->B2_RESERVA) - SB2->B2_QEMP), "@E 999,999,999,999.99")+;
			Chr(13)+Chr(10)+"Quantidade Reservada..: " + TransForm( SB2->B2_RESERVA, "@E 9,999,999,999.99")+;
			Chr(13)+Chr(10)+"Quantidade Empenhada..: " + TransForm( SB2->B2_QEMP, "@E 9,999,999,999.99")+;
			Chr(13)+Chr(10)+"Quantidade Vendida....: " + TransForm( aCols[n, nPosQtdVen], "@E 9,999,999,999.99")+;
			Chr(13)+Chr(10)+"Qtd. a Liberar........: " + TransForm( nQtdLib, "@E 9,999,999,999.99"),;
			"Saldo Insuficiente..." )
			lRet := .F.
		EndIf
	Else
		//Não existe o armazem para este produto
		MsgInfo("Local especificado (" + aCols[n,nPosLocPro] + ") Não Existe para este Produto ("+AllTrim(aCols[n, nPosCodPro])+")", "Armazem Incorreto...")
		lRet := .F.
	EndIf
EndIf

If lRet .and. cLote
	cQuery := " SELECT SUM( SB8.B8_SALDO - SB8.B8_EMPENHO ) AS SALDOLOTE "
	cQuery += " 	FROM "+RetSqlName( "SB8" ) + " SB8 "
	cQuery += " 	WHERE SB8.D_E_L_E_T_ <> '*' "
	cQuery += " 		AND SB8.B8_FILIAL = '" + xFilial("SB8") + "'"
	cQuery += "  		AND SB8.B8_PRODUTO = '" + aCols[n, nPosCodPro] + "'"
	cQuery += "  		AND SB8.B8_LOCAL = '" + aCols[n, nPosLocPro] + "'"
	cQuery += "  		AND SB8.B8_DTVALID >= '" + DtoS(dDataBase) + "'"
	dbUseArea( .T., "TOPCONN", TcGenQry(,, cQuery), cAliasTmp, .F., .F. )
	(cAliasTmp)->( dbGoTop() )
	If (cAliasTmp)->SALDOLOTE < nQtdLib
		MsgAlert( "Não há saldo em Lote disponível para o produto ("+AllTrim(aCols[n,nPosCodPro])+") "+;
		Chr(13)+Chr(10)+"Qtd. em Lote Disponível.: " + TransForm( (cAliasTmp)->SALDOLOTE, "@E 999,999,999,999.99")+;
		Chr(13)+Chr(10)+"Qtd. a Liberar.................: " + TransForm( nQtdLib, "@E 9,999,999,999.99"),;
		"LOTE com saldo insuficiente..." )
		lRet := .F.
	EndIf
	(cAliasTmp)->( dbCloseArea() )
EndIf

dbSelectArea( cAliasAtu )

Return( lRet )