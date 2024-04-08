#INCLUDE "Protheus.ch"                        
#INCLUDE "TopConn.ch"
#INCLUDE "TbiConn.ch"
#INCLUDE "Font.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RelCurvaEst ³ Autor ³ Thiago (Onsten)    ³ Data ³ 30/07/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatório de Curva ABC de Estoque                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico Brascola                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RelCurvaEst()
**************************

Local aAreaAtu	:= GetArea()
Local cCadastro	:= "Relatório de Curva ABC de Estoque"
Local nProcessa	:= 3
Local lJob		:= .t.
Local cDesc1    := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2    := "de acordo com os parametros informados pelo usuario."
Local cDesc3    := "Relatório de Curva ABC de Estoque"
Local cPict     := ""
Local cString   := ""

Private Titulo  := "Relatório de Curva ABC de Estoque"
Private nLin    := 99
Private Imprime := .T.
Private aOrd    := {}
Private cAnoAx  := SubStr(DtoS(dDataBase),3,2)
Private Cabec1  := "CODIGO      DESCRIÇÃO                                CLASSE        ORIGEM           SALDO           VALOR           VALOR          %            %            CONSUMO           DIAS DE           GIRO DE "
Private Cabec2  := "                                                    CONSUMO                       ESTOQUE         ESTOQUE       ESTQ ACUM         ITEM    ACUMULADO            MEDIO           ESTOQUE           ESTOQUE "
//                  9999999999  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX   X    IMPORTADO IND  999.999.999,99  999.999.999.99  999.999.999.99     99999.99     99999.99   999.999.999,99        99,999,999        99,999,999
//                  0         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22
//                  01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
Private lEnd         := .F. 
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "RELABCEST"
Private nTipo        := 15
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cPerg        := U_CriaPerg("CURVES")
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "RELCURVAEST"
Private aRegs        := {}

ValPergunte(cPerg)

wnrel:= SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.f.)

If nLastKey == 27
	Return
EndIf

SetDefault(aReturn,cString)

nTipo := If(aReturn[4]==1,15,18)

Processa({ ||U_ProcABCEst()}, "Curva ABC de Estoque",,.t.)

RestArea(aAreaAtu)

Return(Nil)
 
User Function ProcABCEst()
**************************
Local _cQryAx:= ""
Local _lSB9  := .f.

If Empty(MV_PAR07)
	MV_PAR07:= dDataBase
EndIf	

_cQryAx := "SELECT B9_DATA FROM " + RetSQLName("SB9") + " WHERE D_E_L_E_T_ = ' ' AND B9_DATA = '" + DtoS(MV_PAR07) + "'"

If Select("TRAB") > 0 
	TRAB->(dbCloseArea())
EndIf      

TCQUERY _cQryAx NEW ALIAS "TRAB"

dbSelectArea("TRAB")
dbGotop()

If Eof()
	Alert('Dados do mes corrente!...')
Else
	_lSB9:= .t.
EndIf	

_cQryAx := "SELECT CODIGO, "
_cQryAx += "       DESCRI, " 
_cQryAx += "       ORIGEM, " 
_cQryAx += "       SUM(ESTATU)  ESTATU,  " 
_cQryAx += "       SUM(VESTATU) VESTATU, " 
_cQryAx += "       SUM(CMEDIO)  CMEDIO   "
_cQryAx += "FROM ( " 
_cQryAx += " " 

If _lSB9
	_cQryAx += "     SELECT SB1.B1_COD        AS CODIGO,  "
	_cQryAx += "            SB1.B1_DESC       AS DESCRI,  "
	_cQryAx += "            SB1.B1_ORIGEM     AS ORIGEM,  "
	_cQryAx += "            SUM(SB9.B9_QINI)  AS ESTATU,  "
	_cQryAx += "            SUM(SB9.B9_VINI1) AS VESTATU, "
	_cQryAx += "            0 AS CMEDIO "
	_cQryAx += "     FROM " + RetSQLName("SB1") + " SB1 "
	_cQryAx += "     INNER JOIN " + RetSQLName("SB9") + " SB9 ON B1_COD = B9_COD AND B9_DATA = " + DtoS(MV_PAR07) + " AND B9_FILIAL = '" + xFilial("SB9") + "' AND SB9.D_E_L_E_T_ = '' "
	_cQryAx += "     WHERE SB1.D_E_L_E_T_ = ''"
	_cQryAx += "           AND B1_COD   BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' "
	_cQryAx += "           AND B1_TIPO  BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "' "
	_cQryAx += "           AND B1_GRUPO BETWEEN '" + mv_par05 + "' AND '" + mv_par06 + "' "
	_cQryAx += "           GROUP BY SB1.B1_COD, SB1.B1_DESC, SB1.B1_ORIGEM "
Else
	_cQryAx += "     SELECT SB1.B1_COD        AS CODIGO,  "
	_cQryAx += "            SB1.B1_DESC       AS DESCRI,  "
	_cQryAx += "            SB1.B1_ORIGEM     AS ORIGEM,  "
	_cQryAx += "            SUM(SB2.B2_QATU)  AS ESTATU,  "
	_cQryAx += "            SUM(SB2.B2_VATU1) AS VESTATU, "
	_cQryAx += "            0 AS CMEDIO "
	_cQryAx += "     FROM " + RetSQLName("SB1") + " SB1 "
	_cQryAx += "     INNER JOIN " + RetSQLName("SB2") + " SB2 ON B1_COD = B2_COD AND B2_FILIAL = '" + xFilial("SB2") + "' AND SB2.D_E_L_E_T_ = '' "
	_cQryAx += "     WHERE SB1.D_E_L_E_T_ = ''"
	_cQryAx += "           AND B1_COD   BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' "
	_cQryAx += "           AND B1_TIPO  BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "' "
	_cQryAx += "           AND B1_GRUPO BETWEEN '" + mv_par05 + "' AND '" + mv_par06 + "' "
	_cQryAx += "           GROUP BY SB1.B1_COD, SB1.B1_DESC, SB1.B1_ORIGEM "
EndIf

_cQryAx += " " 
_cQryAx += "     UNION ALL "
_cQryAx += " " 
_cQryAx += "     SELECT SB1.B1_COD        AS CODIGO, "
_cQryAx += "            SB1.B1_DESC       AS DESCRI, "
_cQryAx += "            SB1.B1_ORIGEM     AS ORIGEM, "
_cQryAx += "            0 AS ESTATU,  "
_cQryAx += "            0 AS VESTATU, "
_cQryAx += "            SUM(SB3.B3_MEDIA) AS CMEDIO "
_cQryAx += "     FROM " + RetSQLName("SB1") + " SB1 "
_cQryAx += "     INNER JOIN " + RetSQLName("SB3") + " SB3 ON B1_COD = B3_COD AND B3_FILIAL = '" + xFilial("SB3") + "' AND SB3.D_E_L_E_T_ = '' "
_cQryAx += "     WHERE SB1.D_E_L_E_T_ = ''"
_cQryAx += "           AND B1_COD   BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' "
_cQryAx += "           AND B1_TIPO  BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "' "
_cQryAx += "           AND B1_GRUPO BETWEEN '" + mv_par05 + "' AND '" + mv_par06 + "' "
_cQryAx += "           GROUP BY SB1.B1_COD, SB1.B1_DESC, SB1.B1_ORIGEM "
_cQryAx += " " 
_cQryAx += ") AGRUPA " 
_cQryAx += "GROUP BY CODIGO, DESCRI, ORIGEM "
_cQryAx += "ORDER BY VESTATU DESC "

If Select("TRAB") > 0 
	TRAB->(dbCloseArea())
EndIf      
TCQUERY _cQryAx NEW ALIAS "TRAB"

dbSelectArea("TRAB")
dbGotop()

nTotEst := 0
nTotVEst:= 0

While !Eof()
	If TRAB->VESTATU >= 0
		nTotEst += TRAB->ESTATU
		nTotVEst+= TRAB->VESTATU
	EndIf	

	DbSkip()
EndDo

nPorc80  := (nTotVEst*80)/100
nPorc15  := (nTotVEst*15)/100
nPorc05  := (nTotVEst*5)/100

nTotVCt80:= 0
nTotVCt15:= 0
nTotR80  := 0
nTotR15  := 0
nTotR05  := 0
nTotItem := 0
nTotDias := 0
nTotGiro := 0
nPAcum   := 0
nVEstAcum:= 0

dbGotop()
ProcRegua(RecCount())
dbGotop()

//Impressao

While !Eof()
	IncProc("Imprimindo...  "+TRAB->CODIGO)
	
	If TRAB->VESTATU < 0
		DbSkip()
		Loop
	EndIf

	// If TRAB->ESTATU+TRAB->VESTATU+TRAB->CMEDIO==0 
	If TRAB->VESTATU == 0 
		DbSkip()
		Loop
	EndIf

	nTotVCt80+= TRAB->VESTATU
	nTotItem++
	
	If nTotVCt80 <= nPorc80
		nTotR80++
	Else
		nTotVCt15+= TRAB->VESTATU
		
		If nTotVCt15 <= nPorc15
			nTotR15++
		Else
			nTotR05++
		EndIf		
	EndIf

	If lAbortPrint
		@ nLin,00 Psay "*** CANCELADO PELO OPERADOR ***"
		Exit
	EndIf
		
	If nLin > 57
		nLin:= Cabec(AllTrim(Titulo)+' '+IIf(_lSB9,DtoC(MV_PAR07),''),Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	EndIf
	
	cClasse  := Posicione("SB3",1,xFilial("SB3")+TRAB->CODIGO,"B3_CLASSE")
	nPItem   := (TRAB->VESTATU*100)/nTotVEst
	nPAcum   += nPItem
	nVEstAcum+= TRAB->VESTATU
	
	nTotDias += TRAB->ESTATU/TRAB->CMEDIO*30
	nTotGiro += 360/(TRAB->ESTATU/TRAB->CMEDIO*30)
    
	@ ++nLin, 000 PSay  SubStr(TRAB->CODIGO,1,10)
	@   nLin, 012 PSay  SubStr(TRAB->DESCRI,1,40)
	@   nLin, 055 PSay  cClasse
	@   nLin, 060 PSay  Iif(TRAB->ORIGEM=='0',"     NACIONAL",Iif(TRAB->ORIGEM=='1',"IMPORTADO DIR","IMPORTADO IND"))
	@   nLin, 075 PSay  TRAB->ESTATU                          Picture "@E 999,999,999.99"
	@   nLin, 091 PSay  TRAB->VESTATU                         Picture "@E 999,999,999.99"
	@   nLin, 107 PSay  nVEstAcum                             Picture "@E 999,999,999.99"
	@   nLin, 126 PSay  nPItem                                Picture "@E 99999.99"
	@   nLin, 139 PSay  nPAcum                                Picture "@E 99999.99"
	@   nLin, 150 PSay  TRAB->CMEDIO                          Picture "@E 999,999,999.99"
	@   nLin, 172 PSay  TRAB->ESTATU/TRAB->CMEDIO*30          Picture "@E 99,999,999"
	@   nLin, 190 PSay  360/(TRAB->ESTATU/TRAB->CMEDIO*30)    Picture "@E 99,999,999"
	
	dbSelectArea("TRAB")
	dbSkip()                        

EndDo

@ ++nLin, 000 PSay __PrtFatLine()
@ ++nLin, 000 PSay "T O T A L"
@   nLin, 075 PSay  nTotEst                               Picture "@E 999,999,999.99"
@   nLin, 091 PSay  nTotVEst                              Picture "@E 999,999,999.99"
@   nLin, 172 PSay  nTotDias/nTotItem                     Picture "@E 99,999,999"
@   nLin, 190 PSay  nTotGiro/nTotItem                     Picture "@E 99,999,999"

@ ++nLin, 000 PSay __PrtThinLine()
@ ++nLin, 000 PSay "Total de "+AllTrim(Transform(nTotItem,"@E 999,999,999"))+" itens        -->      80% = "+AllTrim(Transform(nTotR80,"@E 999,999,999"))+" item(s)        |        15% = "+AllTrim(Transform(nTotR15,"@E 999,999,999"))+" item(s)        |        5% = "+AllTrim(Transform(nTotR05,"@E 999,999,999"))+" item(s)."

@ ++nLin, 000 PSay __PrtFatLine()
 
dbSelectArea("TRAB")
dbCloseArea()

Set Device To Screen
If aReturn[5]==1
	dbCommitAll()
	Set Printer To
	OurSpool(wnrel)
EndIf
MS_FLUSH()

Return

Static Function ValPergunte(cPerg)
*********************************
DbSelectArea("SX1")
DbSetOrder(1)
aRegs:= {}
//          Grupo/Ordem/Pergunta/                       Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01     /Def01                    /Cnt01/Var02/Def02                  /Cnt02/Var03/Def03                     /Cnt03/Var04/Def04                    /Cnt04/Var05/Def05         /Cnt05 /F3   /Pyme /GrpSXG /Help /Picture
aAdd(aRegs,{cPerg,"01" ,"Codigo De? "            ,"","","mv_ch1","C" ,15     ,0      ,0     ,"G",""   ,"mv_par01",""                ,"","" ,""   ,""   ,""              ,"","" ,""   ,""   ,""                 ,"","" ,""   ,""   ,""                ,"","" ,""   ,""   ,"",     "","" ,""    ,"SB1",""    ,""     ,""   ,"",""})
aAdd(aRegs,{cPerg,"02" ,"Codigo Ate?"            ,"","","mv_ch2","C" ,15     ,0      ,0     ,"G",""   ,"mv_par02",""                ,"","" ,""   ,""   ,""              ,"","" ,""   ,""   ,""                 ,"","" ,""   ,""   ,""                ,"","" ,""   ,""   ,"",     "","" ,""    ,"SB1",""    ,""     ,""   ,"",""})
aAdd(aRegs,{cPerg,"03" ,"Tipo De? "              ,"","","mv_ch3","C" ,2      ,0      ,0     ,"G",""   ,"mv_par03",""                ,"","" ,""   ,""   ,""              ,"","" ,""   ,""   ,""                 ,"","" ,""   ,""   ,""                ,"","" ,""   ,""   ,"",     "","" ,""    ,"   ",""    ,""     ,""   ,"",""})
aAdd(aRegs,{cPerg,"04" ,"Tipo Ate?"              ,"","","mv_ch4","C" ,2      ,0      ,0     ,"G",""   ,"mv_par04",""                ,"","" ,""   ,""   ,""              ,"","" ,""   ,""   ,""                 ,"","" ,""   ,""   ,""                ,"","" ,""   ,""   ,"",     "","" ,""    ,"   ",""    ,""     ,""   ,"",""})
aAdd(aRegs,{cPerg,"05" ,"Grupo De? "             ,"","","mv_ch5","C" ,4      ,0      ,0     ,"G",""   ,"mv_par05",""                ,"","" ,""   ,""   ,""              ,"","" ,""   ,""   ,""                 ,"","" ,""   ,""   ,""                ,"","" ,""   ,""   ,"",     "","" ,""    ,"SBM",""    ,""     ,""   ,"",""})
aAdd(aRegs,{cPerg,"06" ,"Grupo Ate?"             ,"","","mv_ch6","C" ,4      ,0      ,0     ,"G",""   ,"mv_par06",""                ,"","" ,""   ,""   ,""              ,"","" ,""   ,""   ,""                 ,"","" ,""   ,""   ,""                ,"","" ,""   ,""   ,"",     "","" ,""    ,"SBM",""    ,""     ,""   ,"",""})
aAdd(aRegs,{cPerg,"07" ,"Data do fechamento?"    ,"","","mv_ch7","D" ,8      ,0      ,0     ,"G",""   ,"mv_par07",""                ,"","" ,""   ,""   ,""              ,"","" ,""   ,""   ,""                 ,"","" ,""   ,""   ,""                ,"","" ,""   ,""   ,"",     "","" ,""    ,"   ",""    ,""     ,""   ,"",""})

For i:=1 to Len(aRegs)
	If !DbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to Max(FCount(), Len(aRegs[i]))
			FieldPut(j,aRegs[i,j])
		Next
		MsUnlock()
		DbCommit()
	Endif
Next

Return