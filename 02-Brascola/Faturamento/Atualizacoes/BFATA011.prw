#include "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � BFATA011 � Autor � Marcelo da Cunha   � Data �  19/04/13   ���
�������������������������������������������������������������������������͹��
���Descricao � Cadastro de Metas para o Faturamento                       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � MP10/MP11                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function BFATA011()
**********************
LOCAL cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
LOCAL cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

PRIVATE cString := "SZ4"

dbSelectArea("SZ4")
dbSetOrder(1)
AxCadastro(cString,"Cadastro de Metas para Faturamento",cVldExc,cVldAlt)

Return