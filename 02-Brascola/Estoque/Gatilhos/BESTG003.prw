#INCLUDE "Protheus.ch" 
#include "rwmake.ch"
#INCLUDE "TopConn.ch" 
  
/*/
----------------------------------------------------------------------------
PROGRAMA: BESTG001         AUTOR: CHARLES B. MEDEIROS      DATA: 03/04/14
----------------------------------------------------------------------------

DESCRICAO: Alimenta campo de Data de Validade quando digitado data de fabricacao.

----------------------------------------------------------------------------
CONTROLE DE ALTERACOES

DATA:                     AUTOR:
OBJETIVO:
----------------------------------------------------------------------------
/*/

 
User Function BESTG003()
**********************

Local nSeq	 := 0
Local cSeq	 := '0001'
Local cCod	 := GDFieldGet("D1_COD")
Local Ddtvalid := "//"

DbSelectArea("SB1")
DbSetOrder(1)
DbSeek(xFilial("SB1")+cCod)

Private cprval := (SB1->B1_PRVALID)

If !(Empty(GDFieldGet("D1_DFABRIC"))) 
	Ddtvalid := (GDFieldGet("D1_DFABRIC")+cprval)
Else
	Ddtvalid := CTOD("")
Endif

Return(Ddtvalid)