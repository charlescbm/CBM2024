#include "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � BGDF002  �Autor  � Marcelo da Cunha   � Data �  30/10/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � GDView Gerencial - Alterar Vencimento Contas a Pagar       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function BGDF003(xHeader,xCols,xAt)
************************************
LOCAL oAlter := Nil, nOpca := 0, dVencto := ctod("//")
If (GDFieldPos("M_DIMENS",xHeader) > 0)
	SE2->(dbSetOrder(1))
	If SE2->(dbSeek(xFilial("SE2")+xCols[xAt,GDFieldPos("M_DIMENS",xHeader)]))
		If (SE2->E2_saldo == 0)
			Help("",1,"BRASCOLA",,OemToAnsi("Titulo n�o possui saldo!"),1,0) 
			Return		
		Endif                                   
		lInclui := .T. ; lAltera := .T.
		dVencReaAnt	:= ctod("//") ; aDadosImp := Array(3)
		AxAltera("SE2",SE2->(Recno()),4,,{"E2_VENCTO"})
	Endif
Endif
Return