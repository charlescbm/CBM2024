#include "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � BGDF004  �Autor  � Marcelo da Cunha   � Data �  30/10/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � GDView Gerencial - Liberacao de Pagamentos                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function BGDF004(xHeader,xCols,xAt)
************************************
LOCAL oAlter := Nil, nOpca := 0, dVencto := ctod("//")
If (GDFieldPos("M_DIMENS",xHeader) > 0)
	If !GetMv("MV_CTLIPAG")
   	MSGAlert("Esta rotina s� poder� ser executada, quando o par�metro MV_CTLIPAG For 'T'")
		Return 	
	Endif
	SE2->(dbSetOrder(1))
	If SE2->(dbSeek(xFilial("SE2")+xCols[xAt,GDFieldPos("M_DIMENS",xHeader)]))
		FA580Man("SE2",SE2->(Recno()),2)
	Endif
Endif
Return