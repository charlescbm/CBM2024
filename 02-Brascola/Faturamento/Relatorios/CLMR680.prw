#INCLUDE "RWMAKE.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � CLMR680  �Autor  �Microsiga           � Data �  12/09/05   ���
�������������������������������������������������������������������������͹��
���Desc.     �    Chama o MATR680 inicializando o intervalo de vendedores ���
���          � quando o usuario for vendedor com A3_TIPO = "E"            ���
�������������������������������������������������������������������������͹��
���Uso       � P8                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function CLMR680()

Local cPerg:= Padr( 'MTR680BR', Len( SX1->X1_GRUPO ) )

//�����������������������������������������������Ŀ
//�Posiciona no vendedor correspondente ao usuario�
//�������������������������������������������������
DbSelectArea('SA3')
DbSetOrder(7)

DbSeek( xFilial('SA3') + __cUserID, .f. )       
DbSetOrder(1)

//�������������������������������������������������
//�Se foi localizado o vendedor e ele e externo,  �
//�ajusta os parametros para o codigo do vendedor �
//�������������������������������������������������
If !Eof() .And. SA3->A3_TIPO = 'E' 
	DbSelectArea('SX1')
	DbSetOrder(1)
	
	If DbSeek( cPerg + '16', .f. )
		Reclock('SX1')
			SX1->X1_CNT01 = '000000'
		MsUnlock()
	EndIf

	If DbSeek( cPerg + '17', .f. )
		Reclock('SX1')
			SX1->X1_CNT01 = '000000'    
		MsUnlock()
	EndIf	
EndIf

//�������������������������������������������������
//�          Chama o relatorio padrao             �
//�������������������������������������������������
u_rfatr23()

Return