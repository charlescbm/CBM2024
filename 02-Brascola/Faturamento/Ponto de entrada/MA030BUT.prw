#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MA030BUT �Autor  � Marcelo da Cunha   � Data �  08/11/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Botao para adicionar link com historicos                   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � MP10/MP11                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MA030BUT()
*********************
LOCAL aButtons := {}
aadd(aButtons,{"OPEN",{|| u_GDVHistMan("SA1")},"Historico","Historico"})
Return aButtons