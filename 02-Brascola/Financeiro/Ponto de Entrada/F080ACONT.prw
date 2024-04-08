#include "rwmake.ch"
#include "topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � F080ACONT�Autor  � Marcelo da Cunha   � Data �  12/08/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada para gravar baixa do titulo na GUIA       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function F080ACONT()
***********************
LOCAL cQuery1 := ""

//Procuro pela GUIA para atualizar baixa do t�tulo
//////////////////////////////////////////////////
If (SE2->E2_prefixo == "ICM").and.(Alltrim(SE2->E2_tipo) == "TX")
	cQuery1 := "SELECT F6.R_E_C_N_O_ MRECSF6 FROM "+RetSqlName("SF6")+" F6 "
	cQuery1 += "WHERE F6.D_E_L_E_T_ = '' AND F6.F6_FILIAL = '"+xFilial("SF6")+"' "
	cQuery1 += "AND F6.F6_NUMERO = '"+SE2->E2_prefixo+SE2->E2_num+"' "
	cQuery1 += "AND F6.F6_OPERNF = '2' AND F6.F6_TIPODOC = 'N' AND F6.F6_XPAGTIT = '' "
	cQuery1 := ChangeQuery(cQuery1)
	If (Select("MAR") <> 0)
		dbSelectArea("MAR")
		dbCloseArea()
	Endif
	TCQuery cQuery1 NEW ALIAS "MAR"
	If !MAR->(Eof()).and.(MAR->MRECSF6 > 0)
		SF6->(dbGoto(MAR->MRECSF6))
		Reclock("SF6",.F.)
		SF6->F6_xpagtit := "1" //Titulo Pago
		MsUnlock("SF6")
	Endif
	If (Select("MAR") <> 0)
		dbSelectArea("MAR")
		dbCloseArea()
	Endif
Endif

Return