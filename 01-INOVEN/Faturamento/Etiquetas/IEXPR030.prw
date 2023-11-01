#INCLUDE 'PROTHEUS.CH'

#DEFINE CRLF CHR(13) + CHR(10)

/*********************************************************************************************/
/*/{Protheus.doc} IEXPR030

@description Realiza a impressao de etiquetas de volume

@type function
/*/
/*********************************************************************************************/
//DESENVOLVIDO POR INOVEN

User Function IEXPR030(cNota,cSerie,nQtdVIni,nQtdVFim)
Local aArea		:= GetArea()

Local cPerg     := PadR( "TALETQ02", 10 )
Local cEtq		:= ""
//Local cTotEtq	:= ""

Local nQtdVol	:= 0
Local nVol		:= 0

Default nQtdVIni:= 0
Default nQtdVFim:= 0

CreateSX1( cPerg )

If Pergunte( cPerg, .T. )

	If CB5SetImp( MV_PAR01 )
		
		//-----------------------+
		// Posiciona Nota Fiscal |
		//-----------------------+
		dbSelectArea("SF2")
		SF2->( dbSetOrder(1) )
		If !SF2->( dbSeek(xFilial("SF2") + cNota + cSerie) )
			MsgAlert("Nota nao encontrada.","INOVEN - Avisos")
			RestArea(aArea)
			Return
		EndIf
		
		//-------------------+
		// Posiciona Cliente |
		//-------------------+
		dbSelectArea("SA1")
		SA1->( dbSetOrder(1) )
		SA1->( dbSeek(xFilial("SA1") + SF2->F2_CLIENTE + SF2->F2_LOJA) )
		
		//--------------------------+
		// Posiciona Transportadora |
		//--------------------------+
		dbSelectArea("SA4")
		SA4->( dbSetOrder(1) )
		SA4->( dbSeek(xFilial("SA4") + SF2->F2_TRANSP) )
		
		//------------------+
		// Inicia impressão |
		//------------------+
		If nQtdVIni > 0
			nQtdVol := ( nQtdVFim - nQtdVIni ) + 1
			nQtdVFim:= SF2->F2_VOLUME1
		Else 
			nQtdVIni:= 1
			nQtdVol := SF2->F2_VOLUME1 
			nQtdVFim:= SF2->F2_VOLUME1
		EndIf
			
		For nVol := 1 To nQtdVol
			
			/*
			cEtq := 'CT~~CD,~CC^~CT~' + CRLF
			cEtq += '^XA~TA000~JSN^LT0^MNW^MTD^PON^PMN^LH0,0^JMA^PR4,4~SD15^JUS^LRN^CI0^XZ' + CRLF
			cEtq += '^XA' + CRLF
			cEtq += '^MMT' + CRLF
			cEtq += '^PW823' + CRLF
			cEtq += '^LL0280' + CRLF
			cEtq += '^LS0' + CRLF
			cEtq += '^FO0,0^GFA,29952,29952,00104,:Z64:eJzt3UENACAMBMGiDOsoA0Q0JaGZNTCve1+EpETjlLc4nLbOrl7o5HA4HA6Hw+FwOBwOh8PhcDgcDofD4XA4HA6Hw+FwOBwOh8PhcDgcDofD4XA4HA6Hw+FwOBwOh8PhcDgcDofD4XA4HA6Hw+FwOBwOh8PhcDgcDofD4XDqnVd/HxxOQ0eSJH3SBcf5Dn8=:0EF9^FS' + CRLF
			cEtq += '^FO37,75^GB774,0,5^FS' + CRLF
			cEtq += '^FO36,204^GB778,0,5^FS' + CRLF
			cEtq += '^FT44,111^A0N,28,28^FH\^FDTRASNP. ' + Alltrim(SA4->A4_NOME) + '^FS' + CRLF
			cEtq += '^FT46,182^A0N,28,28^FH\^FD' + Alltrim(SA1->A1_NOME) + '^FS' + CRLF
			cEtq += '^FT45,246^A0N,28,28^FH\^FDVolume: ' + Alltrim(Str(nQtdVFim)) + ' CXs^FS' + CRLF
			cEtq += '^FT679,246^A0N,28,28^FH\^FD' + Alltrim(StrZero(nQtdVIni,4)) + '/' + Alltrim(StrZero(nQtdVFim,4)) + '^FS' + CRLF
			cEtq += '^FT46,54^A0N,28,28^FH\^FDNOTA: ' + Alltrim(SF2->F2_DOC) + '^FS' + CRLF
			cEtq += '^FT281,54^A0N,28,28^FH\^FDSERIE: ' + Alltrim(SF2->F2_SERIE) + '^FS' + CRLF
			cEtq += '^PQ1,0,1,Y^' + CRLF
			cEtq += '^XZ'
			*/

			//NOVO LAYOUT
			cEtq := 'CT~~CD,~CC^~CT~' + CRLF
			//cEtq += '^XA~TA000~JSN^LT-10^MNW^MTD^PON^PMN^LH0,0^JMA^PR4,4~SD15^JUS^LRN^CI27^PA0,1,1,0^XZ' + CRLF
			cEtq += '^XA~TA000~JSN^LT-10^MNW^MTT^PON^PMN^LH0,0^JMA^PR4,4~SD15^JUS^LRN^CI27^PA0,1,1,0^XZ' + CRLF
			cEtq += '^XA' + CRLF
			cEtq += '^MMT' + CRLF
			cEtq += '^PW824' + CRLF
			cEtq += '^LL288' + CRLF
			cEtq += '^LS0' + CRLF
			cEtq += '^FO18,26^GFA,53,856,4,:Z64:eJz7z8DA8B8J1zcML2x/YHhh+QfDB/N/GF6YHQkDAILf1RM=:B4C9' + CRLF
			cEtq += '^FO24,26^GB369,0,8^FS' + CRLF
			cEtq += '^FO385,28^GB0,206,8^FS' + CRLF
			cEtq += '^FO25,231^GFA,33,432,48,:Z64:eJxjYCAN/CcF/BtVT231AB5rbpg=:48D6' + CRLF
			cEtq += '^FO22,68^GFA,49,480,48,:Z64:eJxjYKAGYP6PFXxgYMAugQOMqidT/R+cMQMAIUluKA==:A17B' + CRLF
			cEtq += '^FO22,182^GB364,0,8^FS' + CRLF
			cEtq += '^FT29,62^A0N,22,28^FH\^CI28^FDNOTA: ' + Alltrim(SF2->F2_DOC) + '  SERIE: ' + Alltrim(SF2->F2_SERIE) + '^FS^CI27' + CRLF
			cEtq += '^FT29,109^A0N,25,35^FH\^CI28^FD' + substr(SA4->A4_NOME,1,20) + '^FS^CI27' + CRLF
			cEtq += '^FT29,144^A0N,29,20^FH\^CI28^FD' + substr(SA1->A1_NOME,1,35) + ' ^FS^CI27' + CRLF
			cEtq += '^FT29,180^A0N,29,20^FH\^CI28^FD' + substr(SA1->A1_NOME,36,35) + ' ^FS^CI27' + CRLF
			cEtq += '^FT32,227^A0N,29,33^FH\^CI28^FDVOLUMES: ^FS^CI27' + CRLF
			cEtq += '^FT244,230^A0N,29,33^FH\^CI28^FD' + Alltrim(StrZero(nQtdVIni,4)) + '/' + Alltrim(StrZero(nQtdVFim,4)) + '^FS^CI27' + CRLF
			cEtq += '^FO354,31^GFA,133,168,4,:Z64:eJxjYMAFmBYwMDA6MDAwP2BgYD0ApBuANFCcH0wzLeAHyoowMDywY2C4IMPA8ANIBwD5P3YwMMQEMDBY/GBgEAHSdkC+jACQVmBgEAVq50MxBmIsIxKNAwAAu3MQBg==:F6E0' + CRLF

			//etiqueta ao lado
			lLado := .F.
			if nVol+1 <= nQtdVol
				lLado := .T.
				nVol++	//incrementa 1 na repeticao
				cEtq += '^FO434,26^GFA,53,856,4,:Z64:eJz7z8DA8B8J1zcML2x/YHhh+QfDB/N/GF6YHQkDAILf1RM=:B4C9' + CRLF
				cEtq += '^FO440,26^GB369,0,8^FS' + CRLF
				cEtq += '^FO801,28^GB0,206,8^FS' + CRLF
				cEtq += '^FO441,231^GFA,33,432,48,:Z64:eJxjYCAN/CcF/BtVT231AB5rbpg=:48D6' + CRLF
				cEtq += '^FO438,68^GFA,49,480,48,:Z64:eJxjYKAGYP6PFXxgYMAugQOMqidT/R+cMQMAIUluKA==:A17B' + CRLF
				cEtq += '^FO438,182^GB364,0,8^FS' + CRLF
				cEtq += '^FT445,62^A0N,22,28^FH\^CI28^FDNOTA: ' + Alltrim(SF2->F2_DOC) + '  SERIE: ' + Alltrim(SF2->F2_SERIE) + '^FS^CI27' + CRLF
				cEtq += '^FT445,109^A0N,25,35^FH\^CI28^FD' + substr(SA4->A4_NOME,1,20) + '^FS^CI27' + CRLF
				cEtq += '^FT445,144^A0N,29,20^FH\^CI28^FD' + substr(SA1->A1_NOME,1,35) + ' ^FS^CI27' + CRLF
				cEtq += '^FT445,180^A0N,29,20^FH\^CI28^FD' + substr(SA1->A1_NOME,36,35) + ' ^FS^CI27' + CRLF
				cEtq += '^FT448,227^A0N,29,33^FH\^CI28^FDVOLUMES: ^FS^CI27' + CRLF
				cEtq += '^FT660,230^A0N,29,33^FH\^CI28^FD' + Alltrim(StrZero(nQtdVIni+1,4)) + '/' + Alltrim(StrZero(nQtdVFim,4)) + '^FS^CI27' + CRLF
				cEtq += '^FO770,31^GFA,133,168,4,:Z64:eJxjYMAFmBYwMDA6MDAwP2BgYD0ApBuANFCcH0wzLeAHyoowMDywY2C4IMPA8ANIBwD5P3YwMMQEMDBY/GBgEAHSdkC+jACQVmBgEAVq50MxBmIsIxKNAwAAu3MQBg==:F6E0' + CRLF
			endif

			cEtq += '^PQ1,0,1,Y' + CRLF
			cEtq += '^XZ'

			
			//--------------------+
			// Contador do Volume |
			//--------------------+
			nQtdVIni := nQtdVIni + iif(!lLado, 1, 2)
			
			//cTotEtq += cEtq + CRLF
			
			//---------------------------+
			// Envia imagem de impressao |
			//---------------------------+
			MSCBWrite(cEtq)
			
			//---------------------------------+
			// Finaliza a Imagem da Impressora |
			//---------------------------------+
			MscbEnd()
			
		Next nVol
		
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
EndIf

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
		
	EndIf	
	SX1->( MsUnlock() )
	
Next i

RestArea( aArea )

Return
