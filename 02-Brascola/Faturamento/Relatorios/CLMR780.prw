#INCLUDE "RWMAKE.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CLMR780   �Autor  �Microsiga           � Data �  28/11/05   ���
�������������������������������������������������������������������������͹��
���Desc.     � Chama o MATR780 inicializando o intervalo de vendedores    ���
���          � quando o usuario for vendedor com A3_TIPO = "E"            ���
�������������������������������������������������������������������������͹��
���Uso       � P8                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function CLMR780()

Local cPerg:= Padr( 'MTR780', Len( SX1->X1_GRUPO ) )

//�����������������������������������������������Ŀ
//�Posiciona no vendedor correspondente ao usuario�
//�������������������������������������������������
DbSelectArea("SA3")
DbSetOrder(7)

DbSeek( xFilial("SA3") + __cUserID, .f. )
DbSetOrder(1)

//�������������������������������������������������
//�Se foi localizado o vendedor e ele e externo,  �
//�ajusta os parametros para o codigo do vendedor �
//�������������������������������������������������
If !Eof() .And. SA3->A3_TIPO = "E"
	DbSelectArea("SX1")
	DbSetOrder(1)
	
	If DbSeek( cPerg + '07', .f. )
		Reclock("SX1")
			SX1->X1_CNT01 = "000000"
		MsUnlock()
	EndIf
	
	If DbSeek( cPerg + '08', .f. )
		Reclock("SX1")
			SX1->X1_CNT01 = "000000"
		MsUnlock()
	EndIf
EndIf

//��������������������������
//�Chama o relatorio padrao�
//��������������������������
MATR780()

Return
