#INCLUDE "PROTHEUS.CH"

User Function GFEXFB08()

Local cCdTpDc  := PARAMIXB[1] 
Local cEmisDc  := PARAMIXB[2]
Local cSerDc   := PARAMIXB[3]
Local cNrDc    := PARAMIXB[4]
Local cSeq     := PARAMIXB[5]
Local lRetorno := .F.
	
	dbSelectArea('GWU')
	GWU->(dbSetOrder(1)) //GWU_FILIAL+GWU_CDTPDC+GWU_EMISDC+GWU_SERDC+GWU_NRDC+GWU_SEQ
	
	If GWU->(dbSeek(xFilial('GWU')+cCdTpDc+cEmisDc+cSerDc+cNrDc+cSeq))
		If GWU->GWU_SEQ == "02"
			lRetorno :=  .F.
		EndIf 
	EndIf

Return lRetorno
