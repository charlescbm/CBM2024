/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RFATC02  ³ Autor ³                          ³ Data ³   /  /   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Consulta de Faturamento por Produto                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico Brascola                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RFATC02()

MSGRUN("Aguarde....","Processando",{ || RFATC021()})

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MAPFATIT ³ Autor ³                          ³ Data ³   /  /   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Consulta de Faturamento por Produto                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico Brascola                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RFATC021()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cQuery         := ""
Local aRegs          := {}
Local cPerg          := U_CriaPerg("FATC02")
Local cAlias         := "TRB"
Local aMeses         := {'JAN','FEV','MAR','ABR','MAI','JUN','JUL','AGO','SET','OUT','NOV','DEZ'}
Local aCamposMes     := {}
Local aCamposVal     := {}
Local aCamposLiq     := {}
Local aCamposValBrut := {}
Local aCamposICMS    := {}
Local aCamposPIS     := {}
Local aCamposCOF     := {}
Local aCamposIPI     := {}
Local aCamposDesc    := {}

Local aCamposCUSTO 	:= {}
Local aCamposICMRET	:= {}
Local aCamposFRETE	:= {}


AADD(aRegs,{cPerg,"01","Do Mes  ?"			,"Do Mes ?"				,"Do Mes ?"		  		,"mv_ch1","N",02,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Ate Mes ?"			,"Ate Mes ?"			,"Ate Mes ?"	  		,"mv_ch2","N",02,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"03","Do Ano  ?"			,"Do Ano ?"				,"Do Ano ?"		  		,"mv_ch3","N",04,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"04","Mostra ICMS ?"		,"Mostra ICMS?"		,"Mostra ICMS?" 		,"mv_ch4","N",01,0,0,"C","","mv_par04","SIM","","","","","NAO","","","","","","","","","","","","","","","","","","","","","" } )
Aadd(aRegs,{cPerg,"05","Mostra PIS ?"		,"Mostra PIS?"			,"Mostra PIS?"			,"mv_ch5","N",01,0,0,"C","","mv_par05","SIM","","","","","NAO","","","","","","","","","","","","","","","","","","","","","" } )
Aadd(aRegs,{cPerg,"06","Mostra COFINS ?"	,"Mostra COFINS"		,"Mostra COFINS" 		,"mv_ch6","N",01,0,0,"C","","mv_par06","SIM","","","","","NAO","","","","","","","","","","","","","","","","","","","","","" } )
Aadd(aRegs,{cPerg,"07","Mostra IPI ?"		,"Mostra IPI?"			,"Mostra IPI?"			,"mv_ch7","N",01,0,0,"C","","mv_par07","SIM","","","","","NAO","","","","","","","","","","","","","","","","","","","","","" } )
Aadd(aRegs,{cPerg,"08","Mostra Descontos?","Mostra Descontos?"	,"Mostra Descontos?"	,"mv_ch8","N",01,0,0,"C","","mv_par08","SIM","","","","","NAO","","","","","","","","","","","","","","","","","","","","","" } )
Aadd(aRegs,{cPerg,"09","Quanto ao Tes ?"	,"¿Cuanto al Tes ?"	,"How About TIO ?"	,"mv_ch9","N",01,0,1,"C","","mv_par09","Gera Dupl.","Genera Fac.Cred","Gen. Trade Note","","","Nao Gera Dupl","No Genera Fc.Cr","No T.Note Gen.","","","Todos","Todos","All","","","","","","","","","","","","","S","","","" })
Aadd(aRegs,{cPerg,"10","Mostra Custo?"		,"Mostra CM ?"			,"Mostra CM ?"			,"mv_chA","N",01,0,0,"C","","mv_par10","SIM","","","","","NAO","","","","","","","","","","","","","","","","","","","","","" } )
Aadd(aRegs,{cPerg,"11","Mostra ICMSRet?"	,"Mostra ICMSRet?"	,"Mostra ICMSRet?"	,"mv_chB","N",01,0,0,"C","","mv_par11","SIM","","","","","NAO","","","","","","","","","","","","","","","","","","","","","" } )
Aadd(aRegs,{cPerg,"12","Mostra Frete?"		,"Mostra Frete?"		,"Mostra Frete?"		,"mv_chC","N",01,0,0,"C","","mv_par12","SIM","","","","","NAO","","","","","","","","","","","","","","","","","","","","","" } )
Aadd(aRegs,{cPerg,"13","Somente PA ?"		,""						,""						,"mv_chD","N",01,0,1,"C","","mv_par13","SIM","","","","","NAO","","","","","","","","","","","","","","","","","","","","S","","",""})
Aadd(aRegs,{cPerg,"14","Mostra Cod.Cli"	,"Mostra Cod.Cli?"	,"Mostra Cod.Cli?"	,"mv_chE","N",01,0,0,"C","","mv_par14","SIM","","","","","NAO","","","","","","","","","","","","","","","","","","","","","" } )

lValidPerg(aRegs)

If !Pergunte(cPerg,.T.)
	Return
EndIf

cQuery := "SELECT SD2.D2_FILIAL FILIAL , "    

cQuery += IIf(mv_par14==1," SD2.D2_CLIENTE, ","")

cQuery += " SD2.D2_COD PRODUTO, SB1.B1_DESC DESCRIC, MAX(SB1.B1_PESO) PLIQUI , SBM.BM_DESC GRUPO,"

For nProc := mv_par01 To mv_par02

	cMes    := StrZero(nProc,2)
   cNomMes := aMeses[nProc]

	cQuery += "	CAST(SUM(CASE WHEN SUBSTRING(SD2.D2_EMISSAO,5,2) = '"+cMes+"' THEN D2_QUANT ELSE 0 END) AS NUMERIC (10,2)) QTD_"+cNomMes+","
//	cQuery += " CAST(SUM(CASE WHEN SUBSTRING(SD2.D2_EMISSAO,5,2) = '"+cMes+"' THEN D2_TOTAL ELSE 0 END) AS NUMERIC (10,2)) TOTA_"+cNomMes+","
	cQuery += " CAST(SUM(CASE WHEN SUBSTRING(SD2.D2_EMISSAO,5,2) = '"+cMes+"' THEN D2_VALBRUT ELSE 0 END) AS NUMERIC (10,2)) BRUT_"+cNomMes+","

	If mv_par04 == 1
		cQuery += " CAST(SUM(CASE WHEN SUBSTRING(SD2.D2_EMISSAO,5,2) = '"+cMes+"' THEN D2_VALICM ELSE 0 END) AS NUMERIC (10,2)) ICM_"+cNomMes+","
		AADD(aCamposICMS,{"ICM_"+cNomMes})
   EndIf

	If mv_par05 == 1
		cQuery += " CAST(SUM(CASE WHEN SUBSTRING(SD2.D2_EMISSAO,5,2) = '"+cMes+"' THEN D2_VALIMP5 ELSE 0 END) AS NUMERIC (10,2)) PIS_"+cNomMes+","
		AADD(aCamposPIS,{"PIS_"+cNomMes})
   EndIf

	If mv_par06 == 1
		cQuery += " CAST(SUM(CASE WHEN SUBSTRING(SD2.D2_EMISSAO,5,2) = '"+cMes+"' THEN D2_VALIMP6 ELSE 0 END) AS NUMERIC (10,2)) COFI_"+cNomMes+","
		AADD(aCamposCOF,{"COFI_"+cNomMes})
   EndIf

	If mv_par07 == 1
		cQuery += " CAST(SUM(CASE WHEN SUBSTRING(SD2.D2_EMISSAO,5,2) = '"+cMes+"' THEN D2_VALIPI ELSE 0 END) AS NUMERIC (10,2)) IPI_"+cNomMes+","
		AADD(aCamposIPI,{"IPI_"+cNomMes})
   EndIf

	If mv_par08 == 1
		cQuery += " CAST(SUM(CASE WHEN SUBSTRING(SD2.D2_EMISSAO,5,2) = '"+cMes+"' THEN D2_DESCON ELSE 0 END) AS NUMERIC (10,2)) DESC_"+cNomMes+","
		AADD(aCamposDESC,{"DESC_"+cNomMes})
   EndIf
   




   //Se Exibe Custo medio
	If mv_par10 == 1
		cQuery += " CAST( (SELECT B9_CUSTD FROM "+RetSQLName("SB9")+" WHERE B9_FILIAL = SD2.D2_FILIAL AND B9_COD = SD2.D2_COD "
		cQuery += " AND B9_LOCAL = '40' AND SUBSTRING(B9_DATA,1,6) = '"+Alltrim(Str(mv_par03)+cMes)+"' AND D_E_L_E_T_ = ' ' ) AS NUMERIC (10,2) ) CUSTO_"+cNomMes+","
		AADD(aCamposCUSTO,{"CUSTO_"+cNomMes})
   EndIf
   
	//Se exibe o ICMS Retido
	If mv_par11 == 1
		cQuery += " CAST(SUM(CASE WHEN SUBSTRING(SD2.D2_EMISSAO,5,2) = '"+cMes+"' THEN D2_ICMSRET ELSE 0 END) AS NUMERIC (10,2)) ICMR_"+cNomMes+","
		AADD(aCamposICMRET,{"ICMR_"+cNomMes})
   EndIf
   
   //Se exibe o valor do Frete
	If mv_par12 == 1
		cQuery += " CAST(SUM(CASE WHEN SUBSTRING(SD2.D2_EMISSAO,5,2) = '"+cMes+"' THEN D2_VALFRE ELSE 0 END) AS NUMERIC (10,2)) FRET_"+cNomMes+","
		AADD(aCamposFRETE,{"FRET_"+cNomMes})
   EndIf         




	AADD(aCamposMes,{aMeses[nProc]})
	AADD(aCamposVal,{"QTD_"+cNomMes})
	AADD(aCamposLiq,{"BRUT_"+cNomMes})
Next

cQuery += " CAST(SUM(D2_QUANT) AS NUMERIC (10,2)) QTD_TOT,"
//cQuery += " CAST(SUM(D2_TOTAL) AS NUMERIC (10,2)) BRUT_TOT"
cQuery += " CAST(SUM(D2_VALBRUT) AS NUMERIC (10,2)) BRUT_TOT"
cQuery += " FROM "+RetSqlName("SD2")+" SD2, "+RetSqlName("SF2")+" SF2, "+RetSqlName("SB1")+" SB1, "+RetSqlName("SBM")+" SBM, "+RetSqlName("SF4")+" SF4"
cQuery += " WHERE SD2.D2_EMISSAO BETWEEN '" + AllTrim(Str(mv_par03)) + StrZero(mv_par01,2) + "01' AND '"
cQuery += AllTrim(Str(mv_par03)) + StrZero(mv_par02,2) + "31'"
cQuery += " AND SD2.D2_TIPO NOT IN ('D','B')"
cQuery += " AND SD2.D_E_L_E_T_ = ' '"
cQuery += " AND SF2.F2_FILIAL = SD2.D2_FILIAL"
cQuery += " AND SF2.F2_DOC = SD2.D2_DOC"
cQuery += " AND SF2.F2_SERIE = SD2.D2_SERIE"
cQuery += " AND SF2.D_E_L_E_T_ = ' '"


//Se o usuario optou por gerar somente PA
If mv_par13 == 1 // Gera Duplicata
	cQuery += " AND SD2.D2_TP = '3'   "
EndIf	


cQuery += " AND SB1.B1_FILIAL = '"+xFilial("SB1")+"'"
cQuery += " AND SB1.B1_COD = SD2.D2_COD"
cQuery += " AND SB1.D_E_L_E_T_ = ' '"
cQuery += " AND SBM.BM_FILIAL = '"+xFilial("SBM")+"'"
cQuery += " AND SBM.BM_GRUPO = SB1.B1_GRUPO"
cQuery += " AND SBM.D_E_L_E_T_ = ' ' "
cQuery += " AND SF4.F4_FILIAL = '"+xFilial("SF4")+"'"
cQuery += " AND SF4.F4_CODIGO = SD2.D2_TES"
If mv_par09 == 1 // Gera Duplicata
	cQuery += " AND SF4.F4_DUPLIC = 'S'"
ElseIf mv_par09 == 2 // Não Gera Duplicata
	cQuery += " AND SF4.F4_DUPLIC = 'N'"
EndIf	
cQuery += " AND SF4.D_E_L_E_T_ = ' '"
cQuery += " GROUP BY SD2.D2_FILIAL,"

cQuery += Iif(mv_par14==1," SD2.D2_CLIENTE,","")

cQuery += " SD2.D2_COD, SB1.B1_DESC, SBM.BM_DESC"

cQuery := ChangeQuery(cQuery)
MemoWrite("\QUERYSYS\RFATC02.SQL",cQuery) 


dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)

FOR M1 := 1 TO LEN(aCamposMes)
	
	TCSetField('TRB', aCamposMes[M1,1]    , "N",16,2)
	TCSetField('TRB', aCamposLiq[M1,1]    , "N",16,2)
	TCSetField('TRB', aCamposVal[M1,1]    , "N",16,2)

	IF LEN(aCamposICMS) > 0
		TCSetField('TRB', aCamposICMS[M1,1]   , "N",16,2)
	ENDIF
	
	IF LEN(aCamposPIS) > 0
		TCSetField('TRB', aCamposPIS[M1,1]    , "N",16,2)
	ENDIF
	
	IF LEN(aCamposCOF) > 0
		TCSetField('TRB', aCamposCOF[M1,1]    , "N",16,2)
	ENDIF
	
	IF LEN(aCamposIPI) > 0
		TCSetField('TRB', aCamposIPI[M1,1]    , "N",16,2)
	ENDIF
	
	IF LEN(aCamposDESC) > 0
		TCSetField('TRB', aCamposDESC[M1,1]   , "N",16,2)
	ENDIF
	
	
	IF LEN(aCamposCUSTO) > 0
 		TCSetField('TRB', aCamposCUSTO[M1,1]	,"N",16,2)
	ENDIF
	
	
	IF LEN(aCamposFRETE) > 0
		TCSetField('TRB', aCamposFrete[M1,1]	,"N",16,2)
	ENDIF
	
	IF LEN(aCamposICMRET) > 0
		TCSetField('TRB', aCamposICMRET[M1,1]	,"N",16,2)
	ENDIF	
	
NEXT

TCSetField('TRB', "QTD_TOT"   , "N",16,2)
TCSetField('TRB', "BRUT_TOT" , "N",16,2)

U_ProcExcel(cAlias)

TRB->(DBClosearea())

Return(.T.)