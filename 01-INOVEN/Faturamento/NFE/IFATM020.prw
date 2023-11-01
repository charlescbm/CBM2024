#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
/*
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ IFATM020  บAutor  ณ RENATO BANDEIRA    บ Data ณ  08/04/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ MENSAGENS PARA NOTA FISCAL                                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especํfico                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
*/
//DESENVOLVIDO POR INOVEN

User Function IFATM020
If !Empty(SC5->C5_NOTA)
	MsgAlert('Pedido jแ faturado.')
	Return
	//_nOpc := Aviso("Nota ja Faturada","Ja existe uma NF para o pedido "+SC5->C5_NUM+". Confirma ajustar a mensagem assim mesmo?"+Chr(13)+Chr(10),{"Alterar","Abandona"})
	//If _nOpc == 1
	//Else	
	//EndIf
EndIf

DEFINE MSDIALOG oDlgCOL TITLE "Ajuste de mensagem para Nota Fiscal - Pedido "+SC5->(C5_NUM) FROM 000,000  TO 390,900 COLORS 0, 16777215     PIXEL
/*
If !Empty(SC5->C5_MENNOTA)
_nOpc := Aviso("Mensagem","Jแ existe mensagem cadastrada para o pedido "+SC5->C5_NUM+Chr(13)+Chr(10)+'Mensagem Atual: '+SC5->C5_MENNOTA+Chr(13)+Chr(10)+'Confirma sobrepor a mensagem com a informa็ใo do vendedor?',{"Alterar","Manter"})
If _nOpc == 1
_cMsg   := Left(SC5->C5_XOBSLO, 120)
Else
_cMsg   := SC5->C5_MENNOTA
EndIf
Else
*/
_cMsg    := SC5->C5_MENNOTA //Left(SC5->C5_XOBSLO, 120)
_cMsgCom := SC5->C5_XOBSCO
_cMsgLog := SC5->C5_XOBSLO
//EndIf

_lGrava := .F.
_lCom   := SC5->C5_XMSGCOM=='1'
_lLog   := SC5->C5_XMSGLOG=='1'
@ 006, 005 SAY 'Mensagem Nota:'   Of oDlgCOL Pixel
@ 004, 060 MSGET _oMsg       VAR _cMsg  Picture '@!'   		SIZE C(300), C(010) OF oDlgCOL COLORS 0, 16777215     PIXEL
@ 024, 005 SAY 'Observ. Comercial:'   Of oDlgCOL Pixel
@ 022, 060 GET _oMsgCom	     VAR _cMsgCom  OF oDlgCOL MEMO PIXEL SIZE C(300),C(050) FONT (TFont():New('Verdana',,-12,.T.))   NO BORDER
@ 034, 005 CHECKBOX _oNFCom  VAR _lCom PROMPT 'Sair no DANFE' SIZE 70,7 	PIXEL OF oDlgCOL

@ 096, 005 SAY 'Observ. Logistica:'   Of oDlgCOL Pixel
@ 094, 060 GET _oMsgLog	     VAR _cMsgLog  OF oDlgCOL MEMO PIXEL SIZE C(300),C(050) FONT (TFont():New('Verdana',,-12,.T.))   NO BORDER
@ 106, 005 CHECKBOX _oNFLog  VAR _lLog PROMPT 'Sair no DANFE' SIZE 70,7 	PIXEL OF oDlgCOL

@ 172, 320 BUTTON oButton1 PROMPT "&Confirma" SIZE 062, 015 OF oDlgCOL ACTION (_lGrava := .T., oDlgCOL:End()) Pixel //(ODlgCOL:End()) PIXEL
@ 172, 383 BUTTON oButton2 PROMPT "&Sair"     SIZE 062, 015 OF oDlgCOL ACTION (_lGrava := .F., ODlgCOL:End()) PIXEL
ACTIVATE MSDIALOG oDlgCOL CENTERED

If _lGrava
	
	DbSelectArea('SC5')
	RecLock('SC5', .F.)
	Replace SC5->C5_MENNOTA With _cMsg
	Replace SC5->C5_XOBSCO  With _cMsgCom
	Replace SC5->C5_XOBSLO  With _cMsgLog
	Replace SC5->C5_XMSGCOM With If(_lCom, '1','2')
	Replace SC5->C5_XMSGLOG With If(_lLog, '1','2')
	MsUnlock()
	
EndIf

Return .T.
