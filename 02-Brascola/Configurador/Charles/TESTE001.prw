#INCLUDE "rwmake.ch"   
#include "topconn.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �BCFGA001    � Autor � Fernando S. Maia   � Data �  27/12/11 ���
�������������������������������������������������������������������������͹��
���Descricao � Rotinas x Permiss�es                                       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function TESTE001()

Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cString := "SZA"

dbSelectArea("SZA")
dbSetOrder(1)

AxCadastro(cString,"Atualiza Rotina x Permissoes ",cVldExc,cVldAlt)

Return