User Function RESTA06()

//���������������������������������Ŀ
//�Inicializa as variaveis da funcao�
//�����������������������������������
Local aSaveArea := GetArea()
Local aAreaSB7  := SB7->(GetArea())
Local lRet := .t.



If Posicione("SB1",1,xFilial("SB1")+M->B7_COD,"B1_RASTRO") $ "S/L" .and. EMPTY(M->B7_LOTECTL)  
   Msgalert("ATEN��O !!!ESTE PRODUTO CONTROLA LOTES ,DIGITAR A FICHA NOVAMENTE COM  O NUMERO DO LOTE ","Aviso","INFO")
   lRet := .F.
EndIf                                       

RestArea(aSaveArea)

//��������������������������������Ŀ
//�Retorna o resultado da validacao�
//����������������������������������
Return(lRet)