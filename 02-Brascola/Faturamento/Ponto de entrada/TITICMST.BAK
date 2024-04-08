#include "rwmake.ch"
#include "topconn.ch"

User Function TITICMST()
************************
LOCAL cOrigem := PARAMIXB[1], aRetu := NIL
If (AllTrim(cOrigem) == 'MATA460A')
	// Titulo ST gerado pelo Faturamento (Vencimento igual a data da Emissão) 
	dbSelectArea("SE2")
	Reclock("SE2",.F.)
	SE2->E2_num := "ICM"+Alltrim(Substr(SF2->F2_doc,4,6))
	SE2->E2_vencto := SE2->E2_emissao+1
	SE2->E2_vencrea:= DataValida(SE2->E2_vencto,.T.)
	SE2->E2_vencori:= SE2->E2_vencto
	MsUnlock("SE2")
	aRetu := {SE2->E2_num,SE2->E2_vencrea}
Endif
Return aRetu