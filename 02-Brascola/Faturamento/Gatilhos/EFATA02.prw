# INCLUDE "RWMAKE.CH"

/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Rdmake    � EFATA02  � Autor �                       � Data �   /  /    ���
��������������������������������������������������������������������������Ĵ��
���Descri��o � Valida Condicao de Pagamento                                ���
��������������������������������������������������������������������������Ĵ��
���Observacao�                                                             ���
��������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico Brascola                                         ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
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
		MsgBox(OemToAnsi("Favor utilizar uma Cond. Pagto v�lida da Lista de Pre�os!")) 
	 Endif
		
   	//�������������������������������Ŀ
	//�Valida se a Cond.Pag esta Ativa�
	//���������������������������������
	If lRet .And. SE4->E4_STATUS == 'I'
 		lret := .F.
		Alert("Esta Cond.Pag est� INATIVA. Favor utilizar outra Condi��o de Pagamento!",;
  				"Valida Condi��o de Pagamento",;
				{"OK"})		 	
	EndIf

EndIf



If lRet 
	//���������������������������������������������������������������������Ŀ
	//� Executa calculo de acrescimo de acordo com a Condicao de Pagamento. �
	//�����������������������������������������������������������������������
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