#INCLUDE 'PROTHEUS.CH'

/*********************************************************************************************/
/*/{Protheus.doc} MS520VLD

@description Ponto de Entrada - Valida se Nota pode ser estornada

@author Bernard M. Margarido
@since 23/04/2018
@version 1.0

@type function
/*/
/*********************************************************************************************/
//DESENVOLVIDO POR INOVEN

User Function MS520VLD()
Local lRet		:= .T.	

Local cStatus	:= ""
Local cCodRom	:= ""
//------------------------------------------+
// Valida se nota pertence a algum romaneio |
//------------------------------------------+
u_IFATM001(@cStatus,@cCodRom,1)

If cStatus == "1"
	lRet := .F.
	If MsgYesNo("Nota " + SF2->F2_DOC + " Serie " + SF2->F2_SERIE + " pertencente ao romaneio " + cCodRom + " em aberto. Deseja continuar ?")
		lRet := .T.
	EndIf
ElseIf cStatus $ "2/3"
	//MsgStop("Não será possivel estornar a Nota " + SF2->F2_DOC + " Serie " + SF2->F2_SERIE + ". Nota do romaneio " + cCodRom + " em conferencia / ou expedida .","INOVEN - Avisos")
	lRet := .F.
	If MsgYesNo("Nota " + SF2->F2_DOC + " Serie " + SF2->F2_SERIE + " em CONFERENCIA OU JA CONFERIDA!!!! Deseja mesmo estornar a leitura e excluir do Romaneio Nr. " +cCodRom+ " ?")
		lRet := .T.
	EndIf
EndIf  

Return lRet
