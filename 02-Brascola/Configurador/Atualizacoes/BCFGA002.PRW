/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �BCFGA002  �Autor  �FERNANDO            � Data �  07/08/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Grava Rotina / Data / Hora / Usuario que executou uma      ���
���          � Rotina customizada                                         ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function BCFGA002(crotcus)   
****************************** 

	DbSelectArea("ZA1")
	RecLock("ZA1",.T.)
	ZA1->ZA1_FILIAL := xFilial("ZA1")
	ZA1->ZA1_ROTPAD := AllTrim(Funname())
	ZA1->ZA1_ROTCUS := AllTrim(crotcus)
	ZA1->ZA1_DATA 	:= MsDate()
	ZA1->ZA1_HORA	:= Time()
	ZA1->ZA1_USER   := Alltrim(cUsername)
	ZA1->(MsUnLock())  
	
	//PARA USAR COLOCA-SE NO INICIO DO PROGRAMA A SEGUINTE LINHA:
	//U_BCFGA002("NOME_DA_ROTINA")//Grava detalhes da rotina usada

Return()