# INCLUDE "RWMAKE.CH"

/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Rdmake    � EFATA03  � Autor �                       � Data �   /  /    ���
��������������������������������������������������������������������������Ĵ��
���Descri��o � Bloqueia Tabela Digitada                                    ���
��������������������������������������������������������������������������Ĵ��
���Observacao�                                                             ���
��������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico Brascola                                         ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/
User Function EFATA03(cOrigem)
******************************
Local cCodRep  := ""
Local cTabela  := ""
Local lRetorno := .T. 


dbSelectArea("SA3")
dbSetOrder(7)
If dbSeek(xFilial("SA3")+__cUserId)
	IF SA3->A3_TIPO <> 'I'
		cCodRep  := A3_COD
		lRetorno := .F.
		cGrupo   := SA3->A3_GRPREP
	ENDIF
ENDIF
dbSetOrder(1)

If (cOrigem == "TMK") //Marcelo
	cTabela	:= AllTrim(M->UA_TABELA) //Marcelo
Else
	cTabela	:= AllTrim(M->C5_TABELA) //Fernando
Endif

If !lRetorno
	dbSelectArea("ACA")
	dbSetOrder(1)
	If dbSeek(XFILIAL("ACA") + cGrupo )
		cTabs := ACA->ACA_TABELA
	EndIf
	
	If !(cTabela $ cTabs)
		MsgBox(OemToAnsi("Representante n�o autorizado a utilizar esta Tabela de Pre�o !"))
 	Else
 		lRetorno := .T.
 	EndIf

EndIf

//���������������������������������������������������������������������������������������Ŀ
//� Executa calculo de acrescimo de acordo com a Condicao de Pagamento / Tabela de Preco. �
//�����������������������������������������������������������������������������������������
nPosAnt := n
For nProc := 1 To Len(Acols)
	n := nProc
  	U_EFATA08(NIL,cOrigem)   // Calculo do Acrescimo
   
		//Fernando-07.01.12: colocado em comentario
	//U_ArredVal()  // Arredondamento usado no campo de Tes
Next
n := nPosAnt

Return(lRetorno)