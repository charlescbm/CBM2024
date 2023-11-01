#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"

//-------------------------------------------------------------------
/*/{Protheus.doc} ITECX160
Utilizado para imprimir as etiquetas geradas da OP 
Ordens de Producao
@author  GoOne Consultoria - Crele Cristina
@since   23/11/2021
@version 1
/*/
//-------------------------------------------------------------------
//DESENVOLVIDO POR INOVEN

User Function ITECX160()

If alltrim(cFilAnt) <> '0103'
	MsgAlert( "Opção não disponível para esta filial!", "Atenção" )
	Return
endif



if Pergunte('ITECX160', .T.)

	//Chamar a impressao
	IEXPR160Prt(mv_par01, mv_par02, mv_par03)	//Impressora, Seq. Inicial, Seq. Final

else

	MsgAlert( "Você cancelou a rotina!!!", "Atenção" )
	Return

endif

Return


/************************************************************************************/
/*/{Protheus.doc} IEXPR160Prt

@description Realiza impressao de etiquetas 

@author GoOne Consultoria - Crele Cristina
@since 23/11/2021
@version 1.0

@type function
/*/
/************************************************************************************/
Static Function  IEXPR160Prt(cImpressora, cSeqIDe, cSeqIAte)
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
If !IEXPR160Qry(cAlias, cSeqIDe, cSeqIAte)
		
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
   	nCaixas		:= 0
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
		dData		:= SC2->C2_EMISSAO	//sTod((cAlias)->DTALT)
		dDtValid	:= MonthSum(SC2->C2_DATPRI,SB1->B1_XDTVALI)

		cNFiscal	:= PadL(Alltrim((cAlias)->ZZA_NUMNF),9,"0")
		cItemNf		:= Alltrim((cAlias)->ZZA_ITEMNF)
		cCodProd	:= Alltrim((cAlias)->ZZA_CODPRO)

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

		nCaixas++		
			
		(cAlias)->( dbSkip() )

	EndDo
		
	//--------------------------------------+
	// Encerra comunicação com a impressora |
	//--------------------------------------+
	MSCBClosePrinter()
	
	//-------------------------+
	// Imprime etiqueta Pallet |
	//-------------------------+
	If !Empty(cPallet)
		ITECX160EPl(cImpressora,cPallet,cNFiscal,cItemNf,cCodProd,cDescPrd,dData,dDtValid,nCaixas)
	EndIf
		
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
/*/{Protheus.doc} IEXPR160Qry

@description Consulta etiquetas a srem reimpressas 

@author GoOne Consultoria - Crele Cristina
@since 23/11/2021
@version 1.0

@type function
/*/
/************************************************************************************/
Static Function IEXPR160Qry(cAlias, cSeqIDe, cSeqIAte)
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

/************************************************************************************/
/*/{Protheus.doc} ITCPGETQ

@description Monta imagem da etiqueta pallet

/*/
/************************************************************************************/
Static Function ITCPGETQ(cCodProd,cDescPrd,cCodPallet,cNumCx,dData,dDtValid,cCodBar)

Local cEtiqueta := ""

cEtiqueta 	:= '^XA' + CRLF
cEtiqueta 	+= '^MMT' + CRLF
cEtiqueta 	+= '^PW823' + CRLF
cEtiqueta 	+= '^LL0280' + CRLF
cEtiqueta 	+= '^LS0' + CRLF
cEtiqueta 	+= '^FT342,35^A0N,30,30^FH\^FDINOVEN^FS' + CRLF
cEtiqueta 	+= '^FO10,187^GB782,0,2^FS' + CRLF
cEtiqueta 	+= '^FT41,82^A0N,28,28^FH\^FD' + Alltrim(cCodProd) + "-" + Alltrim(cDescPrd) + '^FS' + CRLF
cEtiqueta 	+= '^FT43,126^A0N,28,28^FH\^FDPALLETE: ' + cCodPallet + '^FS' + CRLF
cEtiqueta 	+= '^FT376,126^A0N,28,28^FH\^FDCXS: ' + cNumCx + '^FS' + CRLF
cEtiqueta 	+= '^FT41,170^A0N,28,28^FH\^FDFabrica\87\C6o: ' + dToc(dData) + ' ^FS' + CRLF
cEtiqueta 	+= '^FT376,173^A0N,28,28^FH\^FDValidade: ' + dToc(dDtValid) + ' ^FS' + CRLF
cEtiqueta 	+= '^FO10,46^GB782,0,1^FS' + CRLF
cEtiqueta 	+= '^PQ1,0,1,Y' + CRLF
cEtiqueta 	+= '^BY2,3,58^FT33,251^BCN,,Y,N^FD>;' + cCodBar + '^FS' + CRLF
cEtiqueta 	+= '^XZ'

Return cEtiqueta


/************************************************************************************/
/*/{Protheus.doc} ITECX160EPl

@description Reimpressao etiqueta Pallet

/*/
/************************************************************************************/
Static Function ITECX160EPl(cImpressora,cCodPallet,cNFiscal,cItemNf,cCodProd,cDescPrd,dData,dDtValid,nCaixas)

//-------------------+
// Valida impressora |
//-------------------+
If CB5SetImp( cImpressora )

	//------------------------+
	// Monta codigo de Barras |
	//------------------------+
	cCodBar	:= Alltrim(cCodPallet)					// Pallet	
	cCodBar += Alltrim(cCodProd)					// Código do produto
	cCodBar += PadL(Alltrim(cNFiscal),9,"0")	    // Número da NF de Entrada
	cCodBar += Alltrim(cItemNf)						// Item NF
	cCodBar += "0000"			 					// Numero da Caixa
	cCodBar += PadL(Alltrim(cNFiscal),10,"0")		// Número da NF de Entrada   
	
	//cEtq := U_ICOMR040(2,cCodProd,cDescPrd,"",cCodPallet,StrZero(nCaixas,4),dData,dDtValid,cCodBar)
	cEtq := ITCPGETQ(cCodProd,cDescPrd,cCodPallet,StrZero(nCaixas,4),dData,dDtValid,cCodBar)
			
	//cTotEtq := cEtq + CRLF
	//cTotEtq += cEtq 
	
	//-------------------------------------+
	// Inicializa a montagem da impressora |
	//-------------------------------------+
	MscbBegin(1,6) 
	
	MSCBWrite(cEtq)
	
	//---------------------------------+
	// Finaliza a Imagem da Impressora |
	//---------------------------------+
	MscbEnd()
			
	MSCBClosePrinter()

Else
	MsgAlert( "Erro ao comunicar-se com a impressora" )
EndIf	

Return .T.
