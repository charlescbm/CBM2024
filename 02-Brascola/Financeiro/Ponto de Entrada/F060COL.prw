#include "rwmake.ch"
#include "topconn.ch"
                       
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � F060COL  �Autor  � Marcelo da Cunha   � Data �  21/08/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada para filtrar titulos com condicao de      ���
���          � pagamento a vista.                                         ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function F060COL()
*********************
LOCAL aRetu1 := {}, aCmp1, aParam1, nPos1
aParam1 := paramixb[1]
aCmp1 := {"E1_OK","E1_FILIAL","E1_PREFIXO","E1_NUM","E1_PARCELA","E1_TIPO","E1_VALOR"}
For nx := 1 to Len(aCmp1)
	nPos1 := aScan(aParam1,{|x| Alltrim(x[1]) == aCmp1[nx] })
	If (nPos1 > 0)
		aadd(aRetu1,aParam1[nPos1])
	Endif
Next nx
For nx := 1 to Len(aParam1)
	nPos1 := aScan(aCmp1,Alltrim(aParam1[nx,1]))
	If (nPos1 == 0)
		aadd(aRetu1,aParam1[nx])
	Endif
Next nx
Return aRetu1