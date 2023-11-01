#INCLUDE 'PROTHEUS.CH'

/************************************************************************************/
/*/{Protheus.doc} ICOMR030

@description Impressao de etiquetas de faltas

@author Bernard M. Margarido
@since 11/07/2018
@version 1.0

@type function
/*/
/************************************************************************************/
//DESENVOLVIDO POR INOVEN

User Function ICOMR030(cNFiscal,cSerie,cCodForn,cLojForn,nGet,aRecFalt)
Local aArea			:= GetArea()

Local cCodBar   	:= ""
Local cCodBarras	:= ""
Local cEtq			:= ""
Local cCodPallet 	:= "" 
Local cCodProd		:= ""
Local cDescPrd		:= ""
Local cItemNf		:= ""
Local cNumLot		:= ""
Local cTotEtq		:= ""
Local cArmTran		:= GetNewPar( "ES_ARMTRAN","90", )
Local cPerg     	:= PadR( "TALETQ01", 10 )

Local dData			:= ""
Local dDtValid		:= ""

Local nX        	:= 0
Local nCaixas		:= 0
Local nTProd		:= TamSx3("B1_COD")[1]
Local nTLote		:= TamSx3("B8_LOTECTL")[1]

If Pergunte( cPerg, .T. )
	
	//-------------------+
	// Posiciona Produto |
	//-------------------+
	dbSelectArea("SB1")
	SB1->( dbSetOrder(1) )
	
	//----------------+
	// Posiciona Lote |
	//----------------+
	dbSelectArea("SB8")
	SB8->( dbSetOrder(3) )
	
	//---------------------------+
	// Comunica com a impressora |
	//---------------------------+	
    If CB5SetImp( MV_PAR01 )
    	
    	For nX := 1 To Len(aRecFalt)
    		
    		//--------------------+
    		// Posiciona Etiqueta |
    		//--------------------+
    		ZZA->( dbGoTo(aRecFalt[nX]) )
    		
    		//-------------------+
			// Posiciona Produto |
			//-------------------+
			SB1->( dbSeek(xFilial("SB1") + PadR(ZZA->ZZA_CODPRO,nTProd) ))
			
			//----------------+
			// Posiciona Lote |
			//----------------+
			If SB8->( dbSeek(xFilial("SB8") + PadR(ZZA->ZZA_CODPRO,nTProd) + cArmTran + PadR(ZZA->ZZA_NUMLOT,nTLote)) )
				dDtaValid := SB8->B8_DTVALID
			Else
				dDtaValid := MonthSum( dDataBase, SB1->B1_XDTVALI)
			EndIf	
    	 	    	     	
    	   	//-------------------------------+
    	   	// Variaveis impressao etiquetas | 
    	   	//-------------------------------+
    	   	cCodPallet 	:= ZZA->ZZA_PALLET 
    	   	cCodProd	:= ZZA->ZZA_CODPRO
    	   	cCodBarras	:= ZZA->ZZA_CODBAR
    	   	cDescPrd	:= SB1->B1_DESC
    	   	cItemNf		:= ZZA->ZZA_ITEMNF
    	   	cNumLot		:= ZZA->ZZA_NUMLOT
    	   	dData		:= SB8->B8_DATA
    	   	dDtValid	:= dDtaValid
    	   	nCaixas		:= 0
    	     	
 		
     		//------------------------+
		    // Monta codigo de Barras |
		    //------------------------+
			cCodBar := Alltrim(cCodBarras) 						//Código de barras
			cCodBar += Alltrim(cCodProd)						//Código do produto
			cCodBar += PadL(Alltrim(cNFiscal),9,"0")	   		//Número da NF de Entrada
			cCodBar += Alltrim(cItemNf)							//Item NF
			cCodBar += Alltrim(ZZA->ZZA_NUMCX)					//Numero da Caixa
			//cCodBar += Alltrim(cNumLot) 						//Lote de Compras
    	     		
		    //-------------------------------------+
			// Inicializa a montagem da impressora |
			//-------------------------------------+
			MscbBegin(1,6)
			
			cEtq 	:= U_ICOMR040(1,cCodProd,cDescPrd,cNumLot,"","",dData,dDtValid,cCodBar)
			
			cTotEtq	+= cEtq + CRLF
					        
			MSCBWrite(cEtq)
			        		        
	        //---------------------------------+
			// Finaliza a Imagem da Impressora |
			//---------------------------------+
			MscbEnd()
					
			nCaixas++
									
		Next nX 
		
		/*	
		If __cUserId == "000000"
			Aviso('',cTotEtq,{"Ok"})
		EndIf	
		*/			
		//--------------------------------------+
		// Encerra comunicação com a impressora |
		//--------------------------------------+
		MSCBClosePrinter()

    Else
    	MsgAlert( "Erro ao comunicar-se com a impressora" )
    EndIf
       
EndIf

RestArea(aArea)	
Return .T.