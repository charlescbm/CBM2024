#INCLUDE "MATR340.CH"
#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ BMTR340A ³ Autor ³ Marcos V. Ferreira    ³ Data ³ 05/05/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Curva Consumos mes a mes                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function BMTR340A()

Local Tamanho    := "G"
Local titulo     := "Consumos/Vendas mes a mes de Materiais"
Local cDesc1     := "Este programa exibira' o consumo dos ultimos 12 meses de cada material"
Local cDesc2     := "ou produto acabado. No caso dos produtos ele estara' listando o  total"
Local cDesc3     := "das vendas."
Local cString    := "SB1"
Local aOrd       := {} 
Local wnrel	     := "BMTR340A"
             
Private aReturn  := {"Zebrado", 1, "Administracao", 1, 2, 1, "",1 }
Private nLastKey := 0 
Private cPerg    := U_CriaPerg("BMR340")
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01     // codigo de                                    ³
//³ mv_par02	 // codigo ate                                   ³ 
//³ mv_par03     // tipo de                                      ³
//³ mv_par04     // tipo ate                                     ³
//³ mv_par05     // grupo de                                     ³
//³ mv_par06     // grupo ate                                    ³
//³ mv_par07     // descricao de                                 ³
//³ mv_par08     // descricao ate                                ³
//³ mv_par09     // qtos meses imprimira                         ³
//³ mv_par10     // imprime itens sem consumo?                   ³
//³ mv_par11     // imprime itens sem estoque?                   ³
//³ mv_par12     // mes base para o calculo?                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

U_BCFGA002("BMTR340A")//Grava detalhes da rotina usada

Grava_SX1(cPerg)

Pergunte( cPerg, .F. )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao Setprint                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho)

SetDefault(aReturn,cString)

If  Len(MV_PAR12) <> 4 .And. Len(MV_PAR12) <> 0
	Alert('Data base de calculo invalida!...')
	Return
EndIf

If ( Subs(MV_PAR12,3,2) > Substr(Str(Year(dDataBase),4),3,2) )
	Alert('Ano superior ao ano base!...')
	Return
EndIf

If ( Subs(MV_PAR12,1,2) > StrZero( Month(dDataBase),2) )
	If ( Subs(MV_PAR12,3,2) = Substr(Str(Year(dDataBase),4),3,2) )
		Alert('Mes superior ao mes base!...')
		Return
	EndIf	
EndIf

If !Empty(MV_PAR12) .And. ( Subs(MV_PAR12,3,2) + Subs(MV_PAR12,1,2) < Subs(Str(Year(dDataBase - 365),4),3,2) + Subs(StrZero(Month(dDataBase - 365),2),1,2) )
	Alert('Numero de meses superior a 12!...')
	Return
EndIf

If  MV_PAR09 = 0
	Alert('Quantidade de meses nao pode ser nulo!...')
	Return
EndIf

RptStatus({|lEnd| BC340Imp(@lEnd,aOrd,wnRel,cString,tamanho,titulo)},titulo)

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ C340IMP  ³ Autor ³ Rodrigo de A. Sartorio³ Data ³ 13.12.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR340			                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function BC340Imp(lEnd,aOrd,WnRel,cString,tamanho,titulo)

Local aMeses	:= {"JAN","FEV","MAR","ABR","MAI","JUN","JUL","AGO","SET","OUT","NOV","DEZ"}
Local nX 		:= 0
Local nAno		:= 0 
Local nMes		:= 0 
Local nCol 		:= 0
Local nMesAux	:= 0
Local aSubQ[14] 
Local aSubV[14] 
Local aTotQ[14] 
Local aTotV[14] 
Local lPassou 
Local _dData:= dDataBase
Local _nMesRetr := 0
Local _nMesBase := 0
Local _nAnoBase := 0 
Local _nMesRec  := 0
Local _nAnoRec  := 0

Private lContinua := .T. 
Private cMes 	  := ""	
Private cCondicao := ""
Private cCondSec  := ""
Private cAnt      := ""
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Imporessao do Cabecalho e Rodape   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt     := Space(10)
cbcont    := 0
li        := 80
m_pag     := 1
nTipo     := IIf(aReturn[4]==1,15,18)
_dDataA   := '01/' + Subs(MV_PAR12,1,2) + '/' + Subs(MV_PAR12,3,2)
_dDataB	  := dDataBase    
_dDataR	  := CtoD(_dDataA)
_nDifMes  := Int ( ( _dDataB - _dDataR ) / 30 ) // Quando muda a data base o número de meses não poderá ser 12
_nMesBase := Month(dDataBase)
_nAnoBase := Val(Subs(Str(Year(dDataBase),4),3,2))
_nMesRec  := Val(Subs(MV_PAR12,1,2))
_nAnoRec  := Val(Subs(MV_PAR12,3,2))

If !Empty(MV_PAR12)
	_dData:= CtoD( StrZero(Day(dDataBase),2) + '/' + Subs(MV_PAR12,1,2) + '/' + Subs(MV_PAR12,3,2) )
EndIf	

nAno:= Year(_dData)

// Se emitira resumo do ano passado.
If month(_dData) < 12
	nAno--
EndIf

// Se retorna janeiro
nMes:= Month(_dData) + 1
If nMes = 13 
	nMes:= 1
EndIf

cMes:= StrZero(nMes,2)
/*
CODIGO     TP GRP  DESCRICAO                    UM   MES/AN01   MES/AN02   MES/AN03   MES/AN04   MES/AN05   MES/AN06   MES/AN07   MES/AN08   MES/AN09   MES/AN10   MES/AN11   MES/AN12      VALOR    MEDIA    %   % ACUM  CL
                                          SLD ESTQ.
00         11 14   19                           48  52                                                                                                                                  184       194      203    210      219
XXX_10_XXX XX XXXX XXXXXXXXXXXX_28_XXXXXXXXXXXX XX  999999999  999999999  999999999  999999999  999999999  999999999  999999999  999999999  999999999  999999999  999999999  999999999  999999999 99999999 999.99 999.99   A    
                                         999999999  999999999  999999999  999999999  999999999  999999999  999999999  999999999  999999999  999999999  999999999  999999999  999999999  999999999 99999999 999.99 999.99   A    
0         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22
01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
*/
Cabec1:= "CODIGO     TP GRP  DESCRICAO                    UM"
Cabec2:= "                                          SLD ESTQ."

For nX := 1 To 12
	If aMeses[nMes] == "JAN" .And. nX != 1
		nAno++
	EndIf
	cabec1 += Space(3)+aMeses[nMes]+"/"+StrZero(nAno,4)
	nMes++
	If nMes > 12
		nMes := 1
	EndIf
Next nX

Cabec1 += "      TOTAL    MEDIA    %   % ACUM  CL"

dbSelectArea("SB1")
SetRegua(LastRec())

Set SoftSeek On
Set Order To 1 //aReturn[8]
Seek cFilial+mv_par01

cCondicao := "lContinua .And. !EOF() .And. B1_COD <= mv_par02"
Set SoftSeek Off

aStruSB1:= SB1->(dbStruct())
cArqQry:= "TRB"

cQuery := "SELECT B1_FILIAL, B1_COD  , B1_TIPO  , B1_GRUPO, B1_DESC , B1_UM   , B1_LOCPAD, "
cQuery += "       B3_Q01   , B3_Q02  , B3_Q03   , B3_Q04  , B3_Q05  , B3_Q06  , B3_Q07   , B3_Q08  , B3_Q09  , B3_Q10  , B3_Q11  , B3_Q12  , "
cQuery += "       B3_MEDIA , B3_TOTAL, B3_CLASSE, B3_MES "
cQuery += "FROM " + RetSQLName("SB1") + " SB1 " 
cQuery += "INNER JOIN " + RetSQLName("SB3") + " SB3 ON B3_FILIAL = '" + xFILIAL('SB3') + "' AND B1_COD = B3_COD AND SB3.D_E_L_E_T_  = '' "
cQuery += "WHERE SB1.D_E_L_E_T_ = ' ' " 
cQuery += "AND B1_FILIAL = '" + xFILIAL('SB1') + "' "
cQuery += "AND B1_COD    BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "'"
cQuery += "AND B1_TIPO   BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "'"
cQuery += "AND B1_GRUPO  BETWEEN '" + mv_par05 + "' AND '" + mv_par06 + "'"
cQuery += "AND B1_DESC   BETWEEN '" + mv_par07 + "' AND '" + mv_par08 + "'"
cQuery += "ORDER BY B3_CLASSE, B3_COD"

//cQuery += "       B3_CMD01 , B3_CMD02, B3_CMD03 , B3_CMD04, B3_CMD05, B3_CMD06, B3_CMD07 , B3_CMD08, B3_CMD09, B3_CMD10, B3_CMD11, B3_CMD12, "

If Select("TRB") > 0
	dbSelectArea("TRB")
	TRB->(dbCloseArea("TRB"))
EndIf

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cArqQry,.F.,.T.)

For nCntFor := 1 To Len(aStruSB1)
	If ( aStruSB1[nCntFor,2]<>"C" )
		TcSetField(cArqQry,aStruSB1[nCntFor,1],aStruSB1[nCntFor,2],aStruSB1[nCntFor,3],aStruSB1[nCntFor,4])
	EndIf
Next

_aStruct  := {}
aAdd(_aStruct, {"CODIGO"   , "C",  10, 0})
aAdd(_aStruct, {"TIPO"     , "C",  02, 0}) 
aAdd(_aStruct, {"GRUPO"    , "C",  04, 0}) 
aAdd(_aStruct, {"DESCRI"   , "C",  28, 0})
aAdd(_aStruct, {"UM"       , "C",  02, 0})
aAdd(_aStruct, {"ESTOQUE"  , "N",  14, 2})
aAdd(_aStruct, {"QTDE_M01" , "N",  14, 2})
aAdd(_aStruct, {"QTDE_M02" , "N",  14, 2})
aAdd(_aStruct, {"QTDE_M03" , "N",  14, 2})
aAdd(_aStruct, {"QTDE_M04" , "N",  14, 2})
aAdd(_aStruct, {"QTDE_M05" , "N",  14, 2})
aAdd(_aStruct, {"QTDE_M06" , "N",  14, 2})
aAdd(_aStruct, {"QTDE_M07" , "N",  14, 2})
aAdd(_aStruct, {"QTDE_M08" , "N",  14, 2})
aAdd(_aStruct, {"QTDE_M09" , "N",  14, 2})
aAdd(_aStruct, {"QTDE_M10" , "N",  14, 2})
aAdd(_aStruct, {"QTDE_M11" , "N",  14, 2})
aAdd(_aStruct, {"QTDE_M12" , "N",  14, 2})
aAdd(_aStruct, {"QTDM_M01" , "N",  14, 2})
aAdd(_aStruct, {"QTDM_M02" , "N",  14, 2})
aAdd(_aStruct, {"QTDM_M03" , "N",  14, 2})
aAdd(_aStruct, {"QTDM_M04" , "N",  14, 2})
aAdd(_aStruct, {"QTDM_M05" , "N",  14, 2})
aAdd(_aStruct, {"QTDM_M06" , "N",  14, 2})
aAdd(_aStruct, {"QTDM_M07" , "N",  14, 2})
aAdd(_aStruct, {"QTDM_M08" , "N",  14, 2})
aAdd(_aStruct, {"QTDM_M09" , "N",  14, 2})
aAdd(_aStruct, {"QTDM_M10" , "N",  14, 2})
aAdd(_aStruct, {"QTDM_M11" , "N",  14, 2})
aAdd(_aStruct, {"QTDM_M12" , "N",  14, 2})
aAdd(_aStruct, {"TOTQTDE"  , "N",  14, 2})
aAdd(_aStruct, {"TOTQTMED" , "N",  14, 2})
aAdd(_aStruct, {"TOTQTDM"  , "N",  14, 2})
aAdd(_aStruct, {"TOTQTMEM" , "N",  14, 2})
aAdd(_aStruct, {"PORCENT"  , "N",  10, 6})
aAdd(_aStruct, {"CLASSIF"  , "C",  01, 0})

cArqTrb := CriaTrab(_aStruct, .t.)
dbUseArea( .T.,,cArqTrb, "TEMP", .F., .F. )

IndRegua("TEMP", Criatrab(,.f.), "DESCEND(STR(TOTQTDM,14,2))",,, "Consultando...")

aFill( aTotQ, 0 )
aFill( aTotV, 0 )

nTotAA    := 0
nTotBB    := 0
nTotCC    := 0
nTotIt    := 0
nTotGeral := 0
nMesAux   := nMes
nQtdMeses := mv_par09
_cPercAcum:= 0
_nMesPoss := 0

// Qunadidade de meses que poderá ser impressa
_nMesPoss := 12 - _nDifMes

// A quantidade de meses solicitada não poderá ser maior que a quantidade de meses permitida
If nQtdMeses > _nMesPoss
	nQtdMeses:= _nMesPoss
EndIf

nVarMesAx:= 12 - nQtdMeses

DbSelectArea("TRB")
DbGoTop()

While !Eof()
	If !Empty( aReturn[7]) .And. !&(aReturn[7] )
		dbSkip()
		Loop
	EndIf
     
	cQry := "SELECT SUM(B2_QATU) AS B2QATU "
	cQry += "FROM " + RetSQLName("SB2") + " "
	cQry += "WHERE D_E_L_E_T_ = '' "
	cQry += "AND B2_FILIAL = '" + xFilial("SB2") + "' "
	cQry += "AND B2_COD    = '" + TRB->B1_COD    + "' "
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),"SALDO",.F.,.T.)	
	dbSelectArea("SALDO")
	dbGoTop()
	
	_nEstoque:= SALDO->B2QATU
	dbCloseArea()

	DbSelectArea("TRB")

	If ( mv_par10==2 .And. TRB->B3_TOTAL == 0) .Or. ( mv_par11 == 2 .And. _nEstoque == 0 )
		DbSkip()
		Loop
	EndIf

	DbSelectArea("TEMP")
	
	RecLock("TEMP",.T.)	

	TEMP->CODIGO := SubStr(TRB->B1_COD,1,10)
	TEMP->TIPO   := TRB->B1_TIPO
	TEMP->GRUPO  := SubStr(TRB->B1_GRUPO,1,4)
	TEMP->DESCRI := SubStr(TRB->B1_DESC,1,28)
	TEMP->UM     := TRB->B1_UM
	TEMP->ESTOQUE:= 0
	
	_nTotQtd:= 0
    _nTotMed:= 0
	
	For nX := 1 To 12     
		cCampo:= "TRB->(B3_Q&cMes)"
		cNX   := StrZero(nX,2)
		campo1:= "TRB->(B3_CMD&cMes)"
		
		If Subs( MV_PAR12, 3, 2 ) + Subs( MV_PAR12, 1, 2 ) > Subs( TRB->B3_MES, 3, 4 )
		   Posicione("SB2", 1, xFilial("SB2") + TRB->B1_COD + TRB->B1_LOCPAD, "B2_CM1")                
	       campo1:= "SB2->B2_CM1"
	    endif

		If ( nX >= nVarMesAx )
			TEMP->(QTDE_M&cNX) := &(cCampo)
			TEMP->(QTDM_M&cNX) := &(cCampo) *  &(campo1)
			
			_nTotQtd+= &(cCampo) 
			_nTotMed+= &(cCampo) * &(campo1) 
		EndIf	
			
		nMesAux++
		
		If nMesAux > 12
			nMesAux := 1
		EndIf
		
		cMes := StrZero(nMesAux,2)
	
	Next nX

	TEMP->ESTOQUE := _nEstoque
	TEMP->TOTQTDE := _nTotQtd
	TEMP->TOTQTMED:= _nTotQtd / nQtdMeses
	TEMP->TOTQTDM := _nTotMed
	TEMP->TOTQTMEM:= _nTotMed / nQtdMeses
	TEMP->CLASSIF := TRB->B3_CLASSE
	
	If Alltrim(TRB->B3_CLASSE)=="A"
		nTotAA++
	ElseIf Alltrim(TRB->B3_CLASSE)=="B"
		nTotBB++
	Else 
		nTotCC++
	EndIf	
	 
	nTotIt++
	nTotGeral+= _nTotMed
	
	DbSelectArea("TRB")
	DbSkip()

EndDo

nTotM2:= 0
nPerAcu:= 0

DbSelectArea("TEMP")
DbGoTop()

While !Eof()
	_nPerc := (TEMP->TOTQTDM / nTotGeral) * 100
	nPerAcu+= _nPerc
	nTotM2 += TEMP->TOTQTDM
	
	RecLock("TEMP",.F.)	
	TEMP->PORCENT := _nPerc
	MsUnlock()	
	
	DbSkip()
EndDo

DbSelectArea("TEMP")
DbGoTop()

While !Eof()
	AFill(aSubQ,0)
	AFill(aSubV,0)
	cCondSec  := ".t."
	lPassou   := .F.
	_cPercAcum:= 0

	While !Eof()
		If li > 60
			Cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
		EndIf

		lPassou := .T.
                
		@ li,000 PSay TEMP->CODIGO
		@ li,011 PSay TEMP->TIPO
		@ li,014 PSay TEMP->GRUPO
		@ li,019 PSay TEMP->DESCRI
		@ li,048 PSay TEMP->UM

		nCol:= 52

		For nX := 1 To 12     
			cNX:= StrZero(nX,2)
	
			@ Li,nCol PSay TEMP->(QTDE_M&cNX)	Picture "@E 999999999" 

			aSubQ[nX]+= TEMP->(QTDE_M&cNX)
			nCol    += 11
		Next nX
		
		_cPercAcum+= TEMP->PORCENT
		If _cPercAcum>100
			_cPercAcum:= 100.000000
		EndIf	
		 
		@ Li,184 PSay TEMP->TOTQTDE		Picture "@E 999999999"
		@ Li,194 PSay TEMP->TOTQTMED	Picture "@E 99999999"
	  
		@ Li,202 PSay TEMP->PORCENT		Picture "999.999" //'999.99'
		@ Li,210 PSay _cPercAcum		Picture "999.999" //'999.99'
		@ Li,219 PSay TEMP->CLASSIF
		
		aSubQ[13] += Iif(TEMP->PORCENT>0,TEMP->PORCENT,0)
		aSubQ[14] += TEMP->TOTQTDE
		Li++
		@ Li,000 PSay "QTDE * MEDIO     -->"
		@ Li,041 PSay TEMP->ESTOQUE		Picture "@E 999999999"
		
		nCol:= 52

		For nX := 1 To 12     
			cNX:= StrZero(nX,2)

			@ Li,nCol PSay TEMP->(QTDM_M&cNX)	Picture "@E 999999999" 

			aSubV[nX]+= TEMP->(QTDM_M&cNX)
			nCol+= 11
		Next nX

		@ Li,184 PSay TEMP->TOTQTDM		Picture "@E 999999999"
		@ Li,194 PSay TEMP->TOTQTMEM	Picture "@E 99999999"
		Li+=2

		aSubV[13] += Iif(TEMP->PORCENT>0,TEMP->PORCENT,0)
		aSubV[14] += TEMP->TOTQTDM

		dbSelectArea("TEMP")
		dbSkip()
	EndDo
	
	For nX := 1 To Len(aTotQ)
		aTotQ[nX] += aSubQ[nX]
	Next nX
	
	For nX := 1 To Len(aTotV)
		aTotV[nX] += aSubV[nX]
	Next nX
	
EndDo

If li != 80
	@ ++Li,010 PSay "Total Geral Qtde " + Replicate(".",24)		
	        
	nCol := 52
	For nX := 1 To 12
		@ Li,nCol PSay aTotQ[nX]      Picture "@E 999999999" //cPictQuant
		nCol += 11
	Next nX

	@ Li,184 PSay aTotQ[14]           Picture "@E 999999999" //TM(aTot[14],14)
	@ Li,194 PSay aTotQ[14]/nQtdMeses Picture "@E 99999999"
	@ Li,203 PSay _cPercAcum /*aTot[13]*/           Picture "999.999" //'999.99'

	@ ++Li,010 PSay "Total Geral Valor " + Replicate(".",23)		
	        
	nCol := 52
	For nX := 1 To 12
		@ Li,nCol PSay aTotV[nX]      Picture "@E 999999999" //cPictQuant
		nCol += 11
	Next nX

	@ Li,184 PSay aTotV[14]           Picture "@E 999999999" //TM(aTot[14],14)
	@ Li,194 PSay aTotV[14]/nQtdMeses Picture "@E 99999999"

	Li+= 2
	@ Li,010 PSay "Total de "+AllTrim(Transform(nTotIt,"@E 999,999"))+" itens.  |   A: "+AllTrim(Transform(nTotAA,"@E 999,999"))+" itens  -  B: "+AllTrim(Transform(nTotBB,"@E 999,999"))+" itens  -  C: "+AllTrim(Transform(nTotCC,"@E 999,999"))+" itens."
	Li+= 2

	Roda(cbcont,cbtxt,Tamanho)
EndIf

dbSelectArea("TEMP")
dbCloseArea()

If aReturn[5] = 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
EndIf 

MS_FLUSH()

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ Grava_SX1 ³ Autor ³                      ³ Data ³ 18/12/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Gera perguntas                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Grava_SX1(cPerg)

Local _I:=_J:= 0

DbSelectArea("SX1")
DbSetOrder(1)
aRegs:= {}

aAdd(aRegs,{ cPerg, "01", "Do Produto? "                 , "", "", "mv_ch1", "C",15 ,0 ,0 , "G", "                                                     ", "mv_par01", "   ", "", "", "", "", "   ", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SB1", "", "", "", "", ""} )
aAdd(aRegs,{ cPerg, "02", "Ate Produto?"                 , "", "", "mv_ch2", "C",15 ,0 ,0 , "G", "                                                     ", "mv_par02", "   ", "", "", "", "", "   ", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SB1", "", "", "", "", ""} )
aAdd(aRegs,{ cPerg, "03", "Do Tipo? "                    , "", "", "mv_ch3", "C", 2 ,0 ,0 , "G", "                                                     ", "mv_par03", "   ", "", "", "", "", "   ", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "   ", "", "", "", "", ""} )
aAdd(aRegs,{ cPerg, "04", "Ate o Tipo?"                  , "", "", "mv_ch4", "C", 2 ,0 ,0 , "G", "                                                     ", "mv_par04", "   ", "", "", "", "", "   ", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "   ", "", "", "", "", ""} )
aAdd(aRegs,{ cPerg, "05", "Do Grupo? "                   , "", "", "mv_ch5", "C", 4 ,0 ,0 , "G", "                                                     ", "mv_par05", "   ", "", "", "", "", "   ", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SBM", "", "", "", "", ""} )
aAdd(aRegs,{ cPerg, "06", "Ate o Grupo?"                 , "", "", "mv_ch6", "C", 4 ,0 ,0 , "G", "                                                     ", "mv_par06", "   ", "", "", "", "", "   ", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SBM", "", "", "", "", ""} )
aAdd(aRegs,{ cPerg, "07", "Da Descricao do produto?"     , "", "", "mv_ch7", "C",30 ,0 ,0 , "G", "                                                     ", "mv_par07", "   ", "", "", "", "", "   ", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "   ", "", "", "", "", ""} )
aAdd(aRegs,{ cPerg, "08", "Ate a Descricao do produto?"  , "", "", "mv_ch8", "C",30 ,0 ,0 , "G", "                                                     ", "mv_par08", "   ", "", "", "", "", "   ", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "   ", "", "", "", "", ""} )
aAdd(aRegs,{ cPerg, "09", "Quantos meses impressos?"     , "", "", "mv_ch9", "N", 2 ,0 ,0 , "G", "                                                     ", "mv_par09", "   ", "", "", "", "", "   ", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "   ", "", "", "", "", ""} )
aAdd(aRegs,{ cPerg, "10", "Imprime itens sem consumo?"   , "", "", "mv_cha", "N", 1 ,0 ,0 , "C", "                                                     ", "mv_par10", "Sim", "", "", "", "", "Nao", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "   ", "", "", "", "", ""} )
aAdd(aRegs,{ cPerg, "11", "Imprime itens sem estoque?"   , "", "", "mv_chb", "N", 1 ,0 ,0 , "C", "                                                     ", "mv_par11", "Sim", "", "", "", "", "Nao", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "   ", "", "", "", "", ""} )
aAdd(aRegs,{ cPerg, "12", "Mes/Ano base para o calculo?" , "", "", "mv_chc", "C", 4 ,0 ,0 , "G", "Subs(MV_PAR12,1,2)>='01'.And.Subs(MV_PAR12,3,2)<='12'", "mv_par12", "   ", "", "", "", "", "   ", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "   ", "", "", "", "", ""} )

For _I:= 1 to Len(aRegs)
	If !DbSeek( cPerg + aRegs[_I,2])
		RecLock( "SX1", .T. )
		For _J:= 1 to Max( FCount(), Len( aRegs[_I] ) )
			FieldPut( _J, aRegs[_I,_J] )
		Next
		MsUnlock()
		DbCommit()
	Endif
Next

Return