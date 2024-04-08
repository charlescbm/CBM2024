#include "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MTA225MNU�Autor  � Marcelo da Cunha   � Data �  10/03/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Adicionar botao para chamar o GDView Produto e Gerencial   ���
���          � na tela de saldos em estoque                               ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MTA225MNU()
**********************
If (Type("aRotina") == "A")
	If ExistBlock("GDVA010") //Verifico rotina GDView Produto
		aadd(aRotina,{"GDView Produto","u_M225GDVA010()",0,4})
	Endif
	If ExistBlock("GDVA100") //Verifico rotina GDView Gerencial
		aadd(aRotina,{"GDView Gerencial","u_GDVA100()",0,4})
	Endif		
Endif
Return 

User Function M225GDVA010()
*************************
dbSelectArea("SB1")
SB1->(dbSetOrder(1))
If SB1->(dbSeek(xFilial("SB1")+SB2->B2_cod))
	MsgRun('GDView Produto. Aguarde... ','',{ || u_GDVA010() })
Endif
Return