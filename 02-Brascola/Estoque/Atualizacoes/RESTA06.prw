User Function RESTA06()

//зддддддддддддддддддддддддддддддддд©
//ЁInicializa as variaveis da funcaoЁ
//юддддддддддддддддддддддддддддддддды
Local aSaveArea := GetArea()
Local aAreaSB7  := SB7->(GetArea())
Local lRet := .t.



If Posicione("SB1",1,xFilial("SB1")+M->B7_COD,"B1_RASTRO") $ "S/L" .and. EMPTY(M->B7_LOTECTL)  
   Msgalert("ATENгцO !!!ESTE PRODUTO CONTROLA LOTES ,DIGITAR A FICHA NOVAMENTE COM  O NUMERO DO LOTE ","Aviso","INFO")
   lRet := .F.
EndIf                                       

RestArea(aSaveArea)

//здддддддддддддддддддддддддддддддд©
//ЁRetorna o resultado da validacaoЁ
//юдддддддддддддддддддддддддддддддды
Return(lRet)