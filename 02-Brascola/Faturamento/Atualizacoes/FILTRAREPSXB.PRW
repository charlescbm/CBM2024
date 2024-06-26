#INCLUDE "RWMAKE.CH"  
#INCLUDE "Topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FILTRAREPSXB�Autor  �Sergio Lacerda    � Data �  08/02/10   ���
�������������������������������������������������������������������������͹��
���Desc.     � Filtra os clientes dos representantes na consulta 'SXB'    ���
���          � ao cadastro de clientes alias 'CLI' e 'SA1'.               ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function RETFILTRO()
**********************
LOCAL aArea := GetArea()
LOCAL cCodRepr := "", cFiltro := ""
                           
//04/02/13 - Marcelo - Filtro dos Representantes
////////////////////////////////////////////////
If (!u_BXRepAdm()) //Parametro/Presidente/Diretor
	cCodRepr := u_BXRepLst("FIL") //Lista dos Representantes
	If Empty(cCodRepr)
		Return (cFiltro := "(.F.)")
	Endif
Endif
If !Empty(cCodRepr)
	cFiltro := 'AllTrim(SA1->A1_VEND) $ "'+cCodRepr+'"'
Endif
RestArea(aArea)

Return (cFiltro)