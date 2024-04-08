#include "rwmake.ch"
#include "topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � TMKVFIM  �Autor  � Marcelo da Cunha   � Data �  02/10/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Gravacao de dados adicionais no pedido de venda            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function TMKVFIM()
*********************
     
//Gravo dados adicionais
////////////////////////
If !Empty(SUA->UA_numsc5).and.(SUA->UA_oper == "1")
	SC5->(dbSetOrder(1))
	If SC5->(dbSeek(xFilial("SC5")+SUA->UA_numsc5))
		Reclock("SC5",.F.)
		SC5->C5_mennota := SUA->UA_obsnota
		SC5->C5_histori := SUA->UA_obsped
		SC5->C5_usrimpl := cUserName
		SC5->C5_especi1 := SUA->UA_especie
		SC5->C5_nomecli := Posicione("SA1",1,XFILIAL("SA1")+SUA->UA_cliente+SUA->UA_loja,"A1_NOME")
		MsUnlock("SC5")
		If ExistBlock("M410STTS")
			INCLUI := (M->UA_OPER $ "123")
			ExecBlock("M410STTS",.F.,.F.) 
		Endif
	Endif
Endif

Return