#include "rwmake.ch"
#include "topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MTA410DEL�Autor  � Marcelo da Cunha   � Data �  25/03/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada para excluir bloqueio de alcada no pedido ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MTA410DEL()
**********************
LOCAL lNovaAlc := SuperGetMv("BR_ALNOVA",.F.,.F.) //Parametro para ativar Alcada
LOCAL nPosB := SC6->(FieldPos("C6_X_BLDSC"))

//Verifico se rotina nova esta ativa
////////////////////////////////////
If (lNovaAlc).and.(nPosB > 0).and.(!INCLUI).and.(!ALTERA)
	SZ3->(dbSetOrder(1))
	SZ3->(dbSeek(xFilial("SZ3")+M->C5_num,.T.))
	While !SZ3->(Eof()).and.(xFilial("SZ3") == SZ3->Z3_filial).and.(SZ3->Z3_pedido == M->C5_num)
		Reclock("SZ3",.F.)
		SZ3->(dbDelete())
		MsUnlock("SZ3")
		SZ3->(dbSkip())
	Enddo
Endif

Return