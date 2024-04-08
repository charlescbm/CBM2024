#include "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT103LDV  �Autor  �Andreza Favero      � Data �  27/12/05   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada para alterar informacao do D1_LOCAL quando ���
���          �realizada devolucao de venda atraves da rotina "Retornar"   ���
���          �do documento de entrada (MAT103).                           ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Brascola                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function Mt103LDV()

Local aArea	:= GetArea()        

Local aLinhaRet := PARAMIXB[1]
Local cLocDev	:= GetMv("BR_LCDEVOL")                      
   
DbSelectArea("SF4")
DbSetOrder(1)
If MsSeek(xFilial("SF4")+aLinhaRet[11,2])
	If SF4->F4_PODER3 == "N"
		aLinhaRet[10,2]	:= Substr(cLocDev,1,2)
	EndIf		
EndIf	
                            
RestArea(aArea)

Return(aLinhaRet)