#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MT097LIB �Autor  � Marcelo da Cunha   � Data �  13/09/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Mostrar mensagem para aprovadores da alcada CC             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MT097LIB()
*********************
LOCAL aSC7 := SC7->(GetArea())
LOCAL cNumPed := Substr(SCR->CR_num,1,6)

//Verifico se existem itens nesse pedido liberados sem orcamento
////////////////////////////////////////////////////////////////                    
If (SCR->CR_ccliber $ "LO") 
	SC7->(dbSetOrder(1))
	SC7->(dbSeek(xFilial("SC7")+cNumPed,.T.))
	While !SC7->(Eof()).and.(xFilial("SC7") == SC7->C7_filial).and.(SC7->C7_num == cNumPed)
		If (SC7->C7_ccliber == "O")
			u_BCA002Libera("SC7",SC7->(Recno()),2)
		Endif
		SC7->(dbSkip())
	Enddo
	RestArea(aSC7)
Endif                     

Return 