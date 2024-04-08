#include "rwmake.ch"
#include "topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � A140EXC  �Autor  � Marcelo da Cunha   � Data �  21/10/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada para retirar marcacao de Pre-nota Gerada  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � MP10/MP11                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function A140EXC()
*********************
LOCAL lRetu := .T.

//��������������������������������������������������������������Ŀ
//� Atualizo Flag para retirar a marcacao de Pre-nota Gerada     �
//����������������������������������������������������������������
If AliasInDic("ZGN")
	ZGN->(dbSetOrder(1)) ; SA2->(dbSetOrder(1))
	If SA2->(dbSeek(xFilial("SA2")+SF1->F1_fornece+SF1->F1_loja))
		If ZGN->(dbSeek(xFilial("ZGN")+"1"+SF1->F1_serie+SF1->F1_doc+SA2->A2_cgc))
			Reclock("ZGN",.F.)
			ZGN->ZGN_usupre := Space(15)
			ZGN->ZGN_datpre := ctod("//")
			ZGN->ZGN_horpre := Space(8)
			ZGN->ZGN_status := "1" //XML Importado
			MsUnlock("ZGN")
		Endif
	Endif
Endif

Return lRetu