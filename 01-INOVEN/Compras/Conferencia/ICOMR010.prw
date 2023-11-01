#INCLUDE 'PROTHEUS.CH'

#DEFINE CRLF CHR(13) + CHR(10)

//-------------------------------------------------------------------
/*/{Protheus.doc} ICOMR010
Efetua a impressão de Etiquetas Térmicas (Caixa)
@author  Victor Andrade
@since   06/04/2018
@version 1
/*/
//-------------------------------------------------------------------
//DESENVOLVIDO POR INOVEN

User Function ICOMR010( aDados, cNFiscal, cSerie, cCodForn, cLojForn, nQtdImp )

Local cCodBar   	:= ""
Local cCodBarras	:= ""
Local cEtq			:= ""
Local cCodPallet 	:= "" 
Local cCodProd		:= ""
Local cDescPrd		:= ""
Local cItemNf		:= ""
Local cNumLot		:= ""
//Local cTotEtq		:= ""
Local cPerg     	:= PadR( "TALETQ01", 10 )

Local dData			:= ""
Local dDtValid		:= ""

Local nCaixas		:= 0

CreateSX1( cPerg )

If Pergunte( cPerg, .T. )
	
	//-------------------+
	// Posiciona Produto |
	//-------------------+
	dbSelectArea("SB1")
	SB1->( dbSetOrder(1) )
	SB1->( dbSeek(xFilial("SB1") + PadR(aDados[02],TamSx3("B1_COD")[1])) )
	
	//----------------+
	// Posiciona Lote |
	//----------------+
	ICOMR010Sb8(aDados[02],aDados[06],@dData,@dDtValid)
	
    If CB5SetImp( MV_PAR01 )
    	
    	Private nGridEtq := 0

		//---------------------+
    	// Posiciona Etiquetas |
    	//---------------------+
    	dbSelectArea("ZZA")
    	ZZA->( dbSetOrder(1) )
    	If ZZA->( dbSeek(xFilial("ZZA") + cNFiscal + cSerie + cCodForn + cLojForn + aDados[01]) )  
    	    While ZZA->( !Eof() .And. xFilial("ZZA") + cNFiscal + cSerie + cCodForn + cLojForn + aDados[01] == ZZA->( ZZA_FILIAL + ZZA_NUMNF + ZZA_SERIE + ZZA_FORNEC + ZZA_LOJA + ZZA_ITEMNF) )
    	     	
    	     	//-------------------------------+
    	     	// Variaveis impressao etiquetas | 
    	     	//-------------------------------+
    	     	cCodPallet 	:= ZZA->ZZA_PALLET 
    	     	cCodProd	:= ZZA->ZZA_CODPRO
    	     	cCodBarras	:= ZZA->ZZA_CODBAR
    	     	cDescPrd	:= SB1->B1_DESC
    	     	cItemNf		:= aDados[01]
    	     	cNumLot		:= ZZA->ZZA_NUMLOT
    	     	nCaixas		:= 0
    	     	
    	     	While ZZA->( !Eof() .And. xFilial("ZZA") + cNFiscal + cSerie + cCodForn + cLojForn + aDados[01] == ;
    	     									ZZA->( ZZA_FILIAL + ZZA_NUMNF + ZZA_SERIE + ZZA_FORNEC + ZZA_LOJA + ZZA_ITEMNF)  .And. ; 
    	     									cCodPallet == ZZA->ZZA_PALLET )
    	     		
    	     		//------------------------+
				    // Monta codigo de Barras |
				    //------------------------+
					cCodBar := Alltrim(cCodBarras) 						//Código de barras
					cCodBar += Alltrim(cCodProd)						//Código do produto
					cCodBar += PadL(Alltrim(cNFiscal),9,"0")	   		//Número da NF de Entrada
					cCodBar += Alltrim(cItemNf)							//Item NF
					cCodBar += Alltrim(ZZA->ZZA_NUMCX)					//Numero da Caixa
					    	     		
				    if empty(nGridEtq)
						cEtq := 'CT~~CD,~CC^~CT~' + CRLF
						//cEtq += '^XA~TA000~JSN^LT-20^MNW^MTD^PON^PMN^LH0,0^JMA^PR4,4~SD15^JUS^LRN^CI27^PA0,1,1,0^XZ' + CRLF
						cEtq += '^XA~TA000~JSN^LT-20^MNW^MTT^PON^PMN^LH0,0^JMA^PR4,4~SD15^JUS^LRN^CI27^PA0,1,1,0^XZ' + CRLF
						cEtq += '^XA' + CRLF
						cEtq += '^MMT' + CRLF
						cEtq += '^PW863' + CRLF
						cEtq += '^LL224' + CRLF
						cEtq += '^LS15' + CRLF
					endif
					nGridEtq++
					cDsQrCode := PadL(Alltrim(cNFiscal),9,"0")	   		//Número da NF de Entrada
					cDsQrCode += Alltrim(cItemNf)						//Item NF
					cDsQrCode += Alltrim(ZZA->ZZA_NUMCX)				//Numero da Caixa
					cEtq += U_ICOMR040(1,cCodProd,cDescPrd,cNumLot,"","",dData,dDtValid,cCodBar,cDsQrCode,nGridEtq)
					if nGridEtq==3
						nGridEtq := 0
						cEtq += '^PQ1,0,1,Y' + CRLF
						cEtq += '^XZ'
						//faz a impressao

						//-------------------------------------+
						// Inicializa a montagem da impressora |
						//-------------------------------------+
						MscbBegin(1,6)
						MSCBWrite(cEtq)
						//---------------------------------+
						// Finaliza a Imagem da Impressora |
						//---------------------------------+
						MscbEnd()

						cEtq := ""
					endif

					/*
					//-------------------------------------+
					// Inicializa a montagem da impressora |
					//-------------------------------------+
					MscbBegin(1,6)
					
					cEtq := U_ICOMR040(1,cCodProd,cDescPrd,cNumLot,"","",dData,dDtValid,cCodBar)
							        
			        //cTotEtq += cEtq + CRLF
			        
			        MSCBWrite(cEtq)
			        		        
			        //---------------------------------+
					// Finaliza a Imagem da Impressora |
					//---------------------------------+
					MscbEnd()
					*/					
					
					//-----------------------------------------+
					// Atualiza numero de estiquetas impressas | 
					//-----------------------------------------+
					If ZZA->( FieldPos("ZZA_QTDIMP") ) > 0
						ZZA->(RecLock("ZZA",.F.))
							ZZA->ZZA_QTDIMP := ZZA->ZZA_QTDIMP + 1
							ZZA->ZZA_USER	:= LogUserName()
						ZZA->( MsUnLock() )	 
					EndIf
					
					nCaixas++
									
					ZZA->( dbSkip() )
				EndDo
				
				//--------------------------------------+
				// Encerra comunicação com a impressora |
				//--------------------------------------+
				//MSCBClosePrinter()
													
				//-------------------------+
				// Imprime etiqueta Pallet |
				//-------------------------+
				If !Empty(cCodPallet)
					U_ICOMR020(cCodPallet,cNFiscal,cItemNf,cCodProd,cDescPrd,dData,dDtValid,nCaixas,@nGridEtq,@cEtq)
				EndIf
				
			EndDo
			if nGridEtq<3
				nGridEtq := 0
				cEtq += '^PQ1,0,1,Y' + CRLF
				cEtq += '^XZ'
				//faz a impressao

				//-------------------------------------+
				// Inicializa a montagem da impressora |
				//-------------------------------------+
				MscbBegin(1,6)
				MSCBWrite(cEtq)
				//---------------------------------+
				// Finaliza a Imagem da Impressora |
				//---------------------------------+
				MscbEnd()

				cEtq := ""
			endif

			//--------------------------------------+
			// Encerra comunicação com a impressora |
			//--------------------------------------+
			MSCBClosePrinter()
					
			/*
			If __cUserId == "000000"
				Aviso('',cTotEtq,{"Ok"})
			EndIf	
			*/
		EndIf	
    Else
    	MsgAlert( "Erro ao comunicar-se com a impressora" )
    EndIf
       
EndIf

Return

/**************************************************************************/
/*/{Protheus.doc} ICOMR010Sb8

@description Consulta Data de Validade do Lote

@author Bernard M. Margarido
@since 20/09/2018
@version 1.0

@param dData	, date, descricao
@param dDtValid	, date, descricao
@type function
/*/
/**************************************************************************/
Static Function ICOMR010Sb8(cCodPro,cLoteCtl,dData,dDtValid)
Local aArea		:= GetArea()

Local cAlias	:= GetNextAlias()
Local cQuery 	:= ""
 
cQuery := "	SELECT " + CRLF
cQuery += "		B8.B8_PRODUTO, " + CRLF
cQuery += "		B8.B8_LOTECTL, " + CRLF
cQuery += "		B8.B8_DATA, " + CRLF
cQuery += "		B8.B8_DTVALID " + CRLF
cQuery += "	FROM " + CRLF
cQuery += "		" + RetSqlName("SB8") + " B8 " + CRLF
cQuery += "	WHERE " + CRLF
cQuery += "		B8.B8_FILIAL = '" + xFilial("SB8") + "' AND " + CRLF 
cQuery += "		B8.B8_PRODUTO = '" + cCodPro + "' AND " + CRLF
cQuery += "		B8.B8_LOTECTL = '" + cLoteCtl + "' AND " + CRLF
cQuery += "		B8.D_E_L_E_T_ = '' "

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

If (cAlias)->( Eof() )
	
	dData 	:= dDatabase
	dDtValid:= dDataBase
	
	(cAlias)->( dbCloseArea() )
	
	RestArea(aArea)
	Return .T.
EndIf

dData	:= sToD((cAlias)->B8_DATA)
dDtValid:= sToD((cAlias)->B8_DTVALID)

(cAlias)->( dbCloseArea() )

RestArea(aArea)
Return .T.

//-------------------------------------------------------------------
/*/{Protheus.doc} CreateSX1
Função para criar as perguntas no SX1
@author  Victor Andrade
@since   12/04/2018
@version 1
/*/
//-------------------------------------------------------------------
Static Function CreateSX1( cPerg )

Local aPerg := {}
Local aArea := GetArea()
Local i

aAdd(aPerg, {cPerg, "01", "Impressora", "MV_CH1", "C", TamSX3("CB5_CODIGO")[1], 0, "G"	, "MV_PAR01", "CB5","","","",""})

For i := 1 To Len(aPerg)
	
	If  !SX1->( DbSeek(aPerg[i,1]+aPerg[i,2]) )		
		RecLock("SX1",.T.)
	Else
		RecLock("SX1",.F.)
	EndIf
	
	Replace X1_GRUPO   with aPerg[i,01]
	Replace X1_ORDEM   with aPerg[i,02]
	Replace X1_PERGUNT with aPerg[i,03]
	Replace X1_VARIAVL with aPerg[i,04]
	Replace X1_TIPO	   with aPerg[i,05]
	Replace X1_TAMANHO with aPerg[i,06]
	Replace X1_PRESEL  with aPerg[i,07]
	Replace X1_GSC	   with aPerg[i,08]
	Replace X1_VAR01   with aPerg[i,09]
	Replace X1_F3	   with aPerg[i,10]
	Replace X1_DEF01   with aPerg[i,11]
	Replace X1_DEF02   with aPerg[i,12]
	Replace X1_DEF03   with aPerg[i,13]
	Replace X1_DEF04   with aPerg[i,14]
	
	SX1->( MsUnlock() )
	
Next i

RestArea( aArea )

Return
