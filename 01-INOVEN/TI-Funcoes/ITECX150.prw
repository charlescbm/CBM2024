#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"

//-------------------------------------------------------------------
/*/{Protheus.doc} ITECX150
Utilizado para gravar a tabela de etiquetas e chamar a impressão - OP 
Ordens de Producao
@author  GoOne Consultoria - Crele Cristina
@since   23/11/2021
@version 1
/*/
//-------------------------------------------------------------------
//DESENVOLVIDO POR INOVEN

User Function ITECX150()

local nQtdGera	:= 0
local nQtZZA	:= 0
local nQtVal	:= 0
Local nCount	:= 0
Local cSeq		:= "001"
local nVolPallet:= 0
Local nQtdPallet:= 0
Local nPallet	:= 0
Local cNPallet	:= ""

Local cSeqIDe	:= ""
Local cSeqIAte	:= ""

If alltrim(cFilAnt) <> '0103'
	MsgAlert( "Opção não disponível para esta filial!", "Atenção" )
	Return
endif



if Pergunte('ITECX150', .T.)

	nQtdGera := mv_par01	//Quantidade a ser gerada/impressa

	nQtZZA := 0
	//Validar quantidade a ser gerada da etiqueta
	ZZA->(dbSetOrder(1))
	ZZA->(msSeek(xFilial('ZZA') + "000" + SC2->C2_NUM + SC2->C2_SEQUEN + "ORDEMPRO" + space(tamSx3("ZZA_LOJA")[1]) + "00" + SC2->C2_ITEM))
	While !ZZA->(eof()) .and. ZZA->ZZA_FILIAL == xFilial('ZZA') .and. ZZA->ZZA_NUMNF + ZZA->ZZA_SERIE + ZZA->ZZA_FORNEC + ZZA->ZZA_LOJA + ZZA->ZZA_ITEMNF == "000" + SC2->C2_NUM + SC2->C2_SEQUEN + "ORDEMPRO" + space(tamSx3("ZZA_LOJA")[1]) + "00" + SC2->C2_ITEM
		nQtZZA++
		ZZA->(dbSkip())
	End
	nQtVal := SC2->C2_QUANT - nQtZZA

	if nQtdGera > nQtVal
		MsgAlert( "Quantidade de etiquetas digitada é inválida. Quantidade válida: " + alltrim(str(nQtVal)), "Atenção" )
		Return
	endif
	//Fim

	//Gera as etiquetas

	//------------------------------------------+
	// Valida a quantidade de caixas por Pallet |
	//------------------------------------------+
	nVolPallet := 0
	SB5->(dbSetOrder(1))
	If SB5->( dbSeek(xFilial("SB5") + SC2->C2_PRODUTO) )
		nVolPallet := SB5->B5_XPALLET
	EndIf
	
	nCount 		:= 1
	nPallet		:= 1
	nQtdPallet	:= Int(nQtdGera/nVolPallet)
	cNPallet	:= ""
	If nQtdPallet > 0
		cNPallet	:= "0" + StrZero(Val(SC2->C2_NUM),6) + SC2->C2_SEQUEN + cSeq
	EndIf	
	
	nQtZZA++
	cSeqIDe	:= StrZero(nQtZZA,4)
	While nQtdGera >= nCount 
		
		ZZA->(RecLock( "ZZA", .T. ))
			ZZA->ZZA_FILIAL	:= xFilial( "ZZA" )
			ZZA->ZZA_CODPRO	:= SC2->C2_PRODUTO
			ZZA->ZZA_CODBAR := GetADVFVal( "SB1", "B1_CODBAR", xFilial( "SB1" ) + SC2->C2_PRODUTO, 1 )
			ZZA->ZZA_QUANT  := 1
			ZZA->ZZA_VLRUNI := 0.01
			ZZA->ZZA_NUMNF  := "000" + SC2->C2_NUM
			ZZA->ZZA_SERIE  := SC2->C2_SEQUEN
			ZZA->ZZA_FORNEC := "ORDEMPRO"
			ZZA->ZZA_LOJA   := space(tamSx3("ZZA_LOJA")[1])
			ZZA->ZZA_NUMCX  := StrZero(nQtZZA,4)	//StrZero(nCount,4)
			ZZA->ZZA_NUMLOT := SC2->C2_XLOTE
			ZZA->ZZA_ITEMNF := "00" + SC2->C2_ITEM
			ZZA->ZZA_LOCENT := SC2->C2_LOCAL
			ZZA->ZZA_PALLET	:= cNPallet	
			ZZA->ZZA_BAIXA	:= "1"
			ZZA->ZZA_CONFER	:= .F.
		ZZA->( MsUnlock() )
		
		//------------------------------+
		// Valida se preencheu o Pallet |
		//------------------------------+
		If nPallet == nVolPallet .And. nQtdPallet <> 0
			nPallet 	:= 0
			cSeq		:= Soma1(cSeq)
			cNPallet	:= "0" + StrZero(Val(SC2->C2_NUM),6) + SC2->C2_SEQUEN + cSeq
			nQtdPallet--
		ElseIf nQtdPallet == 0
			cNPallet	:= ""
		EndIf	
		
		//-----------------+
		// Contador Rotina |
		//-----------------+
		nQtZZA++
		nCount++
		nPallet++
	
	EndDo

	cSeqIAte	:= StrZero(nQtZZA-1,4)
	//Chamar a impressao
	IEXPR150Prt(mv_par02, cSeqIDe, cSeqIAte)

	MsgAlert( "Etiquetas geradas com sucesso!!!", "Atenção" )

else

	MsgAlert( "Você cancelou a rotina!!!", "Atenção" )
	Return

endif

Return


/************************************************************************************/
/*/{Protheus.doc} IEXPR150Prt

@description Realiza impressao de etiquetas 

@author BGoOne Consultoria - Crele Cristina
@since 23/11/2021
@version 1.0

@type function
/*/
/************************************************************************************/
Static Function  IEXPR150Prt(cImpressora, cSeqIDe, cSeqIAte)
Local aArea		:= GetArea()

Local cAlias	:= GetNextAlias()
Local cPallet	:= ""	
Local cDescPrd	:= ""
Local cTotEtq	:= ""	
Local cLoteEtq	:= ""
//Local cCodProd	:= ""

Local dData		:= ""
Local dDtValid	:= ""

//--------------------+
// Consulta Etiquetas | 
//--------------------+
If !IEXPR150Qry(cAlias, cSeqIDe, cSeqIAte)
		
	MsgAlert("Não foram encontradas etiquetas para serem impressas.","INOVEN - Avisos")
	
	//--------------------+
	// Encerra temporario | 
	//--------------------+
	(cAlias)->( dbCloseArea() )
	
	RestArea(aArea)
	Return .T.
EndIf

//-------------------+
// Valida impressora |
//-------------------+
If CB5SetImp( cImpressora )
	
	//---------------+	
	// Posiciona ZZA |
	//---------------+	
	dbSelectArea("ZZA")
	ZZA->( dbSetOrder(1) )
	
	//----------------------------------+
	// Realiza a impressao de etiquetas | 
	//----------------------------------+
	While (cAlias)->( !Eof() )

		SB1->(dbSetOrder(1))
		SB1->(msSeek(xFilial('SB1') + (cAlias)->ZZA_CODPRO))

		//------------------------+
		// Monta codigo de Barras |
		//------------------------+
		cCodBar 	:= Alltrim((cAlias)->ZZA_CODBAR) 				//Código de barras
		cCodBar 	+= Alltrim((cAlias)->ZZA_CODPRO)				//Código do produto
		cCodBar 	+= PadL(Alltrim((cAlias)->ZZA_NUMNF),9,"0")	   	//Número da NF de Entrada
		cCodBar 	+= Alltrim((cAlias)->ZZA_ITEMNF)				//Item NF
		cCodBar 	+= Alltrim((cAlias)->ZZA_NUMCX)					//Numero da Caixa
		cLoteEtq 	:= Alltrim((cAlias)->ZZA_NUMLOT) 				//Lote de Compras
		cPallet		:= (cAlias)->ZZA_PALLET
		cDescPrd	:= (cAlias)->B1_DESC
		dData		:= dDataBase	//sTod((cAlias)->DTALT)
		dDtValid	:= MonthSum(dDataBase,SB1->B1_XDTVALI)
		
		//-------------------------------------+
		// Inicializa a montagem da impressora |
		//-------------------------------------+
		MscbBegin(1,6) 
		
		//cEtq := U_ICOMR040(1,(cAlias)->ZZA_CODPRO,(cAlias)->B1_DESC,(cAlias)->ZZA_NUMLOT,"","",dData,dDtValid,cCodBar)
		cEtq := ITCXGETQ((cAlias)->ZZA_CODPRO,(cAlias)->B1_DESC,(cAlias)->ZZA_NUMLOT,dData,dDtValid,cCodBar)
				
		cTotEtq += cEtq + CRLF
		
		MSCBWrite(cEtq)
						
		//---------------------------------+
		// Finaliza a Imagem da Impressora |
		//---------------------------------+
		MscbEnd()
		
		//-------------------+
		// Posicona registro | 
		//-------------------+
		ZZA->( dbGoTo((cAlias)->RECNOZZA) )
		If ZZA->( FieldPos("ZZA_QTDIMP") ) > 0
			RecLock("ZZA",.F.)
				ZZA->ZZA_QTDIMP := ZZA->ZZA_QTDIMP + 1
				ZZA->ZZA_USER	:= LogUserName()
			ZZA->( MsUnLock() )	 
		EndIf		
			
		(cAlias)->( dbSkip() )

	EndDo
		
	//--------------------------------------+
	// Encerra comunicação com a impressora |
	//--------------------------------------+
	MSCBClosePrinter()
	
	//----------------------------+
	// Imprime etiqueta de Pallet |
	//----------------------------+
	//If ( !Empty(cPallet) .And. !Empty(cCodPallet) )
	//	IEXPR030EPl(cCodPallet,cDescPrd,dData,dDtValid)
	//EndIf
		
	//--------------------+
	// Encerra temporario | 
	//--------------------+
	(cAlias)->( dbCloseArea() )
		
Else
	MsgAlert( "Erro ao comunicar-se com a impressora" )
EndIf	

RestArea(aArea)
Return .T.


/************************************************************************************/
/*/{Protheus.doc} IEXPR150Qry

@description Consulta etiquetas a srem reimpressas 

@author GoOne Consultoria - Crele Cristina
@since 23/11/2021
@version 1.0

@type function
/*/
/************************************************************************************/
Static Function IEXPR150Qry(cAlias, cSeqIDe, cSeqIAte)
Local cQuery 	:= ""
Local cItemNf	:= "00" + SC2->C2_ITEM
Local cCodProd	:= SC2->C2_PRODUTO
Local cNFiscal	:= "000" + SC2->C2_NUM
Local cSerie	:= SC2->C2_SEQUEN

cQuery := "	SELECT " + CRLF 
cQuery += "		ZZA.ZZA_CODBAR, " + CRLF
cQuery += "		ZZA.ZZA_CODPRO, " + CRLF
cQuery += "		ZZA.ZZA_NUMNF, " + CRLF
cQuery += "		ZZA.ZZA_ITEMNF, " + CRLF
cQuery += "		ZZA.ZZA_NUMCX, " + CRLF
cQuery += "		ZZA.ZZA_NUMLOT, " + CRLF
cQuery += "		ZZA.ZZA_PALLET, " + CRLF
cQuery += "		ZZA.R_E_C_N_O_ RECNOZZA, " + CRLF
cQuery += "		B1.B1_DESC " + CRLF
cQuery += "	FROM " + CRLF
cQuery += "		" + RetSqlName("ZZA") + " ZZA " + CRLF
cQuery += "		INNER JOIN " + RetSqlName("SB1") + " B1 ON B1.B1_FILIAL = '" + xFilial("SB1") + "' AND B1.B1_COD = ZZA.ZZA_CODPRO AND B1.D_E_L_E_T_ = '' " + CRLF
cQuery += "	WHERE " + CRLF 
cQuery += "		ZZA.ZZA_FILIAL = '" + xFilial("ZZA") + "' AND " + CRLF 
cQuery += "		ZZA.ZZA_CODPRO = '" + cCodProd + "' AND " + CRLF
cQuery += "		ZZA.ZZA_NUMNF = '" + cNFiscal + "' AND " + CRLF
cQuery += "		ZZA.ZZA_SERIE = '" + cSerie + "' AND " + CRLF
cQuery += "		ZZA.ZZA_NUMCX BETWEEN '" + cSeqIDe + "' AND '" + cSeqIAte + "' AND " + CRLF
cQuery += "		ZZA.ZZA_ITEMNF = '" + cItemNf + "' AND " + CRLF
//cQuery += "		ZZA.ZZA_NUMLOT = '" + cLote + "' AND " + CRLF
cQuery += "		ZZA.D_E_L_E_T_ = '' " + CRLF
cQuery += "	GROUP BY ZZA.ZZA_CODBAR, ZZA.ZZA_CODPRO, ZZA.ZZA_NUMNF, ZZA.ZZA_ITEMNF, ZZA.ZZA_NUMCX, ZZA.ZZA_NUMLOT, ZZA.ZZA_PALLET,ZZA.R_E_C_N_O_, B1.B1_DESC " + CRLF
cQuery += "	ORDER BY ZZA.ZZA_NUMCX "

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

If (cAlias)->( Eof() )
	Return .F.
EndIf

Return .T.

/************************************************************************************/
/*/{Protheus.doc} ITCXGETQ

@description Monta imagem da etiqueta caixa

/*/
/************************************************************************************/
Static Function ITCXGETQ(cCodProd,cDescPrd,cNumLot,dData,dDtValid,cCodBar)
    
Local cEtiqueta := ""

	cEtiqueta := 'CT~~CD,~CC^~CT~' + CRLF
    //cEtiqueta += '^XA~TA000~JSN^LT0^MNW^MTD^PON^PMN^LH0,0^JMA^PR4,4~SD15^JUS^LRN^CI0^XZ' + CRLF 
    cEtiqueta += '^XA~TA000~JSN^LT0^MNW^MTT^PON^PMN^LH0,0^JMA^PR4,4~SD15^JUS^LRN^CI0^XZ' + CRLF 
    cEtiqueta += '^XA' + CRLF
    cEtiqueta += '^MMT' + CRLF
	cEtiqueta += '^PW823' + CRLF
	cEtiqueta += '^LL0280' + CRLF
	cEtiqueta += '^LS0' + CRLF                                                                
	cEtiqueta += '^FT342,35^A0N,30,30^FH\^FDINOVEN^FS' + CRLF
	cEtiqueta += '^FO10,187^GB782,0,2^FS' + CRLF
	cEtiqueta += '^FT41,82^A0N,28,28^FH\^FD' + Alltrim(cCodProd) + "-" + Alltrim(cDescPrd) + '^FS' + CRLF
	cEtiqueta += '^FT43,126^A0N,28,28^FH\^FDLOTE: ' + Alltrim(cNumLot)  + ' ^FS' + CRLF
   	cEtiqueta += '^FT41,170^A0N,28,28^FH\^FDFabrica\87\C6o: ' + dToc(dData) + ' ^FS' + CRLF
	cEtiqueta += '^FT376,173^A0N,28,28^FH\^FDValidade: ' + dToc(dDtValid) + ' ^FS' + CRLF
	cEtiqueta += '^BY2,3,61^FT40,255^BCN,,Y,N^FD>;' + cCodBar + '>6' + cNumLot + '^FS' + CRLF
	cEtiqueta += '^FO10,46^GB782,0,1^FS' + CRLF
	cEtiqueta += '^PQ1,0,1,Y' + CRLF
	cEtiqueta += '^XZ' + CRLF

Return cEtiqueta
