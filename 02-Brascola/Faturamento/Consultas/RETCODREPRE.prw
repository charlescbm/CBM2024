#INCLUDE "RWMAKE.CH"    
#INCLUDE "Topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RETCODREPRE�Autor  �Microsiga           � Data �  03/13/07  ���
�������������������������������������������������������������������������͹��
���Desc.     � Filtra os clientes dos representantes na consulta 'SXB'    ���
���          � ao cadastro de representates 'SA3'.                        ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function RETCODREPRE()
************************
LOCAL aArea := GetArea()
LOCAL cCodRepr := "", cFiltro := ""
                           
//04/02/13 - Marcelo - Filtro dos Representantes
////////////////////////////////////////////////
If (u_BXRepAdm()) //Parametro/Presidente/Diretor
	cCodRepr := "" //Liberar para todos
Else
	cCodRepr := u_BXRepLst("FIL") //Lista dos Representantes
	If Empty(cCodRepr)
		Return (cFiltro := "(.F.)")
	Endif
Endif
If !Empty(cCodRepr)
	cFiltro := 'AllTrim(SA3->A3_COD) $ "'+cCodRepr+'"'
Endif
RestArea(aArea)

Return (cFiltro)