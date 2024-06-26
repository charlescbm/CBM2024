#include "Protheus.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F650DESCR �Autor  �Microsiga           � Data �  29/12/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada no relatorio de retorno de cnab de contas ���
���          � a receber paraverificar registros rejeitado. O banco SOFISA���
���          � informa como rejeitado, mas est� sob analise da genrencia. ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function F650DESCR()

Local aArea		:= GetArea() 
local cDesc := paramixb[1]
//se for rejeitado e somente para o banco SOFISA
If cOcorr == "03 " .and. mv_par03 =='637'  
	cRej := Substr(xBuffer,378,2)
	If cRej $ "CG/BG"
		cOcorr	:= "02" //entrada confirmada
		cDesc := "ANALISE GERENCIA (sofisa)"
	EndIf
EndIf
RestArea(aArea)

Return(cDesc)