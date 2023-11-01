#Include "Protheus.ch"
#INCLUDE "COLORS.CH"
#Include "TopConn.ch"
#INCLUDE "TBICONN.CH"
#define DS_MODALFRAME   128
#DEFINE USADO CHR(0)+CHR(0)+CHR(1) 

#DEFINE  ENTER CHR(13)+CHR(10)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณIVENA030  บAutor  ณ Gabriel Gon็alves  บ Data ณ  23/02/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณMontagem da tela de condi็ใo negociada	                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ			 ณ															  บฑฑ
ฑฑบ          ณ														      บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
//DESENVOLVIDO POR INOVEN


//Tela Condicao Negociada
User Function IVENA030(oDlg, oFolder, oSayCNCli, oGetCNCod, oGetCNLoj, oGetCNCli, oSayCNVTot, oGetCNVTot, oSayCNVUti, oGetCNVUti, oSayCNMaxP, oGetCNMaxP, oSayCNMinP, oGetCNMinP, cCNCod_Cli, cCNLoja_Cli, cCNNomeCli, nCNVal_Tot, nCNVal_Uti, nCNMax_Par, nCNMin_Par, oGetConNe,nCNDif_Par,nCNCre_Cli)

Local aSizeAut	:= MsAdvSize()
Local aButtons	:= {}
Local lGesVen	:= .F.
Local nHeight	:= 0
Local nWidth	:= 0
Local nOpc		:= GD_INSERT+GD_UPDATE+GD_DELETE
Local aValores	:= {}

//Variaveis do pedido
Local cCodFil	:= ""
Local cNumPed	:= ""
Local cNumNF	:= ""
Local cCodCli	:= ""
Local cLojaCli	:= ""
Local nX

Private oDlgAux

// Variaveis Condicao Negociada
Private aHeadConNe := {}
Private aFldConNe  := {"Z1_SEQUENC","Z1_COND","E4_DESCRI","Z1_NATUREZ","ED_DESCRIC","Z1_DTIVENC","Z1_DTFVENC","Z1_VALCON","Z1_VALPAR","Z1_NSU","Z1_AUTORIZ","Z1_ADQUIRI","Z1_CODBAND","Z1_BANDEIR"}
Private aColsConNe := {}
Private aAltConNe  := {"Z1_COND","Z1_VALCON","Z1_DTIVENC","Z1_NSU","Z1_AUTORIZ","Z1_ADQUIRI","Z1_CODBAND"}//ppl 30/03/2017

//Valida se veio da tela de gestใo de vendas e faz as tratativas
If ValType(oDlg) <> 'U'
	oDlgAux	:= oFolder:aDialogs[6]
	lGesVen	:= .T.
	
	//Atualiza os valores
	cCNCod_Cli	:= Space(TamSX3("A1_COD")[1])
	cCNLoja_Cli	:= Space(TamSX3("A1_LOJA")[1])
	cCNNomeCli	:= Space(TamSX3("A1_NOME")[1])
	nCNVal_Tot	:= 0
	nCNVal_Uti	:= 0
	nCNMax_Par	:= GetNewPar("FS_MAXPAR", 5)
	nCNMin_Par	:= 0 
	nCNCre_Cli  := fBuscCred(cCNCod_Cli,cCNLoja_Cli)
	nCNDif_Par  := 0
Else	
	/*If(aSizeAut[6] <= 0 .OR. aSizeAut[5] <= 0) //Monta o tamanho da janela caso nao exista (utilizado no debug)
		aSizeAut[5] := 1200
		aSizeAut[6] := 700
	Endif*/
	
	If IsInCallStack("MATA410")
		cCodFil		:= SC5->C5_FILIAL
		cNumPed		:= SC5->C5_NUM
		cNumNF		:= SC5->C5_NOTA
		cCodCli		:= SC5->C5_CLIENTE
		cLojaCli	:= SC5->C5_LOJACLI
	ElseIf IsInCallStack("MATA450")
		cCodFil		:= SC9->C9_FILIAL
		cNumPed		:= SC9->C9_PEDIDO
		cNumNF		:= SC9->C9_NFISCAL
		cCodCli		:= SC9->C9_CLIENTE
		cLojaCli	:= SC9->C9_LOJA
	EndIf
	
	//Busca dados da condi็ใo negociada
	aValores	:= fValTotPed(cCodFil, cNumPed, cNumNF)
	
	If !aValores[1]
		Aviso("Condi็ใo Negociada","O pedido "+AllTrim(cNumPed)+" nใo possui condi็ใo negociada.",{"OK"})
		Return()
	EndIf
	
	DEFINE MSDIALOG oDlgAux TITLE OemToAnsi("Condi็ใo Negociada") FROM aSizeAut[7],0 TO aSizeAut[6],aSizeAut[5] OF oMainWnd PIXEL Style DS_MODALFRAME
	
	aAltConNe	:= {}
	nOpc		:= 2
	
	//Atualiza os valores
	cCNCod_Cli	:= cCodCli
	cCNLoja_Cli	:= cLojaCli
	cCNNomeCli	:= Posicione("SA1",1,xFilial("SA1")+cCodCli+cLojaCli,"A1_NOME")
	nCNVal_Tot	:= aValores[2]
	nCNVal_Uti	:= aValores[3]
	nCNMax_Par	:= GetNewPar("FS_MAXPAR", 5)
	nCNMin_Par	:= (nCNVal_Tot - aValores[4]) / nCNMax_Par
	aColsConNe	:= aValores[5]
	nCNDif_Par  := aValores[2] - aValores[3] 
	nCNCre_Cli  := fBuscCred(cCNCod_Cli,cCNLoja_Cli)
	
EndIf

//Monta a tela
@ 005,005 SAY oSayCNCli  PROMPT "Cliente:"		 				SIZE 035,009 OF oDlgAux COLORS 0, 16777215 PIXEL

@ 020,005 SAY oSayCNVTot PROMPT "Valor Total do Or็amento:"		SIZE 080,009 OF oDlgAux COLORS 0, 16777215 PIXEL
@ 020,130 SAY oSayCNVUti PROMPT "Valor Utilizado do Or็amento:"	SIZE 080,009 OF oDlgAux COLORS 0, 16777215 PIXEL
@ 020,255 SAY oSayCNDife PROMPT "Valor a Uitlizar do Or็amento:" SIZE 080,009 OF oDlgAux COLORS 0, 16777215 PIXEL

@ 036,005 SAY oSayCNMaxP PROMPT "N๚mero Mแximo de Parcelas:"	SIZE 080,009 OF oDlgAux COLORS 0, 16777215 PIXEL
@ 036,130 SAY oSayCNMinP PROMPT "Valor Mํnimo de Parcelas:"		SIZE 080,009 OF oDlgAux COLORS 0, 16777215 PIXEL
@ 036,255 SAY oSayCNCred PROMPT "Valor em Cr้dito do Cliente:"	 SIZE 080,009 OF oDlgAux COLORS 0, 16777215 PIXEL

@ 004,040 MSGET	oGetCNCod	VAR	cCNCod_Cli	SIZE 020,010 OF oDlgAux COLORS 0, 16777215 WHEN .F. PIXEL
@ 004,065 MSGET	oGetCNLoj	VAR	cCNLoja_Cli	SIZE 020,010 OF oDlgAux COLORS 0, 16777215 WHEN .F. PIXEL
@ 004,090 MSGET	oGetCNCli	VAR	cCNNomeCli	SIZE 160,010 OF oDlgAux COLORS 0, 16777215 WHEN .F. PIXEL

@ 019,085 MSGET	oGetCNVTot	VAR	nCNVal_Tot	PICTURE "@E 999,999,999.99" SIZE 040,010 OF oDlgAux COLORS 0, 16777215 WHEN .F. PIXEL
@ 019,210 MSGET	oGetCNVUti	VAR	nCNVal_Uti	PICTURE "@E 999,999,999.99" SIZE 040,010 OF oDlgAux COLORS 0, 16777215 WHEN .F. PIXEL
@ 019,335 MSGET	oSayCNDife	VAR	nCNDif_Par	PICTURE "@E 999,999,999.99" SIZE 040,010 OF oDlgAux COLORS 0, 16777215 WHEN .F. PIXEL

@ 035,085 MSGET	oGetCNMaxP	VAR	nCNMax_Par	SIZE 040,010 OF oDlgAux COLORS 0, 16777215 WHEN .F. PIXEL
@ 035,210 MSGET	oGetCNMinP	VAR	nCNMin_Par	PICTURE "@E 999,999,999.99" SIZE 040,010 OF oDlgAux COLORS 0, 16777215 WHEN .F. PIXEL
@ 035,335 MSGET	oSayCNCred	VAR	nCNCre_Cli	PICTURE "@E 999,999,999.99" SIZE 040,010 OF oDlgAux COLORS 0, 16777215 WHEN .F. PIXEL

aHeadConNe := {}

DbSelectArea("SX3")
DbSetOrder(2)
For nX := 1 to Len(aFldConNe)
	If SX3->(DbSeek(aFldConNe[nX]))
		
		cPict := SX3->X3_PICTURE
		cX3Tit:= AllTrim(X3Titulo())
		cValid:= SX3->X3_VALID
		
		/*If SX3->X3_CAMPO == "Z1_COND"
			cValid:= "!Pertence("+AllTrim(GetNewPar("FS_CONNEG",""))+")"			
		EndIf*/
		
		Aadd(aHeadConNe, {cX3Tit,SX3->X3_CAMPO,cPict,SX3->X3_TAMANHO,SX3->X3_DECIMAL,cValid,;
			SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO,;
			SX3->X3_WHEN,"A"})
		
	Endif
Next nX

If oDlgAux:nHeight == 0
	nHeight	:= 233
	nWidth	:= 641
Else
	nHeight	:= (oDlgAux:nHeight/2)-30
	nWidth	:= (oDlgAux:nWidth/2)-5
EndIf

oGetConNe := MsNewGetDados():New(052,003,nHeight,nWidth,nOpc, "AllwaysTrue", "AllwaysTrue", "+Z1_SEQUENC", aAltConNe,, 999, "AllwaysTrue", "", "AllwaysTrue", oDlgAux, aHeadConNe, aColsConNe)

If lGesVen
	oGetConNe:bFieldOk	:= {|| U_GatConNeg(@oGetConNe, @nCNVal_Tot, @nCNVal_Uti, @nCNMax_Par, @nCNMin_Par, @oGetCNVUti, @oGetCNMinP , @nCNDif_Par, @nCNCre_Cli, @oSayCNDife)}
	oGetConNe:bDelOk	:= {|| U_AtuConNeg(@oGetConNe, @nCNVal_Tot, @nCNVal_Uti, @nCNMax_Par, @nCNMin_Par, @oGetCNVUti, @oGetCNMinP , @nCNDif_Par, @nCNCre_Cli, @oSayCNDife)}
EndIf

oGetConNe:oBrowse:Refresh()
oGetConNe:Refresh()

//Dispara a tela caso nใo seja no gestใo de vendas
If lGesVen == .F.
	ACTIVATE MSDIALOG oDlgAux ON INIT EnchoiceBar(oDlgAux,{|| oDlgAux:End()},{|| oDlgAux:End()},,aButtons)
EndIf

Return() 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGatConNeg บAutor  ณ Gabriel Gon็alves  บ Data ณ  02/03/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGatilhos da tela de condi็ใo negociada	                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ			 ณ															  บฑฑ
ฑฑบ          ณ														      บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function GatConNeg(oGetConNe, nCNVal_Tot, nCNVal_Uti, nCNMax_Par, nCNMin_Par, oGetCNVUti, oGetCNMinP, nCNDif_Par, nCNCre_Cli, oSayCNDife)

Local cCampo	:= ReadVar()
Local cCondPagt	:= ""
Local nValCond	:= 0
Local aCondPgt	:= {}
Local lContinua	:= .T.
Local cDescCond	:= ""
Local cTipoPG	:= ""
Local cDescPG	:= ""
Local nTotGrid	:= 0
Local nAVisGrid	:= 0
Local nValParMin:= 0

Local nPosCond	:= GDFieldPos("Z1_COND",	oGetConNe:aHeader)
Local nPosDesCon:= GDFieldPos("E4_DESCRI",	oGetConNe:aHeader)
Local nPosNat	:= GDFieldPos("Z1_NATUREZ",	oGetConNe:aHeader)
Local nPosDesNat:= GDFieldPos("ED_DESCRIC",	oGetConNe:aHeader)
Local nPosDtIVen:= GDFieldPos("Z1_DTIVENC",	oGetConNe:aHeader)
Local nPosDtFVen:= GDFieldPos("Z1_DTFVENC",	oGetConNe:aHeader)
Local nPosValCon:= GDFieldPos("Z1_VALCON",	oGetConNe:aHeader)
Local nPosValPar:= GDFieldPos("Z1_VALPAR",	oGetConNe:aHeader)
//Local nPosValNsu:= GDFieldPos("Z1_NSU", 	oGetConNe:aHeader)
//Local nPosValAut:= GDFieldPos("Z1_AUTORIZ",	oGetConNe:aHeader)
//Local nPosValAdq:= GDFieldPos("Z1_ADQUIRI",	oGetConNe:aHeader)
//Local nPosValCob:= GDFieldPos("Z1_CODBAND",	oGetConNe:aHeader)
//Local nPosValBan:= GDFieldPos("Z1_BANDEIR",	oGetConNe:aHeader)
Local nDiasCon	:= GetNewPar("FS_DIASCON",0)
Local nDiasAlt
Local nX
Do Case
	Case cCampo == "M->Z1_COND"
		cCondPagt	:= AllTrim(M->Z1_COND)
		nValCond	:= oGetConNe:aCols[oGetConNe:nAt][nPosValCon]
		aCondPgt	:= Condicao(IIF(nValCond <> 0, nValCond, 10000),cCondPagt,,dDataBase,,,,,,)
		
		DbSelectArea("SE4")
		SE4->(DbSetOrder(01))
		
		//Valida se a condi็ใo de pagamento ้ a propria negociada
		If AllTrim(cCondPagt) $ AllTrim(GetNewPar("FS_CONNEG",""))
			lContinua	:= .F.
			Aviso("Condi็ใo Negociada","Nใo ้ possivel utilizar a condi็ใo negociada dentro da mesma. Selecione outra condi็ใo.",{"OK"})
			
		//Valida se a condi็ใo de pagamento ้ bonifica็ใo
		ElseIf AllTrim(cCondPagt) $ AllTrim(GetNewPar("FS_CONDBON",""))
			lContinua	:= .F.
			Aviso("Condi็ใo Negociada","Nใo ้ possivel utilizar condi็ใo de bonifica็ใo. Selecione outra condi็ใo.",{"OK"})
		
		//Valida se existe a condi็ใo de pagamento
		ElseIf !SE4->(DbSeek(xFilial('SE4')+cCondPagt))
			lContinua	:= .F.
			Aviso("Condi็ใo Pagamento","Nใo foi encontrada a condi็ใo de pagamento. Selecione outra condi็ใo.",{"OK"})
		
		//Valida se pode utilizar a condi็ใo de pagamento no TGV
		//ElseIf SE4->E4_XTGV <> '1'
		//	lContinua	:= .F.
		//	Aviso("Condi็ใo Pagamento","Nใo ้ possivel utilizar esta condi็ใo de pagamento no TGV, entre em contato com o cadastro caso seja necessario.",{"OK"})
		
		//Valida se ja existe a condi็ใo de pagamento
		Else
			//Busca as condi็๕es ja utilizadas no grid
			For nX := 1 To Len(oGetConNe:aCols)
				If !oGetConNe:aCols[nX][Len(aCols[nX])] .And. nX <> oGetConNe:nAt //Desconsidera deletados / linha atual
					If AllTrim(oGetConNe:aCols[nX][nPosCond]) == AllTrim(cCondPagt)
						lContinua	:= .F.
						nX	:= Len(oGetConNe:aCols)
						Aviso("Condi็ใo Pagamento","Condi็ใo de pagamento jแ estแ em uso.",{"OK"})
					EndIf
				EndIf
			Next nX
		EndIf
		
		If lContinua
			cDescCond	:= SE4->E4_DESCRI
			
			If "BOL" $ SE4->E4_DESCRI
				cTipoPG   :="BOL"
			   	cDescPG	  :="BOLETO BANCARIO"
			ElseIf "CC" $ SE4->E4_DESCRI
				cTipoPG   :="CC"
			   	cDescPG	  :="CARTAO DE CREDITO"
			ElseIf "CD" $ SE4->E4_DESCRI
				cTipoPG   :="CD"
			   	cDescPG	  :="CARTAO DE DEBITO AUTOMATICO"
			ElseIf "CH" $ SE4->E4_DESCRI
				cTipoPG   :="CH"
			   	cDescPG	  :="CHEQUE"
			ElseIf "FAT" $ SE4->E4_DESCRI
				cTipoPG   :="FAT"
			   	cDescPG	  :="FATURA"
			ElseIf "CR" $ SE4->E4_DESCRI
				cTipoPG   :="CR"
			   	cDescPG	  :="CREDITO"
			EndIf
			
			oGetConNe:aCols[oGetConNe:nAt][nPosDesCon]	:= cDescCond
			oGetConNe:aCols[oGetConNe:nAt][nPosNat]		:= cTipoPG
			oGetConNe:aCols[oGetConNe:nAt][nPosDesNat]	:= cDescPG
			
			If Len(aCondPgt) > 0
				If nValCond <> 0
					oGetConNe:aCols[oGetConNe:nAt][nPosValPar]	:= aCondPgt[1][2]
				Else
					oGetConNe:aCols[oGetConNe:nAt][nPosValPar]	:= 0
				EndIf
				oGetConNe:aCols[oGetConNe:nAt][nPosDtIVen]	:= aCondPgt[1][1]
				oGetConNe:aCols[oGetConNe:nAt][nPosDtFVen]	:= aCondPgt[Len(aCondPgt)][1]
			Else
				oGetConNe:aCols[oGetConNe:nAt][nPosValPar]	:= 0
				oGetConNe:aCols[oGetConNe:nAt][nPosDtIVen]	:= dDataBase
				oGetConNe:aCols[oGetConNe:nAt][nPosDtFVen]	:= dDataBase
			EndIf
		EndIf
		
	Case cCampo == "M->Z1_VALCON"
		cCondPagt	:= AllTrim(oGetConNe:aCols[oGetConNe:nAt][nPosCond])
		nValCond	:= M->Z1_VALCON
		aCondPgt	:= Condicao(nValCond,cCondPagt,,dDataBase,,,,,,)
		
		//Busca os valores do grid
		For nX := 1 To Len(oGetConNe:aCols)
			If !oGetConNe:aCols[nX][Len(oGetConNe:aCols[nX])] //Desconsidera deletados
				If nX <> oGetConNe:nAt //Desconsidera linha atual em edi็ใo
					nTotGrid	+= oGetConNe:aCols[nX][nPosValCon]
					nAVisGrid	+= U_ValAVisCon(AllTrim(oGetConNe:aCols[nX][nPosCond]), oGetConNe:aCols[nX][nPosValCon])
				Else //Considera a linha atual
					nAVisGrid	+= U_ValAVisCon(AllTrim(oGetConNe:aCols[nX][nPosCond]), nValCond)
				EndIf
			EndIf
		Next nX
		
		nValParMin	:= (nCNVal_Tot-nAVisGrid) / GetNewPar("FS_MAXPAR", 1)
		
		//Valida o valor digitado com o valor total do pedido/ja utilizado em outras condi็๕es
		If nValCond > nCNVal_Tot
			//lContinua	:= .F.
			Aviso("Valor Total","Valor da condi็ใo superior ao total do pedido.",{"OK"})
		
		//Valida o valor digitado com o valor ja utilizado em outras condi็๕es
		ElseIf nValCond + nTotGrid > nCNVal_Tot
			//lContinua	:= .F.
			Aviso("Valor Total","Valor da condi็ใo superior ao valor restante do pedido. R$ "+AllTrim(Str(nCNVal_Tot-nTotGrid))+".",{"OK"})
		
		//Valida as parcelas da condi็ใo
		ElseIf aCondPgt[1][2] < nValParMin
			For nX := 1 To Len(aCondPgt)
				If ( aCondPgt[nX][1] - dDataBase ) > GetNewPar("FS_DIAVIS",0)
				   	//lContinua	:= .F.
				   	nX	:= Len(aCondPgt)
					Aviso("Valor Parcela","Valor das parcelas inferior ao valor minimo das parcelas (desconsiderando pagamentos a vista at้ ";
							+AllTrim(Str(GetNewPar("FS_DIAVIS",0)))+" dias)."; //Dias considerados a vista
							+" Parcela R$ "+AllTrim(Str(aCondPgt[1][2])); //Valor das parcelas na condi็ใo
							+" - Parcela Minima R$ "+AllTrim(Str(Round(nValParMin,2)))+"."; //Valor minimo das parcelas
							,{"OK"})
				EndIf
			Next nX
		EndIf
		
		//Grava os dados da condi็ใo no aCols
		If lContinua
			If Len(aCondPgt) > 0
				oGetConNe:aCols[oGetConNe:nAt][nPosValPar]	:= aCondPgt[1][2]
				oGetConNe:aCols[oGetConNe:nAt][nPosDtIVen]	:= aCondPgt[1][1]
				oGetConNe:aCols[oGetConNe:nAt][nPosDtFVen]	:= aCondPgt[Len(aCondPgt)][1]
			Else
				oGetConNe:aCols[oGetConNe:nAt][nPosValPar]	:= 0
				oGetConNe:aCols[oGetConNe:nAt][nPosDtIVen]	:= dDataBase
				oGetConNe:aCols[oGetConNe:nAt][nPosDtFVen]	:= dDataBase
			EndIf
			
			//Atualiza os valores utilizado/parcela minima
			nCNVal_Uti	:= nTotGrid+nValCond
			nCNMin_Par	:= nValParMin     
			nCNDif_Par  := nCNVal_Tot - nCNVal_Uti
		EndIf
//ppl sn 30/03/2017
	Case cCampo == "M->Z1_DTIVENC" 
		nDiasAlt	:= ABS(M->Z1_DTIVENC-dDatabase)
		If nDiasAlt > nDiasCon //m๓dulo da conta for maior que a tolerโncia
			MsgAlert("A data poderแ ser alterada em no mแximo "+AllTrim(Str(nDiasAlt))+" dias !")		
			lContinua := .F.
		Else
			cCondPagt	:= AllTrim(oGetConNe:aCols[oGetConNe:nAt][nPosCond])
			nValCond	:= Iif(oGetConNe:aCols[oGetConNe:nAt][nPosValCon]==0,1,oGetConNe:aCols[oGetConNe:nAt][nPosValCon])
			aCondPgt	:= Condicao(nValCond,cCondPagt,,M->Z1_DTIVENC,,,,,,)
	
			oGetConNe:aCols[oGetConNe:nAt][nPosDtIVen] := aCondPgt[1][1]
			oGetConNe:aCols[oGetConNe:nAt][nPosDtFVen] := aCondPgt[Len(aCondPgt)][1]
		EndIf
//ppl en 30/03/2017
EndCase

//Atualiza os dados da tela
oGetCNVUti:Refresh()
oGetCNMinP:Refresh()
oSayCNDife:Refresh()

oGetConNe:oBrowse:Refresh()
oGetConNe:Refresh()

Return(lContinua)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณValAVisCon บAutor ณ Gabriel Gon็alves  บ Data ณ  03/03/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณBusca valor de pagamento a vista na condi็ใo			      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ			 ณ															  บฑฑ
ฑฑบ          ณ														      บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function ValAVisCon(cCondPgt, nValCond)

Local nRet		:= 0
Local aCondPgt	:= Condicao(nValCond,cCondPgt,,dDataBase,,,,,,)
Local nZ

For nZ := 1 To Len(aCondPgt)
	If ( aCondPgt[nZ][1] - dDataBase ) <= GetNewPar("FS_DIAVIS",0)
		nRet := aCondPgt[nZ][2]
	EndIf
Next nZ

Return(nRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfValTotPed บAutor ณ Gabriel Gon็alves  บ Data ณ  08/03/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณBusca valores do pedido / condi็ใo negociada			      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ			 ณ															  บฑฑ
ฑฑบ          ณ														      บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fValTotPed(cCodFil, cCodPed, cNFPed)

Local cQuery	:= ""
Local cAlias	:= GetNextAlias()
Local nValPed	:= 0
Local nValUti	:= 0
Local nValAvi	:= 0
Local lAchou	:= .F.
Local aDados	:= {}
Local cTipoPG	:= ""
Local cDescPG	:= ""
Local aCond		:= {}
Local dDataIni
Local dDataFim

Default cNFPed	:= ""

aDados	:= {{"001",Space(TamSX3("Z1_COND")[1]),"","","",dDataBase,dDataBase,0,0,.F.}}

//Busca Valores da condi็ใo negociada
cQuery := "SELECT Z1_SEQUENC, Z1_COND, E4_DESCRI, Z1_DTIVENC, Z1_DTFVENC, Z1_VALCON, Z1_VALPAR, Z1_TOTPED,Z1_NSU,Z1_AUTORIZ,Z1_ADQUIRI,Z1_CODBAND,Z1_BANDEIR "

cQuery += " FROM "+RetSqlName("SZ1")+" SZ1"
cQuery += " INNER JOIN "+RetSqlName("SE4")+" SE4 ON SZ1.Z1_COND = SE4.E4_CODIGO AND SE4.D_E_L_E_T_ <> '*'"

cQuery += " WHERE SZ1.Z1_FILIAL = '"+cCodFil+"'"
cQuery += " AND SZ1.Z1_PEDIDO = '"+cCodPed+"'"
cQuery += " AND SZ1.D_E_L_E_T_ <> '*'"

cQuery += " ORDER BY SZ1.Z1_SEQUENC"

dbUseArea(.T., 'TOPCONN', TcGenQry(,, cQuery), cAlias, .F., .T. )

(cAlias)->(DbGoTop())
If !(cAlias)->(EoF())
	lAchou	:= .T.
	aDados	:= {}
	nValPed	:= (cAlias)->(Z1_TOTPED)
	
	While !(cAlias)->(EoF())
		If "BOL" $ (cAlias)->E4_DESCRI
			cTipoPG   :="BOL"
		   	cDescPG	  :="BOLETO BANCARIO"
		ElseIf "CC" $ (cAlias)->E4_DESCRI
			cTipoPG   :="CC"
		   	cDescPG	  :="CARTAO DE CREDITO"
		ElseIf "CD" $ (cAlias)->E4_DESCRI
			cTipoPG   :="CD"
		   	cDescPG	  :="CARTAO DE DEBITO AUTOMATICO"
		ElseIf "CH" $ (cAlias)->E4_DESCRI
			cTipoPG   :="CH"
		   	cDescPG	  :="CHEQUE"
		ElseIf "FAT" $ (cAlias)->E4_DESCRI
			cTipoPG   :="FAT"
		   	cDescPG	  :="FATURA"
		ElseIf "CR" $ (cAlias)->E4_DESCRI
			cTipoPG   :="CR"
		   	cDescPG	  :="CREDITO"
		EndIf
		
		If EMPTY(cNFPed)
			aCond		:= Condicao((cAlias)->(Z1_VALCON), (cAlias)->(Z1_COND),, dDataBase,,,,,,)
			dDataIni	:= aCond[1][1]
			dDataFim	:= aCond[Len(aCond)][1]
		Else
			dDataIni	:= StoD((cAlias)->(Z1_DTIVENC))
			dDataFim	:= StoD((cAlias)->(Z1_DTFVENC))
		EndIf
		
		aAdd(aDados, {	(cAlias)->(Z1_SEQUENC);
						,(cAlias)->(Z1_COND);
						,(cAlias)->(E4_DESCRI);
						,cTipoPG;
						,cDescPG;
						,dDataIni;
						,dDataFim;
						,(cAlias)->(Z1_VALCON);
						,(cAlias)->(Z1_VALPAR);
						,(cAlias)->(Z1_NSU);
						,(cAlias)->(Z1_AUTORIZ);
						,(cAlias)->(Z1_ADQUIRI);
						,(cAlias)->(Z1_CODBAND);
						,(cAlias)->(Z1_BANDEIR);
						,.F.})
						
		nValUti	+= (cAlias)->(Z1_VALCON)
		nValAvi	+= U_ValAVisCon((cAlias)->(Z1_COND), (cAlias)->(Z1_VALCON))
		
		(cAlias)->(DbSkip())
	EndDo
EndIf
(cAlias)->(DbCloseArea())

Return({lAchou, nValPed, nValUti, nValAvi, aDados})

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAtuConNeg บAutor  ณ Gabriel Gon็alves  บ Data ณ  02/03/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAtualiza dados na tela de condi็ใo negociada                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ			 ณ															  บฑฑ
ฑฑบ          ณ														      บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function AtuConNeg(oGetConNe, nCNVal_Tot, nCNVal_Uti, nCNMax_Par, nCNMin_Par, oGetCNVUti, oGetCNMinP, nCNDif_Par, nCNCre_Cli,oSayCNDife)

Local lContinua	:= .T.
Local nTotGrid	:= 0
Local nAVisGrid	:= 0
Local nValParMin:= 0

Local nPosCond	:= GDFieldPos("Z1_COND",	oGetConNe:aHeader)
//Local nPosDtIVen:= GDFieldPos("Z1_DTIVENC",	oGetConNe:aHeader)
//Local nPosDtFVen:= GDFieldPos("Z1_DTFVENC",	oGetConNe:aHeader)
Local nPosValCon:= GDFieldPos("Z1_VALCON",	oGetConNe:aHeader)
//Local nPosValPar:= GDFieldPos("Z1_VALPAR",	oGetConNe:aHeader)
//Local nPosValNsu:= GDFieldPos("Z1_NSU", 	oGetConNe:aHeader)
//Local nPosValAut:= GDFieldPos("Z1_AUTORIZ",	oGetConNe:aHeader)
//Local nPosValAdq:= GDFieldPos("Z1_ADQUIRI",	oGetConNe:aHeader)
//Local nPosValCob:= GDFieldPos("Z1_CODBAND",	oGetConNe:aHeader)
//Local nPosValBan:= GDFieldPos("Z1_BANDEIR",	oGetConNe:aHeader)
Local nX

//Busca os valores do grid
For nX := 1 To Len(oGetConNe:aCols)
	If nX <> oGetConNe:nAt //Desconsidera linha atual em edi็ใo
		If !oGetConNe:aCols[nX][Len(oGetConNe:aCols[nX])] //Desconsidera deletados
			nTotGrid	+= oGetConNe:aCols[nX][nPosValCon]
			nAVisGrid	+= U_ValAVisCon(AllTrim(oGetConNe:aCols[nX][nPosCond]), oGetConNe:aCols[nX][nPosValCon])
		EndIf
	Else //Considera a linha atual
		If oGetConNe:aCols[nX][Len(oGetConNe:aCols[nX])] //Se estiver restaurando o registro
			nTotGrid	+= oGetConNe:aCols[nX][nPosValCon]
			nAVisGrid	+= U_ValAVisCon(AllTrim(oGetConNe:aCols[nX][nPosCond]), oGetConNe:aCols[nX][nPosValCon])
		EndIf
	EndIf
Next nX

nValParMin	:= (nCNVal_Tot-nAVisGrid) / GetNewPar("FS_MAXPAR", 1)

//Atualiza os valores utilizado/parcela minima
nCNVal_Uti	:= nTotGrid
nCNMin_Par	:= nValParMin
nCNDif_Par  := nCNVal_Tot - nCNVal_Uti

//Atualiza os dados da tela
oGetCNVUti:Refresh()
oGetCNMinP:Refresh()
oSayCNDife:Refresh()
oGetConNe:oBrowse:Refresh()
oGetConNe:Refresh()

Return(lContinua)

Static Function fBuscCred(ccli,cLoj)

Local nValor := 0
  
cQuery := "SELECT SUM(SE1.E1_SALDO) E1SALDO "
cQuery += "FROM "+RetSqlName("SE1")+" SE1 "
cQuery += "WHERE SUBSTRING(SE1.E1_FILIAL,1,2)  = '"+SubStr(xFilial("SE1"),1,2)+"' "
cQuery += "AND   SE1.E1_CLIENTE = '"+ccli+"' "
cQuery += "AND   SE1.E1_LOJA    = '"+cLoj+"' "
cQuery += "AND   SE1.E1_SALDO   > 0 "
cQuery += "AND   SE1.E1_TIPO IN ('NCC','RA' ) "
cQuery += "AND   SE1.D_E_L_E_T_ <> '*' "

If Select("CRE") > 0
	dbSelectArea("CRE")
	dbCloseArea()
EndIf

TcQuery cQuery New Alias "CRE"

dbSelectArea("CRE")
DBGOTOP()
If !Eof()
	nValor := CRE->E1SALDO
EndIf

If Select("CRE") > 0
	dbSelectArea("CRE")
	dbCloseArea()
EndIf

**
Return ( nValor )
**
User function FCADSZ1()
	
	Private cCadastro	:= "Cadastro de Condi็๕es Negociadas"
	Private aRotina		:= {}
	 
	AxCadastro("SZ1", OemToAnsi(cCadastro), 'AllwaysTrue')       

Return()

User function FCADSZ2()
	
	Private cCadastro	:= "Cadastro de Produtos em Promo็ใo"
	Private aRotina		:= {}
	 
	AxCadastro("SZ2", OemToAnsi(cCadastro), 'AllwaysTrue')       

Return()
