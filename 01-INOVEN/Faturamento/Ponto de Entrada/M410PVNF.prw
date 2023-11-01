#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"

/*
����������������������������������������������������������������������������?
�������������������������������������������������������������������������ͻ�?
���Programa  ?M410PVNF �Autor  ?Gabriel Gon�alves  ?Data ? 10/03/17   ��?
�������������������������������������������������������������������������͹�?
���Desc.     ?PE pra validar o faturamento do pedido                    ��?
��?         ?                                                           ��?
�������������������������������������������������������������������������͹�?
���Uso       ?                                        ��?
�������������������������������������������������������������������������ͼ�?
����������������������������������������������������������������������������?
*/
//DESENVOLVIDO POR INOVEN

User Function M410PVNF()

Local lRet	:= .T.
//Local cCliDen	:= GetMv("DT_CLIDENT",.F.,"'000868','012619'")


LjMsgRun("Aguarde ... Avaliando bloqueio do pedido.","Aguarde",{||	lRet := fAvBlPed()}) //-- Avalia se existe bloqueio para o pedido.

Return(lRet)

/*
����������������������������������������������������������������������������?
�������������������������������������������������������������������������ͻ�?
���Programa  ?fAvBlPed �Autor ?IR 				  ?Data ?07/07/2016 ��?
�������������������������������������������������������������������������͹�?
���Desc.     ?Avalia blqieuos do pedido de venda. 					      ��?
��?         ?                                                           ��?
�������������������������������������������������������������������������͹�?
���Uso       ?Espec�fico DENTAL                                          ��?                                6
�������������������������������������������������������������������������ͼ�?
����������������������������������������������������������������������������?
*/
Static Function fAvBlPed()

Local lRet := .T.
Local lBloqCre := .F.
LOCAL _QTDLIB := 0      
Local _nQtdSC6 :=0
Local aArea    := SC9->(GetArea())
Local aAreac6   := SC6->(GetArea())

If Empty(SC5->C5_LIBEROK)
	If IsBlind()
		ConOut("Pedido n�o est?liberado.")
		lRet := .F.
	Else
		Alert("Pedido n�o est?liberado.")
		lRet := .F.
	EndIf
	
ELSEIF SC5->C5_FECENT > DDATABASE + 1
	
	Alert("Pedido n�o ser?faturado verificar a data de entrega.")
	lRet := .F.
Else
	IF SC5->C5_TIPOFAT == '2'
		
		SC9->(dbSetOrder(1))
		SC9->(dbSeek(SC5->C5_FILIAL+SC5->C5_NUM))
		Do While SC9->(!EOF()) .AND. SC5->C5_FILIAL == SC9->C9_FILIAL .AND. SC5->C5_NUM == SC9->C9_PEDIDO
			
			_QTDLIB+=SC9->C9_QTDLIB
			
			If AllTrim(SC9->C9_BLCRED) <> "" .OR. AllTrim(SC9->C9_BLEST) <> ""
				If IsBlind()
					If SC9->C9_BLCRED == "10" .OR. SC9->C9_BLEST == "10"
						ConOut("Pedido j?faturado.")
						lRet := .F.
						Exit
					Else
						ConOut("Pedido possui itens com bloqueio. N�o ser?poss�vel fazer o faturamento.")
						lRet := .F.
						Exit
					EndIf
				Else
					If SC9->C9_BLCRED == "10" .OR. SC9->C9_BLEST == "10"
						Alert("Pedido j?faturado.")
						lRet := .F.
						Exit
					ElseIf AllTrim(SC9->C9_BLCRED) <> ""
						lBloqCre := .T.
						lRet := .F.
						// IRAR FATURAR SOMENTE COM SALDO EM ESTOQUE UTILIZAR A OPCAO 16
					ElseIf AllTrim(SC9->C9_BLEST) <> ""   //---- Se tiver bloqueio de estoque ir?realizar a libera��o. Condi��o tempor�ria at?entrar controle de lotes. //IR//
						Alert("Pedido possui itens com bloqueio de Estoque. N�o ser?poss�vel fazer o faturamento, Favor liberar o pedido.")
						//a450Grava(1,.F.,.T.,.F.,{})
						//MsUnLockAll()
						//lRet := .T.
						lRet := .f.
					EndIf
				EndIf
			EndIf
			SC9->(dbSkip())
		EndDo
		
		If SC6->( Dbseek(SC5->C5_FILIAL+SC5->C5_NUM ) )
			Do While ! SC6->( EOF() ) .And. SC6->C6_NUM == SC5->C5_NUM
				_nQtdSC6 += SC6->C6_QTDVEN
				SC6->( Dbskip() )
			Enddo
		ENDIF
		
		IF _nQtdSC6  <> _QTDLIB
			Alert("Pedido possui itens Liberados diferente da quantidade vendida. N�o ser?poss�vel fazer o faturamento, Favor estornar o pedido.")
			lRet := .f.
			
		ENDIF
		
	endif
	
EndIf

If lBloqCre
	Alert("Pedido possui itens com bloqueio de cr�dito. N�o ser?poss�vel fazer o faturamento.")
EndIf

RestArea(aArea)   
RestArea(aAreac6)

Return(lRet)
