User Function RESTA06()

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//쿔nicializa as variaveis da funcao�
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
Local aSaveArea := GetArea()
Local aAreaSB7  := SB7->(GetArea())
Local lRet := .t.



If Posicione("SB1",1,xFilial("SB1")+M->B7_COD,"B1_RASTRO") $ "S/L" .and. EMPTY(M->B7_LOTECTL)  
   Msgalert("ATEN플O !!!ESTE PRODUTO CONTROLA LOTES ,DIGITAR A FICHA NOVAMENTE COM  O NUMERO DO LOTE ","Aviso","INFO")
   lRet := .F.
EndIf                                       

RestArea(aSaveArea)

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//쿝etorna o resultado da validacao�
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
Return(lRet)