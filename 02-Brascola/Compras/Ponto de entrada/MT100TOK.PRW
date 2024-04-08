#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MT100TOK ³ Autor ³ Elias Reis            ³ Data ³ 30/11/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ PE que faz a verificacao final do documento                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico Brascola                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function MT100TOK()
*********************
Local aAreaAtu := GetArea()
Local aAreaSD1 := SD1->(GetArea())
Local aAreaSF1 := SF1->(GetArea())
Local lRet    := .T.

/*
If Inclui .And.;
   AllTrim(FunName()) == "FINA050" .And.;
   M->E2_TIPO == "TX " .And.;
   Empty(M->E2_CODRET)
   
   Aviso(;
         OemToAnsi("Codigo Retencao"),;
         OemToAnsi("Informe o Codigo de Retenção Título!"),;
         {"Ok"},1,OemToAnsi("Codigo de Retenção");
         )

   lRet    := .F.
	
EndIf
*/
/////validação para evitar erros no SPED FISCAL///////
      
If ACOLS[1][10] $ ('034,087,252')
   CESPECIE := 'NFS'
EndIf               
/*
If ALLTRIM(Cespecie) == "SPED" .and. empty(F1_chvnfe) 
   LRet := .f.
   Msgalert("Notas com especie SPED, deve ser informado a Chave na aba informações Danfe no rodape da tela.")
EndIf

*/

//Atualizo a Transportadora
///////////////////////////
If (lRet).and.(Len(aNfeDanfe) > 0).and.(SF1->(FieldPos("F1_TRANSP")) > 0).and.Empty(aNfeDanfe[01])
	aNfeDanfe[01] := Posicione("SA2",1,xFilial("SA2")+cA100For+cLoja,"A2_TRANSP")
Endif

RestArea(aAreaAtu)
RestArea(aAreaSD1)
RestArea(aAreaSF1)

Return(lRet)