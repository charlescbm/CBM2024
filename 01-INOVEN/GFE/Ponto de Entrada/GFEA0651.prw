#INCLUDE "PROTHEUS.CH"

User Function GFEA0651()

Local cOper  := PARAMIXB[1] 
Local cCodPrd := ''
	
if cOper == 3	//Inlcusao/Ateracao

	GU3->(dbSetOrder(1))
	if GU3->(msSeek(xFilial('GU3') + GW3->GW3_EMISDF))
		if GU3->GU3_TPTRIB == '2' .and. GU3->GU3_CONICM == '2'
			cCodPrd := SuperGetMv("IN_PRITDF",.F.,"")	//Codigo do produto de frete
		endif
	endif

endif

Return cCodPrd
