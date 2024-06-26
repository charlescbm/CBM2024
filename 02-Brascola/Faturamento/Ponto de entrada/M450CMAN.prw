#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �M450CMAN   �Autor  �Charles Medeiros � Data �  12/07/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �Abre tela para inclus�o de Motivo Rejei��o.                 ���
�������������������������������������������������������������������������Ĵ��
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/                  


User Function M450CMAN()

Private cDesRej := space(255)
Private nOpcEsc := 0 
Private oDesRej := space(255)

LRET := .T.

If Paramixb[1] == 3
	
  //	While .T.
		DEFINE FONT oFont NAME "Arial" SIZE 0,-12 BOLD
		DEFINE MSDIALOG oDlg1 TITLE "Motivo do Bloqueio" From 00,00 To 200,680 OF oMainWnd PIXEL
		@ 005,005 SAY "Informe o motivo do bloqueio para os Pedidos em analise do Cliente "+ TMP->C5_NOMECLI OF oDlg1 PIXEL COLOR CLR_HBLUE FONT oFont
		@ 025,025 MSGET oDesRej VAR cDesRej		    SIZE 250,010	OF oDlg1 PIXEL 
		@ 050,060 BUTTON "REJEITA"					SIZE 45,11 ACTION(Rejeita(), oDlg1:End()) OF oDlg1 PIXEL		
		@ 050,170 BUTTON "Cancela"					SIZE 45,11 ACTION(nOpcEsc:=0, oDlg1:End()) OF oDlg1 PIXEL 
													
		ACTIVATE MSDIALOG oDlg1 CENTERED

ElseIf Paramixb[1] == 1

	Libera()

Endif  

Return(LRET)                                                     

******************************************************************************************************
// TRATATIVA DE GRAVA��O DO MOTIV NO SC9
******************************************************************************************************    

Static Function Rejeita()

	IF nOpcEsc == 0 .AND. cDesRej <> ''
	
		_cQuery := "UPDATE " + RetSqlName("SC9")
		_cQuery += " SET  C9_BLCRED = '01', C9_USERLIB = '"+cUsername+"' , C9_MOTREJ = '"+substr(cDesRej,1,255)+"' "
		_cQuery += " WHERE D_E_L_E_T_ <> '*' "
		_cQuery += "AND C9_CLIENTE = '"+ TMP->C5_CLIENTE + "' "
		_cQuery += "AND C9_BLCRED = '01'
		_cQuery += "AND C9_MOTREJ = ''  
		TCSQLEXEC(_cQuery)               
		
		LRET := .T.
	Else
		
		MsgInfo(" Pedido em analise, Favor informar motivo da Rejei��o.") 
		     
		LRET := .F.  
		
	Endif
	
Return(LRET)	  

******************************************************************************************************
// TRATATIVA DE GRAVA��O DO MOTIV NO SC9
******************************************************************************************************   
        
static function Libera()

	_cQuery := "UPDATE " + RetSqlName("SC9")
	_cQuery += " SET  C9_USERLIB = '"+cUsername+"' 
	_cQuery += " WHERE D_E_L_E_T_ <> '*' "
	_cQuery += "AND C9_CLIENTE = '"+ TMP->C5_CLIENTE + "' "  
	_cQuery += "AND C9_LOJA = '"+ TMP->C5_LOJACLI + "' "
	_cQuery += "AND C9_BLCRED = '01'
	TCSQLEXEC(_cQuery)              
	
   LRET := .T.
		
Return(LRET)	