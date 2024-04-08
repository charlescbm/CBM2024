#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"        
#INCLUDE "TbiConn.ch"

/*/
----------------------------------------------------------------------------
PROGRAMA: BESTA007         AUTOR:                          DATA: 21/12/11
----------------------------------------------------------------------------

DESCRICAO: Altera transportadora do redespacho

----------------------------------------------------------------------------
CONTROLE DE ALTERACOES

DATA:                     AUTOR:
OBJETIVO:
----------------------------------------------------------------------------
/*/


User Function Dptransp 

Local _cQuery := ""

If !Pergunte("DEPTRANSP",.t.)
  	Return
EndIf


_cQuery := "UPDATE SC5020 SET  C5_TRANSP = '" + MV_Par01 + "' "
IF MV_PAR04 = 1
_cQuery += ",C5_REDESP = '" + MV_Par02 + "' " 
ENDIF
_cQuery += " FROM SC5020,SA1020 
_cQuery += " WHERE C5_FILIAL = ' " + xFilial("SC5") + " ' AND C5_CLIENTE = A1_COD AND SC5020.D_E_L_E_T_ ='' AND SA1020.D_E_L_E_T_ ='' "
_cQuery += " AND A1_EST = '" + MV_Par03 + "' AND C5_NOTA = '' "
                                

lret:=TcSqlExec(_cQuery) 

Quer1 := " UPDATE SA1020 SET A1_TRANSP = '" + MV_Par01 + "' "
Quer1 += ", A1_X_RDESP  = '" + MV_Par02 + "' "  
Quer1 += ", A1_PERCFRE  = " + ALLTRIM(STR(MV_PAR05)) + " "
Quer1 +=" WHERE A1_EST =  '" + MV_Par03 + "' "
lret1:=TcSqlExec(Quer1)


MSGALERT("FIM DE PROCESSO")

Return
