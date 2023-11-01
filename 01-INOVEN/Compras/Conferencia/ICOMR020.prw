#Include 'Protheus.ch'

//-------------------------------------------------------------------
/*/{Protheus.doc} ICOMR020
Impressão de etiqueta do Pallet
@author  Victor Andrade
@since   13/04/2018
@version 1
/*/
//-------------------------------------------------------------------
//DESENVOLVIDO POR INOVEN

User Function ICOMR020(cCodPallet,cNFiscal,cItemNf,cCodProd,cDescPrd,dData,dDtValid,nCaixas,nGridEtq,cEtq)

Local cPerg     := PadR( "TALETQ02", 10 )

CreateSX1( cPerg )

//If Pergunte( cPerg, .T. )
    
    //If CB5SetImp( MV_PAR01 )
    	
    	//------------------------+
    	// Monta codigo de Barras |
    	//------------------------+
    	cCodBar	:= Alltrim(cCodPallet)					// Pallet	
    	cCodBar += Alltrim(cCodProd)					// Código do produto
		cCodBar += PadL(Alltrim(cNFiscal),9,"0")	    // Número da NF de Entrada
		cCodBar += Alltrim(cItemNf)						// Item NF
		cCodBar += "0000"			 					// Numero da Caixa
		cCodBar += PadL(Alltrim(cNFiscal),10,"0")		// Número da NF de Entrada   

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
		cDsQrCode := 'PALLET: ' + cCodPallet
		cEtq += U_ICOMR040(2,cCodProd,cDescPrd,"",cCodPallet,StrZero(nCaixas,4),dData,dDtValid,cCodBar,cDsQrCode,nGridEtq)
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
		cEtq := U_ICOMR040(2,cCodProd,cDescPrd,"",cCodPallet,StrZero(nCaixas,4),dData,dDtValid,cCodBar)
		    	
    	cTotEtq := cEtq + CRLF
    	cTotEtq += cEtq 
    	
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
		*/
        
        /*
        If __cUserId == "000000"
			Aviso('',cTotEtq,{"Ok"},3)
		EndIf	
        */
    //Else
    //    MsgAlert( "Erro ao comunicar-se com a impressora" )
    //EndIf

//EndIf

Return

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
