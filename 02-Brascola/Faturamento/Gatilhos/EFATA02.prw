# INCLUDE "RWMAKE.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Rdmake    ³ EFATA02  ³ Autor ³                       ³ Data ³   /  /    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Valida Condicao de Pagamento                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico Brascola                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function EFATA02(cOrigem)
******************************
Local cCodRep := "", cCondPg := ""
Local lRepre  := .F., lRet := .T.
Local aAreaAtu := GetArea()
Local aAreaSA3 := SA3->(GetArea())
Local aAreaSE4 := SE4->(GetArea())

dbSelectArea("SA3")
dbSetOrder(7)
If dbSeek(xFilial("SA3")+__cUserId)
	If A3_TIPO <> 'I'
		cCodRep := A3_COD
		lRepre  := .T.
	EndIf
EndIf

If (cOrigem == "TMK") //Marcelo
	cCondPg := AllTrim(M->UA_CONDPG) //Marcelo
Else
	cCondPg := AllTrim(M->C5_CONDPAG) //Fernando
Endif

dbSelectArea("SE4")
dbSetOrder(1)
If dbSeek(XFILIAL("SE4") + cCondPg) 
	//if  !(SA3->A3_GRPREP $ '000008*000009' .AND. SE4->E4_CODIGO = '090')
		//If lRepre == .T.	
		//IF (!Upper(AllTrim(cUserName))$Upper(GetMv("BR_000053"))) .and. SA3->A3_COD <> SA3->A3_SUPER
	 If SE4->E4_SETOR <> "V" 
		lret := .F.
		MsgBox(OemToAnsi("Favor utilizar uma Cond. Pagto válida da Lista de Preços!")) 
	 Endif
		
   	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Valida se a Cond.Pag esta Ativa³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lRet .And. SE4->E4_STATUS == 'I'
 		lret := .F.
		Alert("Esta Cond.Pag está INATIVA. Favor utilizar outra Condição de Pagamento!",;
  				"Valida Condição de Pagamento",;
				{"OK"})		 	
	EndIf

EndIf



If lRet 
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Executa calculo de acrescimo de acordo com a Condicao de Pagamento. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   nPosAnt := n
	For nProc := 1 To Len(Acols)
		n := nProc
	  	U_EFATA08(NIL,cOrigem)  // Calculo do Acrescimo
	
	//Fernando-07.01.12: colocado em comentario   
	//U_ArredVal()  // Arredondamento usado no campo de Tes

	Next
   n := nPosAnt
EndIf

RestArea(aAreaAtu)
RestArea(aAreaSE4)
RestArea(aAreaSA3)

Return(lRet)