/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  ITECX010  �Autor  �CBM            � Data �  004/05/20   ���
�������������������������������������������������������������������������͹��
���Desc.     � Grava Rotina / Data / Hora / Usuario que executou uma      ���
���          � Rotina customizada                                         ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function ITECX010(crotcus,cDescri)   
****************************** 

	DbSelectArea("ZA1")
	RecLock("ZA1",.T.)
	ZA1->ZA1_FILIAL := xFilial("ZA1")
	ZA1->ZA1_ROTPAD := AllTrim(Funname())
	ZA1->ZA1_ROTCUS := AllTrim(crotcus)
	ZA1->ZA1_DESCRI := Alltrim(cDescri)
	ZA1->ZA1_DATA 	:= MsDate()
	ZA1->ZA1_HORA	:= Time()
	ZA1->ZA1_USER   := Alltrim(cUsername)
	ZA1->(MsUnLock())  
	
	//PARA USAR COLOCA-SE NO INICIO DO PROGRAMA A SEGUINTE LINHA:
	//U_ITECX010("NOME_DA_ROTINA","DESCRICAO DA ROTINA")//Grava detalhes da rotina usada

Return()
