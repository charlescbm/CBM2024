//Abaixo segue um exemplo de customização onde é gravado um log de alteração da marcação.
#INCLUDE "RWMAKE.CH"

USER FUNCTION PNA130GRV()
Local _aArea := GetArea()
Local i , j
Local _cOpc := ParamIxb[3]

If _cOpc == 3 .Or. _cOpc == 4  // 3 - Inclusão, 4 - Alteração
	
	// Grava Log de Alteração
	dbSelectArea("PA2")
	RecLock("PA2",.T.)
	PA2->PA2_FILIAL := xFilial("PA2")
	PA2->PA2_MAT 	:= SRA->RA_MAT
	PA2->PA2_NOME	:= SRA->RA_NOME
	PA2->PA2_ALIAS  := ParamIxb[1]
	MsUnLock()
	
ElseIf _cOpc == 5	// Exclusão
	
	// Grava Log de Alteração
	dbSelectArea("PA2")
	RecLock("PA2",.T.)
	PA2->PA2_FILIAL := xFilial("PA2")
	PA2->PA2_MAT 	:= SRA->RA_MAT
	PA2->PA2_NOME	:= SRA->RA_NOME
	PA2->PA2_FLGROT := "E"
	// Exclusão	PA2-
	PA2_ALIAS  := ParamIxb[1]
	MsUnLock()
EndIf
RestArea(_aArea)
Return(.T.)
