#include "rwmake.ch"
#include "topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � F010CQPE �Autor  � Marcelo da Cunha   � Data �  28/01/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina para tratar filtro na consulta Posicao Clientes     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function F010CQPE()
*********************
LOCAL cRetu, cQuery1 := paramixb[1], cPsq1
                   
//Remove Filtro da Filial
/////////////////////////
cRetu := cQuery1
cPsq1 := "SE1.E1_FILIAL='"+xFilial("SE1")+"' AND"
cRetu := StrTran(cRetu,cPsq1,"")
cPsq1 := "SE5.E5_FILIAL='"+xFilial("SE5")+"' AND"
cRetu := StrTran(cRetu,cPsq1,"")
cPsq1 := "SC5.C5_FILIAL='"+xFilial("SC5")+"' AND"
cRetu := StrTran(cRetu,cPsq1,"")
cPsq1 := "SC6.C6_FILIAL='"+xFilial("SC6")+"' AND"
cRetu := StrTran(cRetu,cPsq1,"")
cPsq1 := "SC9.C9_FILIAL='"+xFilial("SC9")+"' AND"
cRetu := StrTran(cRetu,cPsq1,"")

Return cRetu