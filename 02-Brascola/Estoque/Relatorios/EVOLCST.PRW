#INCLUDE "topconn.ch"
#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³evolcst   ºAutor  Consystem            º Data ³  01/07/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Evolucao do custo medio										º±±
±±º          ³ 						                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP10                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER FUNCTION EVOLCST()
Local Tamanho    := "G"
Local titulo     := "Relatorio de Evolucao do Custo medio"
Local cDesc1     := "Este programa exibira' o custo medio dos ultimos 12 meses de cada material"
Local cDesc2     := "ou produto acabado. No caso dos produtos ele estara' listando o  total"
Local cDesc3     := "das vendas."
Local cString    := "SB9"
Local aOrd       := {} 
Local wnrel	     := "evolcst"
             
Private aReturn  := {"Zebrado", 1, "Administracao", 1, 2, 1, "",1 }
Private nLastKey := 0 
Private cPerg    := "evolcst   "
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

U_BCFGA002("EVOLCST")//Grava detalhes da rotina usada

Grava_SX1(cPerg)

Pergunte( cPerg, .F. )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao Setprint                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho)

SetDefault(aReturn,cString)


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
//_dDataA   := '01/' + Subs(MV_PAR12,1,2) + '/' + Subs(MV_PAR12,3,2)
//_dDataB	  := dDataBase    
//_dDataR	  := CtoD(_dDataA)
//_nDifMes  := Int ( ( _dDataB - _dDataR ) / 30 ) // Quando muda a data base o número de meses não poderá ser 12
//_nMesBase := Month(dDataBase)
//_nAno := Val(Subs(Str(Year(dDataBase),4),3,2))

nAno:= (Subs(Str(Year(dDataBase),4),3,2))

/*
CODIGO     TP GRP  DESCRICAO                    UM  CONSUMO    MES/AN01   MES/AN02   MES/AN03   MES/AN04   MES/AN05   MES/AN06   MES/AN07   MES/AN08   MES/AN09   MES/AN10   MES/AN11   MES/AN12      VALOR    MEDIA    %   % ACUM  CL
											CONSUMO.
00         11 14   19                           48  52                                                                                                                                  184       194      203    210      219
XXX_10_XXX XX XXXX XXXXXXXXXXXX_28_XXXXXXXXXXXX XX  999999999  999999999  999999999  999999999  999999999  999999999  999999999  999999999  999999999  999999999  999999999  999999999  999999999 99999999 999.99 999.99   A    
                                         999999999  999999999  999999999  999999999  999999999  999999999  999999999  999999999  999999999  999999999  999999999  999999999  999999999  999999999 99999999 999.99 999.99   A    
0         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22
01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
*/

//Cabec1:= "CODIGO     TP GRP  DESCRICAO                    UM  CONSUMO     JAN        FEV        MARC       ABR        MAIO       JUN        JUL        AGO        SET        OUT        NOV       DEZ     "
//          00         11 14   19                           48  52          63         74         85         96         107        118        129                                                                    184       194      203    210      219
//XXX_10_XXX XX XXXX XXXXXXXXXXXX_28_XXXXXXXXXXXX XX  999999999  999999999  999999999  999999999  999999999  999999999  999999999  999999999  999999999  999999999  999999999  999999999  999999999 99999999 999.99 999.99   A    
//                                         999999999  999999999  999999999  999999999  999999999  999999999  999999999  999999999  999999999  999999999  999999999  999999999  999999999  999999999 99999999 999.99 999.99   A    
 //          0         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22
//01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890

Cabec1:= "CODIGO         TP GRP  DESCRICAO                      UM LOC CONSUMO    "
Cabec2:= "                                                                              "

nMes := 01//\adminMonth(dDataBase)+1
If nMes = 13 
	nMes := 1
EndIf

cMes := StrZero(nMes,2)

nAno:= MV_PAR09

For nX := 1 To 12
If aMeses[nMes] == "JAN" .And. nX != 1	//"JAN"                              
		nAno++
EndIf                                                                            
  //	cabec1 += Space(7)+aMeses[nMes]//+"/"+StrZero(nAno,4) 
	cabec1 += aMeses[nMes]+"/"+substr(nAno,3,2)+Space(4)//+"/"+StrZero(nAno,4)
	nMes++
	If nMes > 12
		nMes := 1
	EndIf
Next nX
//*/


//Cabec1 += "      TOTAL    MEDIA    %   % ACUM  CL"

dbSelectArea("SB1")
SetRegua(LastRec())

                                     
_datad:=mv_par09+'0101'
_dataa:=mv_par09+'1231'
aStruSB1:= SB9->(dbStruct())
cArqQry:= "TRB"

cQuery :=" SELECT B9_COD,B1_DESC,B1_GRUPO,B9_LOCAL,B1_TIPO,B1_UM,ISNULL(B3_MEDIA,0) CONSUMO, "
cQuery +=" SUM(CASE WHEN SUBSTRING(B9_DATA,1,6)='201201' THEN B9_CM1 ELSE 0 END) AS CM_Jan, " 
cQuery +=" SUM(CASE WHEN SUBSTRING(B9_DATA,1,6)='201202' THEN B9_CM1 ELSE 0 END) AS CM_FEV,  "
cQuery +=" SUM(CASE WHEN SUBSTRING(B9_DATA,1,6)='201203' THEN B9_CM1 ELSE 0 END) AS CM_Marc, "
cQuery +=" SUM(CASE WHEN SUBSTRING(B9_DATA,1,6)='201204' THEN B9_CM1 ELSE 0 END) AS CM_Abr ,  "
cQuery +=" SUM(CASE WHEN SUBSTRING(B9_DATA,1,6)='201205' THEN B9_CM1 ELSE 0 END) AS CM_Maio , "
cQuery +=" SUM(CASE WHEN SUBSTRING(B9_DATA,1,6)='201206' THEN B9_CM1 ELSE 0 END) AS CM_Jun  ,  "
cQuery +=" SUM(CASE WHEN SUBSTRING(B9_DATA,1,6)='201207' THEN B9_CM1 ELSE 0 END) AS CM_Jul  ,  "
cQuery +=" SUM(CASE WHEN SUBSTRING(B9_DATA,1,6)='201208' THEN B9_CM1 ELSE 0 END) AS CM_Ago  ,  "
cQuery +=" SUM(CASE WHEN SUBSTRING(B9_DATA,1,6)='201209' THEN B9_CM1 ELSE 0 END) AS CM_Set  ,  "
cQuery +=" SUM(CASE WHEN SUBSTRING(B9_DATA,1,6)='201210' THEN B9_CM1 ELSE 0 END) AS CM_Out  ,  "
cQuery +=" SUM(CASE WHEN SUBSTRING(B9_DATA,1,6)='201211' THEN B9_CM1 ELSE 0 END) AS CM_Nov ,   "
cQuery +=" SUM(CASE WHEN SUBSTRING(B9_DATA,1,6)='201212' THEN B9_CM1 ELSE 0 END) AS CM_Dez  FROM " + RetSQLName("SB9") + " SB9 " 
cQuery +=" LEFT JOIN " + RetSQLName("SB3") + " SB3 ON B9_COD = B3_COD AND B9_FILIAL = B3_FILIAL and  SB3.D_E_L_E_T_  = '' "
cQuery +=" INNER JOIN "+ RetSQLName("SB1") + " SB1 ON B9_COD = B1_COD and  SB1.D_E_L_E_T_  = ''  AND B1_TIPO >=  '"+MV_PAR03+"' and B1_TIPO <= '" + MV_PAR04 + "'" "
cQuery +=" AND B1_GRUPO >=  '"+MV_PAR05+"' and B1_GRUPO <= '" + MV_PAR06 + "' AND B1_DESC >=  '"+MV_PAR07+"' and B1_DESC <= '" + MV_PAR08+"' "
cQuery +=" WHERE B9_DATA >='"+_datad+"' AND B9_DATA <=  '"+_dataa+"' and B9_FILIAL = '" + xFILIAL('SB9') + "'  AND SB9.D_E_L_E_T_  = '' "
cQuery +=" AND B9_COD >=  '"+MV_PAR01+"' and B9_COD <= '" + MV_PAR02 + "' "
cQuery +=" GROUP BY B9_COD,B9_LOCAL,B1_DESC,B1_GRUPO ,B1_TIPO,B1_UM,B3_MEDIA  "


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
aAdd(_aStruct, {"CODIGO"   , "C",  15, 0})
aAdd(_aStruct, {"TIPO"     , "C",  02, 0}) 
aAdd(_aStruct, {"GRUPO"    , "C",  04, 0}) 
aAdd(_aStruct, {"DESCRI"   , "C",  30, 0})
aAdd(_aStruct, {"UM"       , "C",  02, 0})
aAdd(_aStruct, {"LOCAL"    , "C",  02, 0})
aAdd(_aStruct, {"CONSUMO"  , "N",  14, 2})
aAdd(_aStruct, {"JAN"  	   , "N",  14, 2})
aAdd(_aStruct, {"FEV" 	   , "N",  14, 2})
aAdd(_aStruct, {"MAR" 	   , "N",  14, 2})
aAdd(_aStruct, {"ABR "     , "N",  14, 2})
aAdd(_aStruct, {"MAI"     , "N",  14, 2})
aAdd(_aStruct, {"JUN"    , "N",  14, 2})
aAdd(_aStruct, {"JUL"    , "N",  14, 2})
aAdd(_aStruct, {"AGO"    , "N",  14, 2})
aAdd(_aStruct, {"SET" 	   , "N",  14, 2})
aAdd(_aStruct, {"OUT"      , "N",  14, 2})
aAdd(_aStruct, {"NOV"      , "N",  14, 2})
aAdd(_aStruct, {"DEZ"      , "N",  14, 2})


cArqTrb := CriaTrab(_aStruct, .t.)
dbUseArea( .T.,,cArqTrb, "TEMP", .F., .F. )



nMesAux   := nMes

DbSelectArea("TRB")
DbGoTop()

While !Eof()
	If !Empty( aReturn[7]) .And. !&(aReturn[7] )
		dbSkip()
		Loop
	EndIf
     
	DbSelectArea("TRB")


	DbSelectArea("TEMP")
	
	RecLock("TEMP",.T.)	

	TEMP->CODIGO := SubStr(TRB->B9_COD,1,15)
	TEMP->TIPO   := TRB->B1_TIPO
	TEMP->GRUPO  := SubStr(TRB->B1_GRUPO,1,4)
	TEMP->DESCRI := SubStr(TRB->B1_DESC,1,30)
	TEMP->UM     := TRB->B1_UM
	TEMP->LOCAL  := TRB->B9_LOCAL

    TEMP->JAN 	:= TRB->CM_Jan
    TEMP->FEV 	:= TRB->CM_FEV
    TEMP->MAR 	:= TRB->CM_Marc
    TEMP->ABR 	:= TRB->CM_Abr
    TEMP->MAI 	:= TRB->CM_Maio
    TEMP->JUN 	:= TRB->CM_Jun 
    TEMP->JUL 	:= TRB->CM_Jul
    TEMP->AGO 	:= TRB->CM_Ago  
    TEMP->SET 	:= TRB->CM_Set
    TEMP->OUT 	:= TRB->CM_Out
    TEMP->NOV 	:= TRB->CM_Nov 
    TEMP->DEZ 	:= TRB->CM_Dez 
    TEMP->CONSUMO:=TRB->CONSUMO

	DbSelectArea("TRB")
	DbSkip()

EndDo




DbSelectArea("TEMP")
DbGoTop()

if mv_par10 <> 2 
  
	While !Eof()
		If li > 60
			Cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
		EndIf

                
		@ li,000 PSay TEMP->CODIGO
		@ li,015 PSay TEMP->TIPO
		@ li,019 PSay TEMP->GRUPO
		@ li,023 PSay TEMP->DESCRI
		@ li,054 PSay TEMP->UM    
		@ li,057 PSay TEMP->LOCAL
		@ li,062 PSay TEMP->CONSUMO

		nCol:= 73
       
		@ li,nCol PSay TEMP->JAN 
		nCol    += 10
   		@ li,nCol PSay TEMP->FEV 	
   		nCol    += 10
    	@ li,nCol PSay TEMP->MAR 	
    	 nCol   += 10
   		@ li,nCol PSAY TEMP->ABR
   		 nCol   += 10	
    	@ li,nCol PSay TEMP->MAI 
    	 nCol   += 10	
    	@ li,nCol PSay TEMP->JUN 
    	nCol   += 10
    	@ li,nCol PSay TEMP->JUL 
    	nCol   += 10
    	@ li,nCol PSay TEMP->AGO 
    	nCol   += 10
   		@ li,nCol PSay TEMP->SET 
   		nCol   += 10
   		@ li,nCol PSay TEMP->OUT 
   		nCol   += 10
   		@ li,nCol PSay  TEMP->NOV 	
   		nCol   += 10
    	@ li,nCol PSay TEMP->DEZ 
    	
        li++

			
		dbSelectArea("TEMP")
		dbSkip()
	EndDo
	Roda(cbcont,cbtxt,Tamanho)

dbSelectArea("TEMP")
dbCloseArea()

If aReturn[5] = 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
EndIf 

MS_FLUSH()
else
	ProcExcel("TEMP")
	dbSelectArea("TEMP")   
	dbCloseArea()
endif

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
aAdd(aRegs,{ cPerg, "09", "Ano base para o Relatorio?"   , "", "", "mv_chc9","C", 4 ,0 ,0 , "G", "                                                     ", "mv_par09", "   ", "", "", "", "", "   ", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "   ", "", "", "", "", ""} )
aAdd(aRegs,{ cPerg, "10", "Gera excel SIM/NAO 		?"   , "", "", "mv_chc9","N", 1 ,0 ,0 , "C", "                                                     ", "mv_par10", "Nao", "", "", "", "", "Sim", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "   ", "", "", "", "", ""} )
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

                                                                        


static Function ProcExcel(cAlias)

Local oExcelApp
Local cArqTmp		:= CriaTrab( Nil,.F.)
Local cNomArqDes 	:= ""
Local cDirDocs   	:= MsDocPath()
Local cPath			:= AllTrim(GetTempPath())

dbSelectArea( cAlias )


Copy To &(cDirDocs+"\"+cArqTmp+".XLS") VIA "DBFCDXADS"

CpyS2T( cDirDocs+"\"+cArqTmp+".XLS" , cPath, .T. )

Ferase(cDirDocs+"\"+cArqTmp+".XLS")
//Copy To &(cDestino)

If ApOleClient( 'MsExcel' )
	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open( cPath+cArqTmp+".XLS" ) // Abre uma planilha
	oExcelApp:SetVisible(.T.)
	
	oExcelApp:Destroy()
	
Else
	MsgStop(OemToAnsi("Microsoft Excel Não Instalado"))
EndIf

Return

/*

////////////////////////////////////////////////////////////
//      Planilha de notas de entrada por fornecedor.      //
////////////////////////////////////////////////////////////
cDirDocs  := MsDocPath() 
aStru		:= {}
aStruct		:= {}
cArquivo 	:= CriaTrab(,.F.)
cPath		:= AllTrim( GetTempPath() )
oExcelApp
nHandle
cCrLf 		:= Chr(13) + Chr(10)
nX
aFluxo    	:= {}
cMes		:= '  '

AADD ( aStru, { 'FORNECEDOR'    } )
AADD ( aStru, { 'NOME' 	        } )
AADD ( aStru, { 'CLASSIFICACAO' } )
AADD ( aStru, { 'JAN' + '/' + aAno[ 1] } )
AADD ( aStru, { 'FEV' + '/' + aAno[ 2] } )
AADD ( aStru, { 'MAR' + '/' + aAno[ 3] } )
AADD ( aStru, { 'ABR' + '/' + aAno[ 4] } )
AADD ( aStru, { 'MAI' + '/' + aAno[ 5] } )
AADD ( aStru, { 'JUN' + '/' + aAno[ 6] } )
AADD ( aStru, { 'JUL' + '/' + aAno[ 7] } )
AADD ( aStru, { 'AGO' + '/' + aAno[ 8] } )
AADD ( aStru, { 'SET' + '/' + aAno[ 9] } )
AADD ( aStru, { 'OUT' + '/' + aAno[10] } )
AADD ( aStru, { 'NOV' + '/' + aAno[11] } )
AADD ( aStru, { 'DEZ' + '/' + aAno[12] } )
AADD ( aStru, { 'TOTAL'      		   } )

aAdd( aStruct, { "FORNEC", "C", 06, 0 } )
aAdd( aStruct, { "NOME"  , "C", 40, 0 } ) 
aAdd( aStruct, { "DESCR ", "C", 25, 0 } )
aAdd( aStruct, { "MES01" , "N", 14, 2 } )
aAdd( aStruct, { "MES02" , "N", 14, 2 } )
aAdd( aStruct, { "MES03" , "N", 14, 2 } )
aAdd( aStruct, { "MES04" , "N", 14, 2 } )
aAdd( aStruct, { "MES05" , "N", 14, 2 } )
aAdd( aStruct, { "MES06" , "N", 14, 2 } )
aAdd( aStruct, { "MES07" , "N", 14, 2 } )
aAdd( aStruct, { "MES08" , "N", 14, 2 } )
aAdd( aStruct, { "MES09" , "N", 14, 2 } )
aAdd( aStruct, { "MES10" , "N", 14, 2 } )
aAdd( aStruct, { "MES11" , "N", 14, 2 } )
aAdd( aStruct, { "MES12" , "N", 14, 2 } )

cArqTrb:= CriaTrab( aStruct, .t. )
DbUseArea( .T.,, cArqTrb, 'TEMP', .F., .F. )

IndRegua( 'TEMP', Criatrab(,.f.), 'FORNEC',,, 'Aguarde!...' )

DbSelectArea( 'TEMP' )
DbSetOrder(1)

ProcRegua( Len( cAlias ) + 2 )

DbSelectArea( cAlias )
DbGoTop()

While !Eof()
	cMes:= StrZero( Month( (cAlias)->D1_EMISSAO ), 2 )
	
    DbSelectArea('TEMP') 
	DbSetOrder(1)
    
    If DbSeek( (cAlias)->D1_FORNECE )
		RecLock( 'TEMP', .F. )
    Else
		RecLock( 'TEMP', .T. )
   	EndIf   
   		FORNEC  := (cAlias)->D1_FORNECE
	   	NOME    := (cAlias)->A1_NOME
	   	DESCR   := POSICIONE( 'SZ0', 1, xFILIAL('SZ0') + (cAlias)->B1_XCLACOM, 'Z0_DESCR' )
	   	MES&cMes+= (cAlias)->( D1_TOTAL - D1_VALDESC + D1_VALFRE + D1_DESPESA + D1_SEGURO + D1_ICMSRET )
   	MsUnlock()
   	
	DbSelectArea( cAlias )   	
	DbSkip()

EndDo

DbSelectArea( 'TEMP' )
DbGoTop()

While !Eof()
	nTotal:= MES01 + MES02 + MES03 + MES04 + MES05 + MES06 + MES07 + MES08 + MES09 + MES10 + MES11 + MES12
	AADD( aFluxo, { FORNEC, NOME, DESCR, MES01, MES02, MES03, MES04, MES05, MES06, MES07, MES08, MES09, MES10, MES11, MES12, nTOTAL } )
	DbSkip()
EndDo

nHandle:= MsfCreate( cDirDocs + "\" + cArquivo + ".CSV", 0 )

If nHandle > 0
	
	// Grava o cabecalho do arquivo
	IncProc( "Aguarde!... Gerando arquivo de integração com Excel!..." )
	
	aEval( aStru, { |e, nX| fWrite( nHandle, e[1] + If( nX < Len( aStru ), ";", "") ) } )
	fWrite( nHandle, cCrLf ) // Pula linha
	
	For nX:= 1 to Len( aFluxo )
	
		IncProc( "Aguarde!... Gerando arquivo de integração com Excel..." ) 

		fWrite( nHandle, aFluxo[nX][ 1] + ';' )
		fWrite( nHandle, aFluxo[nX][ 2] + ';' )		
		fWrite( nHandle, aFluxo[nX][ 3] + ';' )
		fWrite( nHandle, Transform( aFluxo[nX][ 4], '@E 99,999,999.99' ) + ';' )
		fWrite( nHandle, Transform( aFluxo[nX][ 5], '@E 99,999,999.99' ) + ';' )
		fWrite( nHandle, Transform( aFluxo[nX][ 6], '@E 99,999,999.99' ) + ';' )
		fWrite( nHandle, Transform( aFluxo[nX][ 7], '@E 99,999,999.99' ) + ';' )
		fWrite( nHandle, Transform( aFluxo[nX][ 8], '@E 99,999,999.99' ) + ';' )
		fWrite( nHandle, Transform( aFluxo[nX][ 9], '@E 99,999,999.99' ) + ';' )
		fWrite( nHandle, Transform( aFluxo[nX][10], '@E 99,999,999.99' ) + ';' )
		fWrite( nHandle, Transform( aFluxo[nX][11], '@E 99,999,999.99' ) + ';' )
		fWrite( nHandle, Transform( aFluxo[nX][12], '@E 99,999,999.99' ) + ';' )
		fWrite( nHandle, Transform( aFluxo[nX][13], '@E 99,999,999.99' ) + ';' )
		fWrite( nHandle, Transform( aFluxo[nX][14], '@E 99,999,999.99' ) + ';' )
		fWrite( nHandle, Transform( aFluxo[nX][15], '@E 99,999,999.99' ) + ';' )
		fWrite( nHandle, Transform( aFluxo[nX][16], '@E 99,999,999.99' ) + ';' )
		fWrite( nHandle, cCrLf ) // Pula linha
	Next
	
	IncProc( "Aguarde!... Abrindo o arquivo!..."  )
	
	fClose( nHandle )
	CpyS2T( cDirDocs + "\" + cArquivo + ".CSV", cPath, .T. )
	
	If ! ApOleClient( 'MsExcel' ) 
		MsgAlert( 'MsExcel nao instalado' )
		Return
	EndIf
	
	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open( cPath + cArquivo + ".CSV" ) // Abre uma planilha
	oExcelApp:SetVisible( .T. )
Else
	MsgAlert( "Falha na criação do arquivo!..." ) 
Endif
