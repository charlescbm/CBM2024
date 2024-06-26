/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Rdmake    � EFATA10  � Autor � Sergio Lacerda        � Data � 12/05/2005���
��������������������������������������������������������������������������Ĵ��
���Descri��o � Validacado de quem pode alterar o Preco no Pedido de Venda  ���
��������������������������������������������������������������������������Ĵ��
���Observacao�                                                             ���
��������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico Brascola                                         ���
��������������������������������������������������������������������������Ĵ��
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/
User Function EFATA10()

Local lRet:= .T.
Local cProduto := ""
Local cGrupo   := ""

/***************************************** VERIFICACAO SE O PRODUTO � DEBITO DIRETO *******************************/
nPos1   := Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_PRODUTO"  }) // Posicao do Campo na Matriz
cProduto:= aCols[n,nPos1]  //Grava na variavel

dbSelectArea("SB1")
dbSetOrder(1)
If dbSeek(XFILIAL("SB1")+ cProduto)
	cGrupo := B1_GRUPO
EndIf

/***************************************** SEEK NO SA3 PARA CHECAR SE � REPRESENTANTE *****************************/
If B1_GRUPO == "8002"
	lRet := .T.
Else
	dbSelectArea("SA3")
	dbSetOrder(7)
	If dbSeek(xFilial("SA3")+__cUserId)
		If A3_TIPO <> 'I'
			lRet := .F.
		EndIf
	EndIf
	dbSetOrder(1)
	
	IF (Upper(AllTrim(cUserName))$Upper(GetMv("BR_000041")))
       lRet:=.T.
    ELSE
       lRet := .F.
    ENDIF
	
	If lRet == .F.
		MsgStop(OemToAnsi("Sem permiss�o de acesso! Tecle ESC para retornar."))
	EndIf
	
EndIf

Return(lRet)