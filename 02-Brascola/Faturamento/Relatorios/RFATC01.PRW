#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"
#INCLUDE "TopConn.ch"        
#INCLUDE "TbiConn.ch"
/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���Fun��o    � RFATC01  � Autor �                          � Data �   /  /   ���
����������������������������������������������������������������������������Ĵ��
���Descri��o � Consulta de Faturamento por Cliente                           ���
����������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico Brascola                                           ���
�����������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
User Function RFATC01()

MSGRUN("Aguarde....","Processando",{ || RFATC011()})

Return(.T.)

/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���Fun��o    �          � Autor �                          � Data �   /  /   ���
����������������������������������������������������������������������������Ĵ��
���Descri��o � Consulta de Faturamento por Produto                           ���
����������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico Brascola                                           ���
�����������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
Static Function RFATC011()

Local cQuery     := ""
Local aRegs      := {}
Local cPerg      := U_CriaPerg("FATC01")
Local cAlias     := "TRB"
Local aCamposMes := {}
Local aMeses     := {'JAN','FEV','MAR','ABR','MAI','JUN','JUL','AGO','SETE','OUTU','NOV','DEZ'}

aAdd(aRegs,{cPerg,"01","Do Mes  ?"      	,"Do Mes ?"    ,"Do Mes ?"		,"mv_ch1","N",2,0,0,"G","","mv_par01",""				,"","","","",""					,"","","","",""	   		,"","","","","","","","","","","","","","",""	,"","",""})
aAdd(aRegs,{cPerg,"02","Ate Mes ?"      	,"Ate Mes ?"   ,"Ate Mes ?"		,"mv_ch2","N",2,0,0,"G","","mv_par02",""				,"","","","",""					,"","","","",""  		,"","","","","","","","","","","","","","",""	,"","",""})
aAdd(aRegs,{cPerg,"03","Do Ano  ?"      	,"Do Ano  ?"	,"Do Ano  ?"	,"mv_ch3","N",4,0,0,"G","","mv_par03",""				,"","","","",""					,"","","","",""			,"","","","","","","","","","","","","","",""	,"","",""})
aAdd(aRegs,{cPerg,"04","Quanto ao Tes ?"	,""				,""				,"mv_ch4","N",1,0,1,"C","","mv_par04","Gera Dupl."		,"","","","","Nao Gera Dupl"	,"","","","","Todos"	,"","","","","","","","","","","","","","","S"	,"","",""})
aAdd(aRegs,{cPerg,"05","Somente PA ?"		,""				,""				,"mv_ch5","N",1,0,1,"C","","mv_par05","Sim       "		,"","","","","Nao          "	,"","","","",""     	,"","","","","","","","","","","","","","","S"	,"","",""})
aAdd(aRegs,{cPerg,"06","Resumido?"			,""				,""				,"mv_ch6","N",1,0,1,"C","","mv_par06","Sim       "		,"","","","","Nao          "	,"","","","",""     	,"","","","","","","","","","","","","","","S"	,"","",""})
aAdd(aRegs,{cPerg,"07","Tot. Quantdes?"		,""				,""				,"mv_ch7","N",1,0,1,"C","","mv_par07","Sim       "		,"","","","","Nao          "	,"","","","",""     	,"","","","","","","","","","","","","","","S"	,"","",""})

lValidPerg(aRegs)

If !Pergunte(cPerg,.T.)
	Return
EndIf

If mv_par06 == 1 
	cQuery += "SELECT 	A3_SUPER, A3_NSUP, ACA_DESCRI, F2_VEND1, A3_NOME, F2_CLIENTE, "
	cQuery += "A1_NREDUZ, A1_NOME, A1_MUN, A1_EST, ACY_DESCRI, "
	For i:=mv_par01 To mv_par02
		cQuery += "SUM(" + aMeses[i] + ") " + aMeses[i] + " , "
	Next
	cQuery += "SUM(TOTAL) TOTAL "
	cQuery += "FROM ( "
EndIf

cQuery += "SELECT "
cQuery += "ISNULL(SA3.A3_SUPER,'') A3_SUPER "
cQuery += ",ISNULL((SELECT SA3X.A3_NOME FROM " + RetSQLName("SA3") + " SA3X WHERE SA3X.A3_COD = SA3.A3_SUPER AND SA3X.D_E_L_E_T_ = ''),' ') A3_NSUP "
cQuery += ",ISNULL(ACA.ACA_DESCRI,'') ACA_DESCRI "
cQuery += ",SF2.F2_VEND1 , SA3.A3_NOME , SF2.F2_CLIENTE , SA1.A1_NREDUZ , SA1.A1_NOME , SA1.A1_MUN "
cQuery += ",SA1.A1_EST , ACY.ACY_DESCRI "      
cQuery += ",SD2.D2_COD "

For N1 := mv_par01 To mv_par02
	cQuery += ",CAST(ISNULL(( "
	cQuery += "SELECT SUM(SD2B.D2_VALBRUT) "                                   //FERNANDO
	cQuery += "FROM " + RetSQLName("SF2") + " SF2B , "+RetSQLName("SD2")+" SD2B , "+RetSQLName("SF4")+" SF4 "
	cQuery += "WHERE SF2B.D_E_L_E_T_ 	= ''	"
	cQuery += "	AND SF2B.F2_TIPO 		NOT IN ('D','B')	"
	cQuery += "	AND SF2B.F2_VEND1   	= SF2.F2_VEND1	"
	cQuery += "	AND SF2B.F2_CLIENTE 	= SF2.F2_CLIENTE	"
	cQuery += "	AND SF2B.F2_EMISSAO 	BETWEEN '" + AllTrim(Str(mv_par03)) + STRZERO(N1,2) + "01'"
	cQuery += "	AND '" + AllTrim(Str(mv_par03)) + STRZERO(N1,2) + "31'"
	cQuery += "	AND SD2B.D2_FILIAL 	= SF2B.F2_FILIAL "
	cQuery += "	AND SD2B.D2_DOC 		= SF2B.F2_DOC 	"
	cQuery += "	AND SD2B.D2_SERIE 	= SF2B.F2_SERIE 	"
	cQuery += "	AND SD2B.D2_TIPO 		NOT IN ('D','B')	"
	cQuery += "	AND SD2B.D_E_L_E_T_ 	<> '*' 	"
	cQuery += "	AND SD2B.D2_COD		= SD2.D2_COD "

	If mv_par04 <> 3 //Gera Duplicata <> de Ambos
		cQuery += " AND SD2B.D2_TES IN ( "
		cQuery += " 		SELECT F4_CODIGO 	"
		cQuery += " 		FROM "+RetSQLName("SF4")+" SF4 	"
		cQuery += " 		WHERE F4_FILIAL = '  '	"
		cQuery += " 		AND F4_CODIGO = SD2B.D2_TES	"
		If mv_par04 == 1
			cQuery += " 		AND F4_DUPLIC = 'S'	" 
			cQuery += "			AND F4_ESTOQUE = 'S'	"
		Else
			cQuery += "  		AND F4_DUPLIC = 'N'	"
		EndIf
		cQuery += " 		AND SF4.D_E_L_E_T_ <> '*' )  "   
		cQuery += "  		AND SF4.F4_ESTOQUE = 'S'	"
		
	EndIf

	If mv_par05 == 1
		cQuery += "  AND SD2B.D2_TP = '3' "
	EndIf
	cQuery += " ),0) AS NUMERIC (10,2)) " + '"' + aMeses[N1] + '" '
	AADD(aCamposMes,{aMeses[N1]})
Next

cQuery += " ,CAST(ISNULL((SELECT SUM(SD2B.D2_VALBRUT) 	FROM "+RetSQLName("SF2")+" SF2B, "+RetSQLName("SD2")+" SD2B "
cQuery += " 	WHERE SF2B.D_E_L_E_T_ 	= ''	"
cQuery += " 	AND SF2B.F2_TIPO 		NOT IN ('D','B')	"
cQuery += " 	AND SF2B.F2_VEND1   	= SF2.F2_VEND1	"
cQuery += " 	AND SF2B.F2_CLIENTE 	= SF2.F2_CLIENTE	"
cQuery += " 	AND SD2B.D2_FILIAL	= SF2B.F2_FILIAL 	"
cQuery += " 	AND SD2B.D2_DOC 		= SF2B.F2_DOC 	"
cQuery += " 	AND SD2B.D2_SERIE 	= SF2B.F2_SERIE 	"
cQuery += " 	AND SD2B.D2_TIPO 		NOT IN ('D','B')	"
cQuery += " 	AND SD2B.D_E_L_E_T_ 	<> '*' 	"       
cQuery += " 	AND SD2B.D2_COD		= SD2.D2_COD "
If mv_par04 <> 3 // Gera duplicata <> de Ambos
	cQuery += " 	AND SD2B.D2_TES IN ( "
	cQuery += " 		SELECT F4_CODIGO  	"
	cQuery += " 		FROM "+RetSQLName("SF4")+" SF4 	"
	cQuery += " 		WHERE F4_FILIAL	= '  '	"
	cQuery += " 		AND F4_CODIGO 		= SD2B.D2_TES	"
	If mv_par04 == 1 	//Gera Duplicata
		cQuery += " AND F4_DUPLIC = 'S' "
		cQuery += " AND F4_ESTOQUE = 'S'	"
	Else 					//N�o gera duplicatas	
		cQuery += " AND F4_DUPLIC = 'N' "
	EndIf
	cQuery += " 		AND SF4.D_E_L_E_T_ 	<> '*' )  	"
EndIf
If mv_par05 == 1
	cQuery += "  AND SD2B.D2_TP = '3' "
EndIf
cQuery += "	AND SF2B.F2_EMISSAO BETWEEN '" + AllTrim(Str(mv_par03)) + STRZERO(mv_par01,2) + "01'"
cQuery += "	AND '" + AllTrim(Str(mv_par03)) + STRZERO(mv_par02,2) + "31'"
cQuery += "	),0) AS NUMERIC (10,2)) 'TOTAL' "  
cQuery += " , SB1.B1_DESC "
    
//Totaliza as quantidades vendidas MENSALMENTE
If mv_par07 == 1
	For N1 := mv_par01 To mv_par02
		cQuery += " ,CAST(ISNULL(( "
		cQuery += " 	SELECT SUM(SD2B.D2_QUANT) "
		cQuery += " 	FROM " + RetSQLName("SF2") + " SF2B , "+RetSQLName("SD2")+" SD2B "
		cQuery += " 	WHERE SF2B.D_E_L_E_T_ 	= ''	"
		cQuery += "		AND SF2B.F2_TIPO 		NOT IN ('D','B')	"
		cQuery += "		AND SF2B.F2_VEND1   	= SF2.F2_VEND1	"
		cQuery += "		AND SF2B.F2_CLIENTE 	= SF2.F2_CLIENTE	"
		cQuery += "		AND SF2B.F2_EMISSAO 	BETWEEN '" + AllTrim(Str(mv_par03)) + STRZERO(N1,2) + "01'"
		cQuery += "		AND '" + AllTrim(Str(mv_par03)) + STRZERO(N1,2) + "31'"
		cQuery += "		AND SD2B.D2_FILIAL 	= SF2B.F2_FILIAL "
		cQuery += "		AND SD2B.D2_DOC 		= SF2B.F2_DOC 	"
		cQuery += " 	AND SD2B.D2_SERIE 	= SF2B.F2_SERIE 	"
		cQuery += " 	AND SD2B.D2_TIPO 		NOT IN ('D','B')	"
		cQuery += " 	AND SD2B.D_E_L_E_T_ 	<> '*' 	"
		cQuery += " 	AND SD2B.D2_COD		= SD2.D2_COD "
		If mv_par04 <> 3 //Gera Duplicata <> de Ambos
			cQuery += " AND SD2B.D2_TES IN ( "
			cQuery += " 		SELECT F4_CODIGO 	"
			cQuery += " 		FROM "+RetSQLName("SF4")+" SF4 	"
			cQuery += " 		WHERE F4_FILIAL = '  '	"
			cQuery += " 		AND F4_CODIGO = SD2B.D2_TES	"
			If mv_par04 == 1
				cQuery += " 		AND F4_DUPLIC = 'S'	" 
				cQuery += " 		AND F4_ESTOQUE = 'S'	"
			Else
				cQuery += "  		AND F4_DUPLIC = 'N'	"
			EndIf
			cQuery += " 		AND SF4.D_E_L_E_T_ <> '*' )  "
		EndIf
		If mv_par05 == 1
			cQuery += "  AND SD2B.D2_TP = '3' "
		EndIf
		cQuery += " ),0) AS NUMERIC (10,2)) " + '" Q_' + aMeses[N1] + '" '
		AADD(aCamposMes,{"Q_"+aMeses[N1]})
	Next              

	// totaliza as quantidades vendidas em todos os periodos
	cQuery += " ,CAST(ISNULL((SELECT SUM(SD2B.D2_QUANT) 	FROM "+RetSQLName("SF2")+" SF2B, "+RetSQLName("SD2")+" SD2B "
	cQuery += " 	WHERE SF2B.D_E_L_E_T_ 	= ''	"
	cQuery += " 	AND SF2B.F2_TIPO 		NOT IN ('D','B')	"
	cQuery += " 	AND SF2B.F2_VEND1   	= SF2.F2_VEND1	"
	cQuery += " 	AND SF2B.F2_CLIENTE 	= SF2.F2_CLIENTE	"
	cQuery += " 	AND SD2B.D2_FILIAL	= SF2B.F2_FILIAL 	"
	cQuery += " 	AND SD2B.D2_DOC 		= SF2B.F2_DOC 	"
	cQuery += " 	AND SD2B.D2_SERIE 	= SF2B.F2_SERIE 	"
	cQuery += " 	AND SD2B.D2_TIPO 		NOT IN ('D','B')	"
	cQuery += " 	AND SD2B.D_E_L_E_T_ 	<> '*' 	"       
	cQuery += " 	AND SD2B.D2_COD		= SD2.D2_COD "
	If mv_par04 <> 3 // Gera duplicata <> de Ambos
		cQuery += " 	AND SD2B.D2_TES IN ( "
		cQuery += " 		SELECT F4_CODIGO  	"
		cQuery += " 		FROM "+RetSQLName("SF4")+" SF4 	"
		cQuery += " 		WHERE F4_FILIAL	= '  '	"
		cQuery += " 		AND F4_CODIGO 		= SD2B.D2_TES	"
		If mv_par04 == 1 	//Gera Duplicata
			cQuery += " AND F4_DUPLIC = 'S' " 
			cQuery += " AND F4_ESTOQUE = 'S'"
		Else 					//N�o gera duplicatas	
			cQuery += " AND F4_DUPLIC = 'N' "
		EndIf
		cQuery += " 		AND SF4.D_E_L_E_T_ 	<> '*' )  	"
	EndIf
	If mv_par05 == 1
		cQuery += "  AND SD2B.D2_TP = '3' "
	EndIf
	cQuery += "	AND SF2B.F2_EMISSAO BETWEEN '" + AllTrim(Str(mv_par03)) + STRZERO(mv_par01,2) + "01'"
	cQuery += "	AND '" + AllTrim(Str(mv_par03)) + STRZERO(mv_par02,2) + "31'"
	cQuery += "	),0) AS NUMERIC (10,2)) 'Q_TOTAL' "   

EndIf
	
cQuery += "	FROM "+RetSqlName("SF2")+" SF2 LEFT JOIN "+RetSqlName("SA3")+" SA3 ON SA3.A3_FILIAL = '"+xFilial("SA3")+"' AND SA3.A3_COD = SF2.F2_VEND1 AND SA3.D_E_L_E_T_ <> '*'"
cQuery += "						INNER JOIN "+RetSqlName("SA1")+" SA1 ON SA1.A1_FILIAL = '"+xFilial("SA1")+"' AND SA1.A1_COD = SF2.F2_CLIENTE AND SA1.A1_LOJA = SF2.F2_LOJA AND SA1.D_E_L_E_T_ <> '*'"
cQuery += "						INNER JOIN "+RetSqlName("ACY")+" ACY ON ACY.ACY_GRPVEN = SA1.A1_GRPVEN AND ACY.D_E_L_E_T_ <> '*'"
cQuery += "						LEFT 	JOIN "+RetSQLName("ACA")+" ACA ON SA3.A3_GRPREP = ACA.ACA_GRPREP AND ACA.D_E_L_E_T_ = '' "
cQuery += " 	,"+RetSQLName("SD2")+" SD2 "     
cQuery += " LEFT 	JOIN SB1010 SB1 ON SB1.B1_COD=D2_COD AND SB1.D_E_L_E_T_='' "
cQuery += "	WHERE SF2.D_E_L_E_T_ = '' "
cQuery += "	AND SF2.F2_EMISSAO BETWEEN '" + AllTrim(Str(mv_par03)) + STRZERO(mv_par01,2) + "01' "
cQuery += "	AND '" + AllTrim(Str(mv_par03)) + STRZERO(mv_par02,2) + "31'"
cQuery += " AND SD2.D2_FILIAL 	= SF2.F2_FILIAL 	"
cQuery += " AND SD2.D2_DOC 		= SF2.F2_DOC 	"
cQuery += " AND SD2.D2_SERIE 		= SF2.F2_SERIE 	"
cQuery += " AND SD2.D2_TIPO 		NOT IN ('D','B')	"
cQuery += " AND SD2.D_E_L_E_T_ 	<> '*' 	"

If mv_par04 <> 3 // Gera Duplicatas <> de Ambos
	cQuery += " AND ( "
	cQuery += " 	SELECT COUNT(*) "
	cQuery += " 	FROM SF4010 SF4 "
	If mv_par04 = 1 
		cQuery += " 	WHERE F4_DUPLIC = 'S' "	
		cQuery += " AND F4_ESTOQUE = 'S'	"
	Else
		cQuery += " 	WHERE F4_DUPLIC = 'N' "	
	EndIf
	cQuery += " 	AND SF4.D_E_L_E_T_ = '' "	
	cQuery += " 	AND F4_CODIGO = SD2.D2_TES) > 0 "
EndIf 

If mv_par05 == 1
	cQuery += "  AND SD2.D2_TP = '3' "
EndIf

cQuery += "	AND SF2.F2_TIPO NOT IN ('D','B') "
cQuery += "	GROUP BY "
cQuery += " SA3.A3_SUPER, ACA.ACA_DESCRI,  SF2.F2_VEND1 , "
cQuery += " SF2.F2_VEND1 , SF2.F2_CLIENTE , SA3.A3_NOME , SA1.A1_NREDUZ , SA1.A1_NOME , SA1.A1_MUN , "
cQuery += "	SA1.A1_EST , ACY.ACY_DESCRI "      
cQuery += " ,SD2.D2_COD "                      
cQuery += " ,SB1.B1_DESC "   

//Resumido: (1-Sim/2-Nao)
If mv_par06==1
   cQuery += " ) AGRUPADOR "
   cQuery += " GROUP BY A3_SUPER, A3_NSUP, ACA_DESCRI, F2_VEND1, A3_NOME, F2_CLIENTE, "
   cQuery += " A1_NREDUZ, A1_NOME, A1_MUN, A1_EST, ACY_DESCRI "
EndIf

//MemoWrite("\QUERYSYS\RFATC01.SQL",cQuery)

//dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRB",.F.,.T.)

TcQuery cQuery New Alias "TRB"

For M1 := 1 To Len( aCamposMes )
	TCSetField("TRB", aCamposMes[M1,1] , "N",16,2)
Next

TCSetField("TRB", "MEDIA", 		"N",16,2)
TCSetField("TRB", "TOTAL", 		"N",16,2)
TCSetField("TRB", "Q_TOTAL",	"N",16,2)

u_ProcExcel("TRB")

TRB->(DBClosearea())

Return(.T.)