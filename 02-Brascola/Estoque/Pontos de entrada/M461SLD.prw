#include "rwmake.ch"
#include "topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � M461SLD  �Autor  �Microsiga           � Data �  04/12/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada para bloquear lotes com vencimento menor  ���
���          � que XXX dias para estados do nordeste                      ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function M461SLD()
*********************
LOCAL cEstNor := Alltrim(GetMV("BR_000012")) //Estados Nordeste

//Verifico o Estado do Cliente
//////////////////////////////
If !Empty(cEstNor)
	PUBLIC __lBRBlqEstNor := .F.
	SA1->(dbSetOrder(1))
	If SA1->(dbSeek(xFilial("SA1")+SC9->C9_CLIENTE+SC9->C9_LOJA)).and.(SA1->A1_est $ cEstNor)
		__lBRBlqEstNor := .T.	
	Endif
Endif

Return