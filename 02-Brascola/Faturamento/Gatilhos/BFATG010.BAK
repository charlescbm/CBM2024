#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "TbiConn.ch"
#INCLUDE "Font.ch"

User Function BFATG010(dData) 

Local lRet := .T.
                              
If ( dData > dDatabase)
	If MsgYesNo (" ATENÇÃO !!! Parametro (Data Entrega ate)"+chr(13)+chr(10)+" maior que Data atual. Deseja Continuar ? " )
		lRet := .T.
	Else
		lRet := .F.
	Endif	
EndIf   

Return lRet