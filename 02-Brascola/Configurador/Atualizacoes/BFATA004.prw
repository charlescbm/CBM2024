#INCLUDE "rwmake.ch"

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

User Function BFATA004()


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cString := "SZ1"                  

U_BCFGA002("BFATA004")//Grava detalhes da rotina usada

dbSelectArea("SZ1")
dbSetOrder(1)

AxCadastro(cString,"Produtos para promo��o de vendas",cVldExc,cVldAlt)

Return
