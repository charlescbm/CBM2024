
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MS520VLD  �Autor  �Fernando            � Data �  17/04/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �  Ponto de entrada na Exclus�o de Documento de Sa�da        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


User Function MS520VLD()

lRet := .t.
 
If !Empty(SF2->F2_DTSAIDA)
	Help("",1,"BRASCOLA",,OemToAnsi("Nota Fiscal despachada em: "+dtoc(SF2->F2_DTSAIDA)+". N�o � poss�vel estornar. Favor contatar o Administrador."),1,0) 
 	lRet := .F.
 	Return lRet
 Endif

Return lRet