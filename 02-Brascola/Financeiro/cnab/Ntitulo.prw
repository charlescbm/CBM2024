/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Dac       �Autor  �Evaldo V. Batista   � Data �  11/06/2005 ���
�������������������������������������������������������������������������͹��
���Desc.     � Separa numero de conta do DAC de conta corrente            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function ntitulo()

If SE1->E1_FILORIG = '10'
	//cNum := ALLTRIM(SE1->E1_PREFIXO)+SUBSTRING(SE1->E1_NUM,3,7)+"/"+ ALLTRIM(SE1->E1_PARCELA)
	cNum := SUBSTRING(SE1->E1_NUM,1,6)+"/"+ ALLTRIM(SE1->E1_PARCELA)
Else
   //cNum := ALLTRIM(SE1->E1_PREFIXO)+SUBSTRING(SE1->E1_NUM,1,6)+"/"+ ALLTRIM(SE1->E1_PARCELA)
     cNum := SUBSTRING(SE1->E1_NUM,4,8)+"/"+ ALLTRIM(SE1->E1_PARCELA)
Endif

Return(cNum)
