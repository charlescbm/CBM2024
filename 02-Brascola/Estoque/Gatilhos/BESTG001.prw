#INCLUDE "Protheus.ch" 
#include "rwmake.ch"
#INCLUDE "TopConn.ch" 
  
/*/
----------------------------------------------------------------------------
PROGRAMA: BESTG001         AUTOR: CHARLES B. MEDEIROS      DATA: 13/12/11
----------------------------------------------------------------------------

DESCRICAO: Controla numera��o no cadastro de Produto

----------------------------------------------------------------------------
CONTROLE DE ALTERACOES

DATA:                     AUTOR:
OBJETIVO:
----------------------------------------------------------------------------
/*/

 
User Function BESTG001()
**********************

Local nSeq	 := 0
Local cSeq	 := '0001'
Local cTipo	 := Alltrim(M->B1_TIPO)
Local cGrupo := Alltrim(M->B1_GRUPO)
Local cCod	 := ''

If M->B1_TIPO <> 'MO'
	cQuery := "SELECT MAX(B1_COD)B1_COD "
	cQuery += "FROM 	SB1010 SB1 "
	cQuery += "WHERE D_E_L_E_T_ <> '*' "
	cQuery += "AND SUBSTRING(B1_COD,1,1) = '"+ Alltrim(M->B1_TIPO) + "'"
	cQuery += "AND SUBSTRING(B1_COD,2,2) = '"+ Alltrim(M->B1_GRUPO) + "'"
	
	cQuery := ChangeQuery(cQuery) 
	
	If Select("CHA") <> 0
		dbSelectArea("CHA")
		dbCloseArea()
	Endif              
	
	TCQuery cQuery NEW ALIAS "CHA"
	
	If CHA->B1_COD <> ''
		nSeq := VAL(SUBSTR(CHA->B1_COD,4,4))+1
		cSeq := STRZERO(nSeq,4)
	Endif
	
	cSeq := STRZERO(nSeq,4)
	cCod := cTipo+cGrupo+cSeq   
Else
   
	cCod := ('MOD'+ Substr(M->B1_CC,1,4))	

Endif

Return(cCod)