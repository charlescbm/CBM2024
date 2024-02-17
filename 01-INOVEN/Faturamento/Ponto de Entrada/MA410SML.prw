#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"

//DESENVOLVIDO POR INOVEN - 11/02/2024


User Function MA410SML()
**********************

Local nI:=0

For nI:=1 To Len(ParamIXB[1])
	If ParamIXB[1][nI][1] == "1" .and. alltrim(ParamIXB[1][nI][2]) == "404"
		//M->C5_FRETE :=ParamIXB[1][n][4]
		M->C5_TRANSP := space(6)
		MsgAlert("Transportadora definida como Redespacho não pode ser selecionada!")
	EndIf
Next nI

Return
