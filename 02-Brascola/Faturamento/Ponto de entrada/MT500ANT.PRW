#INCLUDE "PROTHEUS.CH"
/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Rdmake    � MT500ANT � Autor � Marcos Eduardo Rocha  � Data � 09/09/2005���
��������������������������������������������������������������������������Ĵ��
���Descri��o � Ponto de Entrada para validacao da eliminacao por residuo   ���
��������������������������������������������������������������������������Ĵ��
���Observacao� Tratamento de eliminacao por valor.                         ���
��������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico Brascola                                         ���
���������������������������������������������������������������������������ٱ�
��� ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                      ���
��������������������������������������������������������������������������Ĵ��
��� PROGRAMADOR  � DATA   �         MOTIVO DA ALTERACAO                    ���
��������������������������������������������������������������������������Ĵ��
���Elias Reis    �17.03.06�Pergunta para que o usuario selecione se a      ���
���              �        �rotina devera considerar ou nao os pedidos de   ���
���              �        �Amostra.                                        ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/
User Function MT500ANT()
************************
Local aArea    := GetArea()
Local aAreaSC9 := SC9->(GetArea())
Local _lMens   := .F.
Local _cCFO		:= "" 
Local _cTes    := ""

//����������������������������������������������������������������Ŀ
//� Verifica se saldo em valor do pedido e' inferior ao parametro. �
//������������������������������������������������������������������
cQuery := " SELECT SUM((C6_QTDVEN - C6_QTDENT) * C6_PRCVEN) VALOR"
cQuery += " FROM "+RetSqlName("SC6")+" SC6 "
cQuery += " WHERE SC6.C6_FILIAL = '"+xFilial("SC6")+"'"
cQuery += " AND SC6.C6_NUM = '"+SC6->C6_NUM+"'"
cQuery += " AND SC6.C6_BLQ <> 'R '"
cQuery += " AND SC6.C6_BLQ <> 'S '"
cQuery += " AND SC6.C6_QTDVEN > SC6.C6_QTDENT"
cQuery += " AND SC6.D_E_L_E_T_ <> '*'"
//"C6_RESERVA=='"+Space(Len(SC6->C6_RESERVA))+"'"
cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRB",.T.,.T.)
dbGotop()

nValor := TRB->VALOR

dbCloseArea()
                                             
nVlrResPad := GetMv("MV_VLRRESF")

 
//Verifica��o de Tes que controla Financeiro    
_cTes := SC6->C6_TES

cQtes := " SELECT F4_DUPLIC"
cQtes += " FROM "+RetSqlName("SF4")+" SF4 "
cQtes += " WHERE SF4.F4_FILIAL = '"+xFilial("SF4")+"'"
cQtes += " AND SF4.F4_CODIGO = '"+_cTes+"'"
cQtes += " AND SF4.D_E_L_E_T_ <> '*'"                          

/*
A regra anterior observava a geracao de informacoes no financeiro, para que o usuario nao
pudesse excluir pedidos de amostra! Foi feito uma modificacao para que o programa verifique
o CFO utilizado no pedido. Caso seja de amostra, nao sera excluido!
*/

cQCFO := " SELECT SUBSTRING(C6_CF,2,3) CFO "
cQCFO += " FROM " + RetSQLName("SC6")
cQCFO += " WHERE 	C6_FILIAL 	= 	'"+xFilial("SC6")+"'"
cQCFO += " AND 	C6_NUM 		= 	'"+SC6->C6_NUM+"'"
cQCFO += " AND 	D_E_L_E_T_ 	<> '*'"
cQCFO := ChangeQuery(cQCFO)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQCFO),"TR2",.T.,.T.)
dbGotop()
_cCFO := TR2->CFO
dbCloseArea()

//fim                                         


//������������������������������������������������������������������������������������������Ŀ
//� Solicita confirmacao do usuario caso o valor do parametro seja maior que o valor padrao. �
//��������������������������������������������������������������������������������������������
_lMens := .f.                 

If (_cCFO == "911" .And. mv_par13 == 2) //.Or. (Posicione("SC5",1,xFilial("SC5")+SC6->C6_NUM,"C5_AMOSTRA")=="1" .And. mv_par13 == 2 )
  //	Aviso(OemToAnsi("Aten��o"),OemToAnsi("Pedido de Amostra! O Registro do pedido "+SC6->C6_NUM+" Item : "+SC6->C6_ITEM+" n�o ser� eliminado !! "),{"Ok"})
   Return .F.                        
EndIf


If nValor <= mv_par12 .And. mv_par12 > nVlrResPad .And. nValor > nVlrResPad  //.And. _cDupl=="S"   

	If !MsgYesNo(OemToAnsi("Valor informado no Parametro : R$ "+AllTrim(Str(mv_par12,14,2))+ ;
									" � superior ao Valor Padrao : R$ "+AllTrim(Str(nVlrResPad,14,2))+;
									". Elimina o Pedido : "+SC6->C6_NUM+" e Item : "+SC6->C6_ITEM+" com saldo de : R$ "+Alltrim(Str(nValor,14,2))+;
									" por residuo ?"),OemToAnsi("Elim. Res�duo com par�metro superior"))
		RestArea(aArea)
		Return .F.
	EndIf
/*
ElseIf nValor <= mv_par12 //.and.;		 _cDupl == "S"
   Aviso(	OemToAnsi("Aten��o"),;
   			OemToAnsi("Valor do Par�metro : ")+AllTrim(Str(mv_par12,14,2))+;
   			OemToAnsi(" Saldo do Pedido : ")+AllTrim(Str(nValor,14,2))+;
   			OemToAnsi(" O pedido "+SC6->C6_NUM+" Item : "+SC6->C6_ITEM+" ser� eliminado !! "),;
   			{"Ok"}) 
*/ 		
Elseif nValor > mv_par12 
   Aviso(	OemToAnsi("Aten��o"),;
   			OemToAnsi("Valor do Par�metro : ")+AllTrim(Str(mv_par12,14,2))+;
   			OemToAnsi(" Saldo do Pedido : ")+AllTrim(Str(nValor,14,2))+;
   			OemToAnsi(" O pedido "+SC6->C6_NUM+" Item : "+SC6->C6_ITEM+" n�o ser� eliminado !! "),;
   			{"Ok"})
   Return .F.
EndIf

DBSELECTAREA("SC6")
DBSETORDER(1)
SC6->(DBSEEK(XFILIAL("SC6")+C6_NUM+C6_ITEM))
RECLOCK("SC6",.F.)
SC6->C6_X_DATR := DDATABASE
SC6->(MSUNLOCK())
      
//�����������������������������Ŀ
//� Estorna os Itens Liberados. �
//�������������������������������
dbSelectArea("SC9")
dbSetOrder(1)
dbSeek(xFilial("SC9")+SC6->C6_NUM+SC6->C6_ITEM)

While !Eof() .And. SC9->C9_FILIAL+SC9->C9_PEDIDO+SC9->C9_ITEM == xFilial("SC9")+SC6->C6_NUM+SC6->C6_ITEM
	If Empty(SC9->C9_BLEST) .And. Empty(SC9->C9_BLCRED)
	   SC9->(A460Estorna())
	EndIf   

	dbSelectArea("SC9")
	dbSkip()
EndDo

RestArea(aAreaSC9)
RestArea(aArea)

Return .T.