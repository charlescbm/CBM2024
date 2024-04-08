#include "rwmake.ch"
#include "topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � SF1100E  �Autor  � Marcelo da Cunha   � Data �  21/10/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada para atualizar status da NF-e Classifica  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � MP10/MP11                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function SF1100E()
*********************
LOCAL lRetu := .T., lEstorn, cRotina

//��������������������������������������������������������������Ŀ
//� Atualizo Flag para atualizar status da NF-e Classificada     �
//����������������������������������������������������������������
If AliasInDic("ZGN")
	cRotina := Upper(Alltrim(Funname()))
	lEstorn := ("MATA140"$cRotina)
	ZGN->(dbSetOrder(1)) ; SA2->(dbSetOrder(1))
	If SA2->(dbSeek(xFilial("SA2")+SF1->F1_fornece+SF1->F1_loja))
		If ZGN->(dbSeek(xFilial("ZGN")+"1"+SF1->F1_serie+SF1->F1_doc+SA2->A2_cgc))
			Reclock("ZGN",.F.)
			ZGN->ZGN_usucla := Space(15)
			ZGN->ZGN_datcla := ctod("//")
			ZGN->ZGN_horcla := Space(8)
			If (lEstorn)
				ZGN->ZGN_status := "2" //Pre-nota Gerada
			Else
				ZGN->ZGN_usupre := Space(15)
				ZGN->ZGN_datpre := ctod("//")
				ZGN->ZGN_horpre := Space(8)
				ZGN->ZGN_status := "1" //XML Importado
			Endif
			MsUnlock("ZGN")
		Endif
	Endif
Endif

Return lRetu