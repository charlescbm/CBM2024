#INCLUDE "RWMAKE.CH"


/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �M460QRY   �Autor  � Evaldo V. Batista  � Data �  06/16/05   ���
�������������������������������������������������������������������������͹��
���Desc.     � Executa Filtro na Tela de Faturamento                      ���
���          �                                                            ���
���          � Rotina criada para manter Reserva de itens sem exibir o    ���
���          � item para faturamento, ou seja, evita o faturamento de     ���
���          � pedidos liberados que n�o se deseja faturar no momento.    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/    
//DESENVOLVIDO POR INOVEN



USER FUNCTION M460QRY()

//Local cPerg		:= AjustaSx1("M460QR")
//Local cFiltro	:= ""  //Acrescentado por Evaldo em 16/06/05

Local cQry :=paramixb[1]

AjustaSx1("M460QR")

PERGUNTE('M460QR',.T.)

//cQry += " AND SC9.C9_PEDIDO IN (SELECT C5_NUM FROM SC5030 C5 WHERE C5_TRANSP BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' AND C5.D_E_L_E_T_ = '') 
cQry += "" 

RETURN(cQry)  


//Ajusta Pergunta Incial
Static Function AjustaSx1(cPerg)
//******************************
Local aRegs := {}
Local I, J
//Local cPerg := PADR(cPerg,10)

aAdd(aRegs,{PADR(cPerg,10),"01","De Transportadora  ","","","mv_ch1","C",06,00,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","SA4"})
aAdd(aRegs,{PADR(cPerg,10),"02","Ate Transportadora ","","","mv_ch2","C",06,00,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","SA4"})
dbSelectArea("SX1")
dbSetOrder(1)
For I := 1 To Len(aRegs)
	If !DbSeek(PADR(cPerg,10) + aRegs[ I, 2 ])
		RecLock("SX1", .T.)
		For J := 1 To FCount()
			If J <= Len(aRegs[ I ])
				FieldPut(J, aRegs[ I, J ])
			Endif
		Next
		MsUnlock()
	Endif
Next

Return
