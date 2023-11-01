#Include "Protheus.ch"
#INCLUDE "COLORS.CH"
#Include "TopConn.ch"
#INCLUDE "TBICONN.CH"
#include 'parmtype.ch'

//DESENVOLVIDO POR INOVEN


User Function IFATC010(_cliente,_loja)

//Local cPict		:= ''
//Local cX3Tit	:= ''
//Local nX		:= ''
Local aSizeAut 	:= MsAdvSize()
Local aInfo		:= {}
Local aPosObj	:= {}
Local aObjects	:= {}
Local ObjTela	:= Nil
Local oMainWnd	:= Nil
Local oSayCli01	:= Nil
Local oBjoCli	:= Nil
Local oBjoLoja	:= Nil
Local oBjoNome	:= Nil
Local oButHis1	:= Nil
Local oButHis2	:= Nil
//Local oButHis3	:= Nil

Local bOk		:= {||  ObjTela:End() }
Local bCancel 	:= {||  ObjTela:End() }
Private aFldHist := {"ZB_DTHIST","ZB_HORA","ZC_DESCRIC","ZB_USER","ZB_CONTATO","ZB_DTAGEN","ZB_FORMA","A3_NOME","ZB_CELULA"}
Private aHeadHist:= {}
Private aColsHist:= {}
Private oGetHis	 := Nil

DEFAULT _cliente := SA1->A1_COD
DEFAULT _loja    := SA1->A1_LOJA

FsCarreDad(_cliente,_loja)
/*
DbSelectArea("SX3")
DbSetOrder(2)
For nX := 1 to Len(aFldHist)
If SX3->(DbSeek(aFldHist[nX]))

cPict := SX3->X3_PICTURE

cX3Tit:= AllTrim(X3Titulo())

If Alltrim(SX3->X3_CAMPO) == "ZC_DESCRIC"
cX3Tit := "Titulo"
ElseIf Alltrim(SX3->X3_CAMPO) == "A3_NOME"
cX3Tit := "Nome Repres."
Endif

Aadd(aHeadHist, {cX3Tit,SX3->X3_CAMPO,cPict,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
Endif
Next nX

AADD(aColsHist,Array(Len(aHeadHist)+1))
aColsHist[Len(aColsHist)][Len(aHeadHist)+1] := .F.*/

aInfo   := { aSizeAut[ 1 ], aSizeAut[ 2 ], aSizeAut[ 3 ], aSizeAut[ 4 ], 3, 3 }
aPosObj := MsObjSize( aInfo, aObjects, .T. )

DEFINE MSDIALOG ObjTela TITLE OemToAnsi("Historico de Cliente") FROM aSizeAut[7],0 TO aSizeAut[6],aSizeAut[5] OF oMainWnd PIXEL Style DS_MODALFRAME

@ C(028),C(005) SAY oSayCli01  PROMPT "Cliente:"		 SIZE C(025),C(009) OF ObjTela COLORS 0, 16777215 PIXEL

@ C(028),C(042) MSGET 	oBjoCli 		VAR SA1->A1_COD 	SIZE C(030),C(010) OF ObjTela COLORS 0, 16777215 PIXEL WHEN .F.
@ C(028),C(090) MSGET 	oBjoLoja 		VAR SA1->A1_LOJA	SIZE C(015),C(010) OF ObjTela COLORS 0, 16777215 PIXEL WHEN .F.
@ C(028),C(125) MSGET 	oBjoNome 		VAR SA1->A1_NOME 	SIZE C(141),C(010) OF ObjTela COLORS 0, 16777215 PIXEL WHEN .F.

oGetHis := MsNewGetDados():New(C(050),C(003),C(200),C(500),GD_DELETE, "AllwaysTrue", "AllwaysTrue", , aFldHist,, 999, "AllwaysTrue", "", "AllwaysTrue", ObjTela, aHeadHist, aColsHist)

oGetHis:oBrowse:bLDblClick := {|| FSGrvHist(1,_cliente,_loja)}

oGetHis:oBrowse:Refresh()
oGetHis:Refresh()


oButHis1:=tButton():New(c(220),c(385),'Visualiza Histórico' ,ObjTela,{||FSGrvHist(1,_cliente,_loja)},c(065),c(012),,,,.T.)
oButHis2:=tButton():New(c(220),c(450),'Novo Histórico'      ,ObjTela,{||FSGrvHist(2,SA1->A1_COD,SA1->A1_LOJA)},c(065),c(012),,,,.T.)

Activate MsDialog ObjTela Center ON INIT EnchoiceBar(ObjTela,bOk,bCancel)

Return(Nil)

Static Function FSGrvHist(nTp,CLI,LOJA)

Local oSayHis01, oSayHis02, oSayHis03, oSayHis04, oSayHis05, oSayHis06, oSayHis07, oSayHis08, oSayHis09, oSayHis10, oDlgHInc
Local oHisTit, oHisDes, oHisDth, oHisHor, oHisDta, oHisUsr, oHisRep, oHisRaz, oHisCon, oHisFor, oHisHis, oHisCel, oHisNce
Local oHButton1, oHButton2
Local cTitulo := SPACE(06)
Local cDescric:= SPACE(40)
Local dDtHist := dDatabase
Local cHora   := Time()
Local dDtAgen := ctod("//")
Local cUser   := cUserName
Local cRepres := SA1->A1_VEND
Local cNomRep := Posicione("SA3",1,xFilial("SA3")+SA1->A1_VEND,"A3_NOME")
Local cContato:= SPACE(30)
Local cForma  := SPACE(30)
Local cHistor := SPACE(900)
Local cCelula := ''
Local cNomCel := ''
Local nOpca   := 0
Local nX

SA1->(DBSETORDER(1))
SA1->(DBSEEK(xfilial("SA1")+CLI+LOJA))


If nTp == 1
	If Len(alltrim(aColsHist[oGetHis:nAt][3])) == 0
		MsgAlert("Visualização não permitida, Historico inexistente!")
		Return
	EndIf
	chkFile('SZB')
	chkFile('SZC')
	DBSELECTAREA("SZB")
	DBSETORDER(1)
	DBSEEK(xFilial("SZB")+SA1->A1_COD+SA1->A1_LOJA+DTOS(aColsHist[oGetHis:nAt][1])+aColsHist[oGetHis:nAt][2])
	
	cTitulo  := SZB->ZB_TITULO
	cDescric := Posicione("SZC",1,xFilial("SZC")+SZB->ZB_TITULO,"ZC_DESCRIC")
	dDtHist  := SZB->ZB_DTHIST
	cHora    := SZB->ZB_HORA
	dDtAgen  := SZB->ZB_DTAGEN
	cUser    := SZB->ZB_USER
	cRepres  := SZB->ZB_RESPRES
	cNomRep  := Posicione("SA3",1,xFilial("SA3")+SZB->ZB_RESPRES,"A3_NOME")
	cContato := SZB->ZB_CONTATO
	cForma   := SZB->ZB_FORMA
	cHistor  := SZB->ZB_HISTOR
	cCelula  := SZB->ZB_CELULA
	//cNomCel  := Posicione("Z01",1,xFilial("Z01")+SA1->A1_CELULA,"Z01_REGIA")
EndIf

DEFINE MSDIALOG oDlgHInc TITLE "Histórico" FROM C(000),C(000)  TO C(350),C(900) COLORS 0, 16777215 PIXEL

@ C(007),C(005) SAY oSayHis01 PROMPT "Titulo:"                   SIZE C(075),C(007) OF oDlgHInc COLORS 0, 16777215 PIXEL

@ C(022),C(005) SAY oSayHis02 PROMPT "Data Histórico:"           SIZE C(075),C(007) OF oDlgHInc COLORS 0, 16777215 PIXEL
@ C(022),C(200) SAY oSayHis03 PROMPT "Hora:"                     SIZE C(075),C(007) OF oDlgHInc COLORS 0, 16777215 PIXEL
@ C(022),C(320) SAY oSayHis04 PROMPT "Usuario:"                  SIZE C(075),C(007) OF oDlgHInc COLORS 0, 16777215 PIXEL

@ C(037),C(005) SAY oSayHis05 PROMPT "Data Agendamento:"         SIZE C(075),C(007) OF oDlgHInc COLORS 0, 16777215 PIXEL
@ C(037),C(200) SAY oSayHis06 PROMPT "Representante:"            SIZE C(075),C(007) OF oDlgHInc COLORS 0, 16777215 PIXEL

@ C(052),C(005) SAY oSayHis07 PROMPT "Contato Empresa:"          SIZE C(075),C(007) OF oDlgHInc COLORS 0, 16777215 PIXEL
@ C(052),C(200) SAY oSayHis08 PROMPT "Forma de Contato:"         SIZE C(075),C(007) OF oDlgHInc COLORS 0, 16777215 PIXEL

@ C(067),C(005) SAY oSayHis09 PROMPT "Histórico"                 SIZE C(105),C(009) OF oDlgHInc COLORS 0, 16777215 PIXEL
@ C(067),C(200) SAY oSayHis10 PROMPT "Celula:"                   SIZE C(075),C(007) OF oDlgHInc COLORS 0, 16777215 PIXEL

@ C(007),C(055) MSGET oHisTit  VAR cTitulo  PICTURE '@!'         SIZE C(035),C(009) OF oDlgHInc COLORS 0, 16777215 PIXEL F3 "SZC" VALID VldTit(cTitulo,@cDescric) WHEN IIF(nTp==1,.F.,.T.)
@ C(007),C(100) MSGET oHisDes  VAR cDescric                      SIZE C(150),C(009) OF oDlgHInc COLORS 0, 16777215 PIXEL          WHEN .F.

@ C(022),C(055) MSGET oHisDth  VAR dDtHist  PICTURE '99/99/9999' SIZE C(040),C(009) OF oDlgHInc COLORS 0, 16777215 PIXEL          WHEN .F.
@ C(022),C(250) MSGET oHisHor  VAR cHora    PICTURE '99:99'      SIZE C(030),C(009) OF oDlgHInc COLORS 0, 16777215 PIXEL          WHEN .F.
@ C(022),C(360) MSGET oHisUsr  VAR cUser    PICTURE '@!'         SIZE C(085),C(009) OF oDlgHInc COLORS 0, 16777215 PIXEL          WHEN .F.

@ C(037),C(055) MSGET oHisDta  VAR dDtAgen  PICTURE '99/99/9999' SIZE C(040),C(009) OF oDlgHInc COLORS 0, 16777215 PIXEL //VALID (dDtAgen<>CTOD("//")) WHEN IIF(nTp==1,.F.,.T.)
@ C(037),C(250) MSGET oHisRep  VAR cRepres  PICTURE '@!'         SIZE C(035),C(009) OF oDlgHInc COLORS 0, 16777215 PIXEL F3 "SA3" VALID VldRep(cRepres,@cNomRep)  WHEN .F.
@ C(037),C(295) MSGET oHisRaz  VAR cNomRep  PICTURE '@!'         SIZE C(150),C(009) OF oDlgHInc COLORS 0, 16777215 PIXEL          WHEN .F.

@ C(052),C(055) MSGET oHisCon  VAR cContato PICTURE '@!'         SIZE C(140),C(009) OF oDlgHInc COLORS 0, 16777215 PIXEL          WHEN IIF(nTp==1,.F.,.T.)
@ C(052),C(250) MSGET oHisFor  VAR cForma   PICTURE '@!'         SIZE C(195),C(009) OF oDlgHInc COLORS 0, 16777215 PIXEL          WHEN IIF(nTp==1,.F.,.T.)

@ C(067),C(250) MSGET oHisCel  VAR cCelula  PICTURE '@!'         SIZE C(035),C(009) OF oDlgHInc COLORS 0, 16777215 PIXEL F3 "Z01" WHEN .F.
@ C(067),C(295) MSGET oHisNCe  VAR cNomCel  PICTURE '@!'         SIZE C(150),C(009) OF oDlgHInc COLORS 0, 16777215 PIXEL          WHEN .F.

@ C(080),C(005) GET   oHisHis  VAR cHistor MEMO 	             SIZE C(440),C(063) OF oDlgHInc COLORS 0, 16777215 PIXEL          //WHEN IIF(nTp==1,.F.,.T.)

IF nTp == 2
	@ C(147),C(280) BUTTON oHButton1 PROMPT "&Confirma"           SIZE C(062),C(018) OF oDlgHInc ACTION (nOpca:=1,oDlgHInc:End()) PIXEL
EndIf
@ C(147),C(360)    BUTTON oHButton2 PROMPT "&Sair"               SIZE C(062),C(018) OF oDlgHInc ACTION (nOpca:=0,oDlgHInc:End()) PIXEL

ACTIVATE MSDIALOG oDlgHInc CENTERED

If nOpca == 1
	
	RecLock("SZB",.T.)
	SZB->ZB_FILIAL  := xFilial("SZB")
	SZB->ZB_CLIENTE := SA1->A1_COD
	SZB->ZB_LOJA    := SA1->A1_LOJA
	SZB->ZB_TITULO  := cTitulo
	SZB->ZB_DTHIST  := dDtHist
	SZB->ZB_HORA    := cHora
	SZB->ZB_DTAGEN  := dDtAgen
	SZB->ZB_USER    := cUser
	SZB->ZB_RESPRES := cRepres
	SZB->ZB_CONTATO := cContato
	SZB->ZB_FORMA   := cForma
	SZB->ZB_HISTOR  := cHistor
	SZB->ZB_CELULA  := cCelula
	MsUnLock()
	
	aHeadHist := {}
	aFldHist  := {"ZB_DTHIST","ZB_HORA","ZC_DESCRIC","ZB_USER","ZB_CONTATO","ZB_DTAGEN","ZB_FORMA","A3_NOME","ZB_CELULA"}
	aColsHist := {}
	
	cQuery := " SELECT SZB.ZB_DTHIST, SZB.ZB_HORA, SZC.ZC_DESCRIC, SZB.ZB_USER, SZB.ZB_CONTATO, SZB.ZB_DTAGEN, SZB.ZB_FORMA, ISNULL(SA3.A3_NOME,'') A3_NOME, SZB.ZB_CELULA "
	cQuery += " FROM "+RetSqlName('SZB') + " SZB "
   	cQuery += " INNER JOIN "+RetSqlName('SZC') + " SZC ON   SZC.ZC_FILIAL  = '" + xFilial("SZC") + "' AND   SZC.ZC_CODIGO  = SZB.ZB_TITULO AND   SZC.D_E_L_E_T_ <> '*' "
	 cQuery += " LEFT JOIN "+RetSqlName('SA3') + " SA3  ON    SA3.A3_FILIAL  = '" + xFilial("SA3") + "' AND   SA3.A3_COD  = SZB.ZB_RESPRES  AND   SA3.D_E_L_E_T_ <> '*' "
	cQuery += " WHERE SZB.ZB_FILIAL  = '" + xFilial("SZB") + "' "
	
		cQuery += " AND   SZB.ZB_CLIENTE = '" + SA1->A1_COD + "' "
		cQuery += " AND   SZB.ZB_LOJA    = '" + SA1->A1_LOJA + "' "
	
	cQuery += " AND   SZB.D_E_L_E_T_ <> '*' "
	cQuery += " ORDER BY ZB_DTHIST+ZB_HORA DESC "
	
	If Select("TRB") > 0
		dbSelectArea("TRB")
		dbCloseArea()
	EndIf
	
	TCQuery cQuery new Alias "TRB"
	TCSetField("TRB", "ZB_DTHIST","D",08,0)
	TCSetField("TRB", "ZB_DTAGEN","D",08,0)
	
	DbSelectArea("SX3")
	DbSetOrder(2)
	For nX := 1 to Len(aFldHist)
		If SX3->(DbSeek(aFldHist[nX]))
			
			cPict := SX3->X3_PICTURE
			
			cX3Tit:= AllTrim(X3Titulo())
			
			If Alltrim(SX3->X3_CAMPO) == "ZC_DESCRIC"
				cX3Tit := "Titulo"
			ElseIf Alltrim(SX3->X3_CAMPO) == "A3_NOME"
				cX3Tit := "Nome Repres."
			EndIf
			
			Aadd(aHeadHist, {cX3Tit,SX3->X3_CAMPO,cPict,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
			SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
		Endif
	Next nX
	
	SELECT TRB
	DBGOTOP()
	Do WHILE !EOF()
		
		AADD(aColsHist,Array(Len(aHeadHist)+1))
		aColsHist[Len(aColsHist)][Len(aHeadHist)+1] := .F.
		
		aColsHist[Len(aColsHist), GdFieldPos("ZB_DTHIST", aHeadHist)] := TRB->ZB_DTHIST
		aColsHist[Len(aColsHist), GdFieldPos("ZB_HORA",   aHeadHist)] := TRB->ZB_HORA
		aColsHist[Len(aColsHist), GdFieldPos("ZC_DESCRIC",aHeadHist)] := TRB->ZC_DESCRIC
		aColsHist[Len(aColsHist), GdFieldPos("ZB_USER",   aHeadHist)] := TRB->ZB_USER
		aColsHist[Len(aColsHist), GdFieldPos("ZB_CONTATO",aHeadHist)] := TRB->ZB_CONTATO
		aColsHist[Len(aColsHist), GdFieldPos("ZB_DTAGEN", aHeadHist)] := TRB->ZB_DTAGEN
		aColsHist[Len(aColsHist), GdFieldPos("ZB_FORMA",  aHeadHist)] := TRB->ZB_FORMA
		aColsHist[Len(aColsHist), GdFieldPos("A3_NOME",   aHeadHist)] := TRB->A3_NOME
		aColsHist[Len(aColsHist), GdFieldPos("ZB_CELULA", aHeadHist)] := TRB->ZB_CELULA
		DBSKIP()
	EndDo
	
	AADD(aColsHist,Array(Len(aHeadHist)+1))
	aColsHist[Len(aColsHist)][Len(aHeadHist)+1] := .F.
	
	oGetHis:SetArray(aColsHist)
	oGetHis:oBrowse:Refresh()
	//oFolder:aDialogs[4]:Refresh()
EndIf

Return(Nil)

Static Function VldTit(cTitulo,cDescric)

Local lRet:= .T.

cDescric := SPACE(40)
If !Empty(cTitulo)
	SZC->(DbSetOrder(1))
	If !SZC->(Dbseek(xFilial("SZC")+cTitulo))
		MsgAlert("Titulo não Cadastrado!")
		lRet:= .F.
	Else
		cDescric := SZC->ZC_DESCRIC
	EndIf
EndIf

Return(lRet)
Static Function VldRep(cRepres,cNomRep)

Local lRet:= .T.
cNomRep := SPACE(40)

SA3->(DbSetOrder(1))
If !SA3->(DbSeek(xFilial("SA3")+cRepres))
	MsgAlert("Representante não Cadastrado!")
	lRet:= .F.
Else
	cNomRep := SA3->A3_NOME
EndIf
Return(lRet)

Static Function FSCarreDad(_cli,_loja)
Local nX

aHeadHist := {}
aColsHist := {}


chkFile('SZB')

cQuery := " SELECT SZB.ZB_DTHIST, SZB.ZB_HORA, SZC.ZC_DESCRIC, SZB.ZB_USER, SZB.ZB_CONTATO, SZB.ZB_DTAGEN, SZB.ZB_FORMA, ISNULL(SA3.A3_NOME,'')A3_NOME "
cQuery += " FROM "+RetSqlName('SZB') + " SZB "
cQuery += " INNER JOIN "+RetSqlName('SZC') + " SZC ON (SZC.D_E_L_E_T_ = '' AND SZC.ZC_FILIAL  = '" + xFilial("SZC") + "' AND SZC.ZC_CODIGO  = SZB.ZB_TITULO  ) "
cQuery += " LEFT JOIN  "+RetSqlName('SA3') + " SA3 ON (SA3.D_E_L_E_T_ = '' AND SA3.A3_FILIAL  = '" + xFilial("SA3") + "' AND SA3.A3_COD = SZB.ZB_RESPRES ) "
cQuery += " WHERE SZB.ZB_FILIAL  = '" + xFilial("SZB") + "' "

If AllTrim(FunName()) != 'IVENA020'
	
	cQuery += " AND   SZB.ZB_CLIENTE = '" + SA1->A1_COD + "' "
	cQuery += " AND   SZB.ZB_LOJA    = '" + SA1->A1_LOJA + "' "
ELSE
	cQuery += " AND   SZB.ZB_CLIENTE = '" + _cli + "' "
	cQuery += " AND   SZB.ZB_LOJA    = '" + _loja + "' "
ENDIF

cQuery += " AND   SZB.D_E_L_E_T_ <> '*' "
cQuery += " ORDER BY ZB_DTHIST+ZB_HORA DESC "

If Select("TRB") > 0
	dbSelectArea("TRB")
	dbCloseArea()
EndIf

TCQuery cQuery new Alias "TRB"
TCSetField("TRB", "ZB_DTHIST","D",08,0)
TCSetField("TRB", "ZB_DTAGEN","D",08,0)

DbSelectArea("SX3")
DbSetOrder(2)
For nX := 1 to Len(aFldHist)
	If SX3->(DbSeek(aFldHist[nX]))
		
		cPict := SX3->X3_PICTURE
		
		cX3Tit:= AllTrim(X3Titulo())
		
		IF  Alltrim(SX3->X3_CAMPO) == "ZC_DESCRIC"
			cX3Tit := "Titulo"
		ElseIf Alltrim(SX3->X3_CAMPO) == "A3_NOME"
			cX3Tit := "Nome Repres."
		Endif
		
		Aadd(aHeadHist, {cX3Tit,SX3->X3_CAMPO,cPict,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
		SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
	Endif
Next nX

SELECT TRB
DBGOTOP()
Do While !EOF()
	
	AADD(aColsHist,Array(Len(aHeadHist)+1))
	aColsHist[Len(aColsHist)][Len(aHeadHist)+1] := .F.
	
	aColsHist[Len(aColsHist), GdFieldPos("ZB_DTHIST", aHeadHist)]	:= TRB->ZB_DTHIST
	aColsHist[Len(aColsHist), GdFieldPos("ZB_HORA",   aHeadHist)]	:= TRB->ZB_HORA
	aColsHist[Len(aColsHist), GdFieldPos("ZC_DESCRIC",aHeadHist)]	:= TRB->ZC_DESCRIC
	aColsHist[Len(aColsHist), GdFieldPos("ZB_USER",   aHeadHist)]	:= TRB->ZB_USER
	aColsHist[Len(aColsHist), GdFieldPos("ZB_CONTATO",aHeadHist)]	:= TRB->ZB_CONTATO
	aColsHist[Len(aColsHist), GdFieldPos("ZB_DTAGEN", aHeadHist)]	:= TRB->ZB_DTAGEN
	aColsHist[Len(aColsHist), GdFieldPos("ZB_FORMA",  aHeadHist)]	:= TRB->ZB_FORMA
	aColsHist[Len(aColsHist), GdFieldPos("A3_NOME",   aHeadHist)]	:= TRB->A3_NOME
	
	DBSKIP()
EndDo

AADD(aColsHist,Array(Len(aHeadHist)+1))
aColsHist[Len(aColsHist)][Len(aHeadHist)+1] := .F.

Return(Nil)
