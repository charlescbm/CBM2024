#INCLUDE "Rwmake.ch"
#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "TbiConn.ch"
#INCLUDE "dbTree.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออออัออออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบ Programa    ณ RELORC3  ณ Rel. de Val. Reais x Or็ados da Contabilidade por Diretoria  บฑฑ
ฑฑฬอออออออออออออุออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Autor       ณ 07.04.10 ณ Thiago                                                       บฑฑ
ฑฑฬอออออออออออออุออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Observa็๕es ณ Especifico para Brascola                                                บฑฑ
ฑฑศอออออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
 
User Function RELORC3()
***********************
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Define Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Private cPerg  := U_CriaPerg("RLORC3")
Private cAlias := "TRB"
Private titulo := "Lista Real x Orcado da Contabilidade por Diretoria"
Private cDesc1 := "O relatorio irแ apresentar as informa็๕es dos valores real x or็ado"
Private cDesc2 := "digitado no periodo"
Private cDesc3 := ""
Private cString:= "CT2"
Private aOrd   := {} //OemToAnsi("Por Grupo Contabil")	/*,OemToAnsi("Por C.Custo")*/}  
Private aRegs  := {}
Private cCadastro:= "Lista Real x Orcado da Contab. por Diretoria"

ValPergunte(cPerg)

If !Pergunte(cPerg,.t.)
	Return  .F. 
Endif 

Processa({|| RunRePrv() },"Processando...")

Return NIL



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRunRePrv  บAutor  ณMicrosiga           บ Data ณ  03/18/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Rotina                                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function RunRePrv()
**************************
dDataDe := mv_par04 //Iif(mv_par01==1, FirstDay(mv_par04), CtoD("01/01/"+StrZero(Year(mv_par04),4)) )
dDataAte:= mv_par05 //mv_par04

If mv_par02==1 //DIRETORIA
	cQuery :=" " 
	cQuery +=" SELECT CT1_GRUPO, "
	cQuery +="        CT2_DEBITO, "
	cQuery +="        CT1_DESC01, "
	cQuery +="        SUM(VL_REAL) AS VL_REAL, "
	cQuery +="        SUM(VL_ORC) AS VL_ORC, "
	cQuery +="        CTT_X_CCG AS CCUSTO, "
	cQuery +="        DESCRI  "
	cQuery +=" FROM ( SELECT CT1_GRUPO AS CT1_GRUPO, "
	cQuery +="               CT2_DEBITO AS CT2_DEBITO, "
	cQuery +="               CT1_DESC01, "
	cQuery +="               SUM(CT2_VALOR) AS VL_REAL,  "
	cQuery +="               0 AS VL_ORC , "
	cQuery +="               CTT020.CTT_X_CCG AS CTT_X_CCG, "
	cQuery +="               (SELECT C1.CTT_DESC01 FROM CTT020 C1 WHERE CTT020.CTT_X_CCG = C1.CTT_CUSTO) AS DESCRI "
	cQuery +="        FROM CT2020 CT2 "
	cQuery +="        LEFT OUTER JOIN  CT1020  CT1 ON  CT1.D_E_L_E_T_ = '' AND CT1_GRUPO <> ''  AND CT2_DEBITO=CT1_CONTA "
	cQuery +="        INNER JOIN  CTT020  ON  CT2_CCD = CTT_CUSTO  AND CTT_X_CCD = '"+AllTrim(mv_par03)+"'  AND CTT020.D_E_L_E_T_ = '' AND CTT_X_CCG <> '' "   //AND CTT_BLOQ <> '1'
	cQuery +="        WHERE CT2_TPSALD IN('1') "
	cQuery +="          AND CT2_DATA BETWEEN  '"+DtoS(dDataDe)+"' AND '"+DtoS(dDataAte)+"' "
	cQuery +="          AND CT2_LOTE NOT IN ('777777','888888','5000','6000') "
	cQuery +="          AND CT2.D_E_L_E_T_ = '' "
	cQuery +="          AND CT1.D_E_L_E_T_ = '' "
	cQuery +="          AND CT1_GRUPO <> '' "
	cQuery +="        GROUP BY CT1_GRUPO,CT2_DEBITO,CT1_DESC01,CTT_X_CCG,CTT_DESC01 "
	cQuery +="  "
	cQuery +="        UNION ALL "
	cQuery +="  "
	cQuery +="        SELECT CT1_GRUPO AS CT1_GRUPO, "
	cQuery +="               CT2_DEBITO AS CT2_DEBITO, "
	cQuery +="               CT1_DESC01, "
	cQuery +="               0 AS VL_REAL, "                                                    
	cQuery +="               SUM(CT2_VALOR) AS VL_ORC, "
	cQuery +="               CTT020.CTT_X_CCG AS CTT_X_CCG, "
	cQuery +="              (SELECT C1.CTT_DESC01 FROM CTT020 C1 WHERE CTT020.CTT_X_CCG = C1.CTT_CUSTO) AS DESCRI "
	cQuery +="        FROM  CT2020 CT2 "
	cQuery +="        LEFT OUTER JOIN  CT1020  CT1 ON  CT1.D_E_L_E_T_ = '' AND CT1_GRUPO <> ''  AND CT2_DEBITO=CT1_CONTA "
	cQuery +="        INNER JOIN  CTT020  ON  CT2_CCD = CTT_CUSTO  AND CTT_X_CCD = '"+AllTrim(mv_par03)+"' AND CTT020.D_E_L_E_T_ = '' AND CTT_X_CCG <> '' "
	cQuery +="        WHERE CT2_TPSALD IN('2') "
	cQuery +="          AND CT2_DATA BETWEEN  '"+DtoS(dDataDe)+"' AND '"+DtoS(dDataAte)+"' "
	cQuery +="          AND CT2_LOTE = '2011' "
	cQuery +="          AND CT2.D_E_L_E_T_ = '' "
	cQuery +="          AND CT1.D_E_L_E_T_ = '' "
	cQuery +="          AND CT1_GRUPO <> '' "
	cQuery +="        GROUP BY CT1_GRUPO,CT2_DEBITO,CT1_DESC01,CTT_X_CCG,CTT_DESC01 "
	cQuery +="  "
	cQuery +="        UNION ALL "
	cQuery +="  "
	cQuery +="        SELECT CT1_GRUPO AS CT1_GRUPO, "
	cQuery +="               CT2_CREDIT AS CT2_DEBITO, "
	cQuery +="               CT1_DESC01, "
	cQuery +="               SUM(CT2_VALOR )*(-1) AS VL_REAL, "
	cQuery +="               0 AS VL_ORC, "
	cQuery +="               CTT020.CTT_X_CCG AS CTT_X_CCG, "
	cQuery +="               (SELECT C1.CTT_DESC01 FROM CTT020 C1 WHERE CTT020.CTT_X_CCG = C1.CTT_CUSTO) AS DESCRI "
	cQuery +="        FROM  CT2020 CT2 "
	cQuery +="        LEFT OUTER JOIN  CT1020  CT1 ON  CT1.D_E_L_E_T_ = '' AND CT1_GRUPO <> ''  AND CT2_CREDIT = CT1_CONTA "
	cQuery +="        INNER JOIN  CTT020  ON  CT2_CCC = CTT_CUSTO  AND CTT_X_CCD = '"+AllTrim(mv_par03)+"'  AND CTT020.D_E_L_E_T_ = '' AND CTT_X_CCG <> '' "
	cQuery +="        WHERE CT2_TPSALD IN ('1') "
	cQuery +="          AND CT2_DATA BETWEEN  '"+DtoS(dDataDe)+"' AND '"+DtoS(dDataAte)+"' "
	cQuery +="          AND CT2_LOTE NOT IN ('777777','888888','5000','6000') "
	cQuery +="          AND CT2.D_E_L_E_T_ = '' "
	cQuery +="          AND CT1.D_E_L_E_T_ = '' "
	cQuery +="          AND CT1_GRUPO <> '' "
	cQuery +="        GROUP BY CT1_GRUPO,CT2_CREDIT,CT1_DESC01,CTT_X_CCG,CTT_DESC01 "
	cQuery +="  "            
	cQuery +=" )AGRUPA1 "
	cQuery +="  "
	
	cQuery +=" GROUP BY CT1_GRUPO,CT2_DEBITO,CT1_DESC01,CTT_X_CCG,DESCRI "
	cQuery +=" ORDER BY CT1_GRUPO,CT2_DEBITO,CCUSTO,DESCRI "
	
Else //GERENCIA
	cQuery :=" " 
	cQuery +=" SELECT CT1_GRUPO, "
	cQuery +="        CT2_DEBITO, "
	cQuery +="        CT1_DESC01, "
	cQuery +="        SUM(VL_REAL) AS VL_REAL, "
	cQuery +="        SUM(VL_ORC) AS VL_ORC, "
	cQuery +="        CTT_CUSTO AS CCUSTO, "
	cQuery +="        DESCRI  "
	cQuery +=" FROM ( SELECT CT1_GRUPO AS CT1_GRUPO, "
	cQuery +="               CT2_DEBITO AS CT2_DEBITO, "
	cQuery +="               CT1_DESC01, "
	cQuery +="               SUM(CT2_VALOR) AS VL_REAL,  "
	cQuery +="               0 AS VL_ORC , "
	cQuery +="               CTT020.CTT_CUSTO AS CTT_CUSTO, "
	cQuery +="               CTT020.CTT_DESC01 AS DESCRI "
	cQuery +="        FROM CT2020 CT2 "
	cQuery +="        LEFT OUTER JOIN  CT1020  CT1 ON  CT1.D_E_L_E_T_ = '' AND CT1_GRUPO <> ''  AND CT2_DEBITO=CT1_CONTA "
	cQuery +="        INNER JOIN  CTT020  ON  CT2_CCD = CTT_CUSTO  AND CTT_X_CCG = '"+AllTrim(mv_par03)+"'  AND CTT020.D_E_L_E_T_ = '' AND CTT_X_CCG <> '' "
	cQuery +="        WHERE CT2_TPSALD IN('1') "
	cQuery +="          AND CT2_DATA BETWEEN  '"+DtoS(dDataDe)+"' AND '"+DtoS(dDataAte)+"' "
	cQuery +="          AND CT2_LOTE NOT IN ('777777','888888','5000','6000') "
	cQuery +="          AND CT2.D_E_L_E_T_ = '' "
	cQuery +="          AND CT1.D_E_L_E_T_ = '' "
	cQuery +="          AND CT1_GRUPO <> '' "
	cQuery +="        GROUP BY CT1_GRUPO,CT2_DEBITO,CT1_DESC01,CTT_CUSTO,CTT_DESC01 "
	cQuery +="  "
	cQuery +="        UNION ALL "
	cQuery +="  "
	cQuery +="        SELECT CT1_GRUPO AS CT1_GRUPO, "
	cQuery +="               CT2_DEBITO AS CT2_DEBITO, "
	cQuery +="               CT1_DESC01, "
	cQuery +="               0 AS VL_REAL, "
	cQuery +="               SUM(CT2_VALOR) AS VL_ORC, "
	cQuery +="               CTT020.CTT_CUSTO AS CTT_CUSTO, "
	cQuery +="               CTT020.CTT_DESC01 AS DESCRI "
	cQuery +="        FROM  CT2020 CT2 "
	cQuery +="        LEFT OUTER JOIN  CT1020  CT1 ON  CT1.D_E_L_E_T_ = '' AND CT1_GRUPO <> ''  AND CT2_DEBITO=CT1_CONTA "
	cQuery +="        INNER JOIN  CTT020  ON  CT2_CCD = CTT_CUSTO  AND CTT_X_CCG = '"+AllTrim(mv_par03)+"'  AND CTT020.D_E_L_E_T_ = '' AND CTT_X_CCG <> '' "
	cQuery +="        WHERE CT2_TPSALD IN('2') "
	cQuery +="          AND CT2_DATA BETWEEN  '"+DtoS(dDataDe)+"' AND '"+DtoS(dDataAte)+"' "
	cQuery +="          AND CT2_LOTE = '2011' "
	cQuery +="          AND CT2.D_E_L_E_T_ = '' "
	cQuery +="          AND CT1.D_E_L_E_T_ = '' "
	cQuery +="          AND CT1_GRUPO <> '' "
	cQuery +="        GROUP BY CT1_GRUPO,CT2_DEBITO,CT1_DESC01,CTT_CUSTO,CTT_DESC01 "
	cQuery +="  "
	cQuery +="        UNION ALL "
	cQuery +="  "
	cQuery +="        SELECT CT1_GRUPO AS CT1_GRUPO, "
	cQuery +="               CT2_CREDIT AS CT2_DEBITO, "
	cQuery +="               CT1_DESC01, "
	cQuery +="               SUM(CT2_VALOR )*(-1) AS VL_REAL, "
	cQuery +="               0 AS VL_ORC, "
	cQuery +="               CTT020.CTT_CUSTO AS CTT_CUSTO, "
	cQuery +="               CTT020.CTT_DESC01 AS DESCRI "
	cQuery +="        FROM  CT2020 CT2 "
	cQuery +="        LEFT OUTER JOIN  CT1020  CT1 ON  CT1.D_E_L_E_T_ = '' AND CT1_GRUPO <> ''  AND CT2_CREDIT = CT1_CONTA "
	cQuery +="        INNER JOIN  CTT020  ON  CT2_CCC = CTT_CUSTO  AND CTT_X_CCG = '"+AllTrim(mv_par03)+"'  AND CTT020.D_E_L_E_T_ = '' AND CTT_X_CCG <> '' "
	cQuery +="        WHERE CT2_TPSALD IN ('1') "
	cQuery +="          AND CT2_DATA BETWEEN  '"+DtoS(dDataDe)+"' AND '"+DtoS(dDataAte)+"' "
	cQuery +="          AND CT2_LOTE NOT IN ('777777','888888','5000','6000') "
	cQuery +="          AND CT2.D_E_L_E_T_ = '' "
	cQuery +="          AND CT1.D_E_L_E_T_ = '' "
	cQuery +="          AND CT1_GRUPO <> '' "
	cQuery +="        GROUP BY CT1_GRUPO,CT2_CREDIT,CT1_DESC01,CTT_CUSTO,CTT_DESC01 "
	cQuery +="  "
	cQuery +=" )AGRUPA1 "
	cQuery +="  "
	cQuery +=" GROUP BY CT1_GRUPO,CT2_DEBITO,CT1_DESC01,CTT_CUSTO,DESCRI "
	cQuery +=" ORDER BY CT1_GRUPO,CT2_DEBITO,CCUSTO,DESCRI "
EndIf

If Select("TRB") > 0 
	TRB->(dbCloseArea())
EndIf      
TCQUERY cQuery NEW ALIAS "TRB"

dbSelectArea("TRB")
dbGotop()

//FAZER SOMATORIA DE QTAS COLUNAS DEVEM TER NA TABLE. DIVIDIR X% ENTRE ELAS.
nQtdDir   := 0 
nTotRealAx:= 0
nTotOrcAx := 0
aDiretoAux:= {}
aTotGerAux:= {}
aTotGruAux:= {}

While !Eof()
    If aScan(aDiretoAux, TRB->CCUSTO)== 0
		aAdd(aDiretoAux, TRB->CCUSTO)
		aAdd(aTotGerAux, {0,0})
		aAdd(aTotGruAux, {0,0})
		nQtdDir++
	EndIf	
	
	DbSkip()		
EndDo

aSort(aDiretoAux)

nQtdDir++ //soma a coluna dos totais
aAdd(aTotGerAux,{0,0})
aAdd(aTotGruAux,{0,0})

DbGoTop()

//Impressao em HTML..

_cBody := "<!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.01 Transitional//EN'>"
_cBody += "<html>"                                                                                                                                                              
_cBody += "<head>"                                                                                                                                                              
_cBody += "<title>Documento sem t&iacute;tulo</title>"                                                                                                                          
_cBody += "<meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1'>"                                                                                            
_cBody += "</head>"                                                                                                                                                             
_cBody += "<body>"                                                                                                                                                              
_cBody += "   <tr><font face='Tahoma' size='4'>RELATำRIO DESPESAS REAL X PREVISTO</font></tr>" 
_cBody += "</body>"
_cBody += "<body>"
_cBody += "   <td><font face='Tahoma' size='2' color='#ffffff' >.</font></b></td>"                                                                                        
_cBody += "</body>"
_cBody += "<body>"                                                                                                                                                              
_cBody += "   <tr><font face='Tahoma' size='3'>Perํodo de "+DtoC(dDataDe)+" a "+DtoC(dDataAte)+"</font></tr>" 
_cBody += "</body>"
_cBody += "<body>"
_cBody += "   <td><font face='Tahoma' size='2' color='#ffffff' >.</font></b></td>"                                                                                        
_cBody += "</body>"
_cBody += "<body>"
_cBody += "   <td><font face='Tahoma' size='2' color='#ffffff' >.</font></b></td>"                                                                                        
_cBody += "</body>"
_cBody += "<body>"                                                                                                                                                              
_cBody += "   <tr><font face='Tahoma' size='2'><b>Atualizada em "+DtoC(dDataBase)+"</b></font></tr>" 
_cBody += "</body>"
_cBody += "<body>"
_cBody += "   <td><font face='Tahoma' size='2' color='#ffffff' >.</font></b></td>"                                                                                        
_cBody += "</body>"

_cBody += "<table border='1' cellspacing='1' width='100%'>"
_cBody += "<tbody>"
_cBody += "<tr>"               

If mv_par07==1 //Analitico
	_cBody += " <td rowspan='2' width='04%' align='left'  bgcolor='#808080'><font face='Tahoma' size='1' color='#FFFFFF'><b>GRUPO</b></font></td>"
	_cBody += " <td rowspan='2' width='05%' align='left'  bgcolor='#808080'><font face='Tahoma' size='1' color='#FFFFFF'><b>CONTA</b></font></td>"
	_cBody += " <td rowspan='2' width='16%' align='left'  bgcolor='#808080'><font face='Tahoma' size='1' color='#FFFFFF'><b>DESCRIวรO</b></font></td>"  
	
	// PRIMEIRAS 3 COLUNAS = 25%  ==> DIVIDIR OS 75% RESTANTES NAS 'N' COLUNAS DA VARIAVEL nQtdDir
	
	nPercCol:= Round((75/(nQtdDir*3)),1)
	cPercCol:= AllTrim(Str(nPercCol,1))
	
	For nI:= 1 to Len(aDiretoAux)
		_cBody += "	<td colspan='3' width='"+cPercCol+"%' align='center'  bgcolor='#808080'><font face='Tahoma' size='1' color='#FFFFFF'><b>"+AllTrim(Posicione("CTT", 1, xFilial("CTT")+aDiretoAux[nI], "CTT_DESC01"))+"</font></b></td> "
	Next

Else
	_cBody += " <td rowspan='2' width='05%' align='left'  bgcolor='#808080'><font face='Tahoma' size='1' color='#FFFFFF'><b>GRUPO</b></font></td>"
	_cBody += " <td rowspan='2' width='15%' align='left'  bgcolor='#808080'><font face='Tahoma' size='1' color='#FFFFFF'><b>DESCRIวรO</b></font></td>"  
	
	// PRIMEIRAS 2 COLUNAS = 20%  ==> DIVIDIR OS 80% RESTANTES NAS 'N' COLUNAS DA VARIAVEL nQtdDir
	
	nPercCol:= Round((80/(nQtdDir*2)),1)
	cPercCol:= AllTrim(Str(nPercCol,1))
	
	For nI:= 1 to Len(aDiretoAux)
		_cBody += "	<td colspan='3' width='"+cPercCol+"%' align='center'  bgcolor='#808080'><font face='Tahoma' size='1' color='#FFFFFF'><b>"+AllTrim(Posicione("CTT", 1, xFilial("CTT")+aDiretoAux[nI], "CTT_DESC01"))+"</font></b></td> "
	Next
EndIf	

_cBody += "	<td colspan='3' width='"+cPercCol+"%' align='center'  bgcolor='#808080'><font face='Tahoma' size='1' color='#FFFFFF'><b>T O T A L</font></b></td> "
_cBody += "</tr>"                                                                                                                                                           

_cBody += "<tr>" 

For nI:= 1 to nQtdDir
	_cBody += " <td width='"+cPercCol+"%' align='right'  bgcolor='#999999'><font face='Tahoma' size='1' color='#FFFFFF'><b>Real</b></font></td>"
	_cBody += " <td width='"+cPercCol+"%' align='right'  bgcolor='#999999'><font face='Tahoma' size='1' color='#FFFFFF'><b>Orc.</b></font></td>"
	_cBody += " <td width='"+cPercCol+"%' align='right'  bgcolor='#999999'><font face='Tahoma' size='1' color='#FFFFFF'><b>% Var</b></font></td>"
Next

_cBody += "</tr>"                                                                                                                                                           

While !Eof()
    For nA:= 1 to Len(aTotGruAux) //zera total por grupo
    	aTotGruAux[nA][1]:= 0 
    	aTotGruAux[nA][2]:= 0 
    Next	
	
	cGrupoAux:= TRB->CT1_GRUPO
	
	While !Eof() .And. cGrupoAux == TRB->CT1_GRUPO
		cContaAux:= TRB->CT2_DEBITO
		
		While !Eof() .And. cGrupoAux == TRB->CT1_GRUPO .And. cContaAux == TRB->CT2_DEBITO
			cBgColor := '#ffffff'
		
			If mv_par07==1 //Analitico
				_cBody += "<tr>"                                                                                                                                                            
				_cBody += " <td width='04%' align='left'  bgcolor='"+cBgColor+"'><font face='Tahoma' size='1'>"+AllTrim(TRB->CT1_GRUPO)+"</font></td>"
				_cBody += " <td width='05%' align='left'  bgcolor='"+cBgColor+"'><font face='Tahoma' size='1'>"+AllTrim(TRB->CT2_DEBITO)+"</font></td>"
				_cBody += " <td width='16%' align='left'  bgcolor='"+cBgColor+"'><font face='Tahoma' size='1'>"+AllTrim(TRB->CT1_DESC01)+"</font></td>"
			EndIf
							
			nTotRealAx:= 0
			nTotOrcAx := 0

			For nX:= 1 to Len(aDiretoAux)
				If cGrupoAux == TRB->CT1_GRUPO .And.; 
				   cContaAux == TRB->CT2_DEBITO .And.;
				   Alltrim(aDiretoAux[nX])==Alltrim(TRB->CCUSTO)
		
					If mv_par07==1 //Analitico
						_cBody += " <td width='"+cPercCol+"%' align='right'  bgcolor='"+cBgColor+"'><font face='Tahoma' size='1'>"+AllTrim(Transform(TRB->VL_REAL,"@E 999,999,999"))+"</font></td>"
						_cBody += " <td width='"+cPercCol+"%' align='right'  bgcolor='"+cBgColor+"'><font face='Tahoma' size='1'>"+AllTrim(Transform(TRB->VL_ORC ,"@E 999,999,999"))+"</font></td>"
						_cBody += " <td width='"+cPercCol+"%' align='right'  bgcolor='"+cBgColor+"'><font face='Tahoma' size='1'>"+Iif(TRB->VL_ORC==0,"0%",AllTrim(Transform(Round(((TRB->VL_REAL/TRB->VL_ORC)-1)*100,1)  ,"@R 999999.9%")))+"</font></td>"
					EndIf	
    
                    aTotGruAux[nX][1]+= TRB->VL_REAL
                    aTotGruAux[nX][2]+= TRB->VL_ORC
                    aTotGerAux[nX][1]+= TRB->VL_REAL
                    aTotGerAux[nX][2]+= TRB->VL_ORC
					
					nTotRealAx+= TRB->VL_REAL
					nTotOrcAx += TRB->VL_ORC
						   
				    DbSkip()
				Else 
					If mv_par07==1 //Analitico
						_cBody += " <td width='"+cPercCol+"%' align='center'  bgcolor='"+cBgColor+"'><font face='Tahoma' size='1'> - </font></td>"
						_cBody += " <td width='"+cPercCol+"%' align='center'  bgcolor='"+cBgColor+"'><font face='Tahoma' size='1'> - </font></td>"
						_cBody += " <td width='"+cPercCol+"%' align='right'   bgcolor='"+cBgColor+"'><font face='Tahoma' size='1'>0%</font></td>"
					EndIf
				EndIf
			Next
			
			//Total da Conta
			If mv_par07==1 //Analitico
				_cBody += " <td width='"+cPercCol+"%' align='right'  bgcolor='"+cBgColor+"'><font face='Tahoma' size='1'>"+AllTrim(Transform(nTotRealAx,"@E 999,999,999"))+"</font></td>"
				_cBody += " <td width='"+cPercCol+"%' align='right'  bgcolor='"+cBgColor+"'><font face='Tahoma' size='1'>"+AllTrim(Transform(nTotOrcAx,"@E 999,999,999"))+"</font></td>"
				_cBody += " <td width='"+cPercCol+"%' align='right'  bgcolor='"+cBgColor+"'><font face='Tahoma' size='1'>"+Iif(nTotOrcAx==0.Or.nTotRealAx==0,"0%",AllTrim(Transform(Round(((nTotRealAx/nTotOrcAx)-1)*100,1) ,"@R 999999.9%")))+"</font></td>"
				_cBody += "</tr>"
			EndIf
            aTotGruAux[nX][1]+= nTotRealAx
            aTotGruAux[nX][2]+= nTotOrcAx
            aTotGerAux[nX][1]+= nTotRealAx
            aTotGerAux[nX][2]+= nTotOrcAx
		EndDo 	
	EndDo
	
	//Total do Grupo

	_cBody += "<tr>"                                                                                                                                                            

	If mv_par07==1 //Analitico
		cBgColor:= '#f0f0f0'

		_cBody += " <td width='04%' align='left'  bgcolor='"+cBgColor+"'><b><font face='Tahoma' size='1'>"+cGRUPOAux+"</font></b></td>"
		_cBody += " <td width='05%' align='left'  bgcolor='"+cBgColor+"'><b><font face='Tahoma' size='1'>TOTAL</font></b></td>"
		_cBody += " <td width='16%' align='left'  bgcolor='"+cBgColor+"'><b><font face='Tahoma' size='1'>"+AllTrim(Posicione("CTR",1,xFilial("CTR")+AllTrim(cGrupoAux),"CTR_DESC"))+"</font></b></td>"

		For nY:= 1 to Len(aTotGruAux)
			_cBody += " <td width='"+cPercCol+"%' align='"+Iif(aTotGruAux[nY][1]==0,"center","right")+"'  bgcolor='"+cBgColor+"'><b><font face='Tahoma' size='1'>"+Iif(aTotGruAux[nY][1]==0," - ", AllTrim(Transform(aTotGruAux[nY][1],"@E 999,999,999")))+"</font></b></td>"
			_cBody += " <td width='"+cPercCol+"%' align='"+Iif(aTotGruAux[nY][2]==0,"center","right")+"'  bgcolor='"+cBgColor+"'><b><font face='Tahoma' size='1'>"+Iif(aTotGruAux[nY][2]==0," - ", AllTrim(Transform(aTotGruAux[nY][2],"@E 999,999,999")))+"</font></b></td>"
			_cBody += " <td width='"+cPercCol+"%' align='right'  bgcolor='"+cBgColor+"'><b><font face='Tahoma' size='1'>"+Iif(aTotGruAux[nY][1]==0.Or.aTotGruAux[nY][2]==0,"0%",AllTrim(Transform(Round(((aTotGruAux[nY][1]/aTotGruAux[nY][2])-1)*100,1),"@R 999999.9%")))+"</b></font></td>"
	    Next
	Else	
		cBgColor := '#ffffff'
	
		_cBody += " <td width='05%' align='left'  bgcolor='"+cBgColor+"'><font face='Tahoma' size='1'>"+cGRUPOAux+"</font></td>"
		_cBody += " <td width='15%' align='left'  bgcolor='"+cBgColor+"'><font face='Tahoma' size='1'>"+AllTrim(Posicione("CTR",1,xFilial("CTR")+AllTrim(cGrupoAux),"CTR_DESC"))+"</font></td>"

		For nY:= 1 to Len(aTotGruAux)
			_cBody += " <td width='"+cPercCol+"%' align='"+Iif(aTotGruAux[nY][1]==0,"center","right")+"'  bgcolor='"+cBgColor+"'><font face='Tahoma' size='1'>"+Iif(aTotGruAux[nY][1]==0," - ", AllTrim(Transform(aTotGruAux[nY][1],"@E 999,999,999")))+"</font></td>"
			_cBody += " <td width='"+cPercCol+"%' align='"+Iif(aTotGruAux[nY][2]==0,"center","right")+"'  bgcolor='"+cBgColor+"'><font face='Tahoma' size='1'>"+Iif(aTotGruAux[nY][2]==0," - ", AllTrim(Transform(aTotGruAux[nY][2],"@E 999,999,999")))+"</font></td>"
			_cBody += " <td width='"+cPercCol+"%' align='right'  bgcolor='"+cBgColor+"'><font face='Tahoma' size='1'>"+Iif(aTotGruAux[nY][1]==0.Or.aTotGruAux[nY][2]==0,"0%",AllTrim(Transform(Round(((aTotGruAux[nY][1]/aTotGruAux[nY][2])-1)*100,1),"@R 999999.9%")))+"</font></td>"
	    Next
	EndIf
	
	_cBody += "</tr>"                                                                                                                                                            
EndDo	

cBgColor := '#cccccc'

//T O T A L   G E R A L

_cBody += "<tr>"                                                                                                                                                            

If mv_par07==1 //Analitico
	_cBody += " <td width='04%' align='left'  bgcolor='"+cBgColor+"'><b><font face='Tahoma' size='1'>999</font></b></td>"
	_cBody += " <td width='05%' align='left'  bgcolor='"+cBgColor+"'><b><font face='Tahoma' size='1'> </font></b></td>"
	_cBody += " <td width='16%' align='left'  bgcolor='"+cBgColor+"'><b><font face='Tahoma' size='1'>T O T A L   G E R A L</font></b></td>"
Else
	_cBody += " <td width='05%' align='left'  bgcolor='"+cBgColor+"'><b><font face='Tahoma' size='1'>999</font></b></td>"
	_cBody += " <td width='15%' align='left'  bgcolor='"+cBgColor+"'><b><font face='Tahoma' size='1'>T O T A L   G E R A L</font></b></td>"
EndIf

For nY:= 1 to Len(aTotGerAux)
	_cBody += " <td width='"+cPercCol+"%' align='"+Iif(aTotGerAux[nY][1]==0,"center","right")+"'  bgcolor='"+cBgColor+"'><b><font face='Tahoma' size='1'>"+Iif(aTotGerAux[nY][1]==0," - ", AllTrim(Transform(aTotGerAux[nY][1],"@E 999,999,999")))+"</font></b></td>"
	_cBody += " <td width='"+cPercCol+"%' align='"+Iif(aTotGerAux[nY][2]==0,"center","right")+"'  bgcolor='"+cBgColor+"'><b><font face='Tahoma' size='1'>"+Iif(aTotGerAux[nY][2]==0," - ", AllTrim(Transform(aTotGerAux[nY][2],"@E 999,999,999")))+"</font></b></td>"
	_cBody += " <td width='"+cPercCol+"%' align='right'  bgcolor='"+cBgColor+"'><b><font face='Tahoma' size='1'>"+Iif(aTotGerAux[nY][1]==0.Or.aTotGerAux[nY][2]==0,"0%",AllTrim(Transform(Round(((aTotGerAux[nY][1]/aTotGerAux[nY][2])-1)*100,1),"@R 999999.9%")))+"</font></b></td>"
Next

_cBody += "</tr>"                                                                                                                                                            

_cBody += "</tbody>"                                                                                                                                                           
_cBody += "</table>"

_cBody += "<body>"
_cBody += " <td><font face='Tahoma' size='2' color='#ffffff' >.</font></b></td>"                                                                                        
_cBody += "</body>"

_cBody += " <hr> " //linha horizontal

_cBody += "<body>"
_cBody += " <td><i><font face='Tahoma' size='1'>Gerado pelo Microsiga Protheus em "+DtoC(Date())+" - "+Time()+"</font></i></td>"
_cBody += "</body>"
_cBody += "</html>"

cAssunto:= "Relat๓rio "+Iif(mv_par01==1,"mensal","acumulado")+" de despesas realizado x or็ado - "+SubStr(DtoS(dDataBase),1,4)
cEmailAx:= Alltrim(mv_par06) //"thiago.moyses@brascola.com.br"

If !Empty(cEmailAx)
	U_SendMail(cEmailAx,cAssunto,_cBody,"",.t.)
EndIf	


DbSelectArea("TRB")
DbCloseArea()

Return



Static Function ValPergunte(cPerg)
*********************************
DbSelectArea("SX1")
DbSetOrder(1)

aRegs:= {}
//          Grupo/Ordem/Pergunta/                    Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01     /Def01                    /Cnt01/Var02/Def02                  /Cnt02/Var03/Def03                     /Cnt03/Var04/Def04                    /Cnt04/Var05/Def05         /Cnt05 /F3   /Pyme /GrpSXG /Help /Picture /IdgFil
aAdd(aRegs,{cPerg,"01","Tipo Relatorio?"      ,"","","mv_ch1","N" ,1      ,0      ,1     ,"C",""   ,"mv_par01","Mensal"          ,"","" ,""   ,""   ,"Acumulado"     ,"","" ,""   ,""   ,""                 ,"","" ,""   ,""   ,""                ,"","" ,""   ,""   ,"",     "","" ,""    ,""   ,""    ,""     ,""   ,""     ,""})
aAdd(aRegs,{cPerg,"02","Tipo de Consolidacao?","","","mv_ch2","N" ,1      ,0      ,1     ,"C",""   ,"mv_par02","Diretoria"       ,"","" ,""   ,""   ,"Gerencia"      ,"","" ,""   ,""   ,""                 ,"","" ,""   ,""   ,""                ,"","" ,""   ,""   ,"",     "","" ,""    ,""   ,""    ,""     ,""   ,""     ,""})
aAdd(aRegs,{cPerg,"03","C.Custo Sintetico?"   ,"","","mv_ch3","C" ,9      ,0      ,0     ,"G",""   ,"mv_par03",""                ,"","" ,""   ,""   ,""              ,"","" ,""   ,""   ,""                 ,"","" ,""   ,""   ,""                ,"","" ,""   ,""   ,"",     "","" ,""    ,"CTT",""    ,""     ,""   ,""     ,""})
aAdd(aRegs,{cPerg,"04","Data De?"             ,"","","mv_ch4","D" ,8      ,0      ,0     ,"G",""   ,"mv_par04",""                ,"","" ,""   ,""   ,""              ,"","" ,""   ,""   ,""                 ,"","" ,""   ,""   ,""                ,"","" ,""   ,""   ,"",     "","" ,""    ,""   ,""    ,""     ,""   ,""     ,""})
aAdd(aRegs,{cPerg,"05","Data Ate?"            ,"","","mv_ch5","D" ,8      ,0      ,0     ,"G",""   ,"mv_par05",""                ,"","" ,""   ,""   ,""              ,"","" ,""   ,""   ,""                 ,"","" ,""   ,""   ,""                ,"","" ,""   ,""   ,"",     "","" ,""    ,""   ,""    ,""     ,""   ,""     ,""})
aAdd(aRegs,{cPerg,"06","Email para envio?"    ,"","","mv_ch6","C" ,60     ,0      ,0     ,"G",""   ,"mv_par06",""                ,"","" ,""   ,""   ,""              ,"","" ,""   ,""   ,""                 ,"","" ,""   ,""   ,""                ,"","" ,""   ,""   ,"",     "","" ,""    ,""   ,""    ,""     ,""   ,""     ,""})
aAdd(aRegs,{cPerg,"07","Tipo de Listagem?"    ,"","","mv_ch7","N" ,1      ,0      ,1     ,"C",""   ,"mv_par07","Analitico"       ,"","" ,""   ,""   ,"Sintetico"     ,"","" ,""   ,""   ,""                 ,"","" ,""   ,""   ,""                ,"","" ,""   ,""   ,"",     "","" ,""    ,""   ,""    ,""     ,""   ,""     ,""})

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