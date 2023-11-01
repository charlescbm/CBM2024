#Include 'Protheus.ch'
#Include "RWMAKE.CH"
/*
Exemplo de Ponto de Entrada para substituição de Regra
de Avaliação de Crédito.
PARAMIXB : 01 - Codigo do Cliente
02 - Loja do Cliente
03 - Valor da Operacao
04 - Moeda
05 - Pedido de Venda
*/
//DESENVOLVIDO POR INOVEN

User Function MAAVCRPR()

Local lRet 
Local aAreaSA1 := GetArea()
//Local aDados := PARAMIXB

if empty(ParamIxb[8])
 lRet := .t.
else
  lRet := .f.   
endif
  
IF SC5->C5_CONDPAG == '003'
	lRet := .F.
Endif


RestArea(aAreaSA1)

Return lRet
