#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � GPE10BTN �Autor  � Marcelo da Cunha   � Data �  11/09/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Botao para adicionar link com historicos                   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function GPE10BTN()
*********************
LOCAL aButtons := {}
aButtons := {"OPEN",{|| u_GDVHistMan("SRA")},"Historico","Historico"}
Return aButtons