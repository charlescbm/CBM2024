#Include "topconn.CH"
#Include "Colors.ch"
#Include "Protheus.CH"
/*
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������ͻ��
��� Programa    � RFATR10  � Relat�rio de pedidos rejeitados.                             ���
���             �          �                                                              ���
���             �          �                                                              ���
�����������������������������������������������������������������������������������������͹��
��� Solicitante � 17.10.05 � Michele                                                      ���
�����������������������������������������������������������������������������������������͹��
��� Autor       � 18.10.05 � Almir Bandina                                                ���
�����������������������������������������������������������������������������������������͹��
��� Produ��o    � 99.99.99 � Ignorado                                                     ���
�����������������������������������������������������������������������������������������͹��
��� Par�metros  � Nil                                                                     ���
�����������������������������������������������������������������������������������������͹��
��� Retorno     � Nil                                                                     ���
�����������������������������������������������������������������������������������������͹��
��� Observa��es �                                                                         ���
���             �                                                                         ���
�����������������������������������������������������������������������������������������͹��
��� Altera��es  � 99/99/99 - Consultor - Descricao da altera��o                           ���
���             �                                                                         ���
�����������������������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
*/
User Function RFATR10()

Local aAreaAtu	:= GetArea()
Local aRegs		:= {}
Local aOrd		:= {}
Local aDadImp	:= {}
Local cPerg		:= Padr( 'FATR10', Len( SX1->X1_GRUPO ) )
Local cDesc1	:= "Este programa tem como objetivo imprimir uma relacao que mostra os pedidos que"
Local cDesc2	:= "est�o com pend�ncias financeiras de acordo com seu status."
Local cDesc3	:= ""
Local cString	:= "SC9"

Private Tamanho := "G"
Private limite	:= 220
Private wnRel	:= "RFATR10"
Private NomeProg:= "RFATR10"									// Nome do programa
Private aReturn	:= {"Branco", 1,"Financeiro", 2, 2, 1, "",1 }
Private nTipo	:= If(aReturn[4]==1,15,18)
Private nLastKey:= 0
Private m_Pag	:= 1
Private lEnd	:= .F.
Private Titulo	:= "Pedidos Bloqueados/Rejeitados"
Private Cabec0	:= titulo
Private Cabec1	:= "Relacao de pedidos bloqueados e/ou rejeitados pelo credito"
Private Cabec2	:= " "
Private nLin	:= 80
Private cbCont  := 0											// Tamanho do rodap�
Private cbTxt   := ""											// Texto do rodap�
Private cCodRep := ''

// Monta array com as perguntas
aAdd(aRegs,{ cPerg,"01","Vendedor Inicial",		"","","mv_ch1","C",06,0,0,"G","","MV_PAR01","",			"","","",				"","",			"","","","","","","","","","","","","","","","","","","SA3","","","","","" } )
aAdd(aRegs,{ cPerg,"02","Vendedor Final",		"","","mv_ch2","C",06,0,0,"G","","MV_PAR02","",			"","","zzzzzz",			"","",			"","","","","","","","","","","","","","","","","","","SA3","","","","","" } )
aAdd(aRegs,{ cPerg,"03","Pedido Inicial",		"","","mv_ch3","C",06,0,0,"G","","MV_PAR03","",			"","","",				"","",			"","","","","","","","","","","","","","","","","","","SC5","","","","","" } )
aAdd(aRegs,{ cPerg,"04","Pedido Final",			"","","mv_ch4","C",06,0,0,"G","","MV_PAR04","",			"","","zzzzzz",			"","",			"","","","","","","","","","","","","","","","","","","SC5","","","","","" } )
aAdd(aRegs,{ cPerg,"05","Cliente Inicial",		"","","mv_ch5","C",06,0,0,"G","","MV_PAR05","",			"","","",	 			"","",			"","","","","","","","","","","","","","","","","","","SA1","","","","","" } )
aAdd(aRegs,{ cPerg,"06","Loja Inicial",			"","","mv_ch6","C",02,0,0,"G","","MV_PAR06","",			"","","",				"","",			"","","","","","","","","","","","","","","","","","","",	"","","","","" } )
aAdd(aRegs,{ cPerg,"07","Cliente Final",		"","","mv_ch7","C",06,0,0,"G","","MV_PAR07","",			"","","zzzzzz",			"","",			"","","","","","","","","","","","","","","","","","","SA1","","","","","" } )
aAdd(aRegs,{ cPerg,"08","Loja Final",			"","","mv_ch8","C",02,0,0,"G","","MV_PAR08","",			"","","zz",				"","",			"","","","","","","","","","","","","","","","","","","",	"","","","","" } )
aAdd(aRegs,{ cPerg,"09","Dt.Entrega Inicial",	"","","mv_ch9","D",08,0,0,"G","","MV_PAR09","",			"","","01/01/05",		"","",			"","","","","","","","","","","","","","","","","","","",	"","","","","" } )
aAdd(aRegs,{ cPerg,"10","Dt.Entrega Final", 	"","","mv_cha","D",08,0,0,"G","","MV_PAR10","",			"","","31/12/05",		"","",			"","","","","","","","","","","","","","","","","","","",	"","","","","" } )
aAdd(aRegs,{ cPerg,"11","Dt.Emissao Inicial",	"","","mv_chb","D",08,0,0,"G","","MV_PAR11","",			"","","01/01/05",		"","",			"","","","","","","","","","","","","","","","","","","",	"","","","","" } )
aAdd(aRegs,{ cPerg,"12","Dt.Emissao Final", 	"","","mv_chc","D",08,0,0,"G","","MV_PAR12","",			"","","31/12/05",		"","",			"","","","","","","","","","","","","","","","","","","",	"","","","","" } )
aAdd(aRegs,{ cPerg,"13","Produto Inicial",		"","","mv_chd","C",15,0,0,"G","","MV_PAR13","",			"","","",				"","",			"","","","","","","","","","","","","","","","","","","SB1","","","","","" } )
aAdd(aRegs,{ cPerg,"14","Produto Final",		"","","mv_che","C",15,0,0,"G","","MV_PAR14","",			"","","zzzzzzzzzzzzzzz","","",			"","","","","","","","","","","","","","","","","","","SB1","","","","","" } )
aAdd(aRegs,{ cPerg,"15","Tipo Relat�rio",		"","","mv_chf","N",01,0,0,"C","","MV_PAR15","Analitico","","","",				"","Sintetico",	"","","","","","","","","","","","","","","","","","","",  	"","","","","" } )

// Cria as perguntas
U_CriaSX1( aRegs )

Pergunte( cPerg, .f.)

//��������������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT                        �
//����������������������������������������������������������������
wnRel := SetPrint( cString, wnrel, cPerg, @titulo, cDesc1, cDesc2, cDesc3, .F., aOrd,, Tamanho )

If nLastKey == 27
	dbClearFilter()
	Return Nil
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	dbClearFilter()
	Return Nil
Endif

// Verifica se o usuario for um vendedor, for�ar filtrar apenas os pedidos dele
////dbSelectArea("SA3")
////dbSetOrder(7)
////If MsSeek(xFilial("SA3")+__cUserId)
////	mv_par01	:= SA3->A3_COD
////	mv_par02	:= SA3->A3_COD
////EndIf

DbSelectArea("SA3")
DbSetOrder(7)

If DbSeek( xFilial("SA3") + __cUserId, .f. )
	While !Eof() .And. ( AllTrim( __cUserId ) == AllTrim( A3_CODUSR ) )
		If A3_TIPO <> 'I'
			cCodRep+= A3_COD + "','"
		EndIf	
		DbSkip()
	EndDo	
	cCodRep:= Subst( cCodRep, 1, Len ( cCodRep ) - 3 ) 
EndIf	

If mv_par15 == 1
	Cabec1+= " - Analitico"
Else
	Cabec1+= " - Sintetico"
EndIf

Processa({ |lEnd| CallData(@aDadImp) }, "Selecionando Registros" )

//����������������������������������Ŀ
//�Chama funcao que imprime os dados �
//������������������������������������
If !lEnd
	If Len(aDadImp) > 0
		RptStatus({ |lEnd| RunImp(@lEnd,aOrd,Tamanho,aDadImp) }, titulo)
	Else
		Aviso(	Titulo,;
		"N�o existem dados a serem impressos.",;
		{"&Continua"},,;
		"Sem Dados" )
	EndIf
EndIf

Return(Nil)

******************************************************************************************************
Static Function RunImp( lEnd, aOrd, Tamanho, aDadImp )
******************************************************************************************************
Local cRodaTxt	:= ""
Local aArAtu	:= GetArea()
Local aArSC5	:= SC5->(GetArea())
Local aArSC9	:= SC9->(GetArea())
Local aArSA1	:= SA1->(GetArea())
Local aResVend	:= {}
Local nElem		:= 0
Local iX			:= 0
Local cVendAtu	:= ""
Local cPedAtu	:= ""
//Local cCodAtu	:= ""
Local cCodBlq	:= ""
Local nTotVend	:= 0
Local nTotPedi	:= 0
Local nTotGera	:= 0
Local lVendNovo	:= .f.
Local Cabec3	:= ""

If mv_par15 == 1
	//	//Cliente   Nome Fantasia        Pedido    Bloqueio           Situacao do Pedido                          Produto                                         Emissao  Entrega     Valor Pedido
	//	//XXXXXX-XX XXXXXXXXXXWWWWWWWWWW XXXXXX XX XX XXXXXXXXXXWWWWW XX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXX XXXXXXXXXXWWWWWWWWWWXXXXXXXXXX 99/99/99 99/99/99 9,999,999,999.99
	//	//01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	//	//         10        20        30        40        50        60        70        80        90        100       110       120       130      140       150       160       170       180       190       200       210       220
	//	Cabec3	:= "Cliente   Nome Fantasia        Pedido    Bloqueio           Situacao do Pedido                          Produto                                         Emissao  Entrega     Valor Pedido"
	//Cliente   Nome Fantasia        Pedido    Rejeicao                                    Produto                                         Emissao  Entrega     Valor Pedido
	//XXXXXX-XX XXXXXXXXXXWWWWWWWWWW XXXXXX XX XX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXX XXXXXXXXXXWWWWWWWWWWXXXXXXXXXX 99/99/99 99/99/99 9,999,999,999.99
	//01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	//         10        20        30        40        50        60        70        80        90        100       110       120       130      140       150       160       170       180       190       200       210       220
	Cabec3	:= "Cliente         Nome Fantasia        Pedido                                          Produto                                         Emissao              Valor Pedido"
Else
	//	//Bloqueio           Situacao do Pedido                              Valor Pedido
	//	//XX XXXXXXXXXXWWWWW XX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 9,999,999.999999
	//	//01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	//	//         10        20        30        40        50        60        70        80        90        100       110       120       130      140       150       160       170       180       190       200       210       220
	//	Cabec3	:= "Bloqueio           Situacao do Pedido                              Valor Pedido"
	//Cliente   Nome Fantasia        Pedido    Situacao do Pedido                           Emissao  Entrega     Valor Pedido
	//XXXXXX-XX XXXXXXXXXXWWWWWWWWWW XXXXXX XX XX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 99/99/99 99/99/99 9,999,999,999.99
	//Situacao do Pedido                              Valor Pedido"
	//XX XXXXXXXXXXWWWWWWWWWWXXXXXXXXXXWWWWWWWWWW 9,999,999,999.99
	//01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	//         10        20        30        40        50        60        70        80        90        100       110       120       130      140       150       160       170       180       190       200       210       220
	Cabec3	:= "Cliente         Nome Fantasia        Pedido                                           Emissao              Valor Pedido"
	Tamanho	:= "M"
	limite	:= 132
	
EndIf

SetRegua( Len(aDadImp) )

For iX:= 1 to Len( aDadImp )
	
	IncRegua( "Imprimindo dados" )
	
	If nLin > 52
		nLin:= Cabec( Cabec0, PadC( Cabec1, Limite ), PadC( Cabec2, Limite ), NomeProg, Tamanho, nTipo ) + 1
	EndIf
	
	If cVendAtu <> aDadImp[ix][1]
		// Imprime os dados do pedido
		If mv_par15 == 2 .and. nTotPedi > 0
			@ nlin, 000 Psay cCliAtu + "-" + cLojAtu
			@ nlin, 010 Psay cRazAtu
			@ nlin, 031 Psay cPedAtu
			//@ nlin, 041 Psay cCodAtu
			//@ nlin, 044 Psay u_RetDesRej( cCodAtu )
			@ nlin, 085 Psay StoD( cEmiAtu )
			//@ nlin, 094 PSay StoD( cEntAtu )
			@ nLin, 103 Psay nTotPedi Picture "@E 9,999,999,999.99"
			nlin++
			nTotPedi:= 0
		EndIf
		
		If nTotVend > 0
			If nLin > 52
				nLin:= Cabec( Cabec0, PadC( Cabec1, Limite ),PadC( Cabec2, Limite ), NomeProg, Tamanho, nTipo ) + 1
			EndIf
			
			@ nlin, 000 Psay __PrtThinLine()
			nlin++
			
			@ nlin, 000 Psay "Total do vendedor "

			If mv_par15 == 1
				@ nlin, 150 Psay nTotVend Picture "@E 9,999,999,999.99"
			Else
				@ nlin, 103 Psay nTotVend Picture "@E 9,999,999,999.99"
			EndIf
			
			nlin+= 2
			
			nTotVend:= 0
			
			If Len(aResVend) > 0
				// Imprime o resumo
				@ nlin,(Limite/2)-30 Psay "Resumo do Vendedor "+ cVendAtu
				nlin++
				@ nlin,(LImite/2)-30 Psay Replic("-",60)
				nlin++
				@ nlin,(Limite/2)-30 Psay "Situacao do Pedido                              Valor Pedido"
				nlin++
				
				For nLoop := 1 To Len(aResVend)
					@ nlin, (Limite/2)-30    Psay aResVend[nLoop,1]+" "+u_RetDesRej(aResVend[nLoop,1])
					@ nlin, (limite/2)-30+44 Psay Transform(aResVend[nLoop,2], "@E 9,999,999,999.99")
					nlin++
				Next nLoop
				nlin+= 2
			EndIf

			// Zera array para o pr�ximo vendedor
			aResVend	:= {}

		EndIf

		@ nlin, 000 Psay "Vendedor "+aDadImp[ix][1]+" - "+Posicione("SA3",1,xFilial("SA3")+aDadImp[ix][1],"A3_NOME")
		nLin++
		@ nlin, 000 Psay Cabec3
		nlin++
		@ nlin, 000 Psay __PrtThinLine()
		nlin++
	Else
		// Imprime os dados do pedido
		If mv_par15 == 2 .and. nTotPedi > 0 .and. cPedAtu <> aDadImp[ix][5]
			@ nlin, 000 Psay cCliAtu + "-" + cLojAtu
			@ nlin, 010 Psay cRazAtu
			@ nlin, 031 Psay cPedAtu
			//@ nlin, 041 Psay cCodAtu
			//@ nlin, 044 Psay u_RetDesRej( cCodAtu )
			@ nlin, 085 Psay StoD( cEmiAtu )
			//@ nlin, 094 PSay StoD( cEntAtu )
			@ nLin, 103 Psay nTotPedi Picture "@E 9,999,999,999.99"
			nlin++
			nTotPedi:= 0
		EndIf
	EndIf
	 
	If mv_par15 == 1  	// Analitico
		@ nlin, 000 Psay aDadImp[ix][2] + "-" + aDadImp[ix][3]//cliente - loja
		@ nlin, 010 Psay aDadImp[ix][4]//nome reduzido
		@ nlin, 031 Psay aDadImp[ix][5]//nr pedido
		@ nLin, 038 Psay aDadImp[ix][7]//item
		//@ nlin, 041 Psay aDadImp[ix][7]
		//@ nlin, 044 Psay u_RetDesRej( aDadImp[ix][7] )
		@ nLin, 085 Psay AllTrim( aDadImp[ix][10] ) + " " + SubStr( aDadImp[ix][12], 1, 30 ) //Produto + Descricao
		@ nlin, 132 Psay StoD( aDadImp[ix][8] )//Emiss�o
		//@ nlin, 141 Psay StoD( aDadImp[ix][10] )//C9_Entrega
		@ nLin, 150 Psay aDadImp[ix][9] Picture "@E 9,999,999,999.99"//Total
		nlin++
	EndIf

	// Pega dados atuais
	cVendAtu:= aDadImp[ix][1]
	cCliAtu	:= aDadImp[ix][2]
	cLojAtu	:= aDadImp[ix][3]
	cRazAtu	:= aDadImp[ix][4]
	cPedAtu	:= aDadImp[ix][5]
	cCodBlq	:= aDadImp[ix][6]
	//cCodAtu	:= aDadImp[ix][7]
	cEmiAtu	:= aDadImp[ix][8]
	//cEntAtu	:= aDadImp[ix][15]

	// Acumula os totalizadores
	nTotVend+= aDadImp[ix][9]
	nTotPedi+= aDadImp[ix][9]
	nTotGera+= aDadImp[ix][9]

    /*
	//Monta array com o resumo por motivo de rejei��o do vendedor
	nElem:= aScan( aResVend, { |x| x[1] == cCodAtu } )
	If nElem == 0
		aAdd ( aResVend, { cCodAtu, aDadImp[ix][9] } )
	Else
		aResVend[ nElem][2]+= aDadImp[ix][9]
	EndIf */
Next

// Imprime os dados do �ltimo vendedor
If mv_par15 == 2 .and. nTotPedi > 0
	@ nlin, 000 Psay cCliAtu+"-"+cLojAtu
	@ nlin, 010 Psay cRazAtu
	@ nlin, 031 Psay cPedAtu
	//@ nlin, 041 Psay cCodAtu
	//@ nlin, 044 Psay u_RetDesRej(cCodAtu)
	@ nlin, 085 Psay SToD(cEmiAtu)
	//@ nlin, 094 PSay SToD(cEntAtu)
	@ nLin, 103 Psay nTotPedi Picture "@E 9,999,999,999.99"
	nlin++
EndIf

If nTotVend > 0
	If nLin > 52
		nLin:= Cabec(Cabec0,PadC(Cabec1,Limite),PadC(Cabec2,Limite),NomeProg,Tamanho,nTipo)+1
	EndIf
	
	@ nlin, 000 Psay __PrtThinLine()
	nlin++
 
	@ nlin,000 Psay "Total do vendedor "

	If mv_par15 == 1
		@ nlin,150 Psay nTotVend Picture "@E 9,999,999,999.99"
	Else
		@ nlin,103 Psay nTotVend Picture "@E 9,999,999,999.99"
	EndIf

	nlin+= 2

	// Imporime o resumo do �ltimo vendedor
	If Len( aResVend ) > 0
		// Imprime o resumo
		@ nlin,(Limite/2)-30 Psay "Resumo do Vendedor "+ cVendAtu
		nlin++
		@ nlin,(LImite/2)-30 Psay Replic("-",60)
		nlin++
		@ nlin,(Limite/2)-30 Psay "Situacao do Pedido                              Valor Pedido"
		nlin++
		For nLoop:= 1 To Len(aResVend)
			@ nlin,(Limite/2)-30    Psay aResVend[nLoop,1]//+" "+u_RetDesRej(aResVend[nLoop,1])
			@ nlin,(Limite/2)-30+44 Psay Transform(aResVend[nLoop,2], "@E 9,999,999,999.99")
			nlin++
		Next nLoop
		nlin+= 2
	EndIf
EndIf

// Imprime o total geral
If nTotGera > 0
	If nLin > 52
		nLin:= Cabec( Cabec0, PadC( Cabec1, Limite ), PadC( Cabec2, Limite ), NomeProg, Tamanho, nTipo ) + 1
	EndIf
	
	@ nlin, 000 Psay __PrtThinLine()
	nlin++
	@ nlin,000 Psay "Total do Geral"
	If mv_par15 == 1
		@ nlin,150 Psay nTotGera Picture "@E 9,999,999,999.99"
	Else
		@ nlin,103 Psay nTotGera Picture "@E 9,999,999,999.99"
	EndIf
	nlin++
	@ nlin, 000 Psay __PrtThinLine()
	nlin++
EndIf

Roda(CbCont, cRodaTxt, Tamanho)

If aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
Endif

MS_FLUSH()

RestArea(aArSC5)
RestArea(aArSC9)
RestArea(aArSA1)
RestArea(aArAtu)

Return Nil

******************************************************************************************************
Static Function CallData(aDadImp)
******************************************************************************************************
Local aArea	 := GetArea()
Local cQuery := ""
Local cSelect:= "SELECT "
Local cFrom	 := "FROM "
Local cWhere := "WHERE "
Local cGroup := "GROUP BY "
Local cOrder := "ORDER BY "

// ATEN��O - n�o se pode mudar a ordem so select, pois � utilizado na impress�o a mesma ordem.    

cSelect	+= " SC5.C5_VEND1,SC9.C9_CLIENTE,SC9.C9_LOJA,SA1.A1_NREDUZ,SC9.C9_PEDIDO,SC9.C9_BLCRED, "
cSelect	+= " SC9.C9_ITEM,SC5.C5_EMISSAO,CAST((SC9.C9_QTDLIB * SC9.C9_PRCVEN) AS NUMERIC (16,2)) AS C9_TOTAL,"
cSelect	+= " SC9.C9_PRODUTO,SC5.C5_CONDPAG,SB1.B1_DESC,SC5.C5_ENTREGA "
cFrom	+= " "+RetSqlName("SC9")+" SC9 , "+RetSqlName("SA1")+" SA1, "+RetSqlName("SC5")+" SC5, "+RetSqlName("SB1")+" SB1 "
cWhere	+= " SC9.C9_FILIAL = '"+xFilial("SC9")+"'"
cWhere	+= " AND SC9.C9_PEDIDO BETWEEN '"+(mv_par03)+"' AND '"+(mv_par04)+"'"
cWhere	+= " AND SC9.C9_CLIENTE BETWEEN '"+(mv_par05)+"' AND '"+(mv_par07)+"'"
cWhere	+= " AND SC9.C9_LOJA BETWEEN '"+(mv_par06)+"' AND '"+(mv_par08)+"'"
cWhere	+= " AND SC9.C9_PRODUTO BETWEEN '"+(mv_par13)+"' AND '"+(mv_par14)+"'"
//cWhere	+= " AND SC9.C9_ENTREG BETWEEN '"+dtos(mv_par09)+"' AND '"+dtos(mv_par10)+"'"
cWhere	+= " AND SC9.C9_BLCRED NOT IN (' ','02','10')"
cWhere	+= " AND SC9.D_E_L_E_T_ <> '*'"
cWhere 	+= " AND SC5.C5_FILIAL = SC9.C9_FILIAL"
cWhere	+= " AND SC5.C5_NUM = SC9.C9_PEDIDO"
cWhere	+= " AND SC5.C5_EMISSAO BETWEEN '"+dtos(mv_par11)+"' AND '"+dtos(mv_par12)+"'"
cWhere	+= " AND SC5.C5_VEND1 BETWEEN '"+(mv_par01)+"' AND '"+(mv_par02)+"'"

If A3_TIPO <> 'I' .and. !empty(cCodRep)
	cWhere	+= " AND SC5.C5_VEND1 IN ('" + cCodRep + "')"
EndIf	

cWhere	+= " AND SC5.D_E_L_E_T_ <> '*'"
cWhere	+= " AND SA1.A1_FILIAL = '"+xFilial("SA1")+"'"
cWhere	+= " AND SA1.A1_COD = SC9.C9_CLIENTE"
cWhere	+= " AND SA1.A1_LOJA = SC9.C9_LOJA"
cWhere	+= " AND SA1.D_E_L_E_T_ <> '*'"
cWhere	+= " AND SB1.B1_FILIAL = '"+xFilial("SB1")+"'"
cWhere	+= " AND SB1.B1_COD = SC9.C9_PRODUTO"
cWhere	+= " AND SB1.D_E_L_E_T_ <> '*' "
//if mv_par16 == 1
//cWhere	+= " AND SC9.C9_CODREJ <> ''  " 
//ENDIF

cOrder	+= " SC5.C5_VEND1,SC9.C9_BLCRED,SC9.C9_PEDIDO,SC9.C9_CLIENTE,SC9.C9_LOJA "

CursorWait()

// Grava os registros a processar em um array
aDadImp	:= U_QryArr( cSelect + cFrom + cWhere + cOrder)

// Verifica os pedidos que s�o de pagamento antecipado e trata o array
aEval( aDadImp, { |x| x[7] := If( !Empty(x[7]), x[7], If( x[13] == "002","99","00" )) })

// Ordeno o array com Vendedor, Bloqueio Credito, Codigo de Rejeicao, Pedido, Cliente e Loja
// aSort( aDadImp,,, { |x,y| x[1]+x[6]+x[7]+x[5]+x[2]+x[3] < y[1]+y[6]+y[7]+y[5]+y[2]+y[3] })
// N�o considerar os motivos do sistema
aSort( aDadImp,,, { |x,y| x[1]+x[7]+x[5]+x[2]+x[3] < y[1]+y[7]+y[5]+y[2]+y[3] })

CursorArrow()

RestArea(aArea)

Return(nil)

/******************************************************************************************************
User Function RetDesRej(cCodRej)
******************************************************************************************************
Local cRet:= "Pedido em analise"

If cCodRej == "99"
	cRet:= "Pagamento Antecipado"
ElseIf cCodRej == "00"
	cRet:= "Pedido em analise"
ElseIf !Empty(cCodRej)
	cRet:= Left(Tabela("ZZ",cCodRej,.F.),40)
EndIf

Return(cRet)*/