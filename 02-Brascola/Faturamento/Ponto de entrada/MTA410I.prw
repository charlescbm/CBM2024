#include "rwmake.ch"
#include "topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MTA410I  �Autor  � Marcelo da Cunha   � Data �  25/03/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada para gravar bloqueio de alcada no pedido  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MTA410I()
********************
LOCAL lNovaAlc := SuperGetMv("BR_ALNOVA",.F.,.F.) //Parametro para ativar Alcada
LOCAL nPosB := SC6->(FieldPos("C6_X_BLDSC"))

//Verifico se rotina nova esta ativa
////////////////////////////////////
If (lNovaAlc).and.(nPosB > 0).and.(paramixb > 0)
	If !GDDeleted(paramixb)
		If (SC6->C6_x_bldsc == "B") //Bloqueado Alcada Vendas
			SZ3->(dbSetOrder(1))
			If SZ3->(dbSeek(xFilial("SZ3")+SC6->C6_num+SC6->C6_item))
				Reclock("SZ3",.F.)
			Else
				Reclock("SZ3",.T.)
				SZ3->Z3_filial := xFilial("SZ3")
				SZ3->Z3_pedido := SC6->C6_num
				SZ3->Z3_item   := SC6->C6_item
			Endif
			SZ3->Z3_produto := SC6->C6_produto
			SZ3->Z3_descric := Posicione("SB1",1,xFilial("SB1")+SC6->C6_produto,"B1_DESC")
			SZ3->Z3_qtdven  := SC6->C6_qtdven
			SZ3->Z3_prcven  := SC6->C6_prcven
			SZ3->Z3_valor   := SC6->C6_valor
			SZ3->Z3_descont := SC6->C6_descont
			SZ3->Z3_vend    := SC5->C5_vend1
			SZ3->Z3_nomven  := Posicione("SA3",1,xFilial("SA3")+SC5->C5_vend1,"A3_NOME")
			SZ3->Z3_cliente := SC5->C5_cliente
			SZ3->Z3_loja    := SC5->C5_lojacli
			SZ3->Z3_nomcli  := Posicione("SA1",1,xFilial("SA1")+SC5->C5_cliente+SC5->C5_lojacli,"A1_NOME")
			SZ3->Z3_userlib := Space(Len(SZ3->Z3_userlib))
			SZ3->Z3_datalib := ctod("//")
			SZ3->Z3_horalib := Space(Len(SZ3->Z3_horalib))
			SZ3->Z3_obslib  := Space(Len(SZ3->Z3_obslib))
			SZ3->Z3_userpro := Space(Len(SZ3->Z3_userpro))
			SZ3->Z3_datapro := ctod("//")
			SZ3->Z3_horapro := Space(Len(SZ3->Z3_horapro))
			SZ3->Z3_descpro := 0
			SZ3->Z3_flagluc := SC6->C6_flagluc
			MsUnlock("SZ3")
			dbSelectArea("SC6")
			If Reclock("SC6",.F.)
				SC6->C6_bloquei := Strzero(2,Len(SC6->C6_bloquei))
				MsUnlock("SC6")
			Endif
			If !Empty(SC6->C6_bloquei)
				dbSelectArea("SC5")
				If Reclock("SC5",.F.)
					SC5->C5_blq := "1" //Bloqueio por Regra
					MsUnlock("SC5")
				Endif
			Endif
		Elseif (SC6->C6_x_bldsc != "B") //Liberado Alcada Vendas
			SZ3->(dbSetOrder(1))
			If SZ3->(dbSeek(xFilial("SZ3")+SC6->C6_num+SC6->C6_item))
				Reclock("SZ3",.F.)
				SZ3->(dbDelete())
				MsUnlock("SZ3")
			Endif
		Endif
	Endif
Endif

Return