#INCLUDE "RWMAKE.CH"

USER FUNCTION MTA500QRY

Local aRegs  := {}
Local cFiltro:= "" // Acrescentado por Evaldo em 16/06/05
Local cQry   := "" // Acrescentado por Evaldo em 16/06/05
				   // a Função retorna o filtro atual, basta acrescentar o filtro desejado
local NUMPED := ""
Local cPerg  := U_CRIAPERG( 'MTA500' )
Local aRegs  := {}
Local cGrupo := ''
Local cEst   := ''
Local cProd  := ''

AADD( aRegs, { ALLTRIM( cPerg ), "14", "Exceto o Grupo    ?" , " ", " ", "MV_CH14", "C", 60, 0, 0, "G", "", "MV_PAR14" } )
AADD( aRegs, { ALLTRIM( cPerg ), "15", "Exceto o Grupo    ?" , " ", " ", "MV_CH15", "C", 60, 0, 0, "G", "", "MV_PAR15" } )
AADD( aRegs, { ALLTRIM( cPerg ), "16", "Exceto o Estado   ?" , " ", " ", "MV_CH16", "C", 60, 0, 0, "G", "", "MV_PAR16" } )
AADD( aRegs, { ALLTRIM( cPerg ), "17", "Somente o produto ?" , " ", " ", "MV_CH17", "C", 15, 0, 0, "G", "", "MV_PAR17" } )

lValidPerg(aRegs)

cGrupo:= AllTrim( MV_PAR14 )

If !Empty( AllTrim( MV_PAR15 ) )
	cGrupo+=  ';' + AllTrim( MV_PAR15 )
EndIf	                     

cGrupo:= StrTran( cGrupo, ";", "','" )
cGrupo:= StrTran( cGrupo, "*", "','" )

cEst := AllTrim( MV_PAR16 )
cProd:= AllTrim( MV_PAR17 )

cEst:= StrTran( cEst, ";", "','" )
cEst:= StrTran( cEst, "*", "','" )

cvalor1 := Alltrim(Str(mv_par12 ,14,2)) 
                                                      
cQuery := " SELECT C6_NUM NUM, A1_EST, A1_GRPVEN FROM"+ RetSQLName("SC6")+" SC6 "+","+RetSQLName("SA1")+" SA1 "
cQuery += " WHERE C6_FILIAL ='" + xFilial("SC6") + "'"
cQuery += " AND C6_NUM >= '"    + MV_PAR04 + "' AND "
cQuery += " C6_NUM     <= '"    + MV_PAR05 + "' AND "
cQuery += " C6_PRODUTO >= '"    + MV_PAR07 + "' AND "
cQuery += " C6_PRODUTO <= '"    + MV_PAR08 + "' AND "
cQuery += " C6_ENTREG BETWEEN '" + Dtos(MV_PAR10) + "' AND '" + Dtos(MV_PAR11) + "' AND "
cQuery += " C6_BLQ <> 'R ' AND C6_BLQ <> 'S ' AND "
cQuery += " (C6_QTDVEN-C6_QTDENT) > 0 AND "
cQuery += " C6_RESERVA = '" + Space( Len( SC6->C6_RESERVA ) ) + "' AND "
cQuery += " C6_CLI     = A1_COD  AND "
cQuery += " C6_LOJA    = A1_LOJA AND "
cQuery += " SC6.D_E_L_E_T_ <> '*' AND SA1.D_E_L_E_T_ <> '*' "

If !Empty( cGrupo )
	cQuery += "AND A1_GRPVEN NOT IN ('" + cGrupo + "') "
EndIf                           

If !Empty( MV_PAR16 )
	cQuery += "AND A1_EST    NOT IN ('" + cEst   + "') "
EndIf

If !Empty( MV_PAR17 )
	cQuery += "AND C6_PRODUTO IN ('" + cProd   + "') "
EndIf

cQuery += " AND (SELECT SUM((SC61.C6_QTDVEN - SC61.C6_QTDENT) * SC61.C6_PRCVEN)" 
cQuery += "      FROM "+RetSQLName("SC6")+" SC61 "
cQuery += "      WHERE SC61.C6_FILIAL = C6_FILIAL "
cQuery += "      AND SC61.C6_NUM = SC6.C6_NUM "
cQuery += "      AND SC61.C6_BLQ <> 'R '"
cQuery += "      AND SC61.C6_BLQ <> 'S '"
cQuery += "      AND SC61.C6_QTDVEN > SC61.C6_QTDENT"
cQuery += "      AND SC61.D_E_L_E_T_ <> '*') < '" + cvalor1 + "' "    
cQuery += " ORDER BY C6_NUM, C6_ITEM "

cQuery := ChangeQuery(cQuery)
DbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), 'TRB1', .F., .T. )

DBSELECTAREA("TRB1")        
DBGOTOP()

WHILE TRB1->(!EOF())
   NUMPED+= TRB1->NUM + '/'
   TRB1->(DBSKIP())
ENDDO        

//NUMPED = ""+ped+"'"        
NUMPED:= "'" + NUMPED        

cQry:= "C6_NUM IN (" + StrTran( NUMPED, "/", "','" ) + "')"

Dbclosearea("TRB1")
        
RETURN( cQry )