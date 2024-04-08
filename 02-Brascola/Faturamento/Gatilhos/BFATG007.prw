#INCLUDE "rwmake.ch"    
#INCLUDE "topconn.ch"                                       

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � BFATG007  �Autor  �Microsiga           � Data �  18/10/12  ���
�������������������������������������������������������������������������͹��
���Desc.     � Gatilho que somente deixa selecionar representantes que    ���
���          � constam na lista.                                          ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function BFATG007(xCodVen)
***************************
Local aArea	:= GetArea()
Local lRetu := .T.

//04/02/13 - Marcelo - Filtro dos Representantes
////////////////////////////////////////////////
If (!u_BXRepAdm()) //Parametro/Presidente/Diretor
	cRepres := u_BXRepLst("FIL") //Lista dos Representantes
	If !(xCodVen $ cRepres)
		lRetu := .F.
	Endif
Endif
RestArea(aArea)

Return lRetu