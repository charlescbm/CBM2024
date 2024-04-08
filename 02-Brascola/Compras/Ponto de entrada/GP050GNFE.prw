#include "rwmake.ch"
#include "topconn.ch"
                    
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GP050GNFE ºAutor  ³ Marcelo da Cunha   º Data ³  19/03/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada para gravar informacoes da conferencia    º±±
±±º          ³ cega, após a geração da pre-nota de entrada.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function GP050GNFE()
***********************
LOCAL cCod := Space(6), lProcOk := .F.
LOCAL aSF1 := SF1->(GetArea())
LOCAL aSD1 := SD1->(GetArea())
If (ZGN->ZGN_status == "2") //Prenota
	cCod := GetMV("MV_CONCEGA")
	SF1->(dbSetOrder(1)) ; SD1->(dbSetOrder(1))
	SF1->(dbSeek(xFilial("SF1")+ZGN->ZGN_doc+ZGN->ZGN_serie+ZGN->ZGN_clifor+ZGN->ZGN_loja,.T.))
	While !SF1->(Eof()).and.(xFilial("SF1") == SF1->F1_filial).and.(SF1->F1_doc+SF1->F1_serie+SF1->F1_fornece+SF1->F1_loja == ZGN->ZGN_doc+ZGN->ZGN_serie+ZGN->ZGN_clifor+ZGN->ZGN_loja) 
		Reclock("SZC",.T.)
		SZC->ZC_filial := xFilial("SZC")
		SZC->ZC_cod    := cCod
		SZC->ZC_fornec := SF1->F1_fornece
		SZC->ZC_loja   := SF1->F1_loja
		SZC->ZC_nome   := Posicione("SA2",1,xFilial("SA2")+SF1->F1_fornece+SF1->F1_loja,"A2_NOME")
		SZC->ZC_nfiscal:= SF1->F1_doc
		SZC->ZC_serie  := SF1->F1_serie
		SZC->ZC_emissnf:= SF1->F1_emissao
		MsUnlock("SZC")
		lProcOk := .T.
		SD1->(dbSeek(xFilial("SD1")+SF1->F1_doc+SF1->F1_serie+SF1->F1_fornece+SF1->F1_loja,.T.))
		While !SD1->(Eof()).and.(xFilial("SD1") == SD1->D1_filial).and.(SF1->F1_doc+SF1->F1_serie+SF1->F1_fornece+SF1->F1_loja == SD1->D1_doc+SD1->D1_serie+SD1->D1_fornece+SD1->D1_loja) 
			Reclock("SZD",.T.)
			SZD->ZD_filial := xFilial("SZD")
			SZD->ZD_aviso  := cCod
			SZD->ZD_item   := Val(SD1->D1_item)
			SZD->ZD_cod    := SD1->D1_cod
			SZD->ZD_descric:= Posicione("SB1",1,xFilial("SB1")+SD1->D1_cod,"B1_DESC")
			SZD->ZD_um     := SD1->D1_um
			SZD->ZD_quant  := SD1->D1_quant
			SZD->ZD_lote   := SD1->D1_lotefor
			SZD->ZD_dtvalid:= SD1->D1_dtvalid
			MsUnlock("SZD")
			SD1->(dbSkip())
		Enddo		
		SF1->(dbSkip())
	Enddo
	If (lProcOk)
		PutMV("MV_CONCEGA",Strzero(Val(cCod)+1,6))
		If ExistBlock("AVISOIMP")
			ExecBlock("AVISOIMP",.F.,.F.,cCod)
		Endif
	Endif
	RestArea(aSD1)
	RestArea(aSF1)	
Endif
Return