#INCLUDE 'PROTHEUS.CH' 
#INCLUDE 'TOPCONN.CH'

/*/
----------------------------------------------------------------------------
PROGRAMA: BTMKPE001         AUTOR: DÉBORA FRIEBE         DATA: 28/11/11
----------------------------------------------------------------------------

DESCRICAO: Poto de entrada para alimentar automaticamente os campos do registro
de chamado na tabela de Nao conformidades.

----------------------------------------------------------------------------
CONTROLE DE ALTERACOES

DATA:                     AUTOR:
OBJETIVO:
----------------------------------------------------------------------------
/*/

User Function QNCGRFNC()   


Local aAreaSUC := SUC->(GetArea())
Local aAreaSUD := SUD->(GetArea())
Local aAreaQI2 := QI2->(GetArea())

QI2->QI2_LOTE  :=SUD->UD_X_LOTE
QI2->QI2_X_NTOR:= SUD->UD_X_NOTA
QI2->QI2_X_LVLD:= SUD->UD_X_LVLD 
//QI2->QI2_NCHAMA := SUD->UD_CODIGO
QI2->QI2_CONTAT:=  Posicione("SU5",1,xFilial("SU5")+SUC->UC_CODCONT,"U5_CONTAT")

cQuery := "SELECT QI2_FNC  "
cQuery += "FROM QI2010 "
cQuery += "WHERE QI2_FILIAL = '"+xFilial("QI2")+"'"
cQuery += "      AND QI2_LOTE = '"+SUD->UD_X_LOTE+"'"
cQuery += "      AND QI2_CODPRO = '"+SUD->UD_PRODUTO+"'"
cQuery += "      AND QI2_NCHAMA = '"+SUD->UD_CODIGO+"'"
cQuery += "      AND D_E_L_E_T_ <> '*'"
cQuery += "      AND QI2_LOTE  <> ''"
cQuery += "     ORDER BY QI2_FNC "
If Select("QI2LO") > 0
	DbSelectArea("QI2LO")
	DbCloseArea()
Endif               

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'QI2LO',.F.,.T.)

DbSelectArea("QI2LO")
DbGoTop()
WHILE QI2LO->(!EOF())
    QI2->QI2_X_HIST:=alltrim(QI2->QI2_X_HIST)+QI2LO->QI2_FNC+"/"
    QI2LO->(DBSKIP())
END

RestArea(aAreaSUC)              
RestArea(aAreaSUD)
RestArea(aAreaQI2)
Dbclosearea("QI2LO")
RETURN

/*
SUD->(DbSetOrder(1))
If SUD->(DbSeek(xFilial()+SUC->UC_CODIGO))
			
   While SUD->(!Eof()) .AND. xFilial("SUD") == SUD->UD_FILIAL .AND. SUD->UD_CODIGO == SUC->UC_CODIGO		
       GRVQI2(SUD->UD_CODFNC,SUD->UD_X_LOTE)
       SUD->(DbSkip())
   End
Endif                                           
		

RestArea(aAreaSUC)              
RestArea(aAreaSUD)
RestArea(aAreaQI2)
RETURN

STATIC FUNCTION GRVQI2(_CODFNC,_LLOTE)

DBSELECTAREA("QI2")
DBSETORDER(2)
DBSEEK(XFILIAL("QI2")+_CODFNC)
//RecLock("QI2",.F.)
QI2->QI2_LOTE:=_LLOTE
//QI2->(MSUNLOK())
RETURN
