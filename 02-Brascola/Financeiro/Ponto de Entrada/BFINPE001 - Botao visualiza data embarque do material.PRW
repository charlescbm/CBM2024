#INCLUDE "rwmake.ch"
  
/*/
----------------------------------------------------------------------------
PROGRAMA: BFINPE001         AUTO: DÉBORA FRIEBE         DATA: 28/11/11
----------------------------------------------------------------------------

DESCRICAO: Ponto de Entrada para criação de botao na barra de ferramentas
do contas a receber, com o objetivo de visualizaqao da informacao de data
de embarque da mercadoria (data saida).

----------------------------------------------------------------------------
CONTROLE DE ALTERACOES

DATA:                     AUTOR:
OBJETIVO:
----------------------------------------------------------------------------
/*/



User Function F040BUT()
*********************
Private aBut040Ret:= {}

aBut040Ret:= {}

Aadd(aBut040Ret,{'PMSPESQ',{|| U_ConDTSaida() },"Consulta Data NF Saida","Dt.Saida"}) 
If (!INCLUI)
	SA1->(dbSetOrder(1))
	If SA1->(dbSeek(xFilial("SA1")+SE1->E1_cliente+SE1->E1_loja))
		aadd(aBut040Ret,{"OPEN",{|| u_GDVHistMan("SA1",.T.)},"Historico Cliente","Hist.Cliente"})
	Endif
Endif

Return(aBut040Ret)



User Function ConDTSaida()

If !INCLUI
    dDataSai:= Posicione("SF2",1,SE1->E1_FILIAL+SE1->E1_NUM+SE1->E1_PREFIXO+SE1->E1_CLIENTE+SE1->E1_LOJA,"F2_DTSAIDA")
    
	MsgAlert("Data de Saida: "+Iif(!Empty(dDataSai),DtoC(dDataSai),"Em Branco!"))
Else
	MsgAlert("Não Existe!")
EndIf	

Return