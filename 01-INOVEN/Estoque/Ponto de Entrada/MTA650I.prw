#Include 'Protheus.ch'
/*/{Protheus.doc} MTA650I

MTA650I - Ao gravar a ordem de produção

@author GoOne Consultoria - Crele Cristia
@since 16/11/2021
@version 1.0
/*/
User Function MTA650I()

local nQtdGera	:= 0
local nQtZZA	:= 0
Local nCount	:= 0
Local cSeq		:= "001"
local nVolPallet:= 0
Local nQtdPallet:= 0
Local nPallet	:= 0
Local cNPallet	:= ""

If alltrim(cFilAnt) <> '0103'
	Return
endif

//If MsgYesNo("Confirma a geração de etiqueta para esta OP?")

	//nQtdGera := mv_par01	//Quantidade a ser gerada/impressa

	nQtZZA := 0
	//Validar quantidade a ser gerada da etiqueta
	ZZA->(dbSetOrder(1))
	ZZA->(msSeek(xFilial('ZZA') + "000" + SC2->C2_NUM + SC2->C2_SEQUEN + "ORDEMPRO" + space(tamSx3("ZZA_LOJA")[1]) + "00" + SC2->C2_ITEM))
	While !ZZA->(eof()) .and. ZZA->ZZA_FILIAL == xFilial('ZZA') .and. ZZA->ZZA_NUMNF + ZZA->ZZA_SERIE + ZZA->ZZA_FORNEC + ZZA->ZZA_LOJA + ZZA->ZZA_ITEMNF == "000" + SC2->C2_NUM + SC2->C2_SEQUEN + "ORDEMPRO" + space(tamSx3("ZZA_LOJA")[1]) + "00" + SC2->C2_ITEM
		nQtZZA++
		ZZA->(dbSkip())
	End
	nQtVal := SC2->C2_QUANT - nQtZZA

	if empty(nQtVal)
		//MsgAlert( "Etiquetas já geradas para esta OP!", "Atenção" )
		Return
	endif
	//Fim

	nQtdGera := SC2->C2_QUANT

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
	//cSeqIDe	:= StrZero(nQtZZA,4)
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

	//cSeqIAte	:= StrZero(nQtZZA-1,4)
	//Chamar a impressao
	//IEXPR150Prt(mv_par02, cSeqIDe, cSeqIAte)

	MsgAlert( "Etiquetas geradas com sucesso!!!", "Atenção" )


//endif

Return
