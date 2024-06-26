#include "rwmake.ch"
#include "topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � A320CUSTR�Autor  � Marcelo da Cunha   � Data �  07/03/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Atualizacao Custo Standard na Tabela de Historicos         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function A320CUSTR()
**********************
LOCAL cCodPro := SB1->B1_cod
LOCAL nCustd  := SB1->B1_custd
     
//Atualiza Historico do custo Standard
//////////////////////////////////////
SZ2->(dbSetOrder(1))
If SZ2->(dbSeek(xFilial("SZ2")+cCodPro+dtos(dDatabase)))
	Reclock("SZ2",.F.)
Else
	Reclock("SZ2",.T.)
	SZ2->Z2_filial  := xFilial("SZ2")
	SZ2->Z2_produto := cCodPro
	SZ2->Z2_data    := dDatabase	
Endif                          
SZ2->Z2_hora    := Time()
SZ2->Z2_custd   := nCustd
SZ2->Z2_ucalstd := MsDate()
MsUnlock("SZ2")

Return