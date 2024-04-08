#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "TbiConn.ch"
#INCLUDE "TOPCONN.CH"

User Function geranota()
*********************************
//	oEspecie
cEspecie := space(10)
cNumcx	 := space(15)
cPedcli	 := space(25)
//	oObserv
cObserv := space(200)
//	oPesob
nPesob := 0
//	oPesoL
nPesoL := 0
//	oSay1
//	oSay2
//	oSay3
//	oSay4
//	oSay5
//	oVolume
nVolume := 0
Static oDlg

DEFINE MSDIALOG oDlg TITLE "New Dialog" FROM 000, 000  TO 350, 500 COLORS 0, 16777215 PIXEL
@ 014, 010 SAY oSay1 PROMPT "ESPECIE" 		SIZE 045, 009 OF oDlg 						COLORS 0, 16777215 PIXEL
@ 014, 070 MSGET oEspecie VAR cEspecie 		SIZE 080, 010 OF oDlg 						COLORS 0, 16777215 PIXEL
@ 034, 010 SAY oSay2 PROMPT "VOLUME" 		SIZE 033, 015 OF oDlg 						COLORS 0, 16777215 PIXEL
@ 034, 070 MSGET oVolume VAR nVolume 		SIZE 080, 010 OF oDlg PICTURE "@Z 999,99" 	COLORS 0, 16777215 PIXEL
@ 054, 010 SAY oSay1 PROMPT "Nr DE CAIXAS" 	SIZE 045, 009 OF oDlg 						COLORS 0, 16777215 PIXEL
@ 054, 070 MSGET oNumcx  VAR cNumcx 		SIZE 080, 010 OF oDlg 						COLORS 0, 16777215 PIXEL
@ 074, 010 SAY oSay3 PROMPT "PESO LIQUIDO" 	SIZE 040, 015 OF oDlg 						COLORS 0, 16777215 PIXEL
@ 074, 070 MSGET oPesoL VAR nPesoL 			SIZE 080, 010 OF oDlg PICTURE "@Z 999,999" 	COLORS 0, 16777215 PIXEL
@ 094, 010 SAY oSay4 PROMPT "PESO BRUTO" 	SIZE 046, 015 OF oDlg 						COLORS 0, 16777215 PIXEL
@ 094, 070 MSGET oPesob VAR nPesob 			SIZE 080, 010 OF oDlg PICTURE "@Z 999,999" 	COLORS 0, 16777215 PIXEL
@ 114, 010 SAY oSay5 PROMPT "OBSERVACAO" 	SIZE 044, 010 OF oDlg 						COLORS 0, 16777215 PIXEL
@ 114, 070 MSGET oObserv VAR cObserv 		SIZE 080, 010 OF oDlg 						COLORS 0, 16777215 PIXEL
@ 134, 010 SAY oSay5 PROMPT "PED CLIENTE" 	SIZE 044, 010 OF oDlg 						COLORS 0, 16777215 PIXEL
@ 134, 070 MSGET oPedcli VAR cPedcli 		SIZE 080, 010 OF oDlg 						COLORS 0, 16777215 PIXEL
@ 160, 090 BUTTON oButton1 PROMPT "OK" 		SIZE 024, 013 OF oDlg ACTION oDlg:End() PIXEL
ACTIVATE MSDIALOG oDlg CENTERED

cQuery1 := " SELECT SC9.*  "
cQuery1 += " FROM "+RETSQLNAME("SC9")+" SC9 "
cQuery1 += " WHERE C9_PEDIDO IN   ('" + AllTrim( StrTran( SUBSTR(_NUMPED,1,LEN(ALLTRIM(_NUMPED))-1), "/", "','" ) ) + "') "
cQuery1 += " AND  SC9.C9_BLEST    = '  ' "
cQuery1 += " AND SC9.C9_BLCRED   = '  '  "
cQuery1 += " AND SC9.C9_NFISCAL  = '  '  "
cQuery1 += " AND SC9.D_E_L_E_T_ <> '*'   "
cQuery1 += " AND C9_FILIAL = '"+xFilial("SC6")+"' "
cQuery1 += " ORDER BY C9_PEDIDO,C9_ITEM,C9_PRODUTO "

If Select("TRBA") > 0
	TRBA->(DbCloseArea())
EndIf

TCQUERY cQuery1 NEW ALIAS TRBA

dbSelectArea("TRBA")
dbGotop()

while !TRBA->(eof())
	nOpc := 3
	aPvlNfs := {}
	cPedido := TRBA->C9_PEDIDO
	
	DBSELECTAREA("SC5")
	DBSETORDER(1)
	DBSEEK(XFILIAL("SC5")+TRBA->C9_PEDIDO)
	
	IF ! EOF()
		RECLOCK("SC5",.F.)
		C5_MENNOTA	:=ALLTRIM(cObserv)
		C5_ESPECI1	:=ALLTRIM(cEspecie)
		C5_VOLUME1	:=nVolume
		C5_PESOL	:=nPesoL
		C5_PBRUTO	:=nPesoB
		C5_X_NUMCX	:=ALLTRIM(cNumcx)
		C5_XPEDCLI	:=ALLTRIM(cPedcli)
		MSUNLOCK()
	ENDIF
	
	While !Eof() .And. TRBA->C9_PEDIDO == cPedido
		dbSelectArea("SC9")
		dbSetOrder(1)
		//	dbGoto(TRB->R_E_C_N_O_)
		SC9->(DbSeek(xFilial("SC9")+TRBA->C9_PEDIDO+TRBA->C9_ITEM+TRBA->C9_SEQUEN+TRBA->C9_PRODUTO) )
		
		cNumPed  := SC9->C9_PEDIDO
		cItemPed := SC9->C9_ITEM
		cProduto := SC9->C9_PRODUTO
		
		SC6->(DbSetOrder(1))
		SC6->(DbSeek(xFilial("SC6")+cNumPed+cItemPed) )                    //FILIAL+NUMERO+ITEM
		
		SE4->(DbSetOrder(1))
		SE4->(DbSeek(xFilial("SE4")+SC5->C5_CONDPAG) )                           //FILIAL+NUMERO+ITEM+PRODUTO
		
		SB1->(DbSetOrder(1))
		SB1->(DbSeek(xFilial("SB1")+SC9->C9_PRODUTO) )               //FILIAL+PRODUTO
		
		SB2->(DbSetOrder(1))
		SB2->(DbSeek(xFilial("SB2")+SC9->C9_PRODUTO+SC9->C9_LOCAL) )          //FILIAL+PRODUTO+LOCAL
		
		SF4->(DbSetOrder(1))
		SF4->(DbSeek(xFilial("SF4")+SC6->C6_TES) )                            //FILIAL+CODIGO
		
		If !Empty(SC5->C5_TABELA)
			cTabela := "DAK"
			DAK->(DbSetOrder(1))
			DAK->(DbSeek(xFilial("DAK")+SC5->C5_TABELA))                            //FILIAL+CODIGO
			
		Else
			cTabela := ""
			
		EndIf
		
		Aadd(aPvlNfs,{ SC9->C9_PEDIDO,;
		SC9->C9_ITEM,;
		SC9->C9_SEQUEN,;
		SC9->C9_QTDLIB,;
		SC6->C6_PRCVEN,;     //Informação indicando o Preço de Venda
		SC9->C9_PRODUTO,;
		.f.,;
		SC9->(RecNo()),;
		SC5->(RecNo()),;
		SC6->(RecNo()),;
		SE4->(RecNo()),;
		SB1->(RecNo()),;
		SB2->(RecNo()),;
		SF4->(RecNo()),;
		SB2->B2_LOCAL,;
		Iif(cTabela<>"DAK",0,DAK->(RecNo())),SC9->C9_QTDLIB2})
		dbSelectArea("TRBA")
		dbSkip()
	EndDo
	
	cserie := "7  "
	If Len(aPvlNfs) > 0
		cNota := MaPvlNfs(aPvlNfs,cserie, .F., .F., .f., .f., .F., 0, 0, .T., .F.)
	EndIf
enddo

DBCLOSEAREA("TRBA")
DBCLOSEAREA("TRBC")

Return

