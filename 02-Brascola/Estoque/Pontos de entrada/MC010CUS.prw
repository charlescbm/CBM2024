#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MC010CUS  �Autor  �Evaldo V. Batista   � Data �  21/08/2005 ���
�������������������������������������������������������������������������͹��
���Desc.     � Informa um Novo Custo para o produto                       ���
���          � relativo a rotina de Planilha de Custo                     ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MC010CUS()     
*********************
LOCAL cCodPro 	 := ParamIxb[1]
LOCAL nOldCusto := ParamIxb[2]
LOCAL nRetCusto := nOldCusto

PUBLIC lDescPCof, nDescPCof

If (cArqMemo == "STD-DIGI")
	If SB1->(dbseek(xFilial("SB1")+cCodPro))
		nRetCusto := SB1->B1_custm
	Endif
Elseif (nQualCusto == 1) //Custo Standard
	SZ2->(dbSetOrder(1)) //Produto+Data
	If SZ2->(dbSeek(xFilial("SZ2")+cCodPro+dtos(dDatabase)))
		nRetCusto := SZ2->Z2_custd
	Else
		SZ2->(dbSeek(xFilial("SZ2")+cCodPro+dtos(dDatabase),.T.))
		SZ2->(dbSkip(-1))
		If (SZ2->Z2_produto == cCodPro)
			nRetCusto := SZ2->Z2_custd
		Endif
	Endif
Endif

Return (nRetCusto)