#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MT100TOK � Autor � Elias Reis            � Data � 30/11/05 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � PE que faz a verificacao final do documento                ���
�������������������������������������������������������������������������Ĵ��
���Observacao�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico Brascola                                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
         OemToAnsi("Informe o Codigo de Reten��o T�tulo!"),;
         {"Ok"},1,OemToAnsi("Codigo de Reten��o");
         )

   lRet    := .F.
	
EndIf
*/
/////valida��o para evitar erros no SPED FISCAL///////
      
If ACOLS[1][10] $ ('034,087,252')
   CESPECIE := 'NFS'
EndIf               
/*
If ALLTRIM(Cespecie) == "SPED" .and. empty(F1_chvnfe) 
   LRet := .f.
   Msgalert("Notas com especie SPED, deve ser informado a Chave na aba informa��es Danfe no rodape da tela.")
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