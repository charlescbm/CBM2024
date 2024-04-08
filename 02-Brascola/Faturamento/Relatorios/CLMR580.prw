/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CLMR580   �Autor  �Microsiga           � Data �  28/11/05   ���
�������������������������������������������������������������������������͹��
���Desc.     � Chama o MATR580 inicializando o intervalo de vendedores    ���
���          � quando o usuario for vendedor com A3_TIPO = "E"            ���
�������������������������������������������������������������������������͹��
���Uso       � P8                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function CLMR580()

Local cCodRepr:= ''

//�����������������������������������������������Ŀ
//�Posiciona no vendedor correspondente ao usuario�
//�������������������������������������������������
DbSelectArea("SA3")
DbSetOrder(7)
dbSeek(xFilial("SA3")+__cUserID)       
dbSetOrder(1)   // Voltar a Ordem 1 para uso do Rel. Padrao

//�������������������������������������������������
//�Se foi localizado o vendedor e ele e externo,  �
//�ajusta os parametros para o codigo do vendedor �
//�������������������������������������������������
If !Eof() .And. SA3->A3_TIPO = "E" 
	dbSelectArea("SX1")
	dbSetOrder(1)
	dbSeek("MTR58003")
	
	If !Eof()
		Reclock("SX1")
		SX1->X1_CNT01 = "000000"
		MsUnlock()
	EndIf
	
	dbSeek("MTR58004")
	
	If !Eof()
		Reclock("SX1")
		SX1->X1_CNT01 = "000000"
		MsUnlock()
	EndIf	
EndIf

//��������������������������
//�Chama o relatorio padrao�
//��������������������������
MATR580()

Return