#INCLUDE "protheus.ch"   
#INCLUDE "TopConn.ch"
#INCLUDE "RwMake.ch"

/*/
----------------------------------------------------------------------------
PROGRAMA: BESTPE001         AUTOR: D�BORA FRIEBE         DATA: 19/12/11
----------------------------------------------------------------------------

DESCRICAO: Ponto de entrada para valida��o do campo lote fornecedor quanto 
a entrada for de um material com controle de rastro.

----------------------------------------------------------------------------
CONTROLE DE ALTERACOES

DATA:                     AUTOR:
OBJETIVO:
----------------------------------------------------------------------------
/*/


User Function Mt100lok()

Local aArea		:= GetArea()
Local lOk		:= .t.
Local cProduto	:= BuscAcols("D1_COD") 
Local cLote 	:= BuscAcols("D1_LOTECTL")
		
	DbSelectArea("SB1")
	DbSetOrder(1)
	
If EMPTY(cLote) .AND. SB1->B1_RASTRO == 'L'
		msgalert("Para a entrada de Materiais com controle de Rastro � obrigat�rio o preenchimento dos Campos LOTE DO FORNECEDOR e DATA VALIDADE LOTE. Verifique!")
		lOk	:= .f.
EndIf
