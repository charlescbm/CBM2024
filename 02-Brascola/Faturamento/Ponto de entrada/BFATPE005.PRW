#include "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ BFATPE005ºAutor  ³Microsiga           º Data ³  29/12/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada para validar e alterar a condicao de      º±±
±±º          ³ pagamento, caso a parcela for inferior ao definido no      º±±
±±º          ³ parametro  BR_VALMIN.                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MTA410()
********************
LOCAL aArea     := GetArea()
LOCAL oBtnSE4   := Nil
LOCAL oSaySE4   := Nil
LOCAL aSizFrm   := {}
LOCAL lRet      := .t.
LOCAL nPValor   := aScan( aHeader,{|x| AllTrim(x[2])=="C6_VALOR" })
LOCAL nPCFOP    := aScan( aHeader,{|x| AllTrim(x[2])=="C6_CF" })
LOCAL nPProd    := aScan( aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO" })
LOCAL nX        := 0
LOCAL nY        := 0
LOCAL nW        := 0
LOCAL nZ        := Len(aCols)
LOCAL nUsado    := Len(aHeader)
LOCAL nPProd    := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO" })
LOCAL nPQtdVen  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN"  })
LOCAL nPPrcVen  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRCVEN"  })
LOCAL nPValor   := aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALOR"   })
LOCAL nPTES		 := aScan(aHeader,{|x| AllTrim(x[2])=="C6_TES"     })
LOCAL nPItem	 := aScan(aHeader,{|x| AllTrim(x[2])=="C6_ITEM"    })
LOCAL nPQtdLib  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDLIB"  })
LOCAL nPRegra   := aScan(aHeader,{|x| AllTrim(x[2])=="C6_X_REGRA" })
LOCAL nPLocal   := aScan(aHeader,{|x| AllTrim(x[2])=="C6_LOCAL"   })
LOCAL nPEntreg  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_ENTREG"  })
LOCAL nx, nTotal := 0, cQuery1
LOCAL cEstNor := Alltrim(GetMV("BR_000012")) //Estados Nordeste
LOCAL nValMinF := GetMV("BR_000013") //Valor Minimo para Frete
LOCAL nValMinP := GetMV("BR_000022") //Valor Minimo para Pedido

PRIVATE nC6Valor := 0
PRIVATE oDlgSE4
PRIVATE oListBox := Nil
PRIVATE aParc := {}
PRIVATE cCond  := M->C5_CONDPAG
PRIVATE cTipo := M->C5_TIPO
PRIVATE aBonin :={}

If (!u_EFATA04()) //Valido Cliente x Representante
	Return (lRet := .F.)
Endif

If (cTipo == "N")
	
	//CRIA O PARAMETRO CASO NÃO EXISTA.
	SX6->(DbSetOrder(1))
	If !SX6->(dbSeek(xFilial("sx6")+"BR_VALMIN"))
		RecLock("SX6",.t.)
		SX6->X6_FIL     := ""
		SX6->X6_VAR     := "BR_VALMIN"
		SX6->X6_DESCRIC := "ESPECIFICO BRASCOLA - DEFINE O VALOR MINIMO DA    "
		SX6->X6_DESC1   := "PARCELA."
		SX6->X6_TIPO    := "N"
		SX6->X6_CONTEUD := "0.01"
		MsUnLock()()
	EndIf
	
	For nX := 1 to Len(aCols)
		dbSelectArea("SB1")
		dbSetOrder(1)
		dbGoTop()
		If dbSeek(xFilial("SB1")+aCols[nX,nPProd])
			If SUBSTR(aCols[nX,nPCFOP],2,3) $ GetMv("BR_VALCFOP") .And. SB1->B1_TIPO == '3 ' .and. aCols[nx,nPLOCAL] == '40' .and. !aCols[nx,nPTES] $ ('549/546/573/755/822/825/823/756')
				nC6Valor += aCols[nx,nPValor]
			Endif
		EndIf
	Next nX
	
	If GetMV("BR_VALMIN") > 0  .And. nC6Valor > 0 //se o valor minimo for zero não faz sentido.
		aSizFrm := MsAdvSize()
		
		If nC6Valor < GetMV("BR_VALMIN")
			If cCond <> '000' .and. cCond <> '001'.and. cCond <> '060'
				MsgBox ("O valor  do pedido deve ser maior que R$ " + Alltrim(Transform(GetMV("BR_VALMIN"),"@E 999,999,999.99")) + ".","Atencao","ALERT")
				lRet := .f.
			Endif
		Else
			aParc :=  Condicao(nC6Valor,cCond,0)
			While .t.
				If aParc[1,2] < GetMV("BR_VALMIN")
					
					DEFINE FONT oFont NAME "Arial" SIZE 000,-012 BOLD
					DEFINE MSDIALOG oDlgSE4 TITLE "Condição de pagamento" FROM 000, 000 TO aSizFrm[6]*80/110 ,aSizFrm[5]*60/110 COLORS 0, 15658734 PIXEL
					
					@ 010, 015 SAY oSaySE4 prompt "O valor da Parcela deve ser maior que R$ " + Alltrim(Transform(GetMV("BR_VALMIN"),"@E 999,999,999.99"))+"." SIZE 275, 007 OF oDlgSE4 PIXEL FONT oFont
					@ 025, 015 Say oSaySE4 prompt "Escolha outra Condição de pagamento:" SIZE 175, 007 OF oDlgSE4 PIXEL FONT oFont
					@ 043, 017 MSGET cCond F3 "SE42" Valid VldCond() SIZE 050, 011 OF oDlgSE4 PIXEL PIXEL FONT oFont
					
					@ 025, 135 LISTBOX oListBox Fields,;
					HEADER           "Vencimento",		"Valor"		SIZE 160, 150 OF oDlgSE4 PIXEL ColSizes 50,50
					/*Largura*//*Altura*/
					oListBox:SetArray(aParc)
					oListBox:bLine := {|| {	aParc[oListBox:nAt][1],;
					Transform(aParc[oListBox:nAt][2],"@E 999,999,999,999.99") }}
					oListBox:Refresh()
					
					@ 070, 030 BUTTON oBtnSE4 PROMPT "Ok" SIZE 046, 013 OF oDlgSE4 Action {|| oDlgSE4:End()}PIXEL
					
					ACTIVATE MSDIALOG oDlgSE4 CENTERED
				EndIf
				aParc :=  Condicao(nC6Valor,cCond,0)
				If aParc[1,2] >= GetMV("BR_VALMIN")
					// atualiza nova condicao no pedido
					M->C5_CONDPAG := cCond
					lRet := .t.
					Exit
				EndIf
			End
		EndIf
	EndIf
	
	aBonusb := U_BFtRgrB(aCols,{nPProd,nPQtdVen,nPTES},M->C5_CLIENTE,M->C5_LOJACLI,M->C5_TABELA,M->C5_CONDPAG,SE4->E4_FORMA,,M->C5_VEND1)
	IF LEN(aBonusb) > 0
		telbon(aBonusb,1)
		If MsgYesNo("Deseja gerar bonificacao dos itens selecionados.Confirma?")
			nY := Len(aBonin)
			If nY > 0
				cItem := aCols[nZ,nPItem]
				For nX := 1 To nY
					cItem := Soma1(cItem)
					aadd(aCols,Array(nUsado+1))
					nZ++
					N := nZ
					For nW := 1 To nUsado
						If (aHeader[nW,2] <> "C6_REC_WT") .And. (aHeader[nW,2] <> "C6_ALI_WT")
							aCols[nZ,nW] := CriaVar(aHeader[nW,2],.T.)
						EndIf
					Next nW
					aCols[nZ,nUsado+1] := .F.
					aCols[nZ,nPItem  ] := cItem
					A410Produto(aBonin[nX][1],.F.)
					A410MultT("M->C6_PRODUTO",aBonin[nX][1])
					A410MultT("M->C6_TES",aBonin[nX][3])
					aCols[nZ,nPProd  ] := aBonin[nX][1]
					If ExistTrigger("C6_PRODUTO")
						RunTrigger(2,Len(aCols))
					Endif
					aCols[nZ,nPQtdVen] := aBonin[nX][2]
					aCols[nZ,nPTES   ] := aBonin[nX][3]
					If ( aCols[nZ,nPPrcVen] == 0 )
						aCols[nZ,nPPrcVen] := 1
						aCols[nZ,nPValor ] := aCols[nZ,nPQtdVen]
					Else
						aCols[nZ,nPValor ] := A410Arred(aCols[nZ,nPQtdVen]*aCols[nZ,nPPrcVen],"C6_VALOR")
					EndIf
					If ExistTrigger("C6_TES    ")
						RunTrigger(2,Len(aCols))
					Endif
					aCols[nZ,nPREGRA ] := aBonin[nX][4]
					//	If mv_par01 == 1
					//		aCols[nZ,nPQtdLib ] := aCols[nZ,nPQtdVen ]
					//	Endif
					
					//		If lA410BLCo
					//			aCols[nZ] := ExecBlock("A410BLCO",.F.,.F.,{aHeader,aCols[nZ]})
					//		Endif
				Next nX
			EndIf
		EndIf
		
		/*
		
		DEFINE FONT oFont NAME "Arial" SIZE 0,-12 BOLD
		DEFINE MSDIALOG oDlg FROM 096,042 TO 350,580 TITLE "Produto Bonificado" PIXEL
		//@ 11,3 To 113,264 Title OemToAnsi(" Não Disponivel para Produção - "+_cCod+"   ")
		@ 030,012 LISTBOX oListBox1 VAR cListBox1 Fields HEADER ;
		OEMTOANSI("Produto"),;
		OEMTOANSI("Qtd.Bonificada"),;
		OEMTOANSI("escolha"),;
		FIELDSIZES ;
		GetTextWidth(0,"BBBBBBBBBBB"),;
		GetTextWidth(0,"BBBBBBBBBBB"),;
		GetTextWidth(0,"BBBBBBBBBBB"),;
		SIZE 245,060 NOSCROLL PIXEL
		oListBox1:SetArray(aBonusb)
		oListBox1:bLine 		:= {|| {	aBonusb[oListBox1:nAt,1],;
		aBonusb[oListBox1:nAt,2]}}
		
		@ 095,230 BmpButton Type 1 Action  oDlg:End()
		ACTIVATE DIALOG oDlg CENTERED
		
		
		*/
	Endif
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tratamento de Bonificacao por Valor Pedido ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (cTipo == "N").and.(ZZQ->(FieldPos("ZZQ_PEDMIN")) > 0)
	nTotal := 0 ; cCodReg := Space(6)
	SA1->(dbSetOrder(1)) ; SF4->(dbSetOrder(1))
	For nx := 1 to Len(aCols)
		If !GDDeleted(nx) .and.SF4->(dbSeek(xFilial("SF4")+GDFieldGet("C6_TES",nx),.T.)).and.(SF4->F4_duplic == "S")
			nTotal += GDFieldGet("C6_VALOR",nx)
		Endif
	Next nx
	If (nTotal > 0).and.SA1->(dbSeek(xFilial("SA1")+M->C5_cliente+M->C5_lojacli))
		cQuery1 := "SELECT ZZQ_CODREG FROM "+RetSqlName("ZZQ")+" ZZQ WHERE ZZQ.D_E_L_E_T_ = '' AND ZZQ.ZZQ_FILIAL = '"+xFilial("ZZQ")+"' "
		cQuery1 += "AND ZZQ_TIPO = '3' AND ZZQ_PEDMIN <= '"+Alltrim(Str(nTotal))+"' AND ZZQ_PEDMAX >= '"+Alltrim(Str(nTotal))+"' "
		cQuery1 += "AND (ZZQ_GRPVEN = '' OR ZZQ_GRPVEN = '"+SA1->A1_grpven+"') AND (ZZQ_CODTAB = '' OR ZZQ_CODTAB = '"+M->C5_tabela+"') "
		cQuery1 += "AND (ZZQ_CODCLI = '' OR ZZQ_CODCLI = '"+SA1->A1_cod+"') AND (ZZQ_DATDE <= '"+dtos(dDatabase)+"' AND ZZQ_DATATE >= '"+dtos(dDatabase)+"') "
		cQuery1 += "AND (ZZQ_REG1 = '' OR ZZQ_REG1 = '"+SA1->A1_regiao+"' OR ZZQ_REG2 = '"+SA1->A1_regiao+"' OR ZZQ_REG3 = '"+SA1->A1_regiao+"' "
		cQuery1 += " OR ZZQ_REG4 = '"+SA1->A1_regiao+"' OR ZZQ_REG5 = '"+SA1->A1_regiao+"' OR ZZQ_REG6 = '"+SA1->A1_regiao+"') "
		cQuery1 += "AND (ZZQ_VEND1 = '' OR ZZQ_VEND1 = '"+SA1->A1_vend+"') "
		cQuery1 += "ORDER BY ZZQ_CODREG "
		cQuery1 := ChangeQuery(cQuery1)
		If (Select("MAR") <> 0)
			dbSelectArea("MAR")
			dbCloseArea()
		Endif
		TCQuery cQuery1 NEW ALIAS "MAR"
		dbSelectArea("MAR")
		If !MAR->(Eof())
			cCodReg := MAR->ZZQ_codreg
		Endif
		If (Select("MAR") <> 0)
			dbSelectArea("MAR")
			dbCloseArea()
		Endif
		If !Empty(cCodReg)
			If (Type("cTesBonus") == "U")
				cTesBonus := &(GetMv("MV_BONUSTS"))
			Endif
			aBonusb := {}
			ZZR->(dbSetOrder(1))
			ZZR->(dbSeek(xFilial("ZZR")+cCodReg,.T.))
			While !ZZR->(Eof()).and.(xFilial("ZZR") == ZZR->ZZR_filial).and.(ZZR->ZZR_codreg == cCodReg)
				Aadd(aBonusb,{ZZR->ZZR_codpro,Max(1,ZZR->ZZR_qtdmax),cTesBonus,cCodReg})
				ZZR->(dbSkip())
			Enddo
			If (Len(aBonusb) > 0)
			 	aBonin := {}
				TelBon(aBonusb,2)
				If (Len(aBonin) > 0)
					cItem := Soma1(aCols[Len(aCols),nPItem])
					aadd(aCols,Array(nUsado+1))
					nLin1 := Len(aCols)
					N := nLin1
					For nW := 1 To nUsado
						If (aHeader[nW,2] <> "C6_REC_WT") .And. (aHeader[nW,2] <> "C6_ALI_WT")
							aCols[nLin1,nW] := CriaVar(aHeader[nW,2],.T.)
						Endif
					Next nW
					aCols[nLin1,nUsado+1] := .F.
					aCols[nLin1,nPItem] := cItem
					If (nLin1 > 1).and.(nPEntreg > 0)
						aCols[nLin1,nPEntreg] := aCols[1,nPEntreg]
					Endif
					A410Produto(aBonin[1,1],.F.)
					A410MultT("M->C6_PRODUTO",aBonin[1,1])
					A410MultT("M->C6_TES",aBonin[1,3])
					aCols[nLin1,nPProd] := aBonin[1,1]
					If ExistTrigger("C6_PRODUTO")
						RunTrigger(2,Len(aCols))
					Endif
					aCols[nLin1,nPQtdVen] := aBonin[1,2]
					aCols[nLin1,nPTES] := aBonin[1,3]
					If (aCols[nLin1,nPPrcVen] == 0 )
						aCols[nLin1,nPPrcVen] := 1
						aCols[nLin1,nPValor] := aCols[nLin1,nPQtdVen]
					Else
						aCols[nLin1,nPValor] := A410Arred(aCols[nLin1,nPQtdVen]*aCols[nLin1,nPPrcVen],"C6_VALOR")
					EndIf
					If ExistTrigger("C6_TES")
						RunTrigger(2,Len(aCols))
					Endif
					aCols[nLin1,nPRegra] := aBonin[1,4]
				Endif
			Endif
		Endif
	Endif
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Valido regiao do cliente e valor minimo. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (cTipo == "N")
	nTotal := 0
	SA1->(dbSetOrder(1))
	If SA1->(dbSeek(xFilial("SA1")+M->C5_cliente+M->C5_lojacli)).and.(SA1->A1_est $ cEstNor)
		For nx := 1 to Len(aCols)
			If !GDDeleted(nx) .and. !GDFieldGet("C6_TES",nx) $ ('546/573/755/822/825/823/756/549')
				nTotal += GDFieldGet("C6_VALOR",nx)
			Endif
		Next nx
		If (nTotal > 0).and.(nTotal < nValMinP) .and. (M->C5_condpag != "060")
			Help("",1,"BRASCOLA",,OemToAnsi("Valor minimo para estados "+cEstNor+" é de "+Alltrim(Str(nValMinP))+"!"),1,0)
			Return (lRet := .F.)
		Endif
	Endif
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Valido cliente digitado.                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (!u_BXRepAdm()) //Parametro/Presidente/Diretor
	cCodRep := u_BXRepLst("FIL") //Lista dos Representantes
	If !Empty(cCodRep)
		SA1->(dbSetOrder(1))
		If SA1->(dbSeek(xFilial("SA1")+M->C5_cliente+M->C5_lojacli)).and.!(Alltrim(SA1->A1_vend) $ cCodRep)
			Help("",1,"BRASCOLA",,OemToAnsi("Cliente nao faz parte da carteira do representante!"),1,0)
			Return (lRet := .F.)
		Endif
	Else
		Help("",1,"BRASCOLA",,OemToAnsi("Representante nao possui acesso no cadastro de clientes!"),1,0)
		Return (lRet := .F.)
	Endif
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ 30/01/13 - Marcelo - Gravavao Historico. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (lRet)
	u_GDVHCompara("SC5")
	u_GDVHCompara("SC6")
Endif

RestArea(aArea)

Return(lRet)

//VALIDA A NOVA CONDICAO DE PAGAMENTO.
Static Function VldCond()
**********************
SE4->(DbSetOrder(1))
If SE4->(DbSeek(xFilial("SE4")+cCond))
	aParc :=  Condicao(nC6Valor,cCond,0)
	oListBox:SetArray(aParc)
	oListBox:bLine := {|| {	aParc[oListBox:nAt][1],;
	Transform(aParc[oListBox:nAt][2],"@E 999,999,999,999.99") }}
	oListBox:Refresh()
	lRet := .t.
Else
	MsgBox ("Condicao de Pagamento invalida.","Atencao","ALERT")
	lRet := .f.
EndIf
Return(lRet)

Static Function TelBon(aBonusb,xTipo)
*********************************
LOCAL aCampos		:= {}  // Campos apresentado na tela
LOCAL aRegistros	:= {}  // Array com resgristos
LOCAL	l1Elem 		:= .F. // Variavel que define apenas um retorno
LOCAL cTitulo 	   := "Selecione as Bonificacoes" // Titulo da janela
LOCAL cMark 		:= ""								// Retorno funcao f_Opcoes
LOCAL MvParDef  	:= ""								// String de Opcoes para Retorno
LOCAL nCont 		:= 0
LOCAL aResul	   := {}

PRIVATE cCarga	   := ""

If (xTipo == 2)
	l1Elem  := .T. // Variavel que define apenas um retorno
	cTitulo := "Selecione as Bonificacoes por Valor" // Titulo da janela
Endif

For i := 1 to Len(aBonusb)
	_desc:=Posicione("SB1",1,xFilial("SB1")+aBonusb[i,1],"B1_DESC")
	Aadd(aCampos,alltrim(aBonusb[i,1])+"-" +alltrim(_desc)+" - QTD:."+str(aBonusb[i,2],4) )
	Aadd(aRegistros, {aBonusb[i,1],aBonusb[i,2],aBonusb[i,3],aBonusb[i,4] } )
	nCont ++
	MvParDef += StrZero(nCont,4)
Next i

// Chamada do Mark
F_Opcoes(@cMark, cTitulo, aCampos, MvParDef, 12, 49, l1Elem, 004, Len(aRegistros))

If !Empty(cMark)
	For nI := 1 to Len(cMark)
		If (SubStr(cMark,nI,4) <> "****")
			aAdd(aBonin,{aRegistros[Val(SubStr(cMark,nI,4))][1],aRegistros[Val(SubStr(cMark,nI,4))][2],aRegistros[Val(SubStr(cMark,nI,4))][3],aRegistros[Val(SubStr(cMark,nI,4))][4]})
			//				Aadd(aRetorno,{(cCursor)->ZZQ_CODPRO,aRemove[nX][2]*nQuant,cTesBonus,(cCursor)->ZZQ_CODREG})
			nI := nI+3
		Else
			nI := nI+3
		Endif
	Next nI
Endif

Return (aBonin)