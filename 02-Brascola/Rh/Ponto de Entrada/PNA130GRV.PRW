//Abaixo segue um exemplo de customiza��o onde � gravado um log de altera��o da marca��o.
#INCLUDE "RWMAKE.CH"

USER FUNCTION PNA130GRV()
Local _aArea := GetArea()
Local i , j
Local _cOpc := ParamIxb[3]

If _cOpc == 3 .Or. _cOpc == 4  // 3 - Inclus�o, 4 - Altera��o
	
	// Grava Log de Altera��o
	dbSelectArea("PA2")
	RecLock("PA2",.T.)
	PA2->PA2_FILIAL := xFilial("PA2")
	PA2->PA2_MAT 	:= SRA->RA_MAT
	PA2->PA2_NOME	:= SRA->RA_NOME
	PA2->PA2_ALIAS  := ParamIxb[1]
	MsUnLock()
	
ElseIf _cOpc == 5	// Exclus�o
	
	// Grava Log de Altera��o
	dbSelectArea("PA2")
	RecLock("PA2",.T.)
	PA2->PA2_FILIAL := xFilial("PA2")
	PA2->PA2_MAT 	:= SRA->RA_MAT
	PA2->PA2_NOME	:= SRA->RA_NOME
	PA2->PA2_FLGROT := "E"
	// Exclus�o	PA2-
	PA2_ALIAS  := ParamIxb[1]
	MsUnLock()
EndIf
RestArea(_aArea)
Return(.T.)
